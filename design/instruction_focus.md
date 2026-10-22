<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License. See the LICENSE file in the package base
directory for details.
-->

# Instruction focus: CUs made of instruction IDs — Plan

Status: planning (2026-10-22). Branch `improvement/mcp_server/task_suggestions`.

Goal (maintainer): instruction IDs become the identity of what the analysis works with — CUs,
dependences, contexts, patterns — and are carried through the whole pipeline. Lines and columns
become a view derived from the IDs (`instructionID_to_lineID_mapping.txt`), used for output and
for matching data of other builds. The line focus is to be replaced by an instruction focus over
time. Old `Data.xml` files need not be supported.

## 1. Trigger: the CUs of BOTS fib

Lines 31/32 of `fib.c` are `x = fib(n - 1);` / `y = fib(n - 2);`. IR at -O0, per line:
`load n, sub, call fib, store` (instruction IDs 847-850 for line 31, 851-854 for line 32).

`createCUs.cpp` closes a CU right *before* a call if it has phase lines, so the tail of statement
N and the head of statement N+1 end up in one CU:

| CU | instructions (derived from the code) | span |
|---|---|---|
| 3:236 | load n(31) | 31-31 |
| 3:237 | call(31), store x(31), load n(32), sub(32) | 31-32 |
| 3:238 | call(32), store y(32) | 32-32 |

Calls are attached afterwards by searching the first CU of the block whose line *range* contains
the call's line, so call 31 lands on 3:236 and call 32 on 3:237 (matches `Data.xml`: one CU off).
The task detector's scopes (`[31]`, `[31, 32]`) follow from that; see
`design/task_suggestions.md` and the strict xfail in `test_new_task_detector.py`.
The table is derived from reading the code; stage 1 verifies it (dump per CU).

## 2. What exists

- Every instruction gets a unique ID (metadata `dp.md.instr.id`, `instruction_id_assignment.cpp`),
  unique across modules; `instructionID_to_lineID_mapping.txt` maps it to `file:line:column`.
- Dynamic dependences are recorded per instruction ID (`602@475 NOM RAW 308@12|var`), with the
  callpath state after `@`.
- Calls in `Data.xml` carry their ID (`callInstId`).
- The explorer drops both: `parser.py` converts IDs to `file:line` and removes the state;
  `PEGraphX` maps a line to *all* CUs whose read/write phase lines contain it.
- Pass order (`runOnFunction.cpp`): CUs are built on the uninstrumented IR (stage 1), IDs are
  assigned while instrumenting (stage 2), `Data.xml` is written after that (stage 3), the hybrid
  analysis erases only inserted callbacks (stage 4). So `Instruction*` kept per CU in stage 1 can
  be written as IDs in stage 3.

## 3. Stages

1. **Additive.** `CU` holds its `llvm::Instruction*` in order (moved along in the
   cautious-property split); `Data.xml` gets `<instructionIDs>` per CU node. The explorer parses
   them as required data and stores them on `CUNode` (ordered); dependences keep source/sink
   instruction IDs and the callpath state. No change in behaviour; check over the end-to-end suite
   that lines derived from the IDs equal the current lines.
2. **Exact mapping.** Dependence → CU and call → CU by instruction ID (calls: record the CU while
   processing the call instruction, drop the line-range search). Lines remain only for data
   without IDs (to check: static dependences of the hybrid analysis).
3. **Split position.** Split before the first instruction of the call's statement (move the
   statement head into the new CU); compute phases, sizes and counts from the instruction list
   when a CU closes instead of incrementally. Makes the fib xfail pass.
4. **Migration.** `instruction_scope` beside `get_code_scope` in the task graph contexts;
   instruction IDs of loop bodies and tasks in `patterns.json` (added beside existing fields);
   explorer queries move module by module (explorer: 138 uses of `LineID` in 27 files, 236 of
   `start_line`/`end_line`; library about 130). The MCP server stays line-based (presentation).

Each stage gets its own tests and commit.

## 4. Caveats

- **IDs are valid within one build only** (a counter over the compiled modules). Anything compared
  across builds stays on lines/columns: `Hotspots.json` (separate instrumentation build), saved
  GUI suggestions and patches, comparisons between runs.
- **Instructions without debug location** (line 0, e.g. some phis) and instructions inserted by
  instrumentation: need a rule (keep in their CU, contribute no position).
- **Columns are expression positions, not statement extents** (`store x` has the column of `=`);
  statement extents for task bodies come from the AST (`ast_dump.json`).
- **Optimized builds:** the 1:1 relation of IR instructions to source holds at -O0 only.

## 5. Open checks

- [ ] Every relevant instruction gets an ID (fib: load, sub, call, store do).
- [ ] Format of the static dependences of the hybrid analysis (IDs or lines).
- [ ] Other consumers of the line → CU mapping (GUI, optimizer) before stage 2.
- [ ] Profiler rebuild and reinstall (`pip install ./profiler`), pass unit tests
      (`DiscoPoP_Pass_UT`), profiler/instrumentation tests.
