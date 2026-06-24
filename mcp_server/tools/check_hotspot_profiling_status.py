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
    name="check_hotspot_profiling_status",
    description=(
        "Read-only. Check whether hotspot profiling data has been collected for the project. "
        "Call this before instrument_for_hotspot_detection or run_hotspot_profiling "
        "to determine whether these steps can be skipped. "
        "\n\n"
        "Returns:\n"
        "  - hotspot_profiling_available: true if at least one hotspot_result_*.txt "
        "file exists in .discopop/hotspot_detection/private/\n"
        "  - num_runs_accumulated: number of hotspot profiling runs collected so far\n"
        "  - last_run: timestamp of the most recently written hotspot_result_*.txt, or null\n"
        "  - newest_source_modified: timestamp of the most recently modified "
        "source file in the project directory, or null\n"
        "  - results_potentially_stale: true if a source file is newer than the "
        "most recent hotspot profiling result; false if up to date; null if no "
        "results exist or no source files were found\n"
        "  - profiling_files: list of hotspot_result_*.txt files present"
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
        private_dir = p / ".discopop" / "hotspot_detection" / "private"

        result_files = sorted(private_dir.glob("hotspot_result_*.txt")) if private_dir.exists() else []
        hotspot_profiling_available = len(result_files) > 0

        last_run: Optional[str] = None
        last_run_mtime: Optional[float] = None
        if hotspot_profiling_available:
            last_run_mtime = max(f.stat().st_mtime for f in result_files)
            last_run = ctx.fmt_ts(last_run_mtime)

        source_mtime = ctx.newest_source_mtime(project_path)
        newest_source_modified: Optional[str] = ctx.fmt_ts(source_mtime) if source_mtime is not None else None

        results_potentially_stale: Optional[bool] = None
        if hotspot_profiling_available and source_mtime is not None and last_run_mtime is not None:
            results_potentially_stale = source_mtime > last_run_mtime

        result = {
            "status": "success",
            "project_path": project_path,
            "hotspot_profiling_available": hotspot_profiling_available,
            "num_runs_accumulated": len(result_files),
            "last_run": last_run,
            "newest_source_modified": newest_source_modified,
            "results_potentially_stale": results_potentially_stale,
            "profiling_files": [str(f.relative_to(p)) for f in result_files],
        }
        ctx.log_response("check_hotspot_profiling_status", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error checking hotspot profiling status: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
