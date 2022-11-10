---
layout: default
title: Tutorial - INVALID
parent: Old Documentation
---

# Tutorial

In this example, we demonstrate how to use DiscoPoP to extract data dependencies, computational units, parallel patterns, and finally the parallelization suggestions. 

## Setting environment variables

This document assumes that you have already installed llvm, clang, and DiscoPoP. Please set the following environment variables to make the commands simpler.

```
CLANG
CLANG++
DISCOPOP_BUILD
src_file
```

This code sample contains two functions: initialize and compute. In function “initialize”, there are two loops which initialize the arrays (i.e., v and a). 

## Assigning IDs to different files in the program

DiscoPoP can analyze projects containing multiple files scattered in different directories. We have developed a script (i.e., `dp-fmap`) that assigns a unique ID to each file in the project. You can find the script in the scripts directory under the DiscoPoP root directory. Currently, we support the following file types:

```
c|cc|cpp|h|hpp
```

However, it might be the case that you have c/c++ files which have a different file extension (e.g., “.C”). In this case, you can add the desired extension by changing the content of the `dp-fmap` file.

Running `dp-fmap` in the tutorial directory, a `FileMapping.txt` file with the following content is generated:

```
1    /$DiscoPoP_root/test/tutorial/src-parallel-cpu/tutorial.c
```

## Extracting Computational Units (CUs)

To analyze a program with DiscoPoP, we first need to extract its computational units. This is a static process and we get the CUs by running Command 1 on each source code listed in the `FileMapping.txt` file:

```sh
$CLANG -g -O0 -S -emit-llvm -fno-discard-value-names \
    -Xclang -load -Xclang ${DISCOPOP_BUILD}/libi/LLVMCUGeneration.so \
    -mllvm -fm-path -mllvm ./FileMapping.txt \
    -c -I $include_dir -o ${src_file}.ll $src_file
```
*(Command 1: Extracting computational units of a single file)*

Here is a brief description about the flags that we pass to the compiler:

- `-g`: enables obtaining debug information from the source code, e.g., the line numbers.
- `-O0`: makes sure that we analyze the whole source code. 
- `-S -emit-llvm`: outputs the LLVM IR version of the input file. This option might be interesting especially with the instrumentation libraries which we discuss in the next section.
- `-fno-discard-value-names`: keeps names (e.g., variables, functions) as they are in the source code
- `-Xclang -load -Xclang`: commands the clang compiler to use the pass which succeeds the flag
- `-mllvm -fm-path -mllvm`: instructs the clang compiler to receive the FileMapping in the path which is specified after the flag in the command line
- `-c`: compiles a single input file. We need it because DiscoPoP analyzes files in the program one by one.
- `-I`: we need this flag if we need to include any libraries
- `-o`: You may need this flag if you are interested to save the output file.

When you run Command 1, some files will be generated including:

- `Data.xml`: It contains the computational units in the specified input file (i.e., $src_file).
- `DP_CUIDCounter.txt`: It contains the ID of the last CU in the input file. When analyzing the next file in the program, DiscoPoP reads this file to assign IDs starting from the number saved in this file. 

The xml file contains many information about the program. There are four types of nodes in the xml file including: functions, loops, CUs, and dummies. Each node has an ID, a type, a name (some nodes have empty names), the start and end line of the node in the source code.

Function nodes which are represented by type 1 contain information about functions in each file of the source code. Function nodes contain children nodes which can be CUs, loop nodes, and dummies. Also, you can find the list of function arguments there.

Nodes with type 0 are CUs. They follow a read-after-write pattern. They are the atoms of parallelization; meaning that we do not look inside a CU for parallelization opportunities. The information that we report for CUs are the following:
 
