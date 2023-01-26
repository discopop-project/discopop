---
layout: default
title: Reduction
parent: Patterns
grand_parent: Pattern Detection
---

# Reduction Loop

## Reporting
Reduction Loops are reported in the following format:
```
Reduction at: 1:2
Start line: 1:7
End line: 1:9
pragma: "// POTENTIAL REDUCTION: "
private: []
shared: []
first private: []
reduction: ['-:y']
last private: []
```

## Interpretation
The reported values shall be interpreted as follows:
* `Reduction at: <file_id>:<cu_id>`, where the respective parent file can be looked up in the `FileMapping.txt` using `file_id` and `cu_id` can be used for a look up in `Data.xml`
* `Start line: <file_id>:<line_num>`, where `line_num` refers to the source code line of the parallelizable loop.
* `End line: <file_id>:<line_num>`, where `line_num` refers to the last line of the parallelizable loop.
* `pragma:`since the `Reduction` pattern relies on `Do-All` or other patterns for a implementation suggestion, instead of a pragma, a simple comment to hint the user towards potential reduction operations and thus potential code improvements is added here.
* `private: [<vars>]` lists a set of variables which have been identified as thread-`private`
* The same interpretation applies to the following values aswell:
    * `shared`
    * `first_private`
    * `last_private`
* `reduction: [<operation>:<var>]` specifies a set of identified reduction operations and variables.

## Implementation
The implementation of a `Reduction` pattern relies on the usage within a different suggested pattern.
In case that a reduction shall be used in such a pattern, it will be marked via the inserted `reduction()` clauses.
In case that no potential parallelism and thus no other pattern is suggested which makes use of the identified reduction, the identified `Reduction` pattern is to be seen as a hint for potential code improvements and / or restructuring.

### Example
As an example, we will analyze the following code snippet for parallelization potential. All location and meta data will be ignored for the sake of simplicity.

    for (int i = 0; i < N; i++) {
        local_var *= global_array[i];
    }

Analyzing this code snippet results in the following parallelization suggestion, which will be presented via the `Do-All` pattern:
```
pragma: "#pragma omp parallel for"
private: ["i"]
shared: []
first private: ["global_array"]
reduction: ["*:local_var"]
last private: []
```

After interpreting and implementing the suggestion, the resulting, now parallel, source code could look as follows:

    #pragma omp parallel for private(i) firstprivate(global_array) reduction(*:local_var)
    for (int i = 0; i < N; i++) {
        local_var *= global_array[i];
    } 