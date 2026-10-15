---
layout: default
title: Tasks
parent: Parallel patterns
grand_parent: Data
nav_order: 3
---

# Task parallelism

{: .warning }
Experimental and off by default: enable it with `--enable-patterns task` (the default is `reduction,doall`). The detector is incomplete.

The task detector (`new_task_detector.py` in the explorer) works on the task graph that is built on top of the [program execution graph](../Program_execution_graph.md). It identifies simple tasking and reports the results in the `task` list of `.discopop/explorer/patterns.json`; the entries are `TaskParallelismInfo` and `ParallelRegionInfo` objects. The remaining detection steps are not implemented yet. For `example/example.cpp`, `--enable-patterns task` reports no task pattern (the `task` list is empty).

The pattern `*` enables all detectors, including this one; the run can then take much longer than with the default.
