<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License. See the LICENSE file in the package base
directory for details.
-->

# Hotspot Detection Tab — Design & Implementation Plan

Status: design approved; implementation not started.

Adds a **Hotspot Detection** tab to the DiscoPoP Project Manager GUI
(`library/discopop_library/ProjectManager/gui`), positioned left of *Pattern
Detection*. It replaces the *Use for Hotspot Detection* button on the Execute
tab, which is removed in the process.

The tab does three things:

1. **Run measurements** — instrument the project once, then execute a selected
   run configuration to append one measurement run.
2. **Show the accumulated runs** — which configuration produced which run, when,
   how long it took, whether it succeeded.
3. **Present the analysis** — `Hotspots.json` in four interpretable views, in a
   notebook modelled on the Report tab.

---

## 0. Background: how the hotspot data actually works

These properties of the existing tooling drive every design decision below and
were verified against the sources.

**The analyzer needs several runs with *differing inputs*.**
`discopop_hotspot_analyzer` classifies each code region by two criteria
(`hotspot_analyzer.py:270-287`): `avg >= mean(avg)` (`topAvr`) and
`ratio >= mean(ratio)` (`topRatio`), where
`ratio = 1/((min/max)+1)` over the region's runtimes across all accumulated
runs. Hotness is `YES` when both hold, `NO` when neither, `MAYBE` otherwise.

With a **single** run `min == max`, so every `ratio` is exactly `0.5`,
`mean(ratio)` is `0.5`, `ratio >= mean(ratio)` holds for all regions, and
hotness degenerates to `avg >= mean(avg)`. Repeating the *same* input is worse
than one run: `min` and `max` then differ only by measurement noise, so
`topRatio` splits regions arbitrarily and manufactures `MAYBE` classifications.
**Varying the input across runs is what makes `ratio` meaningful**, and in the
ProjectManager model the input lives in each configuration's `execute.sh` — so
accumulating runs across configurations is the intended workflow.

**The region-id table is append-only, and ids carry across compiles.**
`HotspotDetection.cpp` opens all of its outputs with `std::ios_base::app`:
`cs_id.txt` (`:513`, `:722`), `FileMapping.txt` (`:253`) and `temp.txt`
(`:785`). On startup the pass *resumes* numbering from `temp.txt`
(`:369`, `UID = std::stoi(lastid)`), and `rtlib.c:147-160` sizes its output by
counting the lines of `cs_id.txt`, emitting a row for every id from 1 to that
count.

Consequently, **compiling into a non-empty `private/` directory corrupts the
analysis**: the second compile numbers its regions `N+1…2N`, leaves the stale
`1…N` rows in `cs_id.txt`, and the new binary writes `0.0` for every old id.
Because the analyzer joins purely by id, each region ends up with a real
measurement from the run where it existed and `0.0` from the run where it did
not. `calMin` picks up the `0.0`, `roundMin` rewrites it to `1e-6`, so
`ratio ≈ 1.0` for *every* region and `topRatio` becomes universally true; the
YES/MAYBE distinction stops carrying information, and `calAvr` deflates every
average by the runs the region was absent from.

This is not conditional on editing sources — the removed *Use for Hotspot
Detection* button reproduced it on a second click. `mcp_server/tools/gather_data.py:133`
avoids it by `shutil.rmtree`-ing `.discopop/hotspot_detection` before
instrumenting; the documented CLI flow avoids it by compiling once and
re-executing many times.

**Therefore: compile once per accumulation, execute many times.** This is the
invariant the tab enforces.

**`fid` is resolvable but is not a stable key.** `addFileName`
(`HotspotDetection.cpp:248`), which would write malformed lines, is dead code —
`getFileID` writes valid `id\tpath` entries itself (`:281`, `:288`), so
`.discopop/FileMapping.txt` is loadable via
`PathManagement.load_file_mapping` even on an hd-only build. But the file is
appended and ids depend on compile order, so regions are keyed by resolved
**path** rather than `fid`.

