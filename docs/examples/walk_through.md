---
layout: default
title: Walk-through example
parent: Examples
nav_order: 1
---

# Walk-through example
This example will show the complete process to generate a parallel code from the provided example code.

## Prerequisites
- DiscoPoP set up as described [here](../setup/discopop.md)
- Initial working directory is the source directory of DiscoPoP

## Step 1: Instrument and build the example code
In the first step, the instrumented version of the sequential code will be created.
In most cases it is sufficient to overwrite the default `C-` and `CXX-Compilers` and use the provided `wrapper scripts` in DiscoPoP's build directory instead.
```
cd ../example
mkdir build
cd build
cmake -DCMAKE_CXX_COMPILER=${DP_BUILD}/scripts/CXX_wrapper.sh .. 
make
```

The executed static analysis will create a folder named `.discopop`, which will be used to store all data generated and used by the framework.
For a detailed description of the gathered data, please refer to [data](../data/data.md).

## Step 2: Execute instrumented code
After a successful step 1, the instrumented sequential executable has been created an can be executed just like the original version.
```
./cmake_example
```

Executing the instrumented program will execute the DiscoPoP profiler and generate as well as store the identified data dependences for later analysis in the `.discopop/profiler` folder.

Note: The DiscoPoP profiler can introduce significant overhead to the program. For this reason it is worth to consider using small to very small input sizes, depending on the specific program. In general, this will not result in a significant degradation of the result quality, as long as the inputs and as a result the observed data dependences are representative for general executions of the program.


## Step 3: Identify parallel patterns
After gathering data dependency information in step 2 and general program structure information in step 1, parallel patterns can be identified by executing the [DiscoPoP Explorer](../tools/Explorer.md) from the `.discopop` folder.

```
cd .discopop
discopop_explorer
```

The execution will result in the creation of the folder `.discopop/explorer`, and most imporantly the creation of the pattern file `.discopop/explorer/patterns.json`, which describes the identified parallel patterns for use in later steps.

## create applicable patches from patterns
To create applicable patch files, execute the [Patch generator](../tools/Patch_generator.md) from `.discopop` as well.
```
discopop_patch_generator
```
This will result in the creation of a folder named `.discopop/patch_generator`, which contains patch files for individual `file-ids`, grouped by the `suggestion-id` of the parallel pattern suggestion the patch belongs to.

## print patches to the console
for f in $(find patch_generator -maxdepth 1 -type d); do
    echo "SUGGESTION: $f"
    cat $f/1.patch 
    echo ""
done
```
