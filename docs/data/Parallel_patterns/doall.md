---
layout: default
title: Do-All
parent: Parallel patterns
grand_parent: Data
nav_order: 1
---

# Do-All loop

In a do-all loop, no iteration depends on the result of another iteration, so the iterations can run in parallel. The explorer detects do-all loops by default.

## Reporting

The explorer reports the loop `for (int i = 0; i < N; i++) { Arr[i] = i % 13; }` of `example/example.cpp` in `.discopop/explorer/patterns.json` (excerpt of `patterns` / `do_all`):

```json
{
  "pattern_id": 0,
  "node_id": "1:7",
  "start_line": "1:20",
  "end_line": "1:20",
  "applicable_pattern": true,
  "standalone_pattern": true,
  "pattern_tag": "DoAllInfo@1:20-1:20_p([])_s(['N'])_fp([])_r([])_lp([])_c(1)",
  "affected_cu_ids": ["1:7"],
  "iterations_count": -1,
  "pragma": "#pragma omp parallel for",
  "first_private": ["N"],
  "private": [],
  "last_private": [],
  "shared": [],
  "reduction": [],
  "scheduling_clause": "static",
  "collapse_level": 1,
  "collapsed_pattern_ids": [],
  "affected_line_ids": ["1:20"],
  "affected_functions": ["0:15:main"]
}
```

The fields shared by all patterns are described on the [Parallel patterns](Patterns.md) page. In text form (printed instead of the JSON file if you disable the JSON output) the pattern looks like this:

```text
Do-all at: 1:7
Start line: 1:20
End line: 1:20
pragma: "#pragma omp parallel for"
collapse: 1
private: []
shared: []
first private: ['N']
reduction: []
last private: []
scheduling clause: static
```

## Interpretation

* `node_id` / `Do-all at`: `<file id>:<node id>` of the entry CU of the loop. Look up the file id in [`FileMapping.txt`](../Filemapping.md) and the node in [`Data.xml`](../Profiling_and_instrumentation_output.md).
* `start_line` / `end_line`: `<file id>:<line>` of the first and last line of the loop.
* `pragma`: the OpenMP pragma that parallelizes the loop.
* `private`, `shared`, `first_private`, `last_private`: the data sharing clauses of the loop; the text form writes `first private` and `last private`. The loop index is not listed. A do-all pattern has an empty `reduction` list.
* `scheduling_clause`: the scheduling the patch uses, `static`.
* `collapse_level`: the number of perfectly nested do-all loops the pattern covers (`collapse(<n>)`). Nested do-all loops yield additional patterns with a higher `collapse_level`; `collapsed_pattern_ids` names the patterns that were folded into one. They are alternatives: applying a collapsed pattern excludes applying the ones it folds, because a pragma between two collapsed loops does not compile.

## Implementation

You do not insert the pragma by hand. The [patch generator](../../tools/Patch_generator.md) creates a patch for the pattern that adds the clauses, and the [patch applicator](../../tools/Patch_applicator.md) applies it. For the pattern above, `.discopop/patch_generator/0/1.patch` contains:

```diff
@@ -17,6 +17,7 @@
   long sum = 0;
   int Arr[N];

+  #pragma omp parallel for firstprivate(N)
   for (int i = 0; i < N; i++) {
     Arr[i] = i % 13;
   }
```

Besides the clauses of the data sharing lists, the pragma carries `collapse(<n>)` if `collapse_level` is larger than 1.
