<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License. See the LICENSE file in the package base
directory for details.
-->

# Task suggestions in get_parallelization_suggestions — Plan & Todos

Status: MCP tool part implemented (task groups in `mcp_server/tools/task_groups.py`); the
rest of 3.1 and 3.2 is open. Branch:
`improvement/mcp_server/task_suggestions`, based on `improvement/mcp_server/interface`.

`get_parallelization_suggestions` lists task parallelism as type `pattern` with a bare
`#pragma omp parallel` (the fallback in `get_parallelization_suggestions.py`, because only
`do_all` and `reduction` are mapped). It should instead describe the surrounding parallel
region, the bodies of the contained tasks and the variable dependences between them. The
agent derives the actual pragmas and their positions from that description, because the
explorer's positions are not always applicable one to one.

---

## 1. Findings (2026-10-22, BOTS `serial/fft` and `serial/fib`)

- The explorer emits two kinds of objects under the key `task` of `patterns.json`:
  `TASK` (not standalone) and `PARALLELREGION` (standalone, `contains_patterns` lists its
  tasks). Only the regions have patches, so only they are listed today.
- `gather_data` runs the explorer with its default `--enable-patterns reduction,doall`;
  task detection has to be enabled by hand.
- Task entries have no decision-log entry, so the tool shows kind `Loop` and no hotspot.
  The printed line is the first line of the patch's `@@` header (context start), e.g.
  `fib.c:28` for a region starting at line 31.
- `region_*_line` are bare line numbers; the file id is only part of `start_line`
  (`"fid:line"`), which is the span of the enclosing CU, not of the region.
- `262143` as an end line is a sentinel for "unknown"; the side-effect export has it as
  `end_line` of 17 of the 35 functions of fft.
- `Hotspots.json` knows loops and functions only, by `(file id, start line)` without end
  line. Its function lines are one higher than the side-effect export's (`fft_aux` 2907
  against 2906), so match on file id and name.
- `side_effects.json.gz` lists all functions (file id, start line, end line) and is enough
  to find the function enclosing a region.
- fib: group at `fib.c` 31-32 is the real one, but task 2 is reported as 31-32 and thus
  overlaps task 1 (31-31); `x` and `y` are read at line 34 and nothing says the group needs
  a join before it. The other two groups are `sprintf` blocks in `bots_print_results` and
  a call plus the closing brace in `bots_get_params`.
- fft: none of the 26 groups is the parallelism in `fft_aux` (the recursive call in the
  `for` loop at line 2951). Most are branches of an `if ... else if` chain (mutually
  exclusive), a call plus its `return`, or a call plus a message print.

## 2. Output (sketch)

One entry per task group, hottest enclosing scope first:

    Suggestion 5: Task group in Function fib.c:26-35 (inside Hotspot Function fib, <runtime> s, <share>% of runtime)
      parallel region: fib.c:31-32
      task 3: fib.c:31-31   x = fib(n - 1);
      task 4: fib.c:32-32   y = fib(n - 2);
      dependences: none between the tasks
      read after the region: x (line 34), y (line 34)
      flags: ...

No pragmas are printed for tasks; the text says which constructs are needed (parallel
region, tasks, a join before the reads after the region, clauses for the dependences).
Implausible groups are flagged, not hidden (see 3.3).

## 3. Todos

### 3.1 MCP tool (this branch)

- [x] Map the `task` key; list one entry per `PARALLELREGION` with its tasks via
      `contains_patterns`; take the file id from `start_line`.
- [x] Print `in_dep` / `out_dep` / `in_out_dep` as dependences between tasks; RAW as the
      main information, WAR/WAW marked `(anti)` / `(output)`.
- [x] Hotspot of the enclosing function: find the function from the side-effect export, then
      match the hotspot by file id and name (not by line). Say "no hotspot data" if there is
      no match or no export. State that the runtime is the scope's, not the region's, and
      that recursive functions are counted inclusively.
- [x] Flags: identical spans of two tasks, overlapping spans, unknown end line (262143),
      task body that ends in a `return` or is a closing brace.
- [-] Single-statement flag: dropped. It is not helpful for a statement that is or contains a
      function call (maintainer), which covers the real fib tasks and most others. Only worth
      reconsidering for statements without any call (e.g. a plain assignment), if such groups
      turn out to be noise.
- [x] Do not use the first `@@` line or the default kind `Loop` for tasks.
- [x] Relations (`nested_in` / alternative) for task regions and doall loops, e.g. a region
      inside the loop of a doall suggestion.
- [x] `explain_parallelization` for task regions (names the group covering the lines; reasons
      for rejected groups need the decision log of 3.2); tool description and
      `docs/tools/MCP_server.md`.
- [x] Tests with fixtures from the fib and fft runs (`fft_task_groups_fixture.py`) (including the stale or missing
      hotspot and side-effect data).
- [x] `gather_data`: option `enable_task_detection` (the explorer writes the patches itself).
      Not in the default; to be decided by the maintainer. It repeats the detection even if
      its results are current, since patterns.json does not say whether tasks were enabled.

### 3.2 Explorer follow-ups (separate work)

- [ ] **Fill `in_dep` / `out_dep` / `in_out_dep`** (maintainer, by hand; always empty today).
      Then the tool (`task_groups.dependences`) must be adapted: it prints the fields as
      `in x; out y; in/out z` without telling the kind of dependence. Per the agreed
      presentation, RAW is the main information and WAR/WAW are marked `(anti)` / `(output)`,
      which needs the kind per variable in the explorer's output (a new field or a tagged
      entry); add a test with real dependences (fib: none; take a case from `bots/omp-tasks`).

- [ ] **Tests from `bots/omp-tasks`.** The hand-written OpenMP task versions in
      `/home/lukas/git/bots/omp-tasks` are the ground truth (maintainer, 2026-10-22): derive the
      unit tests of the task detection from them (what the serial version must yield).

- [ ] **Loop and recursive tasking.** The detector does not find the recursive calls in the
      `for` loop of `fft_aux` (TODO comments in `new_task_detector.run_detection`).
- [ ] **Mutually exclusive branches.** Do not report statements of different branches of an
      `if ... else if` chain as parallel tasks (fft: 2944-2949, 2959-2964).
- [ ] **Task bodies.** `return` statements and closing braces are reported as task bodies
      (fft 2917-2918, fib/bots_main 440); snap spans to whole statements.
- [ ] **Overlapping spans.** Task 2 of the fib group starts at the line of task 1
      (31-32 against 31-31); derive the spans per task without the shared scope lines.
- [ ] **Unknown end line.** Replace the sentinel 262143 by a real end line, or omit it.
- [ ] **Join points.** Report what is read after the region (fib: `x`, `y` at line 34), so
      that a join (taskwait, depend) can be derived.
- [ ] **Data sharing.** `shared`, `private`, `first_private` are always empty.
- [ ] **Enclosing loop.** Export the innermost enclosing loop (start line) of a region so
      that its hotspot can be matched; loops are not in the side-effect export.
- [ ] **Decision log.** Record task decisions (accepted and rejected groups) in
      `pattern_decisions.json` like doall and reduction do.
- [ ] **Side-effect export:** `static_callees` of `fib` is empty although it calls itself;
      check whether self recursion is excluded on purpose. A recursion flag per group
      (callee is the enclosing function) would let the output suggest a cut-off.
- [ ] **Trivial groups.** Groups of unprofitable code (a few `sprintf` calls in the shared
      BOTS sources) are reported with the same weight as real ones.
