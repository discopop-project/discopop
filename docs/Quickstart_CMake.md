---
layout: default
title: Quickstart - CMake
nav_order: 2
---

# Quickstart - CMake based projects
The following Instructions are intended to aid in profiling and analyzing CMake based projects.

## Prerequisites
Please refer to the [setup instructions](Manual_Quickstart/Manual_Setup.md) for guidance regarding the installation and environment setup.
During the profiling and pattern analysis, a clear identification of individual source files is required.
For this, all scripts require a [FileMapping](Profiling/File_Mapping.md) as an input. Please make sure this file exists.
In the following, `<FILE_MAPPING>` will represent the path to this file.

## Profiling
DiscoPoP provides wrapper scripts for `CMake, clang, clang++` and `clang for linking`.
<br>
A detailed description of the individual scripts can be found [here](Profiling/Wrapper_Scripts.md).
<br>
The following instructions are based on the provided example, which can be found in the `example` folder.
To follow the example, please set the current working directory to `discopop/example`.
<br><br>
When all prerequisites are met, instrumenting a CMake based project with DiscoPoP is possible by simply using the
provided `CMake_wrapper.sh`, located in `build/scripts`, instead of the standard `cmake` command during the build, and specifying the `DP_FM_PATH` environment variable for use during the `make` process.

```
# create Filemapping
<DP_BUILD_DIR>/scripts/dp-fmap

mkdir build
cd build

# cmake build
<DP_BUILD_DIR>/scripts/CMAKE_wrapper.sh ..

# make phase. Important: specify environment variable
DP_FM_PATH=<FILE_MAPPING> make
```

After execution of `make`, the static analysis of your project as well as the instrumentation of the code should be finished and the build should result in the executable (e.g. `cmake_example`) just as expected.
To obtain the dynamic data dependencies, please execute the executable. Due to expected runtime overhead, choose small to very small but representative input sizes if possible.

In case of the example:
```
./cmake_example
```

After the execution has finished, all necessary files are available and the [DiscoPoP Explorer](Pattern_Detection/DiscoPoP_Explorer.md) can be invoked to identify suggestions for parallelization.
A detailed overview of the gathered data can be found [here](Profiling/Data_Details.md).

## Pattern detection

```
discopop_explorer --dep-file=cmake_example_dep.txt --fmap=../FileMapping.txt --json=patterns.json
```

The identified patterns are stored in `patterns.json` as well as `detection_result_dump.json`, in the latter case together with the created PET graph for later use.
Please refer to [this site](Pattern_Detection) for detailed explanations how to interpret the results.

An executable version of this introduction can be found in `example/execute_cmake_example.sh`.
