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

from mcp.types import TextContent, Tool, ToolAnnotations

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="check_parallelization_status",
    annotations=ToolAnnotations(readOnlyHint=True),
    description=(
        "Check whether parallelization pattern detection has already been run "
        "and whether patch files are available. "
        "Call this before run_pattern_detection or get_parallelization_patches "
        "to determine whether these steps can be skipped. "
        "\n\n"
        "Returns:\n"
        "  - patterns_detected: true if patterns.json exists\n"
        "  - patches_available: true if at least one patch file exists under "
        ".discopop/patch_generator/\n"
        "  - last_detection: timestamp of patterns.json, or null\n"
        "  - newest_source_modified: timestamp of the most recently modified "
        "source file in the project directory, or null\n"
        "  - results_potentially_stale: true if a source file is newer than "
        "patterns.json; false if up to date; null if results do not exist or "
        "no source files were found\n"
        "  - pattern_counts: per-type pattern counts from patterns.json\n"
        "  - num_patches: total number of patch files available"
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
        patterns_json = p / ".discopop" / "explorer" / "patterns.json"
        patch_gen_dir = p / ".discopop" / "patch_generator"

        patterns_detected = patterns_json.exists()
        patch_files = list(patch_gen_dir.rglob("*.patch")) if patch_gen_dir.exists() else []
        patches_available = len(patch_files) > 0

        last_detection: Optional[str] = ctx.fmt_ts(patterns_json.stat().st_mtime) if patterns_detected else None

        source_mtime = ctx.newest_source_mtime(project_path)
        newest_source_modified: Optional[str] = ctx.fmt_ts(source_mtime) if source_mtime is not None else None

        results_potentially_stale: Optional[bool] = None
        if patterns_detected and source_mtime is not None:
            results_potentially_stale = source_mtime > patterns_json.stat().st_mtime

        pattern_counts: dict[str, int] = {"do_all": 0, "reduction": 0, "task": 0, "pipeline": 0}
        if patterns_detected:
            try:
                data = json.loads(patterns_json.read_text())
                patterns = data.get("patterns", {})
                for key in pattern_counts:
                    pattern_counts[key] = len(patterns.get(key, []))
            except Exception:
                pass

        result = {
            "status": "success",
            "project_path": project_path,
            "patterns_detected": patterns_detected,
            "patches_available": patches_available,
            "last_detection": last_detection,
            "newest_source_modified": newest_source_modified,
            "results_potentially_stale": results_potentially_stale,
            "pattern_counts": pattern_counts,
            "num_patches": len(patch_files),
        }
        ctx.log_response("check_parallelization_status", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error checking parallelization status: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
