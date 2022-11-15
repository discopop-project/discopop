---
layout: default
title: Manual Instrumentation
parent: Tutorials
grand_parent: DiscoPoP Profiler
nav_order: 3
---

# DiscoPoP Profiler - Manual Instrumentation and Execution

The core of the DiscoPoP Profiler is the `DiscoPoP` optimizer pass.
In order to execute the profiling for an arbitrary target project, first create a `FileMapping.txt` file, which serves as an overview of all files in the project and is required by the optimizer pass.
The optimizer pass then just needs to be loaded during optimization in order to perform the static analysis and create the instrumented source code.
Afterwards compile and link the instrumented source code.
Executing the created executable will result in the creation of the data files described [here](../Data_Details.md).
For a more detailed explanation of the individual steps required to execute the profiling, please refer to the [quickstart example](../../Quickstart/Example.md).