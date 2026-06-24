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
    name="check_hotspot_analysis_status",
    description=(
        "Read-only. Check whether hotspot analysis results (Hotspots.json) are available. "
        "Call this before run_hotspot_analysis to determine whether the step can "
        "be skipped because a current Hotspots.json already exists. "
        "\n\n"
        "Returns:\n"
        "  - hotspot_analysis_available: true if Hotspots.json exists\n"
        "  - last_analysis: timestamp of Hotspots.json, or null\n"
        "  - newest_source_modified: timestamp of the most recently modified "
        "source file in the project directory, or null\n"
        "  - results_potentially_stale: true if a source file is newer than "
        "Hotspots.json; false if up to date; null if Hotspots.json does not "
        "exist or no source files were found\n"
        "  - hotness_summary: counts of YES/MAYBE/NO regions from Hotspots.json\n"
        "  - num_regions: total number of classified code regions"
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
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")
        p = Path(project_path)
        hotspots_json = p / ".discopop" / "hotspot_detection" / "Hotspots.json"

        hotspot_analysis_available = hotspots_json.exists()

        last_analysis: Optional[str] = ctx.fmt_ts(hotspots_json.stat().st_mtime) if hotspot_analysis_available else None

        source_mtime = ctx.newest_source_mtime(project_path)
        newest_source_modified: Optional[str] = ctx.fmt_ts(source_mtime) if source_mtime is not None else None

        results_potentially_stale: Optional[bool] = None
        if hotspot_analysis_available and source_mtime is not None:
            results_potentially_stale = source_mtime > hotspots_json.stat().st_mtime

        hotness_summary: dict[str, int] = {"YES": 0, "MAYBE": 0, "NO": 0}
        num_regions = 0
        if hotspot_analysis_available:
            try:
                data = json.loads(hotspots_json.read_text())
                for region in data.get("code_regions", []):
                    hotness = region.get("hotness", "")
                    if hotness in hotness_summary:
                        hotness_summary[hotness] += 1
                    num_regions += 1
            except Exception:
                pass

        result = {
            "status": "success",
            "project_path": project_path,
            "hotspot_analysis_available": hotspot_analysis_available,
            "last_analysis": last_analysis,
            "newest_source_modified": newest_source_modified,
            "results_potentially_stale": results_potentially_stale,
            "hotness_summary": hotness_summary,
            "num_regions": num_regions,
        }
        ctx.log_response("check_hotspot_analysis_status", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error checking hotspot analysis status: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
