# DiscoPoP
DiscoPoP profiler

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
To obtain data dependences, we need to instrument the target application. Running the instrumented application will result in a text file containing all the dependences located in the present working directory.
	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.o
	clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
	./<APP_NAME>
