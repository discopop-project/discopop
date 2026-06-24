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
    name="run_pattern_detection",
    description=(
        "Analyse the profiling data to detect parallelization opportunities. "
        "Call this after run_instrumented_binary succeeds. "
        "\n\n"
        "This tool runs discopop_explorer from the .discopop directory. The explorer "
        "cross-references the static analysis data (Data.xml from instrumentation) with "
        "the runtime dependency traces (dynamic_dependencies.txt from execution) to "
        "identify loops that can safely be parallelized with OpenMP. "
        "Because the dependency traces reflect only dependencies that were actually "
        "observed during execution — not pessimistic worst-case estimates — the analysis "
        "results are grounded in real behaviour and avoid the over-approximation that "
        "purely static analyses typically introduce. "
        "\n\n"
        "If hotspot detection results are present (.discopop/hotspot_detection/Hotspots.json, "
        "produced by run_hotspot_analysis), discopop_explorer uses them to focus the "
        "analysis on hotspot regions. If no hotspot information is available, the analysis "
        "covers the entire code base: all parallelization candidates that are structurally "
        "possible will be reported, but they are not guaranteed to be hotspots and may "
        "include regions with negligible contribution to overall runtime. "
        "\n\n"
        "Detected pattern types:\n"
        "  do_all    — loops with no loop-carried dependencies; "
        "suitable for #pragma omp parallel for\n"
        "  reduction — loops with reduction operations (e.g. sum += x); "
        "suitable for reduction clauses\n"
        "  task      — task-level parallelism candidates\n"
        "  pipeline  — pipeline parallelism candidates\n"
        "\n"
        "On success creates:\n"
        "  .discopop/explorer/patterns.json               — all detected patterns\n"
        "  .discopop/explorer/detection_result_dump.json  — detailed detection state\n"
        "  .discopop/patch_generator/<id>/<file>.patch    — one patch per pattern\n"
        "\n"
        "After this tool succeeds, call get_parallelization_patches to retrieve the patches."
    ),
    inputSchema={
        "type": "object",
        "properties": {
            "project_path": {
                "type": "string",
                "description": (
                    "Absolute path to the project root. discopop_explorer is invoked "
                    "with <project_path>/.discopop as its working directory."
                ),
            },
        },
        "required": ["project_path"],
    },
)


def handle(arguments: dict[str, Any], ctx: ToolContext) -> list[TextContent]:
    try:
        project_path = arguments.get("project_path", "")

        p = Path(project_path)
        discopop_dir = p / ".discopop"
        data_xml = discopop_dir / "profiler" / "Data.xml"
        dyn_deps = discopop_dir / "profiler" / "dynamic_dependencies.txt"

        if not data_xml.exists():
            return ctx.error("profiler/Data.xml not found. Run instrument_project first.")
        if not dyn_deps.exists():
            return ctx.error("profiler/dynamic_dependencies.txt not found. Run run_instrumented_binary first.")

        venv_bin = os.path.dirname(sys.executable)
        env = os.environ.copy()
        if venv_bin not in env.get("PATH", ""):
            env["PATH"] = venv_bin + os.pathsep + env.get("PATH", "")

        explorer = shutil.which("discopop_explorer", path=env["PATH"])
        if not explorer:
            return ctx.error(
                "discopop_explorer not found on PATH. "
                "Ensure the DiscoPoP library package is installed: pip install ./library"
            )

        ctx.log_action(project_path, "run_pattern_detection", f"Invoking discopop_explorer in {discopop_dir}")
        proc = subprocess.run(
            [explorer],
            cwd=str(discopop_dir),
            capture_output=True,
            text=True,
            env=env,
        )

        patterns_json = discopop_dir / "explorer" / "patterns.json"
        pattern_types: dict[str, int] = {"do_all": 0, "reduction": 0, "task": 0, "pipeline": 0}
        patterns_found = 0
        if patterns_json.exists():
            try:
                data = json.loads(patterns_json.read_text())
                patterns = data.get("patterns", {})
                for key in pattern_types:
                    count = len(patterns.get(key, []))
                    pattern_types[key] = count
                    patterns_found += count
            except Exception:
                pass

        if proc.returncode != 0:
            result: dict[str, Any] = {
                "status": "error",
                "message": f"discopop_explorer failed with return code {proc.returncode}.",
                "returncode": proc.returncode,
                "stdout": proc.stdout,
                "stderr": proc.stderr,
            }
        else:
            ctx.log_action(
                project_path,
                "run_pattern_detection",
                f"Pattern detection complete: {patterns_found} patterns found (do_all={pattern_types['do_all']}, reduction={pattern_types['reduction']}, task={pattern_types['task']}, pipeline={pattern_types['pipeline']})",
            )
            result = {
                "status": "success",
                "project_path": project_path,
                "returncode": proc.returncode,
                "patterns_found": patterns_found,
                "pattern_types": pattern_types,
                "stdout": proc.stdout,
                "stderr": proc.stderr,
            }

        ctx.log_response("run_pattern_detection", result)
        return [TextContent(type="text", text=json.dumps(result))]

    except Exception as e:
        error_msg = f"Error running pattern detection: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return [TextContent(type="text", text=json.dumps({"status": "error", "message": error_msg}))]
