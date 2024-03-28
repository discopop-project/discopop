---
layout: default
title: Program execution graph
parent: Data
nav_order: 3
---

# Program execution graph
The program execution graph is the core data structure of the [DiscoPoP explorer](../tools/Explorer.md) and combines statically as well as dynamically obtained information, described in detail in [profiling and instrumentation output](Profiling_and_instrumentation_output.md), into a single graph structure.

## Structure
Nodes in the graph represent `functions`, `loops`, or `computational units`.
Computational units are connected via `successor` edges to represent the `executed after` relation.
Computational units are connected to functions and loops via `child` edges, representing a `contained in` relation.
`Data dependences` among computational units are depicted via `dependency` edges.
Functions can be connected to computational units via `calling` edges to represent functions calls.

## Use case
Due to the amount of information encoded in this graph structure, it is possible to obtain a accurate depiction of the programs behavior on an abstract level. This abstraction allows the generation of general parallelization suggestions on the basis of small input data, as long as the input represents the behavior of a typical production run of the software.
In order to identify parallel patterns from the program execution graph, analysis methods described in detail in the published papers are applied. Please refer to these publications for further detail, or contact us directly.
