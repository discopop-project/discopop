---
layout: default
title: Do-All Loop - TODO
parent: Patterns
grand_parent: Pattern Detection
---

# Do-All Loop

## Reporting
Do-All Loops are reported in the following format:
```
Do-all at: 1:2
Start line: 1:7
End line: 1:9
iterations: 1000
instructions: 0
workload: 0
pragma: "#pragma omp parallel for"
private: []
shared: []
first private: []
reduction: []
last private: []
```

## Interpretation
The reported values shall be interpreted as follows:
* `Do-all at: <file_id>:<cu_id>`, where the respective parent file can be looked up in the `FileMapping.txt` using `file_id` and `cu_id` can be used for a look up in `Data.xml`
* `Start line: <file_id>:<line_num>`, where `line_num` refers to the source code line of the parallelizable loop.
* `End line: <file_id>:<line_num>`, where `line_num` refers to the last line of the parallelizable loop.
* `iterations: <num>` specifies the counted amount of iterations the loop has executed during the profiling.
* `instructions: <num>` specifies the summed number of instructions executed within one iteration of the loop body
* `TODO: workload: <num>` provides an arbitrary value which represents the computational weight of one iteration of the loop. 
* `pragma:`shows which type of OpenMP pragma shall be inserted before the target loop in order to parallelize it.
* `private: [<vars>]` lists a set of variables which have been identified as thread-`private`
* The same interpretation applies to the following values aswell:
    * `shared`
    * `first_private`
    * `last_private`
* `reduction: [<operation>:<var>]` specifies a set of identified reduction  operations and variables. For pure `Do-All` suggestions, this list is empty. If it is not empty, the suggestion describes a [reduction loop](Reduction.md).

## Implementation
In order to implement a suggestion, first open the source code file corresponding to `file_id` and navigate to line `Start line -> <line_num>`.
Insert `pragma` before the loop begins.
In order to ensure a valid parallelization, you need to add the following clauses to the OpenMP pragma, if the respective lists are not empty:
* `private` -> clause: `private(<vars>)`
* `shared` -> clause: `shared(<vars>)`
* `first_private` -> clause: `firstprivate(<vars>)`
* `last_private` -> clause: `lastprivate(<vars>)`
* `reduction`-> clause: `reduction(<operation>:<vars>)`

### Example
As an example, we will analyze the following code snippet for parallelization potential. All location and meta data will be ignored for the sake of simplicity.

    for (int i = 0; i < N; i++) {
        local_var *= global_array[i];
    }

Analyzing this code snippet results in the following parallelization suggestion:
```
pragma: "#pragma omp parallel for"
private: ["i1"]
shared: []
first private: ["global_array"]
reduction: ["*:local_var"]
last private: []
```

After interpreting and implementing the suggestion, the resulting, now parallel, source code could look as follows:

    #pragma omp parallel for \
        private(i1) \
        firstprivate(global_array) \   
        reduction(*:local_var)
    for (int i = 0; i < N; i++) {
        local_var *= global_array[i];
    } 