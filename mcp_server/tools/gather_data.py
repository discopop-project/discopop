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
import subprocess
import sys
from pathlib import Path
from typing import Any, Optional

from mcp.types import TextContent, Tool

from discopop_library.ProjectManager.configurations.execution import execute_configuration
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="gather_data",
    description=(
        "Run the complete DiscoPoP data collection pipeline and detect parallelization patterns. "
        "Call this after set_compile_script and create_execution_configuration. "
        "\n\n"
        "The pipeline consists of two phases:\n"
        "\n"
        "OPTIONAL — Hotspot detection (enabled when hotspot_config_names is non-empty):\n"
        "  1. Compile with hotspot instrumentation (hd_settings.json).\n"
        "  2. Run the binary once per config in hotspot_config_names to accumulate timing data.\n"
        "     Use at least 2 configs with different input sizes for accurate classification.\n"
        "  3. Analyse timing data to classify regions as YES/MAYBE/NO hotspots.\n"
        "  If hotspot detection is enabled, pattern analysis focuses on hotspot regions.\n"
        "  If omitted, pattern analysis covers the entire codebase.\n"
        "\n"
        "REQUIRED — Data collection and pattern detection:\n"
        "  4. Compile with DiscoPoP instrumentation (dp_settings.json).\n"
        "  5. Run the instrumented binary to collect runtime dependency traces.\n"
        "     NOTE: significant runtime overhead expected — use small inputs.\n"
        "  6. Analyse with discopop_explorer to detect parallelization opportunities.\n"
        "\n"
        "Each step is automatically skipped when its outputs are already current "
        "relative to the source files. Use force=true to re-run all steps unconditionally. "
        "\n\n"
        "On success, call get_parallelization_patches to retrieve the generated patches."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the project root.",
            },
            "config_name": {
                "type": "string",
                "description": (
                    "Name of the execution configuration to use for compilation and profiling "
                    "(steps 4 and 5). Must match a directory under .discopop/project/configs/."
                ),
            },
            "hotspot_config_names": {
                "type": "array",
                "items": {"type": "string"},
                "description": (
                    "Optional. List of configuration names for hotspot profiling runs (step 2). "
                    "At least 1 name is required to enable hotspot detection. "
                    "Using ≥2 configs with different input sizes improves classification accuracy, "
                    "but a single config is accepted (results may be less accurate). "
                    "If omitted, hotspot detection is skipped entirely."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": ("Maximum time in seconds for each individual pipeline step. Default: 3600."),
            },
            "force": {
                "type": "boolean",
                "description": ("Set to true to re-run all steps even if outputs are already current. Default: false."),
            },
        },
        "required": ["project_path", "config_name"],
        "additionalProperties": False,
    },
)


def _log_stdout(project_path: str, step: str, stdout: str, ctx: ToolContext) -> None:
    """Log stdout lines to daemon console only — stdout is never returned to the LLM."""
    if stdout and stdout.strip():
        for line in stdout.strip().splitlines():
            ctx.log_action(project_path, "gather_data", f"[{step}] stdout: {line}")


