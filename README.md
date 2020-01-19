# DiscoPoP - Discovery of Potential Parallelism
DiscoPoP is an open source tool designed to suggest parallelizing programs. It identifies data dependences in a program, detects the basic blocks for the parallelization, finds parallel patterns which can be used to parallelize a code region, and finally suggests OpenMP constructs and clauses to programmers for the parallelization.

It is built on top of LLVM. Therefore, DiscoPoP can perform the above-mentioned steps on any source code which can be transferred into llvm IR.


## Getting started
### Pre-requisites
Before doing anything, you'll need a basic development setup. We have tested DiscoPoP on Unbuntu and following packages should be installed before installing the profiler:

	sudo apt-get install git build-essential cmake

Additionally, you need LLVM installed on your system. Currently, DiscoPoP supports LLVM 8.0 above. Lower versions are not supported, due to API changes which lead to compilation failure. Please follow the installation tutorial [here](https://llvm.org/docs/GettingStarted.html), if you have not installed LLVM before.

### DiscoPoP profiler installation
First, clone the source code into the designated folder. Then, create a build directory:

	mkdir build; cd build;

Next configure cmake. The preferred LLVM installation path for DiscoPoP can be set using the -DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER> cmake variable.

	cmake -DLLVM_DIST_PATH=<PATH_TO_LLVM_BUILD_FOLDER> ..

Once the configuration process is successfully finished, run `make` to compile the profiler to obtain the profiling libraries.


### Running DiscoPoP
DiscoPoP contains different tools for analyzing the target sequential application, namely CUGeneration, DPInstrumentation and CUInstantiation. In the following, we will explain how to run each of them. However, before the execution, run the `dp-fmap` script in the root folder of the target application to obtain the list of files. The output will be written in a file named `FileMapping.txt`.

	<DISCOPOP_PATH>/scripts/dp-fmap

Please use the exact compiler flags that we used. Otherwise, you might not get the correct results, or the analysis might fail.

#### CU Generation 
To obtain the computational units (CU) graph of the target application, please run the following command.

	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File>

#### DiscoPoP Profiling
To obtain data dependences, we need to instrument the target application: 

	clang -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPVariableNamePass.so -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.ll

(OPTIONAL) Use llvm-link to link multiple .ll files into one:

	llvm-link $out.ll other.ll -o out.ll

(OPTIONAL) You may run the DPInstrumentationOmission pass to omit non-essential instructions from profiling to improve performance:

	opt -S -load=<PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentationOmission.so -dp-instrumentation-omission -stats out.ll -o out.ll

Make the application executable:
	
	clang++ out.ll-L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread -o <APP_NAME>

 Running the application will result in a text file containing all the dependences located in the present working directory

	./<APP_NAME>


#### Pattern Detection
We will release the source code for pattern detection soon.

## License
© Contributors Licensed under an BSD-3-Clause license.
