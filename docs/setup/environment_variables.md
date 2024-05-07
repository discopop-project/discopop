---
layout: default
title: Environment variables
parent: Setup
nav_order: 1
---

# Environment variables
Environment variables can be used to control the instrumentation and profiling behavior of DiscoPoP.
An overview of the configurable environment variables and their effects can be found below.

## Instrumentation
The following environment variables take effect during the static analysis and instrumentation of the program (see [Example: Step 1](../examples/walk_through.md#step-1-instrument-and-build-the-example-code)).

- `DP_PROJECT_ROOT_DIR`: Specify the path to the root folder of the project to be analyzed. Only functions defined inside this folder will be instrumented. If no value is supplied, all functions including library functions will be instrumented. Default value: `/`. 


## Profiling
The following environment variables take effect during the profiling of the instrumented program (see [Example: Step 2](../examples/walk_through.md#step-2-execute-instrumented-code)).

