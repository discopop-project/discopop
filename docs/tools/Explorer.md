---
layout: default
title: Explorer
parent: Tools
nav_order: 2
---

# DiscoPoP explorer
## Executable
`discopop_explorer`

## Purpose
Analyze the [output of the instrumentation and profiling stage](../data/Profiling_and_instrumentation_output.md) in order to identify opportunities for parallelism in the sequential target code ([parallel patterns](../data/Parallel_patterns.md)).
As part of the analysis, the [program execution graph](../data/Program_execution_graph.md) is created.

## Required input
- [Filemapping](../data/Filemapping.md)
- [Profiling and instrumentation output](../data/Profiling_and_instrumentation_output.md)

## Output
Identified [parallel patterns](../data/Parallel_patterns.md) are stored in a file named `.discopop/explorer/patterns.json` by default. This information can be imported by various other tools in the framework.

## Note
For a more detailed description of the available run-time arguments, please refer to the help string of the respective tool.
```
discopop_explorer --help
```