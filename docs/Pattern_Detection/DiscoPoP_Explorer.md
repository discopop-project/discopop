---
layout: default
title: DiscoPoP Explorer
parent: Pattern Detection
nav_order: 1
---

# DiscoPoP Explorer
The DiscoPoP Profiler is accompanied by a Python framework, specifically designed to analyze the profiler output files, generate a CU graph, detect potential parallel patterns, and suggest OpenMP parallelizations.
Currently, the following five patterns can be detected:
* [Reduction](Patterns/Reduction.md)
* [Do-All](Patterns/Do-All.md)
* [Pipeline](Patterns/Pipeline.md)
* [Geometric Decomposition](Patterns/Geometric_Decomposition.md)
* [Task Parallelism](Patterns/Tasks.md)

## Getting started
We assume that you have already executed the DiscoPoP profiler on the sequential target application, and the following files have been created in the current working directory:
* `Data.xml` (CU information in XML format)
* `<app_name>_dep.txt` (Data dependences)
* `reduction.txt` and `loop_counter_output.txt` (identified reduction operations and counted loop iterations)

In case any of the files mentioned above are missing, please follow the [profiler instructions](../Profiling/Profiling.md) to generate them.

### Task parallelism - TODO
Currently, the task parallelism detection is not supported, but it will be re-included in the near future.

<!--In addition to the already mentioned files, a file named `<app_name>_CUInstResult.txt` is required for the task parallelism detection.
In order to generate it, the following sequence of commands can be used:
```
python3 -m discopop_explorer --path=<path> --cu-xml=<cuxml> --dep-file=<depfile> --loop-counter=<loopcount> --reduction=<reduction> --generate-data-cu-inst=<outputdir>
clang++ -S -emit-llvm -c -std=c++11 -g <DISCOPOP_PATH>/CUInstantiation/RT/CUInstantiation_iFunctions.cpp -o iFunctions_CUInst.ll
clang++ -g -O0 -emit-llvm -fno-discard-value-names -c <C_File> -o tmp_target_app.ll
<CLANG_BIN_DIR>/opt -S -load=<PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMCUInstantiation.so -CUInstantiation -input=Data_CUInst.txt tmp_target_app.ll -fm-path=FileMapping.txt -o tmp_target_app_instrumented.ll
clang++ tmp_target_app_instrumented.ll iFunctions_CUInst.ll -o <app_name>_cui -L$PATH_TO_DISCOPOP_BUILD_DIR/rtlib -lDiscoPoP_RT -lpthread -o <app_name>_cui
rm tmp_target_app.ll tmp_target_app_instrumented.ll iFunctions_CUInst.ll
./<app_name>_cui
```
-->


### Pre-requisites
To use the DiscoPoP Explorer, you need to have Python 3.6+ installed on your system. Further Python dependencies should have been installed during the [manual setup](../Manual_Quickstart/Manual_Setup.md), but can be installed using the following command:
`pip install -r requirements.txt`

### Usage
If you followed the installation instructions in the [manual setup](../Manual_Quickstart/Manual_Setup.md), you can execute the DiscoPoP Explorer by simply calling the module:

`discopop_explorer --path <path-to-your-output>`

If you have not installed the modules using `pip`, you can execute them manually by specifying the `-m` flag.

`python3 -m discopop_explorer --path <path-to-your-output>`

By specifying the `--path` flag, you can set the path to the DiscoPoP Profiler [output files](../Profiling/Data_Details.md). Then, the Python script searches within this path to find the required files. Nevertheless, if you are interested in passing a specific location for each file, please refer to the available command line options. These can be show by specifying the `-h` or `--help` flags:

`discopop_explorer -h`

By default, running the DiscoPoP Explorer will print out the list of patterns along with OpenMP parallelization suggestions to the standard output. You can also obtain the results in JSON format by passing the `--json` argument to the Python script.

Detailed instructions on how to interpret the suggested patterns can be found on the pages of the respective [patterns](Patterns/Patterns.md).

A simple walk-through example for the execution of the DiscoPoP Explorer and the interpretation and implementation of the results can be found as part of our [manual quickstart example](../Manual_Quickstart/Manual_Example.md).