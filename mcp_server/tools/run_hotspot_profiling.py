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
    name="run_hotspot_profiling",
    description=(
        "OPTIONAL STEP. Run the hotspot-instrumented binary to collect timing data. "
        "Call this after instrument_for_hotspot_detection. "
        "\n\n"
        "This tool runs the named configuration's execute.sh using hd_settings.json. "
        "The instrumented binary records execution times for all loops and functions, "
        "appending a new hotspot_result_<i>.txt file to "
        ".discopop/hotspot_detection/private/ on each call. "
        "\n\n"
        "This tool MUST be called at least twice with different execution "
        "configurations (i.e. different input data sets or problem sizes). "
        "Results from all runs are accumulated and jointly analysed by "
        "run_hotspot_analysis. More varied and generally more executions increase "
        "the accuracy of the hotspot classification. "
        "\n\n"
        "Use small to medium sized inputs with relatively short but realistically "
        "increasing runtimes. The goal is to ensure the collected timing data "
        "reflects the actual computational behaviour of the code. "
        "Inputs that are too small may not exercise the hot regions; inputs that "
        "are too large unnecessarily extend the profiling time. "
        "\n\n"
        "After collecting at least two runs with distinct inputs, call "
        "run_hotspot_analysis to produce Hotspots.json."
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
                    "Use different config_name values across calls to exercise "
                    "different input data sets."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": ("Maximum time in seconds for the binary to run. Default: 3600."),
            },
        },
        "required": ["project_path", "config_name"],
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        config_name = arguments.get("config_name", "")
        timeout_seconds = arguments.get("timeout_seconds", 3600)

        p = Path(project_path)
        configs_dir = p / ".discopop" / "project" / "configs"
        hd_settings = configs_dir / "hd_settings.json"
        execute_sh = configs_dir / config_name / "execute.sh"
        private_dir = p / ".discopop" / "hotspot_detection" / "private"

        if not execute_sh.exists():
            return ctx.error(
                f"execute.sh not found for configuration '{config_name}'. " "Run create_execution_configuration first."
            )
        if not hd_settings.exists():
            return ctx.error("hd_settings.json not found. Run initialize_discopop_directory first.")

        pm_args = ctx.make_pm_args(project_path, timeout_seconds)

        ctx.log_action(
            project_path,
            "run_hotspot_profiling",
            f"Launching execute.sh for config='{config_name}' to collect hotspot timing data, timeout={timeout_seconds}s",
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
            return ctx.error("execute_configuration returned None — hd_settings.json may be missing or malformed.")

        returncode, elapsed, stdout, stderr = exec_result

        result_files = sorted(private_dir.glob("hotspot_result_*.txt")) if private_dir.exists() else []
        total_runs_accumulated = len(result_files)
        profiling_files = [str(f.relative_to(p)) for f in result_files]

        if returncode != 0:
            result: dict[str, Any] = {
                "status": "error",
                "message": f"Hotspot profiling run failed with return code {returncode}.",
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        elif total_runs_accumulated == 0:
            result = {
                "status": "error",
                "message": (
                    "Binary ran but no hotspot_result_*.txt files were created. "
                    "The binary may not have been compiled with hotspot instrumentation — "
                    "re-run instrument_for_hotspot_detection and try again."
                ),
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        else:
            ctx.log_action(
                project_path,
                "run_hotspot_profiling",
                f"Hotspot profiling complete in {elapsed}s: {total_runs_accumulated} run(s) accumulated",
            )
            result = {
                "status": "success",
                "project_path": project_path,
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
                "profiling_files": profiling_files,
                "total_runs_accumulated": total_runs_accumulated,
            }

        ctx.log_response("run_hotspot_profiling", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error running hotspot profiling: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
