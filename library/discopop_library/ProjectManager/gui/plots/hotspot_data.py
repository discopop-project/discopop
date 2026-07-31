# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Pure data-reduction helpers for the Hotspot Detection tab.

Everything here is free of Tk and matplotlib so it can be unit-tested directly,
mirroring :mod:`discopop_library.ProjectManager.gui.plots.data`.

Three artefacts of the hotspot detection tooling are read:

* ``hotspot_detection/private/cs_id.txt`` -- the code-region id table written by
  the instrumentation pass: ``<id> loop <line> <fid>`` or
  ``<id> func <line> <fid> <name>``.
* ``hotspot_detection/private/hotspot_result_<N>.txt`` -- one profiled run:
  ``<id> <runtime>`` per line.
* ``hotspot_detection/Hotspots.json`` -- the analyzer's output, one entry per
  code region with its per-run runtimes and its ``YES``/``MAYBE``/``NO`` hotness.

Regions are identified by a resolved :class:`RegionKey` (source path, line, kind
and name) rather than by the raw numeric id. Ids are only stable within one
instrumented build: the pass appends to ``cs_id.txt`` and resumes numbering from
``temp.txt``, so a second compile renumbers everything. ``fid`` is not usable as
a key either, since ``FileMapping.txt`` is appended and its ids depend on compile
order. :func:`region_fingerprint` turns the resolved key set into a hash that the
GUI stores alongside its accumulated runs, so a build that no longer matches
those runs is detected exactly rather than guessed at from file mtimes.
"""

from __future__ import annotations

import hashlib
import json
import os
from dataclasses import dataclass, field
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple

# Hotness values as written by discopop_hotspot_analyzer.
HOTNESS_YES = "YES"
HOTNESS_MAYBE = "MAYBE"
HOTNESS_NO = "NO"
HOTNESS_ORDER = (HOTNESS_YES, HOTNESS_MAYBE, HOTNESS_NO)

# Code region kinds as written into cs_id.txt / Hotspots.json.
KIND_LOOP = "LOOP"
KIND_FUNCTION = "FUNCTION"

# cs_id.txt spells the kinds differently from Hotspots.json.
_CS_ID_KINDS = {"loop": KIND_LOOP, "func": KIND_FUNCTION}

SIDECAR_FILENAME = "measurement_runs.json"
_FINGERPRINT_PREFIX = "sha1:"


@dataclass(frozen=True)
class RegionKey:
    """Identity of a code region that survives re-instrumentation.

    ``name`` is empty for loops (the instrumentation pass records no name for
    them), so loops are identified by ``(path, line)`` and functions
    additionally by their name.
    """

    path: str
    line: int
    kind: str
    name: str = ""

    def serialize(self) -> str:
        """``path:line:KIND[:name]`` -- the form stored in the sidecar."""
        base = f"{self.path}:{self.line}:{self.kind}"
        return f"{base}:{self.name}" if self.name else base

    @property
    def location(self) -> str:
        """``basename:line``, for display in tables and chart labels."""
        return f"{os.path.basename(self.path)}:{self.line}"

    def display_name(self) -> str:
        """The function name if there is one, else the location."""
        return self.name if self.name else self.location


@dataclass
class HotspotRegion:
    """One code region of the analyzer's output, with derived display fields."""

    key: RegionKey
    csid: int
    runtimes: List[float]
    avg: float
    minimum: float
    maximum: float
    ratio: float
    hotness: str
    share: float = 0.0  # avg / sum of all avgs; filled in by parse_hotspots_json


@dataclass
class MeasurementRun:
    """One accumulated profiling run.

    ``config`` is ``None`` for runs the GUI did not record itself (produced via
    the Execute tab, the CLI or the MCP server), which are synthesized from the
    result files' mtimes and displayed as external.
    """

    index: int
    config: Optional[str] = None
    timestamp: Optional[str] = None
    time: Optional[float] = None
    code: Optional[int] = None
    regions: Dict[str, float] = field(default_factory=dict)

    @property
    def is_external(self) -> bool:
        return self.config is None


