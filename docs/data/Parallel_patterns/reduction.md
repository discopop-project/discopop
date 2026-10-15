---
layout: default
title: Reduction
parent: Parallel patterns
grand_parent: Data
nav_order: 2
---

# Reduction loop

In a reduction loop, every iteration combines a value into a variable with an associative operation, for example `sum += Arr[i]`. The iterations can run in parallel if every thread accumulates into a private copy and the copies are combined at the end. The explorer detects reduction loops by default.

## Reporting

The explorer reports the loop `for (int i = 0; i < N; i++) { sum += Arr[i]; }` of `example/example.cpp` in `.discopop/explorer/patterns.json` (excerpt of `patterns` / `reduction`):

```json
{
  "pattern_id": 1,
  "node_id": "1:12",
  "start_line": "1:24",
  "end_line": "1:24",
  "applicable_pattern": true,
  "standalone_pattern": true,
  "pattern_tag": "ReductionInfo@1:24-1:24_p([])_s([])_fp([])_r(['+:sum'])_lp([])",
  "affected_cu_ids": ["1:12"],
  "pragma": "#pragma omp parallel for",
  "first_private": ["N"],
  "private": [],
  "last_private": [],
  "shared": [],
  "reduction": ["+:sum"],
  "collapse_level": 1,
  "affected_line_ids": ["1:24"],
  "affected_functions": ["0:15:main"]
}
```

The fields shared by all patterns are described on the [Parallel patterns](Patterns.md) page. In text form (printed instead of the JSON file if you disable the JSON output) the pattern looks like this:

```text
Reduction at: 1:12
Start line: 1:24
End line: 1:24
pragma: #pragma omp parallel for
private: []
shared: []
first private: ['N']
reduction: ['+:sum']
last private: []
```

## Interpretation

* `node_id` / `Reduction at`: `<file id>:<node id>` of the entry CU of the loop (see [`FileMapping.txt`](../Filemapping.md) and [`Data.xml`](../Profiling_and_instrumentation_output.md)).
* `start_line` / `end_line`: `<file id>:<line>` of the first and last line of the loop.
* `pragma`: the OpenMP pragma that parallelizes the loop.
* `private`, `shared`, `first_private`, `last_private`: data sharing clauses, as for [do-all loops](doall.md).
* `reduction`: a list of `<operation>:<variable>` entries, one per reduction variable.
* `collapse_level`: 1 for reduction patterns.

## Supported operations

The pass recognizes the operations `+`, `-`, `*`, `&`, `|` and `^` (see [reduction.txt](../Profiling_and_instrumentation_output.md#reduction-instructions)). It reports a conditional update of a variable (`if (a < x) x = a`) with the operation `>`, which the explorer lists as `max`.
<!-- UNVERIFIED: how the patch generator writes the clause for `max`; the explorer also maps `<` to `min`, the pass does not emit it -->

## Implementation

The [patch generator](../../tools/Patch_generator.md) creates a patch with the reduction clause, the [patch applicator](../../tools/Patch_applicator.md) applies it. For the pattern above, `.discopop/patch_generator/1/1.patch` inserts

```text
#pragma omp parallel for firstprivate(N) reduction(+:sum)
```

before the loop.