**`execution_results.json` cannot serve as the run log.** `execute_configuration`
deduplicates by `(applied_suggestions, thread_count, label)`
(`configurations/execution.py:213-221`), so repeated hd runs of one
configuration overwrite each other. A separate sidecar log is required.

---

## 1. Decisions

| Aspect | Decision |
|---|---|
| Tab position | `Editor · Execute · Report · **Hotspot Detection** · Pattern Detection · Autotuning` |
| Tab gating | Always enabled — it produces the data, so gating it would deadlock. Unmet prerequisites disable the run button with an inline reason. |
| Launch scope | The configuration selected in the left panel; repeat count (default **1**). |
| Compile policy | Compile **only when needed**; otherwise execute only and append a run. |
| Re-instrumenting with runs present | Confirmation dialog naming the number of runs discarded, then clear + compile. |
| Clearing | Explicit `Clear Measurements` button (confirm dialog). No automatic wipe. |
| Result views | Four, in a Report-style notebook: permanent tabs plus a `＋` menu adding closable chart tabs. |
| Selection | Per-tab, exactly as `report_panel.py`; each results tab owns a Selection Details bar. |
| Run log | `.discopop/hotspot_detection/measurement_runs.json`, regions stored by resolved key. |

### 1a. When a compile is required

* no instrumented build yet (`private/cs_id.txt` absent), or
* project sources are newer than `cs_id.txt`, or
* the selected configuration's resolved `compile.sh` differs from the one
  recorded for the current build, or
* the user presses `Re-instrument`, or
* **the region fingerprint no longer matches** (see below).

Mtimes only *decide whether to compile*. Correctness rests on the fingerprint.

### 1b. The region fingerprint (exact guard)

The sidecar records `region_fingerprint`: a stable hash over the sorted resolved
region keys parsed from `cs_id.txt` at instrumentation time. Before appending a
run, the fingerprint is recomputed from the current `cs_id.txt`; a mismatch
means the build no longer matches the accumulated runs (e.g. the user rebuilt
outside the GUI) and is routed to the confirm-and-clear path. This replaces
mtime heuristics as the safety net, so the corruption described in §0 cannot be
reached silently.

### 1c. Accepted limitations

* **Repetitions only narrow measurement noise.** The spinner defaults to 1 and
  carries a caption saying so; varying the input across configurations is what
  produces signal. Kept because repeated runs of an unstable benchmark do
  legitimately tighten `min`/`max`.
* **`LOOP` region keys are `(path, line)`.** Loops have no name in `cs_id.txt`,
  so an edit that shifts a loop's line changes its key. This is strictly more
  stable than raw ids (which shift when any region anywhere is added or
  removed), and the fingerprint guard catches the case regardless.
* **hd runs still land in `execution_results.json`** with an empty label, so
  repeated runs of one configuration overwrite each other there and the Report
  tab shows a single `hd` row per configuration. This matches the removed
  button's behaviour and keeps the Report table uncluttered; the authoritative
  per-run record is the sidecar.
* **Timeouts are taken from the Execute tab's fields**, as
  `_prepare_inplace_run` already does. Noted in a caption rather than
  duplicated as new inputs.

---

## 2. Step 1 — Remove the old button

* `gui/mixins/execute_panel.py` — drop `prepare_hotspot_detection_button`, its
  tooltip and `on_prepare_hotspot_detection`.
* `gui/mixins/execution.py` — drop `_prepare_hotspot_detection`,
  `HOTSPOT_ANALYZER`, `_hotspot_analysis_process` and its `_stop_execution`
  branch; the two `prepare_hotspot_detection_button.config(...)` calls in
  `_run_execution` and `_prepare_inplace_run`; and the now-unused `post_step`
  parameter of `_prepare_inplace_run` (hotspot detection was its only user, so
  `_prepare_pattern_detection` is left with a single straight path).
  `_run_hotspot_analyzer` moves to the new mixin.
* `gui/mixins/mixin_base.py` — drop the `prepare_hotspot_detection_button`
  attribute and the `_prepare_hotspot_detection` stub.

