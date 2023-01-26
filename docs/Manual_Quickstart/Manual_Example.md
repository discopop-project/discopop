---
layout: default
title: Manual Example
parent: Manual Quickstart
nav_order: 3
---

# Manual Quickstart Example

## Prerequisites
We assume that you have finished the [manual setup](Manual_Setup.md) already.
In order to follow the example, please make sure you know the paths to the following executables, files and folders. 
Occurrences of names in capital letters (e.g. `DP_SOURCE`) should be replaced by the respective (absolute) paths.

- From installation of prerequisites:
    - `clang` / `clang++`
- From DiscoPoP Profiler installation:
    - `DP_SOURCE`: Path to the DiscoPoP source folder
    - `DP_BUILD`: Path to the DiscoPoP build folder

## Important Note
For the sake of simplicity, this example only shows the process to profile a single file manually.
In case you want to analyse a more complex project, please refer to the respective tutorial pages for detailed instructions regarding the [manual profiling](../Tutorials/Manual.md), the assisted profiling using the [Execution Wizard script](../Tutorials/Execution_Wizard.md) or the assisted profiling via the [graphical Configuration Wizard](../Tutorials/Configuration_Wizard.md).


<!--
    - Setup (install packages + Python dependencies + CMake build)
    - Apply DiscoPoP to the provided example code
    - Display and interpret suggestions (Not in detail. Link to a Wiki page which describes the suggestions instead)
    - Implement suggestion (in a provided, parallelized copy of the source code)
    - Compile sequential and parallel version of the code
    - Execute sequential and parallel version of the code and compare execution times (example should result in a significant difference)
-->

## Step 0: Enter the Example Directory
As a first step, please change your working directory to the `DP_SOURCE/example` directory:

    cd DP_SOURCE/example

## Step 1: Profiling

### Step 1.1: Create File Mapping
DiscoPoP requires an overview of the files in the target project (`FileMapping.txt`). This file can be created by simply executing the `dp-fmap` script located in the `DP_BUILD/scripts` folder:

    DP_BUILD/scripts/dp-fmap

### Step 1.2: Compile the Target
To prepare the following instrumentation and profiling steps, we first have to compile the target source code to LLVM-IR.

    clang++ -g -c -O0 -S -emit-llvm -fno-discard-value-names example.cpp -o example.ll

The additional specified flags ensure the addition of debug information into `example.ll`, which is required for the later analyses steps.

### Step 1.3: Instrumentation and Static Analysis
After creating the LLVM-IR representation of our target source code, the `DiscoPoP` optimizer pass is loaded and executed.

    opt-11 -S -load=DP_BUILD/libi/LLVMDiscoPoP.so --DiscoPoP example.ll -o example_dp.ll --fm-path FileMapping.txt

In this process, the static analyses are executed and the instrumented version of `example.ll`, named `example_dp.ll` is created in order to prepare the dynamic profiling step.

### Step 1.4: Linking
In order to execute the profiled version of the target source code, we have to link it into an executable, in this case named `out_prof`.
Specifically, we have to link the DiscoPoP Runtime libraries in order to allow the profiling.

    clang++ example_dp.ll -o out_prof -LDP_BUILD/rtlib -lDiscoPoP_RT -lpthread

### Step 1.5: 
To execute the profiling and finish the collection of the required data, the created executable `out_prof` needs to be executed.

    ./out_prof

As a major result of the profiling, a file named `out_prof_dep.txt` will be created which contains information on the identified data dependencies.
Further details regarding the gathered data can be found [here](../Profiling/Data_Details.md).


## Step 2: Creating Parallelization Suggestions
In order to generate parallelization suggestions from the [gathered data](../Profiling/Data_Details.md), the [DiscoPoP Explorer](../Pattern_Detection/DiscoPoP_Explorer.md) has to be executed. Since all gathered data is stored in the current working directory and no files have been renamed, it is sufficient to specify the `--path` and the `--dep-file` arguments in order to generate the parallelization suggestions.
`--dep-file` has to be specified since it's name depends on the name of the original executable.

    discopop_explorer --path=. --dep-file=out_prof_dep.txt

By default, the DiscoPoP Explorer outputs parallelization suggestions to the console.
It should show four different suggestions in total.
* Two `Do-all` suggestions, 
* one `Reduction` suggestion,
* and one `Geometric Decomposition`.

## Step 3: Interpreting and Implementing the Suggestions
For detailed information on how to interpret and implement the created suggestions, please refer to the [pattern wiki](../Pattern_Detection/Patterns/Patterns.md).

Looking at the created suggestions there are two ways that the code can be parallelized (the parallelized code can be found inside the example directory as `solution1.cpp` and `solution2.cpp`):

* **Implementing the Do-All and Reduction Patterns**<br/> 
To implement the suggested `Do-All` patterns, all we have to do is to add the suggested pragma before each loop. One of the suggestions should contain a suggested `reduction` clause. Make sure to add the `reduction` clause when implementing this `Do-All` pattern! The suggested `Reduction` pattern does not provide a pragma to be inserted, as it relies on the previously mentioned `Do-All` and is only suggested as a possible hint towards the user. In addition, the DiscoPoP Explorer also suggests classifications for used variables to ensure correctness and improve performance. These should be added as clauses to the pragma. Note that OpenMP implicitly makes some variables like the loop index a private variable so we can omit the corresponding clauses.
  - To implement the first `Do-All` suggestion we add the following line before the corresponding loop.
      
        #pragma omp parallel for shared(Arr,N)

  - To implement the second `Do-All` suggestion, which contains the `Reduction`, we add the following line before the corresponding loop.

        #pragma omp parallel for reduction(+:sum) shared(Arr,N)

  - For this specific example, when we implement both patterns it is better to open only one parallel region with `#pragma omp parallel` and use the `pragma omp for` before each loop:

        #pragma omp parallel  shared(Arr,N)
        {
            #pragma omp for
            for(...) {...} // first loop
            #pragma omp for reduction(+:sum)
            for(...) {...} // second loop
        }

* **Implementing the geometric decomposition**<br/> The Geometric Decomposition Pattern requires some code rewriting. A more in-depth example with explanation of the Geometric Decomposition Pattern interpretation can be found in the [pattern wiki](../Pattern_Detection/Patterns/Patterns.md).
A possible solution is provided in `solution2.cpp` in the example directory.

Please note that it is not possible to implement both the Geometric Decomposition together with one of the other suggestions at the same time.

## Step 4: Compile the parallelized application
After changing the source recompile the edited source code with the `-fopenmp` flag to enable openMP.
We provide example solutions on how to parallelize the patterns in the files `solution1.cpp` and `solution2.cpp`. You can compile them using:
    
    clang++ solution1.cpp -fopenmp -o solution1
    clang++ solution2.cpp -fopenmp -o solution2

## Final Remarks

- When using openMP library functions (like `omp_get_thread_num()` in the Geometric Decomposition) make sure to include the `omp.h` header.
- Make sure to check the correctness of each suggestion! The approach of DiscoPoP can find a lot more opportunities than most tools that use only regular static analysis. However there is the possibility of false positives. These advantages and disadvantages are due to the fact that data dependencies are recorded during an instrumented run of the application. Usually the data dependencies do not change much if a representative input is selected during the instrumentation but it depends on the application!
- DiscoPoP analyzes data dependencies, not expected speedup. This means that some suggestions - especially for small problem sizes - are in fact likely to cause a slowdown due to the overhead of parallelization.
