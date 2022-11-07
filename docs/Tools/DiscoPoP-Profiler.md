---
layout: default
title: DiscoPoP Profiler
parent: Tool Overview
nav_order: 1
---


# DiscoPoP Profiler

*Call clang++ with DiscoPoP LLVM passes.*

The DiscoPoP profiler consists of multiple LLVM libraries (CUGeneration,
DPInstrumentation and DPReduction) to be passed to clang++ at compilation, as 
well as a runtime library for the instrumented code.

`discopop_profiler` wraps clang++ invocations to include the necessary compiler
and linker flags to make use of the DiscoPoP features. To use one of
the DiscoPoP passes, `discopop_profiler` is used *instead* of `clang++`, with
one of the option flags `--CUGeneration`, `--DPInstrumentation` or
`--DPReduction` to select the LLVM pass.

## Pre-requisites

`discopop_profiler` is included in the
[PyPI package `discopop`](https://pypi.org/project/discopop/). As such, it is
installed with

```
pip install discopop
```

It is required that the DiscoPoP profiler is installed (see 
[DiscoPoP profiler installation](../README.md#discopop-profiler-installation))
and the environment variable `DISCOPOP_INSTALL` is set to the path where
DiscoPoP is installed.

```
export DISCOPOP_INSTALL=<PATH_TO_DISCOPOP_BUILD_DIRECTORY>
``` 

## Usage

```
usage: discopop_profiler [--verbose] [--clang CLANG]
                         (--CUGeneration | --DPInstrumentation | --DPReduction)
                         <clang++ arguments>

Call clang++ with DiscoPoP LLVM passes.

optional arguments:
  -h, --help            Show this help message and exit.
  -V, --version         Show version number and exit.
  -v, --verbose         Show additional information such as clang++
                        invocations.
  --clang CLANG         Path to clang++ executable.
  --CUGeneration, --cugeneration
                        Obtain the computational unit (CU) graph of the target
                        application.
  --DPInstrumentation, --dpinstrumentation
                        Instrument the target application to obtain data
                        dependences.
  --DPReduction, --dpreduction
                        Instrument the target application to obtain the list
                        of reduction operations.
```

### CU generation

To obtain the computational unit (CU) graph of the target application, please 
run the following command.

```
discopop_profiler --CUGeneration -c <C_File>
```

### Dependence profiling

To obtain data dependences, we need to instrument the target application.
Running the instrumented application will result in a text file containing all
the dependences that are located in the present working directory.

```
discopop_profiler --DPInstrumentation -c <C_File> -o out.o
discopop_profiler --DPInstrumentation out.o -o <APP_NAME>
./<APP_NAME>
```

### Identifying reduction operations

To obtain the list of reduction operations in the target application, we need to
instrument the target application. Running the instrumented application will
result in a text file containing all the reductions that are located in the
present working directory.

```
discopop_profiler --DPReduction -c <C_File> -o out.o
discopop_profiler --DPReduction out.o -o <APP_NAME>
./<APP_NAME>
```

### Usage with projects that use the CMake build system

Since `discopop_profiler` is invoked like a regular compiler, it is easy to run
DiscoPoP instrumentation on projects that use a build system such as CMake.

1. Configure CMake to use `discopop_profiler` as `CMAKE_CXX_COMPILER`:
   ```
   cmake -DCMAKE_CXX_COMPILER="discopop_profiler" -DCMAKE_CXX_FLAGS="--DPInstrumentation" .
   ```
1. Build the project with DiscoPoP instrumentation applied on the code:
   ```
   make
   ```

## Troubleshooting

### clang++ executable not found in PATH

`discopop_profiler` expects to find `clang++-8` or `clang++` in your system's `PATH`.
If clang is installed elsewhere, either add the installation location to your
`PATH`, or set the location to the `clang++` binary to be invoked with

```
discopop_profiler --clang=<PATH_TO_CLANG++_EXECUTABLE> ...
```

### Compiler invocation

`discopop_profiler` prints the exact flags passed to `clang++` if the `--verbose`
flag is set.

```
discopop_profiler --verbose ...
```
