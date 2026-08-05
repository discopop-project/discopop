# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import os
import json
import re
import shutil
import signal
import subprocess
import time
from typing import Callable, Dict, List, Optional, Tuple

from filelock import FileLock

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments

PATH = str

logger = logging.getLogger("ConfigurationManager")


def _resolve_compiler(cmd: str, search_path: str) -> str:
    """Resolve an unversioned clang/clang++ to an installed versioned binary.

    Settings default CC/CXX to the unversioned ``clang``/``clang++`` names, but
    many distributions only ship versioned binaries (e.g. ``clang-21``) with no
    bare ``clang`` symlink. If ``cmd`` already resolves on ``search_path`` it is
    returned unchanged; if it is a bare ``clang``/``clang++`` that does not
    resolve, fall back to the highest ``clang-<N>``/``clang++-<N>`` found on
    ``search_path``. Anything else is returned unchanged so the build fails with
    its own error rather than being silently rewritten.
    """
    if shutil.which(cmd, path=search_path):
        return cmd
    if cmd not in ("clang", "clang++"):
        return cmd
    pattern = re.compile(re.escape(cmd) + r"-(\d+)$")
    best: Optional[Tuple[int, str]] = None
    for directory in (search_path or "").split(os.pathsep):
        if not directory or not os.path.isdir(directory):
            continue
        try:
            entries = os.listdir(directory)
        except OSError:
            continue
        for name in entries:
            match = pattern.match(name)
            if match and shutil.which(name, path=search_path):
                version = int(match.group(1))
                if best is None or version > best[0]:
                    best = (version, name)
    return best[1] if best else cmd


