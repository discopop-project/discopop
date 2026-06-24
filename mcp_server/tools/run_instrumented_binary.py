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
from pathlib import Path
from typing import Any

from mcp.types import TextContent, Tool

from discopop_library.ProjectManager.configurations.execution import execute_configuration
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="run_instrumented_binary",
    description=(
        "Run the instrumented binary to collect runtime data dependency traces. "
        "Call this after instrument_project succeeds. "
        "\n\n"
        "This tool runs the named configuration's execute.sh using dp_settings.json "
        "(the same settings used during instrumentation). The instrumented binary "
        "communicates with the DiscoPoP runtime library to record every memory access "
        "and data dependency at runtime. This produces:\n"
        "  .discopop/profiler/dynamic_dependencies.txt  — RAW/WAR/WAW dependency traces\n"
        "  .discopop/profiler/loop_counter_output.txt   — loop iteration counts\n"
        "  .discopop/profiler/reduction.txt             — detected reduction operations\n"
        "  .discopop/profiler/memory_regions.txt        — memory region data\n"
        "\n"
        "The recorded data dependencies are grounded in the actual observed execution "
        "rather than being estimated or assumed from the source code. Crucially, they "
        "are not pessimistic: only dependencies that actually occurred during the run "
        "are recorded, not all dependencies that could theoretically occur. This makes "
        "them a reliable and precise basis for parallelization analysis.\n"
        "\n"
        "NOTE: Profiling incurs significant runtime overhead — the instrumented binary "
        "will run noticeably slower than the original. In particularly bad cases overhead "
        "can reach up to 100x, although the average is far below that. Long execution "
        "times must be expected. To keep profiling practical, use the smallest input or "
        "problem size that still exercises the loops of interest. If no suitable small "
        "input exists, increase timeout_seconds accordingly. "
        "\n\n"
        "The quality of pattern detection depends directly on how representative the "
        "execution is. Multiple configurations with different inputs can be created and "
        "run independently to profile different code paths. "
        "\n\n"
        "NOTE: Data dependency profiling does not determine which code regions are "
        "hotspots. It only records which dependencies exist. To additionally identify "
        "hotspot regions, run the optional hotspot detection pipeline "
        "(instrument_for_hotspot_detection → run_hotspot_profiling × ≥2 → "
        "run_hotspot_analysis) before instrument_project. "
        "\n\n"
        "After this tool succeeds, call run_pattern_detection to analyse the collected data."
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
                    "Name of the configuration whose execute.sh to run. "
                    "Must match a directory under .discopop/project/configs/."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": (
                    "Maximum time in seconds for the binary to run. Default: 3600. "
                    "Set this to accommodate the expected runtime with its input."
                ),
            },
        },
        "required": ["project_path", "config_name"],
        "additionalProperties": False,
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        config_name = arguments.get("config_name", "")
        timeout_seconds = arguments.get("timeout_seconds", 3600)

        p = Path(project_path)
        configs_dir = p / ".discopop" / "project" / "configs"
        dp_settings = configs_dir / "dp_settings.json"
        execute_sh = configs_dir / config_name / "execute.sh"
        data_xml = p / ".discopop" / "profiler" / "Data.xml"

        if not execute_sh.exists():
            return ctx.error(
                f"execute.sh not found for configuration '{config_name}'. " "Run create_execution_configuration first."
            )
        if not data_xml.exists():
            return ctx.error(
                "profiler/Data.xml not found. Run instrument_project first to compile with instrumentation."
            )
        if not dp_settings.exists():
            return ctx.error("dp_settings.json not found. Run initialize_discopop_directory first.")

        pm_args = ctx.make_pm_args(project_path, timeout_seconds)

        ctx.log_action(
            project_path,
            "run_instrumented_binary",
            f"Launching execute.sh for config='{config_name}' to collect runtime profiling data, timeout={timeout_seconds}s",
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
            return ctx.error("execute_configuration returned None — dp_settings.json may be missing or malformed.")

        returncode, elapsed, stdout, stderr = exec_result

        profiler_dir = p / ".discopop" / "profiler"
        profiling_files = (
            [str(f.relative_to(p)) for f in profiler_dir.rglob("*") if f.is_file()] if profiler_dir.exists() else []
        )

        dyn_deps = p / ".discopop" / "profiler" / "dynamic_dependencies.txt"
        if returncode != 0:
            result: dict[str, Any] = {
                "status": "error",
                "message": f"Binary execution failed with return code {returncode}.",
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        elif not dyn_deps.exists():
            result = {
                "status": "error",
                "message": (
                    "Binary ran but dynamic_dependencies.txt was not created. "
                    "The binary may not have been compiled with instrumentation — "
                    "re-run instrument_project and try again."
                ),
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        else:
            ctx.log_action(
                project_path,
                "run_instrumented_binary",
                f"Profiling complete in {elapsed}s: {len(profiling_files)} output files collected",
            )
            result = {
                "status": "success",
                "project_path": project_path,
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
                "profiling_files": profiling_files,
            }

        ctx.log_response("run_instrumented_binary", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error running instrumented binary: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