`hd` remains among the Execute tab's mode checkboxes; that path is orthogonal
and runs produced through it appear as `(external)` in the Runs overview.

---

## 3. Step 2 — `gui/plots/hotspot_data.py` (pure, Tk-free)

Mirrors `plots/data.py`: no Tk, no matplotlib, unit-testable headless.

```python
@dataclass(frozen=True)
class RegionKey:                 # stable identity across compiles
    path: str; line: int; kind: str; name: str      # kind: LOOP | FUNCTION

@dataclass
class HotspotRegion:
    key: RegionKey; csid: int
    runtimes: List[float]
    avg: float; minimum: float; maximum: float
    ratio: float; hotness: str                      # YES | MAYBE | NO
    share: float                                    # avg / sum(avg)

@dataclass
class MeasurementRun:
    index: int
    config: Optional[str]                           # None => external
    timestamp: Optional[str]
    time: Optional[float]; code: Optional[int]
    regions: Dict[str, float]                       # serialized key -> runtime
```

Functions:

* `parse_cs_id(text) -> Dict[int, Tuple[str, int, int, str]]` — `(kind, line, fid, name)`,
  handling both the 4-field `loop` and 5-field `func` line formats.
* `resolve_keys(cs_id, file_mapping) -> Dict[int, RegionKey]`.
* `parse_hotspot_result(text) -> Dict[int, float]`.
* `parse_hotspots_json(data, keys) -> List[HotspotRegion]`, deriving `share`.
* `quadrant_thresholds(regions) -> Tuple[float, float]` — reproduces the
  analyzer's `mean(avg)` / `mean(ratio)` so the chart crosshairs agree with the
  labels exactly.
* `region_fingerprint(keys) -> str`.
* `load_runs` / `save_runs` for the sidecar, synthesizing `(external)` entries
  from `hotspot_result_*.txt` mtimes for indices absent from it.

`RegionKey` serializes as `path:line:KIND[:name]`.

### Sidecar schema

```json
{
  "region_fingerprint": "sha1:…",
  "instrumented_at": "2026-07-31T10:01:44",
  "compile_script": "/…/configs/compile.sh",
  "runs": [
    {"run": 0, "config": "small_input", "ts": "2026-07-31T10:02:11",
     "time": 3.4, "code": 0,
     "regions": {"lulesh.cc:1284:LOOP": 4.812,
                 "lulesh.cc:2140:FUNCTION:CalcHourglass": 2.004}}
  ]
}
```

Written by the GUI only; ignored by every other tool. `Clear Measurements`
deletes `.discopop/hotspot_detection/` including this file.
`.discopop/FileMapping.txt` is **not** deleted — it is shared with the `dp` flow.

The index of a newly created run is determined by diffing the set of
`hotspot_result_*.txt` files before and after execution (`rtlib` picks the first
free index itself).

---

## 4. Step 3 — `gui/plots/hotspot_charts.py`

Same shape as `report_charts.py`: `render_*(figure, regions, …, on_select=…)`,
reusing `mode_style.style_axes` / `style_legend`, `_setup_hover_tooltips` and the
`_find_record_at_event` click-routing pattern.

* `render_quadrant` — log-x average runtime vs `ratio`, crosshairs at
  `quadrant_thresholds`, quadrants annotated (`YES` / `MAYBE` / `NO`), marker
  shape from `kind`, colour from hotness. Makes the classifier visible: users see
  *why* a region is `MAYBE` and how close it sits to a boundary.
* `render_top_bars` — horizontal bars, top *N* by average runtime
  (*N* ∈ {10, 20, 50}), coloured by hotness, labelled `path:line`.
* `render_run_profile` — one region's runtime across run indices, with
  `min`/`max`/`ratio` annotated; the region comes from a combobox in the tab's
  control strip, defaulting to the hottest.

Hotness reuses the existing `STATUS_COLORS` semantics (`YES` → green,
`MAYBE` → orange, `NO` → `REFERENCE_COLOR`) so hotness never collides with the
`CONFIG_PALETTE` used for configurations elsewhere.