@dataclass
class MeasurementLog:
    """The GUI's sidecar: an instrumented build plus the runs recorded against it."""

    region_fingerprint: Optional[str] = None
    instrumented_at: Optional[str] = None
    compile_script: Optional[str] = None
    runs: List[MeasurementRun] = field(default_factory=list)


# ---------------------------------------------------------------------------
# cs_id.txt / hotspot_result_<N>.txt
# ---------------------------------------------------------------------------


def parse_cs_id(text: str) -> Dict[int, Tuple[str, int, int, str]]:
    """Parse ``cs_id.txt`` into ``{id: (kind, line, fid, name)}``.

    Handles both line formats the instrumentation pass writes -- 4 fields for
    loops and 5 for functions -- and skips malformed lines rather than raising,
    since the file is appended to by a compiler pass the GUI does not control.

    A later entry for an already-seen id wins: the pass appends without
    truncating, so after a re-instrumentation the newest table is the one that
    matches the current binary.
    """
    regions: Dict[int, Tuple[str, int, int, str]] = {}
    for line in text.splitlines():
        fields = line.split()
        if len(fields) < 4:
            continue
        kind = _CS_ID_KINDS.get(fields[1])
        if kind is None:
            continue
        try:
            csid = int(fields[0])
            line_number = int(fields[2])
            fid = int(fields[3])
        except ValueError:
            continue
        name = fields[4] if len(fields) > 4 else ""
        regions[csid] = (kind, line_number, fid, name)
    return regions


def parse_file_mapping(text: str) -> Dict[int, str]:
    """Parse ``FileMapping.txt`` (``<fid>\\t<path>`` per line) into ``{fid: path}``.

    Deliberately more tolerant than
    :func:`discopop_library.PathManagement.PathManagement.load_file_mapping`,
    which drops entries whose file no longer exists and warns about them. Here the
    path is only ever displayed, so keeping it is strictly better than degrading a
    region to ``file_<fid>``; and the file is appended to by the instrumentation
    pass, so a later duplicate entry for an id wins.
    """
    mapping: Dict[int, str] = {}
    for line in text.splitlines():
        if "\t" not in line:
            continue
        raw_fid, _, path = line.partition("\t")
        path = path.strip()
        if not path:
            continue
        try:
            mapping[int(raw_fid)] = path
        except ValueError:
            continue
    return mapping


def resolve_keys(
    cs_id: Dict[int, Tuple[str, int, int, str]],
    file_mapping: Dict[int, Any],
) -> Dict[int, RegionKey]:
    """Map region ids to :class:`RegionKey`s using a ``FileMapping`` dict.

    ``file_mapping`` is ``{fid: path}`` as returned by
    :func:`discopop_library.PathManagement.PathManagement.load_file_mapping`
    (whose values are ``Path`` objects; anything ``str()``-able works). Ids whose
    ``fid`` is absent from the mapping fall back to ``file_<fid>`` so a region is
    never silently dropped.
    """
    keys: Dict[int, RegionKey] = {}
    for csid, (kind, line_number, fid, name) in cs_id.items():
        mapped = file_mapping.get(fid)
        path = str(mapped) if mapped is not None else f"file_{fid}"
        keys[csid] = RegionKey(path=path, line=line_number, kind=kind, name=name)
    return keys


def parse_hotspot_result(text: str) -> Dict[int, float]:
    """Parse one ``hotspot_result_<N>.txt`` into ``{id: runtime}``."""
    runtimes: Dict[int, float] = {}
    for line in text.splitlines():
        fields = line.split()
        if len(fields) < 2:
            continue
        try:
            runtimes[int(fields[0])] = float(fields[1])
        except ValueError:
            continue
    return runtimes


