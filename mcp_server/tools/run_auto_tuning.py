# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import logging
import os
import shutil
import signal
import subprocess
import sys
import threading
from collections import deque
from pathlib import Path
from typing import Any, Deque, Optional

from mcp.types import TextContent, Tool

from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.detailed_hotspot_loader import hotspots_json_path, load_detailed_hotspots
from discopop_library.ProjectManager.configurations.validation import VALIDATE_SCRIPT_NAME
from discopop_library.ProjectManager.gui.plots.data import parse_progress_jsonl
from mcp_server.tools.helpers import ToolContext, read_applied_suggestions

logger = logging.getLogger("discopop-mcp")

DEFAULT_ALGORITHM = 6
DEFAULT_TIMEOUT_SECONDS = 3600
# How long the tuner and its children get to shut down after SIGTERM before SIGKILL.
_KILL_GRACE_SECONDS = 10.0
# Only the tail of the tuner's output is kept; it is used for error reporting, the full
# output goes to the server log line by line.
_OUTPUT_TAIL_LINES = 40

TOOL = Tool(
    name="run_auto_tuning",
    description=(
        "Let DiscoPoP's empirical autotuner select a good combination of parallelization "
        "suggestions, and return that selection as a list of suggestion IDs. "
        "Call this after gather_data, when more than a handful of patches exist and the "
        "question is which of them to apply.\n\n"
        "The autotuner compiles, executes and validates candidate patch combinations in "
        "throwaway copies of the project and keeps the fastest combination that still "
        "produces a valid result. The correctness and effectiveness of the selection are "
        "therefore measured, not guessed.\n\n"
        "IMPORTANT: this tool does NOT modify any source file. It only reports the "
        "selection. To persist it, pass the returned suggestion_ids to "
        "manage_patches(action='apply', suggestion_ids=[...]).\n\n"
        "Preconditions:\n"
        "  - gather_data must have been run (patches, line mapping and detection results "
        "must exist).\n"
        "  - No patches may currently be applied: the tuner measures the project in its "
        "current state and patches candidate combinations on top of it. Run "
        "manage_patches(action='clear') first if anything is applied.\n"
        "  - algorithm 6 (the default) requires hotspot detection results — run gather_data "
        "with hotspot_config_names set, ideally with two configurations of different input "
        "sizes.\n\n"
        "NOTE: this is a measurement run. It compiles and executes the project many times "
        "and can take from minutes to hours. Use timeout_seconds to bound it; when the "
        "timeout expires the search is stopped and the best combination measured so far is "
        "still returned with status 'timeout'.\n\n"
        "How far the correctness claim reaches depends on the configuration: without a "
        "validate.sh a candidate counts as valid as soon as it exits with code 0, so a "
        "parallelization that corrupts the output is indistinguishable from a correct one. "
        "Define validate.sh via create_execution_configuration(validate_script_body=...) "
        "before tuning whenever the program's output can be checked. The result carries a "
        "'warnings' list whenever the selection rests on weaker evidence than it appears to."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the project root directory (the parent of .discopop).",
            },
            "config_name": {
                "type": "string",
                "description": (
                    "Name of the execution configuration to tune. Must match a directory "
                    "under .discopop/project/configs/. Its execute.sh should use an input "
                    "that is representative of a production run — the selection is only as "
                    "meaningful as the workload it was measured on."
                ),
            },
            "algorithm": {
                "type": "integer",
                "description": (
                    "Search algorithm. Default: 6.\n"
                    "  0 — no combination; measures every suggestion on its own.\n"
                    "  1 — linear combination; accumulates suggestions that keep the result valid.\n"
                    "  3 — evolutionary combination; uses randomness, so it is not reproducible.\n"
                    "  4 — greedy forward search; one pass over all suggestions, O(N) evaluations.\n"
                    "  5 — coordinate descent; repeated bit-flip passes until no pass improves.\n"
                    "  6 — hotspot-guided region descent; deterministic and measurement-frugal, "
                    "but requires hotspot detection results. Recommended default."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": (
                    "Maximum wall clock time for the whole search. Default: 3600. When it "
                    "expires the tuner is stopped and the best combination measured so far "
                    "is returned with status 'timeout'."
                ),
            },
        },
        "required": ["project_path", "config_name"],
        "additionalProperties": False,
    },
)


