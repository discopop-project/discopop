---
layout: default
title: Geometric Decomposition
has_children: true
parent: Parallel patterns
grand_parent: Data
nav_order: 2
---


# Geometric Decomposition

## Reporting
Possible geometric decompositions are reported in the following format:
```
Geometric decomposition at: 1:9
Start line: 1:26
End line: 1:36
Do-All loops: ['1:11']
Reduction loops: []
	Number of tasks: 24
	Chunk limits: 1000
	pragma: for (i = 0; i < num-tasks; i++) #pragma omp task]
	private: []
	shared: []
	first private: ['i']
	reduction: []
	last private: []
```

## Interpretation
The reported values shall be interpreted as follows:
* `Geometric decomposition at: <file_id>:<cu_id>`, where the respective parent file can be looked up in the `FileMapping.txt` using `file_id` and `cu_id` can be used for a look up in `Data.xml`
* `Start line: <file_id>:<line_num>`, where `line_num` refers to the first source code line of the potential geometrically decomposable code.
* `End line: <file_id>:<line_num>`, where `line_num` refers to the last line of the suggested pattern.
* `Do-All loops: [<file_id>:<cu_id>]` specifies which [Do-all loops](Do-All.md) can be part of the geometric decomposition.
* `Reduction loops: [<file_id>:<ci_id>]` specifies which [Reduction loops](Reduction.md) can be part of the geometric decomposition.
* `Number of tasks: <int>` specifies the number of tasks which should or can be spawned in order to process the geometric decomposition.
* `Chunk limits: <int>` determine the size of a workload package (amount of iterations) for each individual spawned task.
* `private, shared, first_private` and `last_private` indicate variables which should be mentioned within the respective OpenMP data sharing clauses.
* `reduction: [<operation>:<var>]` specifies a set of identified reduction operations and variables.


## Implementation
In order to implement a geometric decomposition, first open the source code file corresponding to `file_id` and navigate to line `Start line -> <line_num>`.
Insert `pragma` before each of the loops mentioned in `Do-all loops` and `Reduction loops`. Make sure to replace `num-tasks` with the specified `Number of tasks`, or insert a respective variable into the source code.
Modify the loop conditions of the original source code in order to allow a geometric decomposition. Each task should be responsible for processing a chunk of the size `Chunk limits`.
In order to ensure a valid parallelization, you need to add the following clauses to the OpenMP pragma, if the respective lists are not empty:
* `private` -> clause: `private(<vars>)`
* `shared` -> clause: `shared(<vars>)`
* `first_private` -> clause: `firstprivate(<vars>)`
* `last_private` -> clause: `lastprivate(<vars>)`
* `reduction`-> clause: `reduction(<operation>:<vars>)`

### Example
As an example, we will analyze the following code snippet for parallelization potential. Some location and meta data will be ignored for the sake of simplicity.

    int main( void)
    {
        int i;
        int d=20,a=22, b=44,c=90;
        for (i=0; i<100; i++) {
            a = foo(i, d);
            b = bar(a, d);
            c = delta(b, d);
        }
        a = b;
        return 0;
    }

Analyzing this code snippet results in the following geometric decomposition suggestion:
```
Geometric decomposition at: 1:1
Start line: 1:2
End line: 1:12
Type: Geometric Decomposition Pattern
Do-All loops: ['1:3']  // line 5
Reduction loops: []
	Number of tasks: 10
	Chunk limits: 10
	pragma: for (i = 0; i < num-tasks; i++) #pragma omp task]
	private: []
	shared: []
	first private: ['i']
	reduction: []
	last private: []
```

After interpreting and implementing the suggestion, the resulting, now parallel, source code could look as follows.
Since `i` has been used in the original source code already, the inserted `pragma` uses `x` instead.
As a last modification, the loop conditions in the original source code need to be modified slightly in order to allow the decomposition.
For a simpler interpretation of the example we have added the `chunk_size` and `tid` variables.
Note: Since the geometric decomposition relies on the identification of the thread number, the outermost `for` loop should be located inside a `parallel region`. However, depending on the specific analyzed source code, a surrounding `parallel region` might already exist or a different location for the surrounding `parallel region` may be more beneficial.

    int main( void)
    {
        int i;
        int d=20,a=22, b=44,c=90;

        #pragma omp parallel
        #pragma omp single
        for (int x = 0; x < 10; x++ ) {
            #pragma omp task
            {
                int tid = omp_get_thread_num();
                int chunk_size = 10;     // value of Chunk limits

                for (i = tid*chunk_size; i < tid*chunk_size + chunk_size; i++) {
                    a = foo(i, d);
                    b = bar(a, d);
                    c = delta(b, d);
                }
            }
        }

        a = b;
        return 0;
    }
