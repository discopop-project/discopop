# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Standalone parser for .discopop/profiler/static_dependencies.txt.

Mirrors the relevant subset of
explorer/discopop_explorer/utilities/PEGraphConstruction/parser.py::__parse_dep_file,
restricted to the static dependency file only (no dynamic_dependencies.txt, no loop metadata).
Kept free of any ToolContext/mcp_server.tools import to avoid a circular import — helpers.py
imports this module, not the other way round.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional


@dataclass
class StaticDependency:
    dtype: str  # "RAW" | "WAR" | "WAW"
    var_name: str
    memory_region: str
    source_file_id: int
    source_line: int
    sink_file_id: int
    sink_line: int


def _load_instruction_to_line_mapping(profiler_dir: Path) -> Dict[str, str]:
    mapping_path = profiler_dir / "instructionID_to_lineID_mapping.txt"
    mapping: Dict[str, str] = {}
    if not mapping_path.exists():
        return mapping
    for line in mapping_path.read_text(encoding="utf-8").splitlines():
        if line.startswith("#") or len(line) == 0:
            continue
        parts = line.split(" ")
        instruction_id, line_id = parts[0], parts[1]
        if line_id.startswith("*"):
            continue
        file_id, line_num = line_id.split(":")[:2]
        mapping[instruction_id] = f"{file_id}:{line_num}"
    return mapping


def _resolve_endpoint(raw: str, instruction_to_line: Dict[str, str]) -> Optional[str]:
    if ":" in raw:
        return raw
    if "@" in raw:
        raw = raw[: raw.index("@")]
    return instruction_to_line.get(raw)


def _parse_line_id(line_id: str) -> tuple[int, int]:
    parts = line_id.split(":")
    return int(parts[0]), int(parts[1])


def parse_static_dependencies(project_path: str) -> Optional[List[StaticDependency]]:
    """Parse .discopop/profiler/static_dependencies.txt into a flat list of StaticDependency.

    Returns None if static_dependencies.txt does not exist (i.e. compilation with DiscoPoP
    instrumentation has not been run yet)."""
    profiler_dir = Path(project_path) / ".discopop" / "profiler"
    static_deps_path = profiler_dir / "static_dependencies.txt"
    if not static_deps_path.exists():
        return None

    instruction_to_line = _load_instruction_to_line_mapping(profiler_dir)
    dependencies: List[StaticDependency] = []

    for line in static_deps_path.read_text(encoding="utf-8").splitlines():
        fields = line.split()
        if len(fields) < 4 or fields[1] != "NOM":
            continue

        sink = fields[0]
        # pairwise iteration over (type, source) pairs, mirroring parser.py's zip/[::2] trick
        for dtype, source_field in list(zip(fields[2:], fields[3:]))[::2]:
            if dtype == "INIT":
                continue

            source_parts = source_field.split("|")
            source_id = source_parts[0]
            var_str = source_parts[1] if len(source_parts) > 1 else ""

            var_name = var_str
            memory_region = ""
            if "(" in var_str:
                var_name, rest = var_str.split("(", 1)
                memory_region = rest[: rest.index(")")]

            if var_name.startswith("GEPRESULT_"):
                var_name = var_name.replace("GEPRESULT_", "")

            resolved_sink = _resolve_endpoint(sink, instruction_to_line)
            resolved_source = _resolve_endpoint(source_id, instruction_to_line)
            if resolved_sink is None or resolved_source is None:
                continue

            sink_file_id, sink_line = _parse_line_id(resolved_sink)
            source_file_id, source_line = _parse_line_id(resolved_source)

            dependencies.append(
                StaticDependency(
                    dtype=dtype,
                    var_name=var_name,
                    memory_region=memory_region,
                    source_file_id=source_file_id,
                    source_line=source_line,
                    sink_file_id=sink_file_id,
                    sink_line=sink_line,
                )
            )

    return dependencies