- `BasicBlockID`: The ID of the basic block that the CU happens in. A basic block is a block of code with single entry and exit points. A basic block may contain multiple CUs but a CU may not span over multiple basic blocks.
- `readDataSize`: number of bytes which is read in this CU. We consider LLVM-IR load instructions to compute this value.
- `writeDataSize`: Number of bytes written in this CU. It is computed like `readDataSize`.
- `instructionsCount`: Number of LLVM-IR instructions in the CU.
- `instructionLines`: The line numbers in which the CU appears.
- `readPhaseLines`: LLVM-IR load instructions which happen within the CU boundaries.
- `writePhaseLines`: LLVM-IR store instructions in the CU.
- `returnInstructions`: It indicates the line number of return instructions if the CU contains return instructions.
- `Successors`: The succeeding CU when analyzing the source code top-down in the source code.
- `localVariables`: the variables which appear within the CU. We also report the line number where the variable is defined, its name and its type.
- `globalVariables`: variables which break the read-after-write rule for the CU. They cause the creation of a new CU which will succeed the CU.
- `callsNode`: It indicates the line number of a called function if the CU contains a call instruction.

Loop nodes have type 2. They contain children nodes which can be CUs, other loops, or dummy nodes.

Dummy nodes are usually library functions whose source code is not available. We cannot profile them and thus do not provide parallelization suggestions for them. 

Please note that DiscoPoP appends CUs to an existing `Data.xml` file and thus if you need to extract computational units of the program again, you need to remove the existing `Data.xml` file. You also need to remove the `DP_CUIDCounter.txt` file to generate CUs starting from 0.

## Identifying data dependencies 

DiscoPoP uses a signature to store data dependences. You can configure the settings of this signature by creating a dp.conf file in the root directory of your program. The contents of the config file usually contains the following parameters:

- `DP_DEBUG`: If `DP_DEBUG` is set to one, DiscoPoP prints out debug information.
- `SIG_ELEM_BIT`: Size of each element in the signature in bits. 
- `SIG_NUM_ELEM`: Size of the signature. The bigger it is, the less false positives/negatives are reported.
- `SIG_NUM_HASH`: Number of signatures. A value of two indicates that one signature is used for read accesses and one signature for write accesses.
- `USE_PERFECT`: When it is set to one, DiscoPoP uses a perfect signature. The default value is one.

To find parallelization opportunities, we need to extract data dependencies inside the program. For that, we need to instrument the memory accesses, link the program with DiscoPoP run-time libraries, and finally execute the program with several representative inputs. For the instrumentation, you need to apply Command 2 to each file of the program. However, you can also apply Command 2 to specific files if you are interested to find parallelization opportunities in those files and you are sure that there are no (data or control) dependencies with the uninstrumented files. We always recommend profiling all the files in a program to find all the available parallelization opportunities. 

```sh
$CLANG -g -O0 -S -emit-llvm -fno-discard-value-names \
    -Xclang -load -Xclang ${DISCOPOP_BUILD}/libi/LLVMDPInstrumentation.so \
    -mllvm -fm-path -mllvm ./FileMapping.txt \
    -I $include_dir -o${src_file}_dp.ll $src_file
```
*(Command 2: Instrumenting memory access instructions in a input file)*

To link the instrumented program with DiscoPoP libraries, you need to execute Command 3:

```sh
$CLANG++ ${src_file}_dp.ll  -o dp_run -L${DISCOPOP_BUILD}/rtlib -lDiscoPoP_RT -lpthread
```
*(Command 3: Linking instrumented code with DiscoPoP runtime libraries)*

When you have instrumented and linked the program with DiscoPoP runtime libraries, you need to execute it with several representative inputs. We need this constraint to make sure that we minimize the chance of missing data dependences in code sections which might not be covered with a specific input. We explain how to find out which parts of the program were not executed with the given input in Section 5.

To execute the program, we use Command 4.

```sh
./dp_run
```
*(Command 4: Executing the program to obtain data dependences)*

After executing the program, you find a text file which ends with “{ExecutableName}_dep.txt” which contains the data dependences identified with the provided input. For this example, the ExecutableName is dp_run and thus the dependence file is dp_run_dep.txt

## Finding reductions in loops