def best_from_measurements(events: list[dict[str, Any]]) -> tuple[Optional[dict[str, Any]], Optional[float]]:
    """The fastest usable measurement of a progress stream, plus the baseline runtime.

    Used when the tuner was stopped before it wrote its own ``result`` event. Only
    configurations that were actually executed and passed every check are eligible: an
    entry whose patches never reached the code (``application_failed``) carries no
    runtime at all, and an invalid or crashing run must never be reported as the best
    configuration no matter how fast it was.
    """
    baseline_runtime: Optional[float] = None
    best: Optional[dict[str, Any]] = None
    for event in events:
        if event.get("event") == "baseline":
            runtime = event.get("runtime")
            if isinstance(runtime, (int, float)) and runtime > 0:
                baseline_runtime = float(runtime)
            continue
        if event.get("event") != "measurement":
            continue
        if event.get("application_failed"):
            continue
        if event.get("return_code") != 0 or not event.get("valid") or not event.get("tsan"):
            continue
        runtime = event.get("runtime")
        if not isinstance(runtime, (int, float)) or runtime <= 0:
            continue
        if best is None or float(runtime) < float(best["runtime"]):
            best = event
    return best, baseline_runtime


def _validate_preconditions(project_path: str, config_name: str, dot_dp: str) -> Optional[str]:
    """Check every artefact the autotuner needs, reusing its own validation.

    ``AutotunerArguments.__post_init__`` runs the same check the CLI runs and raises
    ``FileNotFoundError`` for the first missing path. Constructing it here has no side
    effects — the tuner itself runs as a subprocess.
    """
    try:
        AutotunerArguments(
            log_level="WARNING",
            write_log=False,
            dot_dp_path=dot_dp,
            skip_cleanup=False,
            sanitize=False,
            configuration=config_name,
            suggestions=None,
            allow_plots=False,
            thread_count=1,
        )
    except FileNotFoundError as e:
        missing = str(e)
        if os.path.basename(missing) == config_name or f"configs/{config_name}" in missing:
            return (
                f"Configuration '{config_name}' is incomplete or does not exist (missing: {missing}). "
                "Use get_configurations to list the available configurations, or "
                "create_execution_configuration to create one."
            )
        return (
            f"The project is not ready for auto tuning (missing: {missing}). "
            "Run gather_data first so that the profiler results, detection results and "
            "patch files exist."
        )
    return None


def _validate_hotspots(dot_dp: str) -> Optional[str]:
    """Reject algorithm 6 without hotspot data instead of letting it be a silent no-op.

    ``execute_hotspot_guided_combination`` returns right after the baseline measurement
    when no hot loops are known, so the run would burn one compile-and-execute cycle and
    report that nothing could be improved.
    """
    hotspots_file = hotspots_json_path(dot_dp)
    remedy = (
        "Re-run gather_data with hotspot_config_names set (ideally two configurations with "
        "different input sizes), or choose a different algorithm (4 or 5) which does not "
        "need hotspot information."
    )
    if not os.path.exists(hotspots_file):
        return f"algorithm 6 requires hotspot detection results, but {hotspots_file} does not exist. " + remedy
    regions = load_detailed_hotspots(dot_dp)
    if not [region for region in regions if region.node_type == HotspotNodeType.LOOP]:
        return "algorithm 6 requires hot loops, but the hotspot detection results contain none. " + remedy
    return None


