---
layout: default
title: Manual Instrumentation
parent: Tutorials
grand_parent: DiscoPoP Profiler
nav_order: 3
---

# DiscoPoP Profiler - Manual Instrumentation and Execution

The core of the DiscoPoP Profiler is the `DiscoPoP` optimizer pass.
In order to execute the profiling for an arbitrary target project, the following steps need to be performed:

* **Create a `FileMapping.txt` file:**<br/>
It serves as an overview of all files in the project and is required by the optimizer pass. <br/>
You can use the provided `dp-fmap` script for this. Simply run it from the directory containing your source code.

* **Compile the source code and run the DiscoPoP optimizer pass:**<br/>
The optimizer pass performs the static analysis and adds runtime instrumentation to the program. <br/>
Add the mandatory `-O0 -g -fno-discard-value-names` flags during compilation to get debug information like source code lines and variable names! Also add the `-S -emit-llvm` flags to get the readable LLVM-IR form.<br/>
Compiling and Optimizing can be done in one step or separately.

* **Linking**<br/>

* **Execute the created executable**<br/>
This will result in the creation of the data files described [here](../Data_Details.md).

* **Run the discopop_explorer:**<br/>
This will analyze the data files and provide parallelization suggestions.


Please refer to the [quickstart example](../../Quickstart/Example.md) to get an example of how the specific steps can be applied to a single file. The same approach will work for more complex projects.