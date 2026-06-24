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
    name="check_profiling_status",
    annotations=ToolAnnotations(readOnlyHint=True),
    description=(
        "Check whether data dependency profiling results already exist for the project. "
        "Call this before instrument_project or run_instrumented_binary to determine "
        "whether these steps can be skipped because valid results are already present. "
        "\n\n"
        "Returns:\n"
        "  - instrumentation_complete: true if Data.xml exists "
        "(static analysis from instrument_project succeeded)\n"
        "  - profiling_complete: true if dynamic_dependencies.txt exists "
        "(runtime profiling from run_instrumented_binary succeeded)\n"
        "  - last_instrumentation: timestamp of Data.xml, or null\n"
        "  - last_profiling: timestamp of dynamic_dependencies.txt, or null\n"
        "  - newest_source_modified: timestamp of the most recently modified "
        "source file (.c/.cpp/.h etc.) in the project directory, or null if none found\n"
        "  - results_potentially_stale: true if a source file is newer than the "
        "profiling results (suggesting re-profiling may be needed); false if results "
        "are up to date; null if results do not exist or no source files were found\n"
        "  - profiling_files: list of files currently present in .discopop/profiler/"
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
        profiler_dir = p / ".discopop" / "profiler"
        data_xml = profiler_dir / "Data.xml"
        dyn_deps = profiler_dir / "dynamic_dependencies.txt"

        instrumentation_complete = data_xml.exists()
        profiling_complete = dyn_deps.exists()

        last_instrumentation: Optional[str] = ctx.fmt_ts(data_xml.stat().st_mtime) if instrumentation_complete else None
        last_profiling: Optional[str] = ctx.fmt_ts(dyn_deps.stat().st_mtime) if profiling_complete else None

        source_mtime = ctx.newest_source_mtime(project_path)
        newest_source_modified: Optional[str] = ctx.fmt_ts(source_mtime) if source_mtime is not None else None

        results_potentially_stale: Optional[bool] = None
        if profiling_complete and source_mtime is not None:
            results_potentially_stale = source_mtime > dyn_deps.stat().st_mtime
        elif instrumentation_complete and source_mtime is not None:
            results_potentially_stale = source_mtime > data_xml.stat().st_mtime

        profiling_files = (
            [str(f.relative_to(p)) for f in profiler_dir.rglob("*") if f.is_file()] if profiler_dir.exists() else []
        )

        result = {
            "status": "success",
            "project_path": project_path,
            "instrumentation_complete": instrumentation_complete,
            "profiling_complete": profiling_complete,
            "last_instrumentation": last_instrumentation,
            "last_profiling": last_profiling,
            "newest_source_modified": newest_source_modified,
            "results_potentially_stale": results_potentially_stale,
            "profiling_files": profiling_files,
        }
        ctx.log_response("check_profiling_status", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error checking profiling status: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
