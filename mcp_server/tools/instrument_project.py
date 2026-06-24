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
from pathlib import Path
from typing import Any

from mcp.types import TextContent, Tool

from discopop_library.ProjectManager.configurations.execution import execute_configuration
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="instrument_project",
    description=(
        "Compile the project with DiscoPoP instrumentation. Call this after "
        "set_compile_script and create_execution_configuration. "
        "\n\n"
        "This tool runs compile.sh using dp_settings.json, which sets "
        "CC=discopop_cc and CXX=discopop_cxx. These DiscoPoP compiler wrappers invoke "
        "clang/clang++ with the DiscoPoP LLVM pass loaded, which injects instrumentation "
        "code and performs static analysis. Compilation produces:\n"
        "  .discopop/FileMapping.txt              — maps numeric file IDs to source paths\n"
        "  .discopop/line_mapping.json            — maps instruction IDs to source lines\n"
        "  .discopop/profiler/Data.xml            — static analysis: CUs, loops, functions\n"
        "  .discopop/profiler/ast_dump.json       — full Abstract Syntax Tree\n"
        "  .discopop/profiler/loop_meta.txt       — loop metadata\n"
        "  .discopop/profiler/static_dependencies.txt\n"
        "\n"
        "The .discopop/profiler/ directory is deleted before each run to prevent stale "
        "data from prior instrumentation attempts. "
        "\n\n"
        "After this tool succeeds, call run_instrumented_binary to collect runtime data."
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
                    "Name of an existing execution configuration created via "
                    "create_execution_configuration. Required by the project manager "
                    "for environment setup."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": (
                    "Maximum time in seconds allowed for compilation. "
                    "Default: 3600. Set lower for fast projects, higher for large codebases."
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
        compile_sh = configs_dir / "compile.sh"
        dp_settings = configs_dir / "dp_settings.json"
        profiler_dir = p / ".discopop" / "profiler"

        if not compile_sh.exists():
            return ctx.error(f"compile.sh not found at {compile_sh}. Run set_compile_script first.")
        if not dp_settings.exists():
            return ctx.error("dp_settings.json not found. Run initialize_discopop_directory first.")
        config_dir = configs_dir / config_name
        if not config_dir.exists():
            return ctx.error(f"Configuration '{config_name}' not found. Run create_execution_configuration first.")

        if profiler_dir.exists():
            shutil.rmtree(str(profiler_dir))
            ctx.log_action(project_path, "instrument_project", "Deleted stale .discopop/profiler/ directory")

        pm_args = ctx.make_pm_args(project_path, timeout_seconds)

        ctx.log_action(
            project_path,
            "instrument_project",
            f"Launching compile.sh via dp_settings (discopop_cxx), config='{config_name}', timeout={timeout_seconds}s",
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
            return ctx.error("execute_configuration returned None — dp_settings.json may be missing or malformed.")

        returncode, elapsed, stdout, stderr = exec_result

        files_created = (
            [str(f.relative_to(p)) for f in profiler_dir.rglob("*") if f.is_file()] if profiler_dir.exists() else []
        )

        data_xml = p / ".discopop" / "profiler" / "Data.xml"
        if returncode != 0:
            result: dict[str, Any] = {
                "status": "error",
                "message": f"Compilation failed with return code {returncode}.",
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        elif not data_xml.exists():
            result = {
                "status": "error",
                "message": (
                    "Compilation succeeded but Data.xml was not created. "
                    "Ensure discopop_cxx is installed and in PATH."
                ),
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
            }
        else:
            result = {
                "status": "success",
                "project_path": project_path,
                "returncode": returncode,
                "elapsed_time": elapsed,
                "stdout": stdout,
                "stderr": stderr,
                "files_created": files_created,
            }

        ctx.log_response("instrument_project", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error during instrumentation: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