def region_fingerprint(keys: Iterable[RegionKey]) -> str:
    """A stable hash over a set of region keys.

    Order-independent (the key set is sorted first) so it depends only on which
    regions the build contains, not on the order the pass happened to emit them.
    """
    digest = hashlib.sha1()
    for serialized in sorted(key.serialize() for key in keys):
        digest.update(serialized.encode("utf-8"))
        digest.update(b"\n")
    return _FINGERPRINT_PREFIX + digest.hexdigest()


# ---------------------------------------------------------------------------
# Hotspots.json
# ---------------------------------------------------------------------------


def parse_hotspots_json(data: Dict[str, Any], keys: Dict[int, RegionKey]) -> List[HotspotRegion]:
    """Flatten ``Hotspots.json`` into :class:`HotspotRegion`s, sorted by avg desc.

    ``keys`` resolves ids to source locations. Entries whose id is missing from
    it are still kept, using the ``fid``/``lineNum``/``name`` recorded in the
    JSON itself, so a stale id table degrades the location display rather than
    hiding regions.
    """
    regions: List[HotspotRegion] = []
    for entry in data.get("code_regions", []):
        try:
            csid = int(entry["csid"])
        except (KeyError, TypeError, ValueError):
            continue
        kind = str(entry.get("typ", KIND_LOOP))
        name = str(entry.get("name", ""))
        key = keys.get(csid)
        if key is None:
            key = RegionKey(
                path=f"file_{entry.get('fid', 0)}",
                line=int(entry.get("lineNum", 0)),
                kind=kind,
                name=name,
            )
        runtimes = [float(value) for value in entry.get("runtimes", [])]
        regions.append(
            HotspotRegion(
                key=key,
                csid=csid,
                runtimes=runtimes,
                avg=float(entry.get("avr", 0.0)),
                minimum=float(entry.get("minVal", 0.0)),
                maximum=float(entry.get("maxVal", 0.0)),
                ratio=float(entry.get("ratio", 0.0)),
                hotness=str(entry.get("hotness", HOTNESS_NO)),
            )
        )

    total = sum(region.avg for region in regions)
    if total > 0:
        for region in regions:
            region.share = region.avg / total

    regions.sort(key=lambda region: region.avg, reverse=True)
    return regions


def quadrant_thresholds(regions: Sequence[HotspotRegion]) -> Tuple[float, float]:
    """The ``(mean(avg), mean(ratio))`` thresholds the analyzer classifies against.

    Reproduces ``hotspot_analyzer.run``'s ``np.mean`` over both metrics so the
    crosshairs drawn on the quadrant chart agree exactly with the hotness labels
    the analyzer already wrote. Returns ``(0.0, 0.0)`` for an empty input.
    """
    if not regions:
        return (0.0, 0.0)
    count = len(regions)
    return (
        sum(region.avg for region in regions) / count,
        sum(region.ratio for region in regions) / count,
    )


def hotness_counts(regions: Iterable[HotspotRegion]) -> Dict[str, int]:
    """Number of regions per hotness value, always covering all three keys."""
    counts = {hotness: 0 for hotness in HOTNESS_ORDER}
    for region in regions:
        if region.hotness in counts:
            counts[region.hotness] += 1
    return counts


def ratio_is_degenerate(regions: Sequence[HotspotRegion]) -> bool:
    """Whether the ``ratio`` criterion carries no information.

    ``ratio = 1/((min/max)+1)`` is exactly ``0.5`` for every region when only a
    single run was profiled, because ``min == max``. The classifier then reduces
    to "average above the mean", and the ratio axis of the quadrant chart is
    meaningless -- the charts say so rather than presenting it as signal.
    """
    if not regions:
        return True
    return all(abs(region.ratio - 0.5) < 1e-9 for region in regions)


# ---------------------------------------------------------------------------
# the GUI's measurement-run sidecar
# ---------------------------------------------------------------------------


