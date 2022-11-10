### Running DiscoPoP
DiscoPoP contains different tools for analyzing the target sequential application, namely CUGeneration, DPInstrumentation, and DPReduction. In the following, we will explain how to run each of them. However, before executing anything, please run the `dp-fmap` script in the root folder of the target application to obtain the list of files. The output will be written in a file named `FileMapping.txt`.

	<DISCOPOP_PATH>/scripts/dp-fmap

#### CU generation 
To obtain the computational unit (CU) graph of the target application, please run the following command.

	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File>

#### Dependence profiling
To obtain data dependences, we need to instrument the target application. Running the instrumented application will result in a text file containing all the dependences that are located in the present working directory.

	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.o
	clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
	./<APP_NAME>

#### Identifying reduction operations
To obtain the list of reduction operations in the target application, we need to instrument the target application. Running the instrumented application will result in a text file containing all the reductions that are located in the present working directory.

	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.o
	clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
	./<APP_NAME>
	
*NOTE:* Please use the exact compiler flags that we used. Otherwise, you might not get the correct results, or the analysis might fail.

DiscoPoP also provides a wrapper [discopop_profiler](Tools/DiscoPoP-Profiler.md) to
easily invoke clang with the DiscoPoP LLVM passes.