def _pump_output(stream: Any, tail: Deque[str], project_path: str, ctx: ToolContext) -> None:
    """Forward the tuner's output to the server log, keeping only a bounded tail."""
    try:
        for raw_line in stream:
            line = raw_line.rstrip("\n")
            if not line.strip():
                continue
            tail.append(line)
            ctx.log_action(project_path, "run_auto_tuning", f"[autotuner] {line}")
    except Exception:  # the stream is closed when the process is killed
        pass


def _terminate(proc: "subprocess.Popen[str]") -> None:
    """Stop the tuner and every compile/execute child it started.

    The tuner is launched in its own session, so signalling the process group reaches
    the compile and execute scripts as well; killing only the tuner would leave a
    long-running benchmark behind.
    """
    try:
        os.killpg(os.getpgid(proc.pid), signal.SIGTERM)
    except (OSError, ProcessLookupError):
        proc.terminate()
    try:
        proc.wait(timeout=_KILL_GRACE_SECONDS)
        return
    except subprocess.TimeoutExpired:
        pass
    try:
        os.killpg(os.getpgid(proc.pid), signal.SIGKILL)
    except (OSError, ProcessLookupError):
        proc.kill()
    try:
        proc.wait(timeout=_KILL_GRACE_SECONDS)
    except subprocess.TimeoutExpired:
        pass


def _cleanup_project_copies(project_path: str, config_name: str, ctx: ToolContext) -> list[str]:
    """Remove the candidate project copies a killed tuner left behind.

    ``copy_configuration`` places every candidate next to the project root, named
    ``<config>_<settings>_<project>_<id>``. A completed run deletes them itself; an
    interrupted one cannot, and they are full copies of the project.
    """
    project_dir = Path(project_path).resolve()
    prefix = f"{config_name}_par_settings.json_{project_dir.name}_"
    removed: list[str] = []
    try:
        candidates = sorted(project_dir.parent.iterdir())
    except OSError:
        return removed
    for entry in candidates:
        if not entry.is_dir() or not entry.name.startswith(prefix):
            continue
        try:
            shutil.rmtree(str(entry))
            removed.append(entry.name)
            ctx.log_action(project_path, "run_auto_tuning", f"Removed leftover project copy {entry}")
        except OSError as e:
            ctx.log_action(project_path, "run_auto_tuning", f"Could not remove leftover project copy {entry}: {e}")
    return removed


def _validation_notes(dot_dp: str, config_name: str, result: dict[str, Any]) -> list[str]:
    """Say how far the tuner's "the result stays valid" claim actually reaches.

    Without a ``validate.sh`` a candidate counts as valid as soon as it exits with code
    0, so a parallelization that silently corrupts the output is indistinguishable from
    a correct one — and it is usually also the fastest candidate. A speedup above the
    thread count is the symptom that shows up first, since no correct parallelization
    can exceed it.
    """
    notes: list[str] = []
    validate_script = Path(dot_dp) / "project" / "configs" / config_name / VALIDATE_SCRIPT_NAME
    if not validate_script.exists():
        notes.append(
            f"Configuration '{config_name}' has no {VALIDATE_SCRIPT_NAME}, so a candidate counted as "
            "valid merely exited with code 0 — its output was never checked. Add one via "
            "create_execution_configuration(validate_script_body=...) to let the tuner verify "
            "correctness, and review the selected patches before trusting them."
        )
    speedup = result.get("speedup")
    threads = result.get("thread_count")
    if isinstance(speedup, (int, float)) and isinstance(threads, (int, float)) and threads > 0:
        if speedup > threads:
            notes.append(
                f"The measured speedup ({speedup}) exceeds the thread count ({int(threads)}), which no "
                "correct parallelization can do. The selected combination most likely skips work "
                "rather than distributing it — verify the program's output before applying it."
            )
    return notes


def _progress_file(dot_dp: str) -> Path:
    return Path(dot_dp) / "auto_tuner" / "progress.jsonl"


def _progress_mtime(dot_dp: str) -> Optional[float]:
    """The progress file's mtime, or None when it does not exist.

    Sampled before and after the run so a progress file left over from an earlier
    invocation is never mistaken for this run's output.
    """
    try:
        return _progress_file(dot_dp).stat().st_mtime
    except OSError:
        return None


