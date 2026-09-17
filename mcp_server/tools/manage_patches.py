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
import sys
from pathlib import Path
from typing import Any, Optional

from mcp.types import TextContent, Tool

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="manage_patches",
    description=(
        "Apply, roll back, clear, load, or list applied parallelization patches via "
        "discopop_patch_applicator. Call get_parallelization_patches first to "
        "discover available pattern IDs.\n\n"
        "Actions:\n"
        "  list    — Return the IDs of currently applied suggestions. No files changed.\n"
        "  apply   — Apply the patches for the given suggestion_ids. The source files "
        "are modified in place. suggestion_ids must be non-empty.\n"
        "  rollback — Undo previously applied suggestions identified by suggestion_ids. "
        "suggestion_ids must be non-empty.\n"
        "  clear   — Reset all source files to their original (un-patched) state. "
        "The list of applied suggestions is preserved on disk so it can be restored "
        "with load. Existing saves are overwritten.\n"
        "  load    — Re-apply suggestions that were saved by a previous clear operation.\n\n"
        "Requires gather_data to have been run first (patch files must exist under "
        ".discopop/patch_generator/ and FileMapping.txt must be present)."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the project root directory.",
            },
            "action": {
                "type": "string",
                "enum": ["apply", "rollback", "clear", "load", "list"],
                "description": "Operation to perform on the patches.",
            },
            "suggestion_ids": {
                "type": "array",
                "items": {"type": "string"},
                "description": (
                    "List of suggestion IDs to apply or roll back. "
                    "Required for 'apply' and 'rollback' actions; ignored for all others. "
                    "IDs match the pattern_id values returned by get_parallelization_patches."
                ),
            },
        },
        "required": ["project_path", "action"],
        "additionalProperties": False,
    },
)


def _find_patch_applicator() -> Optional[str]:
    venv_bin = os.path.dirname(sys.executable)
    env_path = os.environ.get("PATH", "")
    search_path = venv_bin + os.pathsep + env_path if venv_bin not in env_path else env_path
    return shutil.which("discopop_patch_applicator", path=search_path)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path: str = arguments.get("project_path", "")
        action: str = arguments.get("action", "")
        suggestion_ids: list[str] = arguments.get("suggestion_ids") or []

        discopop_dir = Path(project_path) / ".discopop"

        if not discopop_dir.exists():
            return ctx.error(
                "DiscoPoP directory not found. Run initialize_discopop_directory and gather_data first.",
                project_path,
                "manage_patches",
            )

        patch_gen_dir = discopop_dir / "patch_generator"
        file_mapping = discopop_dir / "FileMapping.txt"

        if not patch_gen_dir.exists():
            return ctx.error(
                "patch_generator directory not found. Run gather_data first.",
                project_path,
                "manage_patches",
            )
        if not file_mapping.exists():
            return ctx.error(
                "FileMapping.txt not found. Run gather_data first.",
                project_path,
                "manage_patches",
            )

        if action in ("apply", "rollback") and not suggestion_ids:
            return ctx.error(
                f"'suggestion_ids' must be non-empty for action '{action}'.",
                project_path,
                "manage_patches",
            )

        applicator = _find_patch_applicator()
        if not applicator:
            return ctx.error(
                "discopop_patch_applicator not found on PATH. Ensure the discopop_library package is installed.",
                project_path,
                "manage_patches",
            )

        cmd: list[str] = [applicator]
        if action == "apply":
            cmd += ["--apply"] + suggestion_ids
        elif action == "rollback":
            cmd += ["--rollback"] + suggestion_ids
        elif action == "clear":
            cmd += ["--clear"]
        elif action == "load":
            cmd += ["--load"]
        elif action == "list":
            cmd += ["--list"]
        else:
            return ctx.error(f"Unknown action '{action}'.", project_path, "manage_patches")

        ctx.log_action(
            project_path,
            "manage_patches",
            f"action={action}, suggestion_ids={suggestion_ids}, cmd={cmd}",
        )

        import subprocess

        try:
            proc = subprocess.run(
                cmd,
                cwd=str(discopop_dir),
                capture_output=True,
                text=True,
                timeout=60,
            )
        except subprocess.TimeoutExpired:
            return ctx.error(
                "discopop_patch_applicator timed out after 60s.",
                project_path,
                "manage_patches",
            )

        stdout = proc.stdout.strip()
        stderr = proc.stderr.strip()

        # rc=0: success; rc=2: partial success; rc=3: nothing to do (trivially ok)
        if proc.returncode not in (0, 2, 3):
            result: dict[str, Any] = {
                "status": "error",
                "project_path": project_path,
                "action": action,
                "message": f"discopop_patch_applicator failed (rc={proc.returncode}).",
                "returncode": proc.returncode,
                "stderr": stderr,
            }
            ctx.log_response("manage_patches", result)
            return [TextContent(type="text", text=json.dumps(result))]

        # Parse applied suggestions list for list action (stdout: "Applied suggestions:  ['1', '2']")
        applied_suggestions: Optional[list[str]] = None
        if action == "list":
            for line in stdout.splitlines():
                if "Applied suggestions:" in line:
                    try:
                        raw = line.split("Applied suggestions:")[-1].strip()
                        applied_suggestions = json.loads(raw.replace("'", '"'))
                    except Exception:
                        applied_suggestions = [raw]
                    break

        result = {
            "status": "success" if proc.returncode == 0 else "partial",
            "project_path": project_path,
            "action": action,
            "returncode": proc.returncode,
        }
        if suggestion_ids:
            result["suggestion_ids"] = suggestion_ids
        if applied_suggestions is not None:
            result["applied_suggestions"] = applied_suggestions
        if proc.returncode == 2:
            result["message"] = "Some patches were applied; others may have failed. Check stderr for details."
        if proc.returncode == 3:
            result["message"] = "Nothing to do (no patches to roll back or load)."
        if stderr:
            result["stderr"] = stderr

        ctx.log_response("manage_patches", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error in manage_patches: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
