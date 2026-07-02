# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import logging
from typing import Any

from mcp.types import TextContent, Tool

from mcp_server.tools.gather_data import _instrument_project, _progress
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="gather_static_data",
    description=(
        "Compile the project with DiscoPoP instrumentation to produce static data dependencies, "
        "without executing the program and without running pattern detection. Call this after "
        "set_compile_script and create_execution_configuration. "
        "\n\n"
        "This is a much cheaper alternative to gather_data: it only performs the compile step "
        "(no profiling run, no discopop_explorer pass), so it finishes in roughly the time it "
        "takes to build the project once. Use it to get a fast, compile-time-only overview of "
        "data dependencies via get_static_data_dependencies. "
        "IMPORTANT — static dependencies are NOT conservative: every dependency reported is real, "
        "but the analysis only captures dependencies that are identifiable from the code statically "
        "(e.g. it cannot resolve aliasing or runtime-dependent memory accesses). The result is "
        "reliable but may be incomplete — it does not represent the full set of theoretically "
        "possible dependencies. "
        "\n\n"
        "This step is automatically skipped when its outputs are already current relative to the "
        "source files. Use force=true to re-run unconditionally. "
        "\n\n"
        "For parallelization patches or the full hybrid (static+dynamic) dependency set, use "
        "gather_data and get_data_dependencies instead."
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
                    "Name of the execution configuration to use for compilation. "
                    "Must match a directory under .discopop/project/configs/. "
                    "The compile output itself does not depend on this configuration's contents — "
                    "it is only used to label and locate the build."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": ("Maximum time in seconds for the compile step. Default: 3600."),
            },
            "force": {
                "type": "boolean",
                "description": ("Set to true to re-run even if outputs are already current. Default: false."),
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
        timeout_seconds: int = arguments.get("timeout_seconds", 3600)
        force: bool = arguments.get("force", False)

        source_mtime = ToolContext.newest_source_mtime(project_path)

        _progress(1, 1, "DiscoPoP instrumentation (compile)")
        instr = _instrument_project(project_path, config_name, timeout_seconds, force, ctx, source_mtime)
        steps = {"instrumentation": instr}

        if instr["status"] not in ("success", "skipped"):
            result: dict[str, Any] = {
                "status": "error",
                "project_path": project_path,
                "message": "Instrumentation failed. See steps.instrumentation for details.",
                "steps": steps,
            }
            ctx.log_response("gather_static_data", result)
            return [TextContent(type="text", text=json.dumps(result))]

        result = {
            "status": "success",
            "project_path": project_path,
            "steps": steps,
        }
        ctx.log_response("gather_static_data", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error in gather_static_data: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