def _hotspot_instrument(
    project_path: str,
    config_name: str,
    timeout_seconds: int,
    force: bool,
    ctx: ToolContext,
    source_mtime: Optional[float],
) -> dict[str, Any]:
    p = Path(project_path)
    configs_dir = p / ".discopop" / "project" / "configs"
    compile_sh = configs_dir / "compile.sh"
    hd_settings = configs_dir / "hd_settings.json"
    hotspot_dir = p / ".discopop" / "hotspot_detection"
    private_dir = hotspot_dir / "private"
    config_dir = configs_dir / config_name

    if not compile_sh.exists():
        return {"status": "error", "message": "compile.sh not found. Run set_compile_script first."}
    if not hd_settings.exists():
        return {"status": "error", "message": "hd_settings.json not found. Run initialize_discopop_directory first."}
    if not config_dir.exists():
        return {"status": "error", "message": f"Configuration '{config_name}' not found."}

    if not force and private_dir.exists():
        result_files = list(private_dir.glob("hotspot_result_*.txt"))
        if result_files:
            last_run_mtime = max(f.stat().st_mtime for f in result_files)
            if source_mtime is None or source_mtime <= last_run_mtime:
                return {
                    "status": "skipped",
                    "reason": "results_are_current",
                    "last_run": ToolContext.fmt_ts(last_run_mtime),
                    "num_runs_accumulated": len(result_files),
                }

    if hotspot_dir.exists():
        shutil.rmtree(str(hotspot_dir))
        ctx.log_action(project_path, "gather_data", "Deleted stale .discopop/hotspot_detection/")

    pm_args = ctx.make_pm_args(project_path, timeout_seconds)
    ctx.log_action(
        project_path,
        "gather_data",
        f"Hotspot instrumentation: compile.sh via hd_settings, config='{config_name}', timeout={timeout_seconds}s",
    )
    original_cwd = os.getcwd()
    try:
        exec_result = execute_configuration(
            arguments=pm_args,
            project_copy_root_path=project_path,
            config_path=str(config_dir),
            settings_path=str(hd_settings),
            script_path=str(compile_sh),
            thread_count=1,
            timeout=float(timeout_seconds),
        )
    finally:
        os.chdir(original_cwd)

    if exec_result is None:
        return {"status": "error", "message": "execute_configuration returned None for hd_settings.json."}

    returncode, elapsed, stdout, stderr = exec_result
    _log_stdout(project_path, "hotspot_instrument", stdout, ctx)

    if returncode != 0:
        return {
            "status": "error",
            "message": f"Hotspot instrumentation failed (rc={returncode}).",
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    ctx.log_action(project_path, "gather_data", f"Hotspot instrumentation succeeded in {elapsed}s")
    return {"status": "success", "elapsed_time": elapsed}


def _hotspot_profiling_single(
    project_path: str,
    config_name: str,
    timeout_seconds: int,
    force: bool,
    ctx: ToolContext,
    source_mtime: Optional[float],
) -> dict[str, Any]:
    p = Path(project_path)
    configs_dir = p / ".discopop" / "project" / "configs"
    hd_settings = configs_dir / "hd_settings.json"
    execute_sh = configs_dir / config_name / "execute.sh"
    private_dir = p / ".discopop" / "hotspot_detection" / "private"

    if not execute_sh.exists():
        return {"status": "error", "message": f"execute.sh not found for configuration '{config_name}'."}
    if not hd_settings.exists():
        return {"status": "error", "message": "hd_settings.json not found."}

    if not force and private_dir.exists():
        existing = list(private_dir.glob("hotspot_result_*.txt"))
        if existing:
            last_run_mtime = max(f.stat().st_mtime for f in existing)
            if source_mtime is None or source_mtime <= last_run_mtime:
                return {
                    "status": "skipped",
                    "reason": "results_are_current",
                    "num_runs_accumulated": len(existing),
                }

    pm_args = ctx.make_pm_args(project_path, timeout_seconds)
    ctx.log_action(
        project_path,
        "gather_data",
        f"Hotspot profiling: execute.sh for config='{config_name}', timeout={timeout_seconds}s",
    )
    original_cwd = os.getcwd()
    try:
        exec_result = execute_configuration(
            arguments=pm_args,
            project_copy_root_path=project_path,
            config_path=str(configs_dir / config_name),
            settings_path=str(hd_settings),
            script_path=str(execute_sh),
            thread_count=1,
            timeout=float(timeout_seconds),
        )
    finally:
        os.chdir(original_cwd)

    if exec_result is None:
        return {"status": "error", "message": "execute_configuration returned None."}

    returncode, elapsed, stdout, stderr = exec_result
    _log_stdout(project_path, f"hotspot_profiling[{config_name}]", stdout, ctx)
    result_files = sorted(private_dir.glob("hotspot_result_*.txt")) if private_dir.exists() else []

    if returncode != 0:
        return {
            "status": "error",
            "message": f"Hotspot profiling failed for '{config_name}' (rc={returncode}).",
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    if not result_files:
        return {
            "status": "error",
            "message": (
                f"Binary ran for '{config_name}' but no hotspot_result_*.txt files were created. "
                "Re-run hotspot instrumentation."
            ),
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    ctx.log_action(
        project_path,
        "gather_data",
        f"Hotspot profiling done in {elapsed}s: {len(result_files)} run(s) accumulated",
    )
    return {"status": "success", "elapsed_time": elapsed}


def _hotspot_analysis(
    project_path: str, timeout_seconds: int, force: bool, ctx: ToolContext, source_mtime: Optional[float]
) -> dict[str, Any]:
    p = Path(project_path)
    discopop_dir = p / ".discopop"
    private_dir = discopop_dir / "hotspot_detection" / "private"
    hotspots_json = discopop_dir / "hotspot_detection" / "Hotspots.json"

    if not private_dir.exists():
        return {"status": "error", "message": "No hotspot profiling data found (.discopop/hotspot_detection/private/)."}
    result_files = list(private_dir.glob("hotspot_result_*.txt"))
    if not result_files:
        return {"status": "error", "message": "No hotspot_result_*.txt files found."}

    if not force and hotspots_json.exists():
        analysis_mtime = hotspots_json.stat().st_mtime
        if source_mtime is None or source_mtime <= analysis_mtime:
            return {
                "status": "skipped",
                "reason": "results_are_current",
                "last_run": ToolContext.fmt_ts(analysis_mtime),
            }

    venv_bin = os.path.dirname(sys.executable)
    env = os.environ.copy()
    if venv_bin not in env.get("PATH", ""):
        env["PATH"] = venv_bin + os.pathsep + env.get("PATH", "")

    analyzer = shutil.which("discopop_hotspot_analyzer", path=env["PATH"])
    if not analyzer:
        return {"status": "error", "message": "discopop_hotspot_analyzer not found on PATH."}

    ctx.log_action(
        project_path,
        "gather_data",
        f"Hotspot analysis: invoking discopop_hotspot_analyzer ({len(result_files)} run(s))",
    )
    try:
        proc = subprocess.run(
            [analyzer],
            cwd=str(discopop_dir),
            capture_output=True,
            text=True,
            env=env,
            timeout=timeout_seconds,
        )
    except subprocess.TimeoutExpired:
        return {"status": "error", "message": f"discopop_hotspot_analyzer timed out after {timeout_seconds}s."}

    _log_stdout(project_path, "hotspot_analysis", proc.stdout, ctx)

    if proc.returncode != 0:
        return {
            "status": "error",
            "message": f"discopop_hotspot_analyzer failed (rc={proc.returncode}).",
            "returncode": proc.returncode,
            "stderr": proc.stderr,
        }

    hotness_summary: dict[str, int] = {"YES": 0, "MAYBE": 0, "NO": 0}
    hotspots_found = 0
    if hotspots_json.exists():
        try:
            data = json.loads(hotspots_json.read_text())
            for region in data.get("code_regions", []):
                hotness = region.get("hotness", "")
                if hotness in hotness_summary:
                    hotness_summary[hotness] += 1
                hotspots_found += 1
        except Exception:
            pass

    ctx.log_action(
        project_path,
        "gather_data",
        f"Hotspot analysis complete: {hotspots_found} regions "
        f"(YES={hotness_summary['YES']}, MAYBE={hotness_summary['MAYBE']}, NO={hotness_summary['NO']})",
    )
    return {"status": "success"}


def _instrument_project(
    project_path: str,
    config_name: str,
    timeout_seconds: int,
    force: bool,
    ctx: ToolContext,
    source_mtime: Optional[float],
) -> dict[str, Any]:
    p = Path(project_path)
    configs_dir = p / ".discopop" / "project" / "configs"
    compile_sh = configs_dir / "compile.sh"
    dp_settings = configs_dir / "dp_settings.json"
    profiler_dir = p / ".discopop" / "profiler"
    data_xml = profiler_dir / "Data.xml"
    config_dir = configs_dir / config_name

    if not compile_sh.exists():
        return {"status": "error", "message": "compile.sh not found. Run set_compile_script first."}
    if not dp_settings.exists():
        return {"status": "error", "message": "dp_settings.json not found. Run initialize_discopop_directory first."}
    if not config_dir.exists():
        return {"status": "error", "message": f"Configuration '{config_name}' not found."}

    if not force and data_xml.exists():
        result_mtime = data_xml.stat().st_mtime
        if source_mtime is None or source_mtime <= result_mtime:
            return {
                "status": "skipped",
                "reason": "results_are_current",
                "last_run": ToolContext.fmt_ts(result_mtime),
            }

    if profiler_dir.exists():
        shutil.rmtree(str(profiler_dir))
        ctx.log_action(project_path, "gather_data", "Deleted stale .discopop/profiler/")

    pm_args = ctx.make_pm_args(project_path, timeout_seconds)
    ctx.log_action(
        project_path,
        "gather_data",
        f"Instrumentation: compile.sh via dp_settings, config='{config_name}', timeout={timeout_seconds}s",
    )
    original_cwd = os.getcwd()
    try:
        exec_result = execute_configuration(
            arguments=pm_args,
            project_copy_root_path=project_path,
            config_path=str(config_dir),
            settings_path=str(dp_settings),
            script_path=str(compile_sh),
            thread_count=1,
            timeout=float(timeout_seconds),
        )
    finally:
        os.chdir(original_cwd)

    if exec_result is None:
        return {"status": "error", "message": "execute_configuration returned None for dp_settings.json."}

    returncode, elapsed, stdout, stderr = exec_result
    _log_stdout(project_path, "instrument_project", stdout, ctx)

    if returncode != 0:
        return {
            "status": "error",
            "message": f"Instrumentation failed (rc={returncode}).",
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    if not data_xml.exists():
        return {
            "status": "error",
            "message": "Compilation succeeded but Data.xml was not created. Ensure discopop_cxx is on PATH.",
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    ctx.log_action(project_path, "gather_data", f"Instrumentation succeeded in {elapsed}s")
    return {"status": "success", "elapsed_time": elapsed}


def _run_profiling(
    project_path: str,
    config_name: str,
    timeout_seconds: int,
    force: bool,
    ctx: ToolContext,
    source_mtime: Optional[float],
) -> dict[str, Any]:
    p = Path(project_path)
    configs_dir = p / ".discopop" / "project" / "configs"
    dp_settings = configs_dir / "dp_settings.json"
    execute_sh = configs_dir / config_name / "execute.sh"
    data_xml = p / ".discopop" / "profiler" / "Data.xml"
    dyn_deps = p / ".discopop" / "profiler" / "dynamic_dependencies.txt"

    if not execute_sh.exists():
        return {"status": "error", "message": f"execute.sh not found for configuration '{config_name}'."}
    if not data_xml.exists():
        return {"status": "error", "message": "profiler/Data.xml not found — instrumentation step must have failed."}
    if not dp_settings.exists():
        return {"status": "error", "message": "dp_settings.json not found."}

    if not force and dyn_deps.exists():
        result_mtime = dyn_deps.stat().st_mtime
        if source_mtime is None or source_mtime <= result_mtime:
            return {
                "status": "skipped",
                "reason": "results_are_current",
                "last_run": ToolContext.fmt_ts(result_mtime),
            }

    pm_args = ctx.make_pm_args(project_path, timeout_seconds)
    ctx.log_action(
        project_path,
        "gather_data",
        f"Profiling: execute.sh for config='{config_name}', timeout={timeout_seconds}s",
    )
    original_cwd = os.getcwd()
    try:
        exec_result = execute_configuration(
            arguments=pm_args,
            project_copy_root_path=project_path,
            config_path=str(configs_dir / config_name),
            settings_path=str(dp_settings),
            script_path=str(execute_sh),
            thread_count=1,
            timeout=float(timeout_seconds),
        )
    finally:
        os.chdir(original_cwd)

    if exec_result is None:
        return {"status": "error", "message": "execute_configuration returned None."}

    returncode, elapsed, stdout, stderr = exec_result
    _log_stdout(project_path, "run_profiling", stdout, ctx)

    if returncode != 0:
        return {
            "status": "error",
            "message": f"Profiling failed (rc={returncode}).",
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    if not dyn_deps.exists():
        return {
            "status": "error",
            "message": (
                "Binary ran but dynamic_dependencies.txt was not created. " "Re-run instrumentation and try again."
            ),
            "returncode": returncode,
            "elapsed_time": elapsed,
            "stderr": stderr,
        }
    ctx.log_action(project_path, "gather_data", f"Profiling complete in {elapsed}s")
    return {"status": "success", "elapsed_time": elapsed}


def _run_pattern_detection(
    project_path: str, timeout_seconds: int, force: bool, ctx: ToolContext, source_mtime: Optional[float]
) -> dict[str, Any]:
    p = Path(project_path)
    discopop_dir = p / ".discopop"
    data_xml = discopop_dir / "profiler" / "Data.xml"
    dyn_deps = discopop_dir / "profiler" / "dynamic_dependencies.txt"
    patterns_json = discopop_dir / "explorer" / "patterns.json"

    if not data_xml.exists():
        return {"status": "error", "message": "profiler/Data.xml not found — instrumentation step must have failed."}
    if not dyn_deps.exists():
        return {
            "status": "error",
            "message": "profiler/dynamic_dependencies.txt not found — profiling step must have failed.",
        }

    if not force and patterns_json.exists():
        result_mtime = patterns_json.stat().st_mtime
        if source_mtime is None or source_mtime <= result_mtime:
            return {
                "status": "skipped",
                "reason": "results_are_current",
                "last_run": ToolContext.fmt_ts(result_mtime),
            }

    venv_bin = os.path.dirname(sys.executable)
    env = os.environ.copy()
    if venv_bin not in env.get("PATH", ""):
        env["PATH"] = venv_bin + os.pathsep + env.get("PATH", "")

    explorer = shutil.which("discopop_explorer", path=env["PATH"])
    if not explorer:
        return {"status": "error", "message": "discopop_explorer not found on PATH."}

    ctx.log_action(project_path, "gather_data", "Pattern detection: invoking discopop_explorer")
    try:
        proc = subprocess.run(
            [explorer],
            cwd=str(discopop_dir),
            capture_output=True,
            text=True,
            env=env,
            timeout=timeout_seconds,
        )
    except subprocess.TimeoutExpired:
        return {"status": "error", "message": f"discopop_explorer timed out after {timeout_seconds}s."}

    _log_stdout(project_path, "pattern_detection", proc.stdout, ctx)

    if proc.returncode != 0:
        return {
            "status": "error",
            "message": f"discopop_explorer failed (rc={proc.returncode}).",
            "returncode": proc.returncode,
            "stderr": proc.stderr,
        }

    ctx.log_action(project_path, "gather_data", "Pattern detection complete")
    return {"status": "success"}


def _progress(step: int, total: int, label: str) -> None:
    from termcolor import colored

    prefix = colored(f"[gather_data {step}/{total}]", "cyan", attrs=["bold"])
    sys.stderr.write(f"\r{prefix} {label}...\n")
    sys.stderr.flush()


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        config_name = arguments.get("config_name", "")
        hotspot_config_names: list[str] = arguments.get("hotspot_config_names") or []
        timeout_seconds: int = arguments.get("timeout_seconds", 3600)
        force: bool = arguments.get("force", False)

        steps: dict[str, Any] = {}
        hotspot_detection_enabled = len(hotspot_config_names) >= 1
        hotspot_ok = True

        # Compute source mtime once and reuse across all staleness checks.
        source_mtime = ToolContext.newest_source_mtime(project_path)

        num_hd_steps = 3 if hotspot_detection_enabled else 0
        total_steps = num_hd_steps + 3  # instrument + profile + detect
        step = 0

        # === Optional: hotspot detection pipeline ===
        if hotspot_detection_enabled:
            step += 1
            _progress(step, total_steps, "Hotspot instrumentation")
            hd_instr = _hotspot_instrument(project_path, config_name, timeout_seconds, force, ctx, source_mtime)
            steps["hotspot_instrumentation"] = hd_instr

            if hd_instr["status"] in ("success", "skipped"):
                step += 1
                _progress(step, total_steps, f"Hotspot profiling ({len(hotspot_config_names)} config(s))")
                profiling_runs: list[dict[str, Any]] = []
                for hd_config in hotspot_config_names:
                    run_res = _hotspot_profiling_single(
                        project_path, hd_config, timeout_seconds, force, ctx, source_mtime
                    )
                    profiling_runs.append({"config": hd_config, **run_res})
                steps["hotspot_profiling"] = profiling_runs

                if all(r["status"] in ("success", "skipped") for r in profiling_runs):
                    step += 1
                    _progress(step, total_steps, "Hotspot analysis")
                    hd_analysis = _hotspot_analysis(project_path, timeout_seconds, force, ctx, source_mtime)
                    steps["hotspot_analysis"] = hd_analysis
                    if hd_analysis["status"] not in ("success", "skipped"):
                        hotspot_ok = False
                else:
                    step += 1
                    hotspot_ok = False
                    steps["hotspot_analysis"] = {"status": "not_run", "reason": "hotspot_profiling_failed"}
            else:
                step += 2
                hotspot_ok = False
                steps["hotspot_profiling"] = []
                steps["hotspot_analysis"] = {"status": "not_run", "reason": "hotspot_instrumentation_failed"}

        # === Required: instrument project ===
        step += 1
        _progress(step, total_steps, "DiscoPoP instrumentation (compile)")
        instr = _instrument_project(project_path, config_name, timeout_seconds, force, ctx, source_mtime)
        steps["instrumentation"] = instr
        if instr["status"] not in ("success", "skipped"):
            result: dict[str, Any] = {
                "status": "error",
                "project_path": project_path,
                "message": "Instrumentation failed. See steps.instrumentation for details.",
                "hotspot_detection_enabled": hotspot_detection_enabled,
                "steps": steps,
            }
            ctx.log_response("gather_data", result)
            return [TextContent(type="text", text=json.dumps(result))]

        # === Required: run instrumented binary ===
        step += 1
        _progress(step, total_steps, "Profiling (run instrumented binary)")
        prof = _run_profiling(project_path, config_name, timeout_seconds, force, ctx, source_mtime)
        steps["profiling"] = prof
        if prof["status"] not in ("success", "skipped"):
            result = {
                "status": "error",
                "project_path": project_path,
                "message": "Profiling failed. See steps.profiling for details.",
                "hotspot_detection_enabled": hotspot_detection_enabled,
                "steps": steps,
            }
            ctx.log_response("gather_data", result)
            return [TextContent(type="text", text=json.dumps(result))]

        # === Required: pattern detection ===
        step += 1
        _progress(step, total_steps, "Pattern detection (discopop_explorer)")
        detection = _run_pattern_detection(project_path, timeout_seconds, force, ctx, source_mtime)
        steps["pattern_detection"] = detection
        if detection["status"] not in ("success", "skipped"):
            result = {
                "status": "error",
                "project_path": project_path,
                "message": "Pattern detection failed. See steps.pattern_detection for details.",
                "hotspot_detection_enabled": hotspot_detection_enabled,
                "steps": steps,
            }
            ctx.log_response("gather_data", result)
            return [TextContent(type="text", text=json.dumps(result))]

        from termcolor import colored

        sys.stderr.write(f"\r{colored('[gather_data] Pipeline complete.', 'green', attrs=['bold'])}\n")
        sys.stderr.flush()

        result = {
            "status": "success",
            "project_path": project_path,
            "hotspot_detection_enabled": hotspot_detection_enabled,
            "steps": steps,
        }
        if hotspot_detection_enabled and not hotspot_ok:
            result["warning"] = "Hotspot detection failed; pattern analysis covers the entire codebase."
        ctx.log_response("gather_data", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error in gather_data: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
