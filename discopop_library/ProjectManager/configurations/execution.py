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
import shutil
import signal
import subprocess
import time
from typing import Dict, List, Optional, Tuple

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments

PATH = str

logger = logging.getLogger("ConfigurationManager")


def execute_configuration(
    arguments: ProjectManagerArguments,
    project_copy_root_path: PATH,
    config_path: PATH,
    settings_path: PATH,
    script_path: PATH,
    timeout: Optional[float] = None,
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
            cmd = str(script_path)
        else:
            cmd = "timeout " + str(timeout) + " " + str(script_path)
        p = subprocess.Popen(
            cmd,
            cwd=config_path,
            executable="/bin/bash",
            shell=True,
            stderr=subprocess.PIPE,
            stdout=subprocess.PIPE,
            env=my_env,
        )

        stdout, stderr = p.communicate()

    except subprocess.TimeoutExpired as tex:
        timeout_expired = True
        os.killpg(os.getpgid(p.pid), signal.SIGTERM)
        print("KILLED PROCESS: ", p.pid)

    elapsed = round((time.time() - start), 3)
    logger.debug("-> return code: " + str(p.returncode))
    logger.debug("-> stdout:\n" + stdout.decode("utf-8") if not timeout_expired else "")
    logger.debug("-> stderr:\n" + stderr.decode("utf-8") if not timeout_expired else "")
    logger.debug("-> elapsed time: " + str(elapsed) + "s")

    # save execution results
    execution_results_path = os.path.join(arguments.project_config_dir, "execution_results.json")
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

    result_dict = {
        "applied_suggestions": applied_suggestions,
        "code": p.returncode,
        "stdout": stdout.decode("utf-8") if not timeout_expired else "",
        "stderr": stderr.decode("utf-8") if not timeout_expired else "",
        "timeout_epired": timeout_expired,
        "time": elapsed,
    }
    # check for duplicates and overwrite them
    to_be_removed: List[int] = []
    for idx, entry in enumerate(execution_results[config_name][script_name][settings_name]):
        if entry["applied_suggestions"] == applied_suggestions:
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
