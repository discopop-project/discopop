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

from discopop_library.ProjectManager.configurations.compile_script import (
    get_per_config_compile_script_path,
    get_shared_compile_script_path,
)
from discopop_library.ProjectManager.utilities.scriptFiles import write_script_file
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="set_compile_script",
    annotations=ToolAnnotations(idempotentHint=True),
    description=(
        "Write a compilation script compile.sh for a DiscoPoP project. "
        "Call this after initialize_discopop_directory, once you know how the project is built. "
        "\n\n"
        "The script is executed from the project root with these environment variables available:\n"
        "  $CC, $CXX          — compiler executables (injected from the active settings file)\n"
        "  $CFLAGS, $CXXFLAGS — compiler flags\n"
        "  $DP_PROJECT_ROOT_DIR — absolute path to the project root\n"
        "  $DOT_DISCOPOP      — absolute path to the .discopop directory\n"
        "\n"
        "IMPORTANT: The script body MUST use $CC/$CXX for compilers AND $CFLAGS/$CXXFLAGS "
        "for flags — never hardcode compiler names like g++ or clang++. "
        "The same script is reused for sequential builds, DiscoPoP instrumentation, "
        "hotspot detection, and parallel builds — the compiler and flags are selected "
        "by the settings file, not the script. "
        "The script must exit 0 on success. "
        "\n\n"
        "Examples:\n"
        "  Single C++ file:  $CXX $CXXFLAGS main.cpp -o myapp\n"
        "  Single C file:    $CC $CFLAGS main.c -o myapp\n"
        "  Mixed C/C++:      $CXX $CXXFLAGS src/main.cpp && $CC $CFLAGS src/util.c -o myapp\n"
        '  Make project:     make CC="$CC" CXX="$CXX" CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS"\n'
        "  CMake project:    mkdir -p build && cmake -B build "
        '-DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" '
        '-DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS" . && cmake --build build\n'
        "\n"
        "By default this sets the shared compile.sh, used by every execution configuration "
        "that does not define its own override. Pass config_name to instead set a per-"
        "configuration override that only applies to that one configuration (e.g. when a "
        "configuration needs different compile-time parameters). "
        "\n\n"
        "After setting the compile script, call create_execution_configuration to define "
        "how to run the compiled binary."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": (
                    "Absolute path to the project root. Must already be initialized "
                    "via initialize_discopop_directory."
                ),
            },
            "script_body": {
                "type": "string",
                "description": (
                    "Full bash script body. Must use $CC/$CXX/$CFLAGS/$CXXFLAGS instead "
                    "of hardcoded compiler names. A #!/bin/bash shebang is "
                    "prepended automatically if not present."
                ),
            },
            "config_name": {
                "type": "string",
                "description": (
                    "Optional. If given, writes a per-configuration override to "
                    "configs/<config_name>/compile.sh instead of the shared script — used only "
                    "for that configuration, which must already exist (see "
                    "create_execution_configuration). Omit to write/replace the shared "
                    "compile.sh used by every configuration without its own override."
                ),
            },
        },
        "required": ["project_path", "script_body"],
        "additionalProperties": False,
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        script_body = arguments.get("script_body", "")
        config_name = arguments.get("config_name")

        configs_dir = Path(project_path) / ".discopop" / "project" / "configs"
        if not configs_dir.exists():
            return ctx.error("DiscoPoP directory not initialized. Run initialize_discopop_directory first.")

        if config_name:
            if not (configs_dir / config_name).is_dir():
                return ctx.error(
                    f"Execution configuration '{config_name}' does not exist. "
                    "Call create_execution_configuration first.",
                    project_path,
                    "set_compile_script",
                )
            compile_sh = Path(get_per_config_compile_script_path(str(configs_dir), config_name))
        else:
            compile_sh = Path(get_shared_compile_script_path(str(configs_dir)))

        write_script_file(str(compile_sh), script_body)
        ctx.log_action(project_path, "set_compile_script", f"Wrote {compile_sh.name} ({len(script_body)} bytes)")

        result: dict[str, Any] = {
            "status": "success",
            "project_path": project_path,
            "path": str(compile_sh),
        }
        if config_name:
            result["config_name"] = config_name
        ctx.log_response("set_compile_script", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error writing compile script: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
