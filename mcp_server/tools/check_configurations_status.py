# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import logging
from pathlib import Path
from typing import Any

from mcp.types import TextContent, Tool, ToolAnnotations

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="check_configurations_status",
    annotations=ToolAnnotations(readOnlyHint=True),
    description=(
        "Check whether the DiscoPoP directory has been initialised and whether "
        "the compile script and execution configurations are set up. "
        "Call this at the start of a session to determine whether "
        "initialize_discopop_directory, set_compile_script, and "
        "create_execution_configuration need to be run, or whether existing "
        "configurations can be reused. "
        "\n\n"
        "Returns:\n"
        "  - initialized: true if .discopop/project/configs/ exists\n"
        "  - compile_script_configured: true if compile.sh exists and has been "
        "customised (i.e. is not the auto-generated placeholder)\n"
        "  - settings_files: which of seq/dp/hd/par settings JSON files are present\n"
        "  - configurations: list of named configurations and whether each has an execute.sh\n"
        "  - num_configurations: total number of configurations found"
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the project root directory.",
            },
        },
        "required": ["project_path"],
        "additionalProperties": False,
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        p = Path(project_path)
        configs_dir = p / ".discopop" / "project" / "configs"

        initialized = configs_dir.exists()

        compile_script_configured = False
        if initialized:
            compile_sh = configs_dir / "compile.sh"
            if compile_sh.exists():
                content = compile_sh.read_text()
                compile_script_configured = "Use set_compile_script" not in content and "exit 1" not in content

        settings_files = {}
        for key, filename in [
            ("seq", "seq_settings.json"),
            ("dp", "dp_settings.json"),
            ("hd", "hd_settings.json"),
            ("par", "par_settings.json"),
        ]:
            settings_files[key] = (configs_dir / filename).exists() if initialized else False

        configurations = []
        if initialized:
            for config_dir in sorted(configs_dir.iterdir()):
                if config_dir.is_dir():
                    configurations.append(
                        {
                            "name": config_dir.name,
                            "has_execute_sh": (config_dir / "execute.sh").exists(),
                        }
                    )

        result = {
            "status": "success",
            "project_path": project_path,
            "initialized": initialized,
            "compile_script_configured": compile_script_configured,
            "settings_files": settings_files,
            "configurations": configurations,
            "num_configurations": len(configurations),
        }
        ctx.log_response("check_configurations_status", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error checking configurations status: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
