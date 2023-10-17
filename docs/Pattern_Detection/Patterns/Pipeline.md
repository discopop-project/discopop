---
layout: default
title: Pipeline
parent: Patterns
grand_parent: Pattern Detection
---

# Pipeline

## Reporting

### Pipelines
Pipelines are reported in the following format:
```
Pipeline at: 1:11
Start line: 1:30
End line: 1:34
Stages:
    <stage_1>

    <stage_2>

    ...
```
The reported values shall be interpreted as follows:
* `Pipeline at: <file_id>:<cu_id>`, where the respective parent file can be looked up in the `FileMapping.txt` using `file_id` and `cu_id` can be used for a look up in `cus.xml`
* `Start line: <file_id>:<line_num>`, where `line_num` refers to the first source code line of the identified pipeline.
* `End line: <file_id>:<line_num>`, where `line_num` refers to the last line of the pipeline loop.
* `Stages` defines a list of stages contained in the identified pipeline. The specific format of the stages is described in the following.

### Pipeline Stages
Individual stages of a pipeline are reported in the following format:
```
Node: 1:13
Start line: 1:31
End line: 1:31
pragma: "#pragma omp task"
first private: ['i']
private: []
shared: ['d', 'in']
reduction: []
InDeps: []
OutDeps: ['a']
InOutDeps: []
```

The reported values shall be interpreted as follows:
* `Node: <file_id>:<cu_id>`, where the respective parent file can be looked up in the `FileMapping.txt` using `file_id` and `cu_id` can be used for a look up in `cus.xml`
* `Start line: <file_id>:<line_num>`, where `line_num` refers to the first source code line of the identified pipeline stage.
* `End line: <file_id>:<line_num>`, where `line_num` refers to the last line of the stage.
* `pragma:`shows which type of OpenMP pragma shall be inserted before the `start line`.
* `private: [<vars>]` lists a set of variables which have been identified as thread-`private`
* The same interpretation applies to the following values aswell:
    * `shared`
    * `first_private`
* `reduction: [<operation>:<var>]` specifies a set of identified reduction operations and variables.
* `InDeps: [<vars>]` specifies `in`-dependencies according to the [OpenMP depend clause](https://www.openmp.org/spec-html/5.0/openmpsu99.html).
* `OutDeps: [<vars>]` specifies `out`-dependencies according to the [OpenMP depend clause](https://www.openmp.org/spec-html/5.0/openmpsu99.html).
* `InOutDeps: [<vars>]` specifies `inout`-dependencies according to the [OpenMP depend clause](https://www.openmp.org/spec-html/5.0/openmpsu99.html).


## Implementation
In order to implement a suggested pipeline, first navigate to the source code location specified by `Pipeline at:`.
For each individual stage the following OpenMP pragmas and closes need to be added to the source code, if the respective lists are not empty:
* Insert `pragma` prior to the `start line` mentioned by the stage.
* If `private` is not empty, add the clause `private(<vars>)`, where vars are separated by commas to the pragma.
* Do the same for:
    * `shared` -> clause: `shared(<vars>)`
    * `first_private` -> clause: `firstprivate(<vars>)`
    * `reduction`-> clause: `reduction(<operation>:<vars>)`
    * `InDeps` -> clause: `depend(in:<vars>)`
    * `OutDeps` -> clause: `depend(out:<vars>)`
    * `InOutDeps` -> clause: `depend(inout:<vars>)`


### Example
As an example, we will analyze the following code snippet for parallelization potential. Some location and meta data will be ignored for the sake of simplicity.

    int i;
    int d=20,a=22, b=44,c=90;
    for (i=0; i<100; i++) {
        a = foo(i, d);
        b = bar(a, d);
        c = delta(b, d);
    }
    a = b;

Analyzing this code snippet results in the following parallelization suggestion:
```
Pipeline at:
Start line: 1:3
End line: 1:7
Stages:
Node: 1:13
	Start line: 1:4
	End line: 1:4
	pragma: "#pragma omp task"
	first private: ['i']
	private: []
	shared: ['d', 'in']
	reduction: []
	InDeps: []
	OutDeps: ['a']
	InOutDeps: []

	Start line: 1:5
	End line: 1:5
	pragma: "#pragma omp task"
	first private: []
	private: []
	shared: ['d', 'in']
	reduction: []
	InDeps: ['a']
	OutDeps: ['b']
	InOutDeps: []

	Start line: 1:6
	End line: 1:7
	pragma: "#pragma omp task"
	first private: []
	private: ['c']
	shared: ['d', 'in']
	reduction: []
	InDeps: ['b']
	OutDeps: []
	InOutDeps: []
```

After interpreting and implementing the suggestion, the resulting, now parallel, source code could look as follows:

    int i;
    int d=20,a=22, b=44,c=90;
    for (i=0; i<100; i++) {
        #pragma omp task firsprivate(i) shared(d, in) depend(out:a)
        a = foo(i, d);
        #pragma omp task shared(d, in) depend(in:a) depend(out:b)
        b = bar(a, d);
        #pragma omp task private(c) shared(d, in) depend(in: b)
        c = delta(b, d);
    }
    a = b;