def _read_progress_events(dot_dp: str) -> list[dict[str, Any]]:
    progress_file = _progress_file(dot_dp)
    if not progress_file.exists():
        return []
    try:
        return parse_progress_jsonl(progress_file.read_text())
    except OSError:
        return []


def _result_from_events(events: list[dict[str, Any]], timed_out: bool) -> dict[str, Any]:
    """Turn the tuner's progress stream into the tool's result payload."""
    baseline = next((e for e in events if e.get("event") == "baseline"), None)
    baseline_runtime = baseline.get("runtime") if baseline else None
    thread_count = baseline.get("thread_count") if baseline else None
    final = next((e for e in reversed(events) if e.get("event") == "result"), None)

    if final is not None and not timed_out:
        return {
            "status": "success",
            "thread_count": thread_count,
            "suggestion_ids": [str(s) for s in final.get("suggestions", [])],
            "speedup": final.get("speedup"),
            "efficiency": final.get("efficiency"),
            "runtime": final.get("runtime"),
            "baseline_runtime": baseline_runtime,
            "evaluated_configurations": final.get("evaluated"),
            "valid_count": final.get("valid_count"),
            "invalid_count": final.get("invalid_count"),
            "failed_count": final.get("failed_count"),
            "not_applied_count": final.get("not_applied_count"),
            "optimization_time_s": final.get("optimization_time_s"),
        }

    best, measured_baseline = best_from_measurements(events)
    reference = baseline_runtime if isinstance(baseline_runtime, (int, float)) else measured_baseline
    speedup = best.get("speedup") if best else None
    if speedup is None and best and reference:
        runtime = best.get("runtime")
        if isinstance(runtime, (int, float)) and runtime > 0:
            speedup = round(float(reference) / float(runtime), 4)
    return {
        "status": "timeout" if timed_out else "success",
        "partial": True,
        "thread_count": thread_count,
        "suggestion_ids": [str(s) for s in best.get("suggestions", [])] if best else [],
        "speedup": speedup,
        "runtime": best.get("runtime") if best else None,
        "baseline_runtime": reference,
        "evaluated_configurations": len([e for e in events if e.get("event") == "measurement"]),
    }


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path: str = arguments.get("project_path", "")
        config_name: str = arguments.get("config_name", "")
        algorithm: int = arguments.get("algorithm", DEFAULT_ALGORITHM)
        timeout_seconds: int = arguments.get("timeout_seconds", DEFAULT_TIMEOUT_SECONDS)

        dot_dp = str(Path(project_path) / ".discopop")
        if not os.path.exists(dot_dp):
            return ctx.error(
                "DiscoPoP directory not found. Run initialize_discopop_directory and gather_data first.",
                project_path,
                "run_auto_tuning",
            )

        precondition_error = _validate_preconditions(project_path, config_name, dot_dp)
        if precondition_error is not None:
            return ctx.error(precondition_error, project_path, "run_auto_tuning")

        if algorithm == 6:
            hotspot_error = _validate_hotspots(dot_dp)
            if hotspot_error is not None:
                return ctx.error(hotspot_error, project_path, "run_auto_tuning")

        # The tuner measures the project as it stands and applies each candidate on top of
        # a copy of it. Patches that are already in the code would therefore be counted as
        # part of the baseline and stacked under every candidate, which makes both the
        # measurements and the returned selection wrong.
        applied, applied_error = read_applied_suggestions(project_path)
        if applied_error is not None:
            return ctx.error(applied_error, project_path, "run_auto_tuning")
        if applied:
            return ctx.error(
                "The following suggestions are currently applied to the source files: "
                + ", ".join(applied)
                + ". Auto tuning measures the project in its current state and patches every "
                "candidate on top of it, so the results would be wrong. Run "
                "manage_patches(action='clear') first, then call run_auto_tuning again.",
                project_path,
                "run_auto_tuning",
            )

        cmd = [
            sys.executable,
            "-m",
            "discopop_library.EmpiricalAutotuning",
            "--dot-dp-path",
            dot_dp,
            "-c",
            config_name,
            "-A",
            str(algorithm),
            "--log",
            "WARNING",
        ]
        ctx.log_action(
            project_path,
            "run_auto_tuning",
            f"config={config_name}, algorithm={algorithm}, timeout={timeout_seconds}s, cmd={cmd}",
        )

        tail: Deque[str] = deque(maxlen=_OUTPUT_TAIL_LINES)
        progress_mtime_before = _progress_mtime(dot_dp)
        # start_new_session puts the tuner into its own process group so a timeout can
        # take down the compile and execute scripts it spawned along with it.
        proc = subprocess.Popen(
            cmd,
            cwd=dot_dp,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            start_new_session=True,
        )
        pump = threading.Thread(target=_pump_output, args=(proc.stdout, tail, project_path, ctx), daemon=True)
        pump.start()

        timed_out = False
        try:
            returncode = proc.wait(timeout=timeout_seconds)
        except subprocess.TimeoutExpired:
            timed_out = True
            ctx.log_action(
                project_path,
                "run_auto_tuning",
                f"Timeout after {timeout_seconds}s — stopping the autotuner",
            )
            _terminate(proc)
            returncode = proc.returncode if proc.returncode is not None else -1
        pump.join(timeout=5.0)

        removed_copies = _cleanup_project_copies(project_path, config_name, ctx) if timed_out else []

        # A progress file that this run did not write belongs to an earlier one. Reporting
        # it would present an old run's selection as the result of this one.
        events = _read_progress_events(dot_dp) if _progress_mtime(dot_dp) != progress_mtime_before else []
        if not events:
            if timed_out:
                message = (
                    f"The timeout of {timeout_seconds}s expired before the autotuner completed its "
                    "first measurement, so no configuration could be evaluated. A single measurement "
                    "covers one compilation plus one execution of the project — re-run with a "
                    "timeout_seconds large enough for several of those."
                )
            else:
                message = f"The autotuner produced no measurements (rc={returncode})."
            if tail:
                message += " Last output:\n" + "\n".join(tail)
            return ctx.error(message, project_path, "run_auto_tuning")

        result = _result_from_events(events, timed_out)
        result["project_path"] = project_path
        result["config_name"] = config_name
        result["algorithm"] = algorithm

        if timed_out:
            result["message"] = (
                f"The search was stopped after {timeout_seconds}s. The reported combination is the "
                "best one measured so far; the search was not completed and the final pass that "
                "checks whether an accepted suggestion can be removed again did not run. "
                "Re-run with a larger timeout_seconds for a complete search."
            )
            if removed_copies:
                result["removed_project_copies"] = removed_copies
        elif returncode != 0:
            # measurements exist, so the outcome is still usable — but say what happened
            result["status"] = "partial"
            result["returncode"] = returncode
            result["message"] = (
                f"The autotuner exited with code {returncode}. The reported combination is derived "
                "from the measurements it had written. Last output:\n" + "\n".join(tail)
            )
        elif not result["suggestion_ids"]:
            result["message"] = (
                "No combination of suggestions was faster than the unmodified project, so no "
                "suggestion is recommended for application."
            )
        else:
            result["message"] = (
                "Pass suggestion_ids to manage_patches(action='apply', suggestion_ids=[...]) to "
                "persist this selection. No source file has been modified by this tool."
            )

        # How much the "the result stays valid" claim is worth depends on the configuration,
        # so the caller is told rather than left to assume the strongest reading.
        if result["suggestion_ids"]:
            warnings = _validation_notes(dot_dp, config_name, result)
            if warnings:
                result["warnings"] = warnings

        ctx.log_response("run_auto_tuning", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error in run_auto_tuning: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
