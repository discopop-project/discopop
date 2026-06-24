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

from mcp.types import TextContent, Tool, ToolAnnotations

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="create_execution_configuration",
    annotations=ToolAnnotations(idempotentHint=True),
    description=(
        "Create a named execution configuration for a DiscoPoP project. "
        "Call this after set_compile_script to define how to run the compiled binary. "
        "\n\n"
        "Each configuration is a named subdirectory under .discopop/project/configs/ "
        "containing an execute.sh script. A project can have multiple configurations "
        "representing different execution scenarios (e.g. different input sizes or "
        "argument sets). "
        "\n\n"
        "IMPORTANT — profiling overhead: The instrumented binary records every memory "
        "access at runtime, which incurs significant overhead compared to the original "
        "program. In particularly bad cases overhead can reach up to 100x, although "
        "the average is far below that. If the program accepts input data or a parameter "
        "controlling problem size, always prefer the smallest input that still exercises "
        "the code paths of interest. Configurations with unnecessarily large workloads "
        "may become impractically slow under instrumentation. "
        "\n\n"
        "The execute.sh script is executed from the project root with the same environment "
        "variables as compile.sh: $CC, $CXX, $CFLAGS, $CXXFLAGS, $DP_PROJECT_ROOT_DIR, "
        "$DOT_DISCOPOP, $OMP_NUM_THREADS. The script must exit 0 on success. "
        "\n\n"
        "Examples for script_body:\n"
        "  Minimal:              ./myapp\n"
        "  Small input:          ./myapp --input data/small.txt --iterations 100\n"
        "  Multiple short runs:  ./myapp --mode A && ./myapp --mode B\n"
        "  Piped input:          ./myapp < test_data/small_input.dat\n"
        "\n"
        "After creating at least one configuration, call instrument_project to compile "
        "with DiscoPoP instrumentation."
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
                    "Identifier for this configuration. Used as the subdirectory name "
                    "under .discopop/project/configs/. Must not contain path separators. "
                    "Examples: default, small_input, large_input"
                ),
            },
            "script_body": {
                "type": "string",
                "description": (
                    "Full bash script body for running the compiled binary. "
                    "Executed from the project root. Must exit 0 on success. "
                    "A #!/bin/bash shebang is prepended automatically if not present."
                ),
            },
        },
        "required": ["project_path", "config_name", "script_body"],
        "additionalProperties": False,
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        config_name = arguments.get("config_name", "")
        script_body = arguments.get("script_body", "")

        if not config_name or os.sep in config_name or "/" in config_name:
            return ctx.error(f"Invalid config_name '{config_name}'. Must be a plain name without path separators.")

        configs_dir = Path(project_path) / ".discopop" / "project" / "configs"
        if not configs_dir.exists():
            return ctx.error("DiscoPoP directory not initialized. Run initialize_discopop_directory first.")

        config_dir = configs_dir / config_name
        config_dir.mkdir(parents=True, exist_ok=True)
        ctx.log_action(project_path, "create_execution_configuration", f"Ensured config directory: {config_dir}")

        if not script_body.startswith("#!"):
            script_body = "#!/bin/bash\n" + script_body

        execute_sh = config_dir / "execute.sh"
        execute_sh.write_text(script_body)
        execute_sh.chmod(execute_sh.stat().st_mode | 0o111)
        ctx.log_action(
            project_path,
            "create_execution_configuration",
            f"Wrote execute.sh for config '{config_name}' ({len(script_body)} bytes)",
        )

        result = {
            "status": "success",
            "project_path": project_path,
            "config_name": config_name,
            "path": str(execute_sh),
        }
        ctx.log_response("create_execution_configuration", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error creating execution configuration: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
