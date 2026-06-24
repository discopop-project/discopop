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
import subprocess
import sys
from pathlib import Path
from typing import Any

from mcp.types import TextContent, Tool

from mcp_server.tools.helpers import ToolContext

logger = logging.getLogger("discopop-mcp")

TOOL = Tool(
    name="run_hotspot_analysis",
    description=(
        "OPTIONAL STEP. Analyse accumulated hotspot profiling data to classify "
        "code regions as hotspots. Call this after run_hotspot_profiling has been "
        "called at least twice with different inputs. "
        "\n\n"
        "This tool runs discopop_hotspot_analyzer from the .discopop directory. "
        "The analyzer combines all hotspot_result_<i>.txt files collected by prior "
        "run_hotspot_profiling calls and classifies each loop and function as "
        "YES (clear hotspot), MAYBE (borderline), or NO (not a hotspot). "
        "\n\n"
        "On success, creates .discopop/hotspot_detection/Hotspots.json. "
        "This file is automatically detected and used by discopop_explorer "
        "(run_pattern_detection) to focus the parallelization analysis. "
        "The downstream tool decides which hotness classes (YES, NO, MAYBE, or "
        "combinations thereof) to consider when filtering candidate regions. "
        "\n\n"
        "Using hotspot detection generally reduces analysis time compared to "
        "analysing the entire code base. However, overly restricting the hotness "
        "filter applied by the downstream tool could cause beneficial parallelization "
        "suggestions to be missed. "
        "\n\n"
        "After this tool succeeds, proceed with instrument_project as the next step "
        "in the main pipeline."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": (
                    "Absolute path to the project root. "
                    "discopop_hotspot_analyzer is invoked with "
                    "<project_path>/.discopop as its working directory."
                ),
            },
            "timeout_seconds": {
                "type": "integer",
                "description": "Maximum time in seconds allowed for hotspot analysis. Default: 3600.",
            },
            "force": {
                "type": "boolean",
                "description": (
                    "Set to true to force re-analysis even if Hotspots.json is already " "current. Default: false."
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
        timeout_seconds = arguments.get("timeout_seconds", 3600)
        force = arguments.get("force", False)

        p = Path(project_path)
        discopop_dir = p / ".discopop"
        private_dir = discopop_dir / "hotspot_detection" / "private"
        hotspots_json = discopop_dir / "hotspot_detection" / "Hotspots.json"

        if not private_dir.exists():
            return ctx.error(
                "No hotspot profiling data found (.discopop/hotspot_detection/private/ is absent). "
                "Run instrument_for_hotspot_detection and run_hotspot_profiling first."
            )
        result_files = list(private_dir.glob("hotspot_result_*.txt"))
        if not result_files:
            return ctx.error(
                "No hotspot_result_*.txt files found in .discopop/hotspot_detection/private/. "
                "Run run_hotspot_profiling at least once."
            )

        if not force and hotspots_json.exists():
            source_mtime = ToolContext.newest_source_mtime(project_path)
            analysis_mtime = hotspots_json.stat().st_mtime
            if source_mtime is None or source_mtime <= analysis_mtime:
                result: dict[str, Any] = {
                    "status": "skipped",
                    "reason": "results_are_current",
                    "project_path": project_path,
                    "last_run": ToolContext.fmt_ts(analysis_mtime),
                    "newest_source_modified": ToolContext.fmt_ts(source_mtime) if source_mtime else None,
                }
                ctx.log_response("run_hotspot_analysis", result)
                return [TextContent(type="text", text=json.dumps(result))]

        venv_bin = os.path.dirname(sys.executable)
        env = os.environ.copy()
        if venv_bin not in env.get("PATH", ""):
            env["PATH"] = venv_bin + os.pathsep + env.get("PATH", "")

        analyzer = shutil.which("discopop_hotspot_analyzer", path=env["PATH"])
        if not analyzer:
            return ctx.error(
                "discopop_hotspot_analyzer not found on PATH. "
                "Ensure the hotspot detection package is installed: pip install ./hotspot_detection"
            )

        ctx.log_action(
            project_path,
            "run_hotspot_analysis",
            f"Invoking discopop_hotspot_analyzer in {discopop_dir} ({len(result_files)} profiling run(s))",
        )
        try:
            proc = subprocess.run(
                [analyzer],
                cwd=str(discopop_dir),
                capture_output=True,
                text=True,
                env=env,
                timeout=timeout_seconds,
            )
        except subprocess.TimeoutExpired:
            return ctx.error(f"discopop_hotspot_analyzer timed out after {timeout_seconds}s.")

        hotness_summary: dict[str, int] = {"YES": 0, "MAYBE": 0, "NO": 0}
        hotspots_found = 0
        if hotspots_json.exists():
            try:
                data = json.loads(hotspots_json.read_text())
                for region in data.get("code_regions", []):
                    hotness = region.get("hotness", "")
                    if hotness in hotness_summary:
                        hotness_summary[hotness] += 1
                    hotspots_found += 1
            except Exception:
                pass

        if proc.returncode != 0:
            result = {
                "status": "error",
                "message": f"discopop_hotspot_analyzer failed with return code {proc.returncode}.",
                "returncode": proc.returncode,
                "stdout": proc.stdout,
                "stderr": proc.stderr,
            }
        else:
            ctx.log_action(
                project_path,
                "run_hotspot_analysis",
                f"Analysis complete: {hotspots_found} regions classified "
                f"(YES={hotness_summary['YES']}, MAYBE={hotness_summary['MAYBE']}, NO={hotness_summary['NO']})",
            )
            result = {
                "status": "success",
                "project_path": project_path,
                "returncode": proc.returncode,
                "hotspots_found": hotspots_found,
                "hotness_summary": hotness_summary,
                "output_file": str(hotspots_json.relative_to(p)),
                "stdout": proc.stdout,
                "stderr": proc.stderr,
            }

        ctx.log_response("run_hotspot_analysis", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error running hotspot analysis: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