def deserialize_log(data: Dict[str, Any]) -> MeasurementLog:
    """Build a :class:`MeasurementLog` from parsed sidecar JSON."""
    runs: List[MeasurementRun] = []
    for entry in data.get("runs", []):
        try:
            index = int(entry["run"])
        except (KeyError, TypeError, ValueError):
            continue
        raw_regions = entry.get("regions", {})
        regions = {str(key): float(value) for key, value in raw_regions.items()}
        runs.append(
            MeasurementRun(
                index=index,
                config=entry.get("config"),
                timestamp=entry.get("ts"),
                time=entry.get("time"),
                code=entry.get("code"),
                regions=regions,
            )
        )
    runs.sort(key=lambda run: run.index)
    return MeasurementLog(
        region_fingerprint=data.get("region_fingerprint"),
        instrumented_at=data.get("instrumented_at"),
        compile_script=data.get("compile_script"),
        runs=runs,
    )


def serialize_log(log: MeasurementLog) -> Dict[str, Any]:
    """Render a :class:`MeasurementLog` as the JSON the sidecar stores."""
    return {
        "region_fingerprint": log.region_fingerprint,
        "instrumented_at": log.instrumented_at,
        "compile_script": log.compile_script,
        "runs": [
            {
                "run": run.index,
                "config": run.config,
                "ts": run.timestamp,
                "time": run.time,
                "code": run.code,
                "regions": run.regions,
            }
            for run in log.runs
        ],
    }


def merge_external_runs(log: MeasurementLog, known_indices: Sequence[int]) -> List[MeasurementRun]:
    """The runs present on disk, with unrecorded indices synthesized as external.

    ``known_indices`` are the indices of the ``hotspot_result_*.txt`` files that
    actually exist. Indices the sidecar knows about but which no longer have a
    result file are dropped; indices with a file but no sidecar entry are
    returned as external runs (``config is None``).
    """
    recorded = {run.index: run for run in log.runs}
    merged: List[MeasurementRun] = []
    for index in sorted(set(known_indices)):
        merged.append(recorded.get(index) or MeasurementRun(index=index))
    return merged


# ---------------------------------------------------------------------------
# filesystem layout
# ---------------------------------------------------------------------------


def hotspot_dir(dot_dp: str) -> str:
    return os.path.join(dot_dp, "hotspot_detection")


def private_dir(dot_dp: str) -> str:
    return os.path.join(hotspot_dir(dot_dp), "private")


def cs_id_path(dot_dp: str) -> str:
    return os.path.join(private_dir(dot_dp), "cs_id.txt")


def hotspots_json_path(dot_dp: str) -> str:
    return os.path.join(hotspot_dir(dot_dp), "Hotspots.json")


def sidecar_path(dot_dp: str) -> str:
    return os.path.join(hotspot_dir(dot_dp), SIDECAR_FILENAME)


def result_file_indices(directory: str) -> List[int]:
    """Indices of the ``hotspot_result_<N>.txt`` files in ``directory``, sorted.

    Note that the analyzer stops at the first missing index, so a gap truncates
    the data it sees; the Runs overview shows what is on disk regardless.
    """
    if not os.path.isdir(directory):
        return []
    indices: List[int] = []
    for entry in os.listdir(directory):
        if not (entry.startswith("hotspot_result_") and entry.endswith(".txt")):
            continue
        stem = entry[len("hotspot_result_") : -len(".txt")]
        try:
            indices.append(int(stem))
        except ValueError:
            continue
    return sorted(indices)


def load_json_file(path: str) -> Optional[Dict[str, Any]]:
    """Read a JSON object from ``path``, or ``None`` if absent/unreadable.

    Used for both ``Hotspots.json`` and the sidecar: a partially written or
    hand-edited file must degrade the display, never crash the GUI.
    """
    if not os.path.exists(path):
        return None
    try:
        with open(path, "r") as f:
            data = json.load(f)
    except (OSError, json.JSONDecodeError):
        return None
    return data if isinstance(data, dict) else None