def execute_configuration(
    arguments: ProjectManagerArguments,
    project_copy_root_path: PATH,
    config_path: PATH,
    settings_path: PATH,
    script_path: PATH,
    thread_count: int,
    timeout: Optional[float] = None,
    process_started_callback: Optional[Callable[["subprocess.Popen[bytes]"], None]] = None,
) -> Optional[Tuple[int, float, str, str]]:
    # check prerequisites
    if not os.path.exists(settings_path):
        return None

    config_name = os.path.basename(config_path)
    settings_name = os.path.basename(settings_path)
    script_name = os.path.basename(script_path)

    config_path = config_path.replace(arguments.project_root, project_copy_root_path)
    settings_path = settings_path.replace(arguments.project_root, project_copy_root_path)
    script_path = script_path.replace(arguments.project_root, project_copy_root_path)
    project_copy_dp_path = os.path.join(project_copy_root_path, ".discopop")

    # get applied suggestions
    applied_suggestions_file = os.path.join(project_copy_dp_path, "patch_applicator", "applied_suggestions.json")
    applied_suggestions: List[int] = []
    if os.path.exists(applied_suggestions_file):
        with open(applied_suggestions_file, "r") as f:
            applied_suggestions = json.load(f)["applied"]

    # load environment settings
    logger.debug(
        "executing configuration: "
        + str(os.path.basename(config_path))
        + " --- "
        + str(os.path.basename(script_path))
        + " --- "
        + str(os.path.basename(settings_path))
    )
    with open(settings_path, "r") as f:
        settings = json.load(f)
    logger.debug("-> settings:\n" + str(settings))

    # prepare environment variables
    home_dir = os.getcwd()
    os.chdir(project_copy_root_path)
    my_env: Dict[str, str] = os.environ.copy()
    for key in settings:
        my_env[key] = settings[key]
    my_env["DP_PROJECT_ROOT_DIR"] = project_copy_root_path
    my_env["DOT_DISCOPOP"] = project_copy_dp_path
    my_env["OMP_NUM_THREADS"] = str(thread_count)

    # Ensure the PATH includes the directory where discopop tools are found
    import sys

    venv_bin = os.path.dirname(sys.executable)
    if venv_bin not in my_env.get("PATH", ""):
        my_env["PATH"] = venv_bin + os.pathsep + my_env.get("PATH", "")

    # Resolve unversioned clang/clang++ to an installed versioned binary when no
    # bare clang is on PATH (common on distros shipping only clang-<N>). Done
    # after PATH is finalized so the venv bin is included in the search.
    for compiler_key in ("CC", "CXX"):
        original = my_env.get(compiler_key, "")
        if not original:
            continue
        resolved = _resolve_compiler(original, my_env.get("PATH", ""))
        if resolved != original:
            logger.info("Resolved %s=%s to %s (no bare %s on PATH)", compiler_key, original, resolved, original)
            my_env[compiler_key] = resolved

    # print("MYENV:")
    # for key in my_env:
    #    print("--> ", key, " : ", my_env[key])

    timeout_expired = False
    start = time.time()
    try:
        #        result = subprocess.run(
        #            str(script_path),
        #            cwd=config_path,
        #            executable="/bin/bash",
        #            shell=True,
        #            capture_output=True,
        #            env=my_env,
        #            timeout=timeout,
        #        )
        if timeout is None:
            cmd = f"/bin/bash {str(script_path)}"
        else:
            cmd = f"timeout {str(timeout)} /bin/bash {str(script_path)}"
        p = subprocess.Popen(
            cmd,
            cwd=project_copy_root_path,
            executable="/bin/bash",
            shell=True,
            stderr=subprocess.PIPE,
            stdout=subprocess.PIPE,
            env=my_env,
        )

        if process_started_callback is not None:
            process_started_callback(p)

        stdout, stderr = p.communicate()

    except subprocess.TimeoutExpired as tex:
        timeout_expired = True
        os.killpg(os.getpgid(p.pid), signal.SIGTERM)
        print("KILLED PROCESS: ", p.pid)

    elapsed = round((time.time() - start), 3)
    logger.debug("-> return code: " + str(p.returncode))
    logger.debug("-> thread count: " + str(thread_count))
    logger.debug("-> stdout:\n" + stdout.decode("utf-8") if not timeout_expired else "")
    logger.debug("-> stderr:\n" + stderr.decode("utf-8") if not timeout_expired else "")
    logger.debug("-> elapsed time: " + str(elapsed) + "s")

    # save execution results
    lock = FileLock(os.path.join(arguments.project_dir, "execution_results.json.lock"))
    with lock:

        execution_results_path = os.path.join(arguments.project_dir, "execution_results.json")
        execution_results = dict()
        if os.path.exists(execution_results_path):
            with open(execution_results_path, "r") as f:
                execution_results = json.load(f)

        if config_name not in execution_results:
            execution_results[config_name] = dict()
        if script_name not in execution_results[config_name]:
            execution_results[config_name][script_name] = dict()
        if settings_name not in execution_results[config_name][script_name]:
            execution_results[config_name][script_name][settings_name] = []

        label: str = "" + arguments.label_prefix
        if arguments.apply_suggestions == "auto":
            label += "auto"
        if arguments.apply_suggestions == "prm":
            label += "prm"

        result_dict = {
            "applied_suggestions": applied_suggestions,
            "code": p.returncode,
            "stdout": stdout.decode("utf-8") if not timeout_expired else "",
            "stderr": stderr.decode("utf-8") if not timeout_expired else "",
            "timeout_expired": timeout_expired,
            "time": elapsed,
            "thread_count": thread_count,
            "label": label,
        }
        # check for duplicates and overwrite them
        to_be_removed: List[int] = []
        for idx, entry in enumerate(execution_results[config_name][script_name][settings_name]):
            if entry["applied_suggestions"] == applied_suggestions:
                if entry["thread_count"] == thread_count:
                    if entry["label"] == label:
                        to_be_removed.append(idx)
        for idx in sorted(to_be_removed, reverse=True):
            del execution_results[config_name][script_name][settings_name][idx]
        execution_results[config_name][script_name][settings_name].append(result_dict)

        # overwrite execution results file
        with open(execution_results_path, "w+") as f:
            json.dump(execution_results, f, sort_keys=True, indent=4)

    os.chdir(home_dir)

    return (
        p.returncode,
        elapsed,
        stdout.decode("utf-8") if not timeout_expired else "",
        stderr.decode("utf-8") if not timeout_expired else "",
    )
