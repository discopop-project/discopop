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
from typing import Any, Optional

from mcp.types import TextContent, Tool

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="get_configurations",
    description=(
        "Retrieve all execution configurations defined for a DiscoPoP project, "
        "including the content of the shared compile.sh and each configuration's execute.sh. "
        "\n\n"
        "Call this to inspect what build and execution scripts are currently defined for a project, "
        "or to check whether a project has been initialized yet — an empty configurations list and "
        "null compile_script means initialize_discopop_directory has not been run. "
        "\n\n"
        "Returns:\n"
        "  - compile_script: content of .discopop/project/configs/compile.sh, or null if absent\n"
        "  - settings: contents of seq_settings.json and dp_settings.json, if present\n"
        "  - configurations: list of named configurations, each with its execute.sh content\n"
        "\n"
        "Example output:\n"
        '  {"status":"success","compile_script":"#!/bin/bash\\n$CXX $CXXFLAGS main.cpp -o myapp\\n",'
        '"configurations":[{"name":"default","execute_script":"#!/bin/bash\\n./myapp\\n"}]}'
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the target project root directory.",
            },
        },
        "required": ["project_path"],
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        p = Path(project_path)
        configs_dir = p / ".discopop" / "project" / "configs"

        compile_script: Optional[str] = None
        compile_sh = configs_dir / "compile.sh"
        if compile_sh.exists():
            compile_script = compile_sh.read_text()

        settings: dict[str, Any] = {}
        for key, filename in [("seq", "seq_settings.json"), ("dp", "dp_settings.json")]:
            settings_file = configs_dir / filename
            if settings_file.exists():
                settings[key] = json.loads(settings_file.read_text())

        configurations = []
        if configs_dir.exists() and configs_dir.is_dir():
            for config_dir in sorted(configs_dir.iterdir()):
                if not config_dir.is_dir():
                    continue
                execute_sh = config_dir / "execute.sh"
                configurations.append(
                    {
                        "name": config_dir.name,
                        "execute_script": execute_sh.read_text() if execute_sh.exists() else None,
                    }
                )

        result = {
            "status": "success",
            "project_path": project_path,
            "compile_script": compile_script,
            "settings": settings,
            "configurations": configurations,
        }
        ctx.log_response("get_configurations", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error retrieving configurations: {str(e)}"
        logger.error(error_msg)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
