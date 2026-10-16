---
layout: default
title: Program execution graph
parent: Data
nav_order: 4
---

# Program execution graph

The program execution graph (PET, class `PEGraphX` in the explorer) is the core data structure of the [explorer](../tools/Explorer.md). It combines statically and dynamically obtained information, described in [profiling and instrumentation output](Profiling_and_instrumentation_output.md), in one graph.

## Nodes

The nodes correspond to the nodes of `Data.xml`:

| Type | Class | Meaning |
|---|---|---|
| 0 | `CUNode` | computational unit |
| 1 | `FunctionNode` | function |
| 2 | `LoopNode` | loop |
| 3 | `DummyNode` | function without source code |

The explorer adds one CU to the end of every function (`FuncExit_<function name>`), so that each function has a single exit node. A class `FunctionReturnNode` exists in the code but is not created at the moment.

## Edges

| Edge type | Direction | Meaning |
|---|---|---|
| `child` | function or loop to the nodes it contains | contains |
| `successor` | CU to the CUs that can execute after it | executed after |
| `dependency` (`DATA`) | sink CU to source CU | data dependence |
| `calls` (`CALLSNODE`) | CU to the function it calls | function call |
| `produce_consume` | - | defined, but no code creates it at the moment |

A dependency edge carries these fields:

| Field | Meaning |
|---|---|
| `dtype` | `RAW`, `WAR`, `WAW` or `INIT` |
| `var_name`, `memory_region` | accessed variable and memory region |
| `source_line`, `sink_line` | lines of the two accesses |
| `intra_iteration`, `intra_iteration_level` | the dependency does not cross loop iterations (and at which loop level) |
| `carried_by_loop` | the loop whose iterations the dependency crosses, derived from the callpath states |
| `origin` | `STATIC_ANALYSIS` or `DYNAMIC_ANALYSIS` |

## Task graph

On top of the graph, the explorer builds a task graph. It unfolds the control flow along the callpath states, so that the same function called from different places appears separately, and groups the nodes into contexts such as loops and function bodies. The do-all, reduction and task detectors work on it. The task graph is an internal structure of the explorer and is not written to a file (except as part of `detection_result_dump.json`).

## Use case

The graph encodes the behavior of the program on an abstract level. This allows the generation of general parallelization suggestions from small input data, as long as the input represents the behavior of a typical production run.
