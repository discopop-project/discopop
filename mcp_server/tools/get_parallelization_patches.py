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
    name="get_parallelization_patches",
    annotations=ToolAnnotations(readOnlyHint=True),
    description=(
        "Retrieve the generated OpenMP parallelization patches. Call this after "
        "run_pattern_detection to inspect or present the suggested code changes. "
        "\n\n"
        "Each detected pattern results in a unified-diff patch file stored under "
        ".discopop/patch_generator/<pattern_id>/. The patch inserts an OpenMP pragma "
        "(e.g. #pragma omp parallel for with appropriate clauses) directly above the "
        "loop it applies to. Patches are in standard unified diff format and can be "
        "applied with the patch command or via discopop_patch_applicator. "
        "\n\n"
        "Use the optional pattern_id parameter to retrieve a single patch when the "
        "user asks about a specific suggestion. Omit it to retrieve all patches. "
        "\n\n"
        "NOTE: If the optional hotspot detection pipeline was not run prior to "
        "pattern detection, the returned patches cover every parallelization candidate "
        "found in the code base — they are not guaranteed to correspond to hotspots "
        "and may include regions with negligible contribution to overall runtime. "
        "To restrict suggestions to hotspot regions, re-run the pipeline starting "
        "from instrument_for_hotspot_detection. "
        "\n\n"
        "Example patch content:\n"
        "  --- original/main.cpp\n"
        "  +++ main.cpp\n"
        "  @@ -17,6 +17,7 @@\n"
        "  +  #pragma omp parallel for firstprivate(N)\n"
        "     for (int i = 0; i < N; i++) {\n"
        "       Arr[i] = i % 13;\n"
        "     }"
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": "Absolute path to the project root.",
            },
            "pattern_id": {
                "type": "integer",
                "description": (
                    "If provided, return only the patch for this specific pattern ID "
                    "(as shown in patterns.json). Omit to return all available patches."
                ),
            },
        },
        "required": ["project_path"],
        "additionalProperties": False,
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        pattern_id_filter: Optional[int] = arguments.get("pattern_id")

        p = Path(project_path)
        patch_gen_dir = p / ".discopop" / "patch_generator"

        if not patch_gen_dir.exists():
            return ctx.error("patch_generator directory not found. Run run_pattern_detection first.")

        patches = []
        for pattern_dir in sorted(patch_gen_dir.iterdir(), key=lambda d: d.name):
            if not pattern_dir.is_dir():
                continue
            try:
                pid = int(pattern_dir.name)
            except ValueError:
                continue

            if pattern_id_filter is not None and pid != pattern_id_filter:
                continue

            for patch_file in sorted(pattern_dir.glob("*.patch")):
                patch_content = patch_file.read_text()
                source_file = ToolContext.extract_source_from_patch(patch_content)
                patches.append(
                    {
                        "pattern_id": pid,
                        "source_file": source_file,
                        "patch_content": patch_content,
                    }
                )

        pattern_ids: list[int] = sorted({p["pattern_id"] for p in patches if isinstance(p["pattern_id"], int)})
        ctx.log_action(
            project_path,
            "get_parallelization_patches",
            f"Found {len(patches)} patches across {len(pattern_ids)} pattern IDs: {pattern_ids}",
        )
        result = {
            "status": "success",
            "project_path": project_path,
            "patches": patches,
        }
        ctx.log_response("get_parallelization_patches", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error retrieving parallelization patches: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