Some loops may have inter-iteration dependencies that can be resolved using the OpenMP reduction clause. To identify such data dependences, we need to instrument the loops. DiscoPoP automatically detects these loops. We use Command 5 for the instrumentation. 

```sh
$CLANG -g -O0 -S -emit-llvm -fno-discard-value-names \
    -Xclang -load -Xclang ${DISCOPOP_BUILD}/libi/LLVMDPReduction.so \
    -mllvm -fm-path -mllvm ./FileMapping.txt \
    -I $include_dir -o ${src_file}_red.bc $src_file
```
*(Command 5: Instrumenting loops with the LLVM pass which detects reduction pattern )*

Then, we need to link the files to generate the executable. Command 6 performs this.

```sh
$CLANG $bin_dir/${src_file}_red.bc -o dp_run_red -L${DISCOPOP_BUILD}/rtlib -lDiscoPoP_RT -lpthread
```
*(Command 6: Linking the instrumented loops with DiscoPoP runtime libraries for the reduction detection)*

Finally, we should execute the program to obtain the reduction opportunities. Command 7 executes our test program.

```sh
./dp_run_red
```
*(Command 7: executing the program which is instrumented to detect reduction pattern)*

After execution, you will find a file named `reduction.txt` in your root directory. This file contains information about the loops which contain reduction operation.

Please note that the overhead for reduction detection is less than that of profiling the whole program because we merely profile specific loops in the program.

## Detecting parallel patterns and parallelization suggestions

To find the patterns and the parallelization suggestions, you need to call the discopop python module with the appropriate input, i.e., `Data.xml`, `dp_run_dep.txt`, and `reduction.txt` file.

Figure 1 demonstrates a simplified view of the computational units and the relevant data dependencies in the loops of function “initialize” in our test program. Based on the information, the pattern detector component identifies that the loops in the function are doall loops. Further, the pattern implementor suggests to wrap the loops with OpenMP parallel for constructs and the related data sharing clauses. Figure 1 also contains the parallelization suggestions. 

![A simplified view of the CUs, data dependences, parallel patterns and parallelization suggestions which are identified in function “initialize” of our test program.](img/init1.svg)
*(Figure 1: A simplified view of the CUs, data dependences, parallel patterns and parallelization suggestions which are identified in function “initialize” of our test program. )*

Moreover, Figure 2 shows the analysis information for function compute in the test program. Unlike the function “initialize”, there is an inter-iteration dependence which can be resolved with the OpenMP reduction clause.  

![A simplified view of the CUs, data dependences, parallel patterns and parallelization suggestions which are identified in function “compute” of our test program.](/img/reduction1.svg)
*(Figure 2:  A simplified view of the CUs, data dependences, parallel patterns and parallelization suggestions which are identified in function “compute” of our test program. )*

Please note that like many scientific applications which work on arrays or matrices, the suggestions do not change if we change the input size. Thus, it is possible to analyze the program with small inputs, obtain the parallelization suggestions and execute the parallelized version with larger inputs. However, this is a recommendation merely and it being applicable or not depends highly on the code.

Furthermore, we need to mention that DiscoPoP has an optimistic approach towards parallelization and thus programmers require to validate the final suggestions. Considering the example above, it can be easily confirmed by looking at the loops that there are no inter-iteration dependences.

## Running serial and parallel codes

You can execute the codes by inserting the parallelization suggestions into the source code. You need to compile the parallelized program with `-fopenmp`. The speedup which is gained by parallelizing the code highly depends on the hardware platform on which you execute the serial and parallel codes.  

## Common errors

| Common errors | Solution |
| - | -|
| ModuleNotFoundError: No module named | Install the required python dependencies |
| DiscoPoP finished the analysis fine but it does not provide any suggestions | Delete the FileMapping file and regenerate it |
| node IDs in the `Data.xml` file start with 0 (e.g., id=”0:1”) | FileMapping is not generated fine. Remove it and regenerate it. |
| -g: command not found | Path to clang is not set |
| /libi/LLVMCUGeneration.so: cannot open shared object file: | Path to DiscoPoP build directory is not set correctly |
