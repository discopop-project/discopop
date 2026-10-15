---
layout: default
title: Home
nav_order: 1
---

# DiscoPoP - Discovery of Potential Parallelism
DiscoPoP is an open-source tool that helps software developers parallelize their programs with threads. It is a joint project of the [High-Performance Computing Lab @ TU Darmstadt](https://github.com/tuda-hpclab) and the [Software Analytics and Pervasive Parallelism Lab](https://www.cs.iastate.edu/swapp/) at Iowa State University.

In a nutshell, DiscoPoP performs the following steps:
* detect parts of the code (computational units or CUs) with little to no internal parallelization potential,
* find data dependences among them,
* identify parallel patterns that can be used to parallelize a code region,
* and finally, suggest corresponding OpenMP parallelization constructs and clauses to programmers.

A more comprehensive overview of DiscoPoP can be found on our [project website](https://www.discopop.tu-darmstadt.de/).

## Where to start

| Page | Content |
|---|---|
| [Getting started](getting_started.md) | Install DiscoPoP and use the graphical user interface. Start here if you want to analyze your own project. |
| [Manual](manual.md) | The detailed reference: setup options, examples, every tool, the data DiscoPoP produces, and how to contribute. |

## Components

| Component | Purpose | Page |
|---|---|---|
| GUI and project manager (`discopop_gui`, `discopop_project_manager`) | Configure a project, run it, and drive all other tools from one window or the command line | [Graphical user interface](tools/GUI.md), [Project manager](tools/Project_manager.md) |
| Profiler (`discopop_cc`, `discopop_cxx`) | Instruments the program and records data dependences while it runs | [Compiler wrappers](tools/Instrumentation.md) |
| Explorer (`discopop_explorer`) | Detects parallel patterns in the profiling data and creates patches | [Explorer](tools/Explorer.md) |
| Patch tools | Create, apply and repair the OpenMP patches | [Patch generator](tools/Patch_generator.md), [Patch applicator](tools/Patch_applicator.md), [Patch repair](tools/Patch_repair.md) |
| Hotspot detection | Measures which code regions take the time | [Hotspot detection](tools/Hotspot_detection.md) |
| Empirical autotuner (`discopop_auto_tuner`) | Measures combinations of suggestions and selects the best one | [Empirical autotuner](tools/Autotuner.md) |
| MCP server (`discopop_mcp_server`) | Lets AI assistants run DiscoPoP | [MCP server](tools/MCP_server.md) |
| VS Code extension | An extension to the GUI for browsing suggestions and hotspots in the editor | [VS Code extension](setup/vscx.md) |

## Contact
In case any issues arise, please contact us via GitHub messages or by mail to [discopop-support@lists.parallel.informatik.tu-darmstadt.de](mailto:discopop-support@lists.parallel.informatik.tu-darmstadt.de).

## License
© DiscoPoP is available under the terms of the BSD-3-Clause license, as specified in the LICENSE file.
