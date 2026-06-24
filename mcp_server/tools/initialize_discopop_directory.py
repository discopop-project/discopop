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

from mcp.types import TextContent, Tool

from discopop_library.ProjectManager.utilities.deriveSettingsFiles import derive_settings_files
from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="initialize_discopop_directory",
    description=(
        "Set up the DiscoPoP directory structure for a project. Call this as the very "
        "first step before any other DiscoPoP tool when working with a project that has "
        "not been initialized yet. Safe to call on an already-initialized project — "
        "existing files are left unchanged and reported in skipped_files. "
        "\n\n"
        "This tool creates:\n"
        "  - .discopop/project/configs/          — configuration directory\n"
        "  - seq_settings.json                   — base sequential build settings (CC, CXX, CFLAGS, CXXFLAGS)\n"
        "  - dp_settings.json                    — instrumentation settings (CC=discopop_cc, CXX=discopop_cxx)\n"
        "  - hd_settings.json                    — hotspot detection settings\n"
        "  - par_settings.json                   — parallel build settings\n"
        "  - compile.sh                          — placeholder that must be replaced via set_compile_script\n"
        "\n"
        "After this tool succeeds, call set_compile_script to describe how to build the "
        "project, then create_execution_configuration to describe how to run it."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": (
                    "Absolute path to the project root directory (the directory containing "
                    "the source files). Example: /home/user/myproject"
                ),
            },
            "base_cc": {
                "type": "string",
                "description": (
                    "Base C compiler for sequential (non-instrumented) builds. " "Default: clang. Example: gcc"
                ),
            },
            "base_cxx": {
                "type": "string",
                "description": (
                    "Base C++ compiler for sequential (non-instrumented) builds. " "Default: clang++. Example: g++"
                ),
            },
            "cflags": {
                "type": "string",
                "description": (
                    "Initial CFLAGS shared across all build modes. " "Default: empty string. Example: -O2 -std=c11"
                ),
            },
            "cxxflags": {
                "type": "string",
                "description": (
                    "Initial CXXFLAGS shared across all build modes. " "Default: empty string. Example: -O2 -std=c++17"
                ),
            },
        },
        "required": ["project_path"],
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        base_cc = arguments.get("base_cc", "clang")
        base_cxx = arguments.get("base_cxx", "clang++")
        cflags = arguments.get("cflags", "")
        cxxflags = arguments.get("cxxflags", "")

        p = Path(project_path)
        if not p.exists():
            return ctx.error(f"project_path does not exist: {project_path}")

        configs_dir = p / ".discopop" / "project" / "configs"
        configs_dir.mkdir(parents=True, exist_ok=True)
        ctx.log_action(project_path, "initialize_discopop_directory", f"Ensured directory exists: {configs_dir}")

        created: list[str] = []
        skipped: list[str] = []

        seq_settings_path = configs_dir / "seq_settings.json"
        if not seq_settings_path.exists():
            seq_settings_path.write_text(
                json.dumps({"CC": base_cc, "CXX": base_cxx, "CFLAGS": cflags, "CXXFLAGS": cxxflags}, indent=2)
            )
            created.append(str(seq_settings_path.relative_to(p)))
            ctx.log_action(
                project_path,
                "initialize_discopop_directory",
                f"Created seq_settings.json (CC={base_cc}, CXX={base_cxx})",
            )
        else:
            skipped.append(str(seq_settings_path.relative_to(p)))

        derive_settings_files(str(configs_dir), overwrite=False)
        ctx.log_action(
            project_path, "initialize_discopop_directory", "Derived dp/hd/par settings files from seq_settings.json"
        )
        for name in ("dp_settings.json", "hd_settings.json", "par_settings.json"):
            f = configs_dir / name
            if str(f.relative_to(p)) not in skipped:
                if f.exists():
                    created.append(str(f.relative_to(p)))

        compile_sh = configs_dir / "compile.sh"
        if not compile_sh.exists():
            initial_content = (
                "#!/bin/bash\n"
                "# This script is executed from the project root directory.\n"
                "# Use $CC/$CXX/$CFLAGS/$CXXFLAGS — do NOT hardcode compiler names.\n"
                "# Replace this placeholder via the set_compile_script MCP tool.\n"
                "echo 'compile.sh has not been configured yet. Use set_compile_script.'\n"
                "exit 1\n"
            )
            compile_sh.write_text(initial_content)
            compile_sh.chmod(compile_sh.stat().st_mode | 0o111)
            created.append(str(compile_sh.relative_to(p)))
            ctx.log_action(project_path, "initialize_discopop_directory", "Created placeholder compile.sh")
        else:
            skipped.append(str(compile_sh.relative_to(p)))

        result = {
            "status": "success",
            "project_path": project_path,
            "created_files": created,
            "skipped_files": skipped,
        }
        ctx.log_response("initialize_discopop_directory", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error initializing DiscoPoP directory: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