When only one run is accumulated, the quadrant chart annotates that the `ratio`
axis is inactive rather than presenting a degenerate single column as signal.

---

## 5. Step 4 — `gui/mixins/hotspot_panel.py`

A sub-notebook, flat and Report-shaped:

```
Measurement │ Runs │ Regions │ «closable chart tabs» │ ＋
```

**Measurement** — left: selected-configuration label, repeat count with the
noise caption, `Run Measurement` / `Stop` / `Re-run Analysis` /
`Re-instrument`, a red `Clear Measurements`, and a status block
(`Instrumented build: current | stale | none`, `Accumulated runs: N`,
YES/MAYBE/NO counts). Right: the shared output console via
`create_styled_output_console`.

The worker thread reuses `execute_configuration` exactly as
`_prepare_inplace_run` does, streaming output through `self.after(0, …)`. The
analyzer stays a **subprocess** — it `chdir`s into the profiling directory and
never restores the working directory, and the project's GUI convention is to
subprocess tools carrying C extensions.

**Runs** — Treeview of `MeasurementRun`s: index, configuration, timestamp,
elapsed time, status, region count.

**Regions** — the sortable table (hotness pill, kind, `path:line`, average,
share of total, min/max, `ratio`), filters for hotness and kind, its own
Selection Details bar, and a *Show in VSCode* action reusing the URI approach
from `explorer_integration._open_in_vscode`.

**`＋`** — menu of the three chart types; closable tabs with `✕`, each with its
own detail bar. Lifted from `report_panel._add_report_plot`,
`_build_detail_bar`, `_on_report_tab_changed` and `_close_report_plot`.

`Stop` terminates the compile, execute and analyzer subprocesses through handles
owned by this mixin.

---

## 6. Step 5 — Wiring

* `gui/ConfigManagerApp.py` — add `HotspotPanelMixin` to the bases, insert the
  frame before the Pattern Detection frame, store `hotspot_tab_index`, call
  `_build_hotspot_panel`.
* `_refresh_config_list` / `_on_config_selected` also refresh the hotspot
  configuration label and button states.
* `_update_pattern_detection_ui` additionally refreshes the hotspot results,
  since the analyzer's output feeds the Autotuning tab's hotspot types.
* `gui/mixins/mixin_base.py` — new attributes plus `_build_hotspot_panel`,
  `_update_hotspot_ui` and `_refresh_hotspot_results` stubs.

---

## 7. Step 6 — Verification

* `venv/bin/python -m pytest library/discopop_library/ProjectManager/gui/plots`
  — new `test_hotspot_data.py` and `test_hotspot_charts.py` alongside the four
  existing test modules. Cases: both `cs_id.txt` line formats; `fid` → path
  resolution; the degenerate single-run case (all ratios exactly `0.5`);
  `quadrant_thresholds` agreeing with the hotness labels the analyzer wrote;
  fingerprint stability and mismatch; external-run synthesis from mtimes.
* `venv/bin/python -m mypy --config-file=mypy.ini -p discopop_library`
* `venv/bin/python -m black -l 120 --check .`
* End-to-end on `example/`: measure once, confirm one run recorded and
  `Hotspots.json` regenerated; measure a second configuration and confirm the
  run is *appended* without recompiling and the quadrant chart gains a real
  `ratio` spread; edit a source and confirm the confirm-and-clear dialog fires;
  confirm all four views populate and each carries its own selection.
* `scripts/dev/run_ci_locally.sh`

---

## 8. Out of scope

* Changing `discopop_hotspot_analyzer` to join runs on resolved region keys
  instead of ids. This would make compiling between runs safe, but it alters the
  `Hotspots.json` contract consumed by the autotuner
  (`HostpotLoader/hostpot_loader.py`) and the optimizer. The compile-once
  invariant achieves correctness without touching the `hotspot_detection`
  package.
* Measuring several configurations from a single click. The tab operates on the
  selected configuration; accumulating across inputs is *select, click, repeat*.
