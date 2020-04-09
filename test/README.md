# Walk-through example
The following walk-through example demonstrates how to use DiscoPoP to analyze a sample sequential application and identify its parallelization opportunities. In this example, we use `SimplePipeline` application. As its name suggests, this program involves a pipeline pattern. We assume that you have successfully installed DiscoPoP.

First, switch to `simple_pipeline` folder which contains `SimplePipeline.c` program. Then, please run the following commands step-by-step to obtain the desired results.

1) Run the `dp-fmap` script to obtain the list of files. The output will be written in a file named FileMapping.txt.

	`<DISCOPOP_PATH>/scripts/dp-fmap`

2) To obtain the computational unit (CU) graph, please run the following command.

	`clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c`

The output is an XML file, which contains all the CU nodes. You should be able to obtain a CU graph as in [`SimplePipelineData.xml`](/simple_pipeline/data/SimplePipelineData.xml).

3) To obtain data dependences, we need to instrument the application. Running the instrumented application will result in a text file containing all the dependences located in the present working directory.
```
	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c -o out.o
	clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
	./out
```
The output is a text file, which contains all the dependencies. You should be able to obtain a CU graph as in [`SimplePipelineDep.txt`](/simple_pipeline/data/SimplePipelineDep.txt).
A data dependence is represented as a triple `<sink, type, source>`. `type` is the dependence type (`RAW`, `WAR` or `WAW`). Note that a special type `INIT` represents the first write operation to a memory address. `source` and `sink` are the source code locations of the former and the latter memory accesses, respectively. `sink` is further represented as a pair.

4) Although there is no reduction pattern in the SimplePipeline application, we suggest that you run the reduction analysis to avoid missing any pattern. To obtain the list of reduction operations, we need to instrument the target application. Running the instrumented application will result in a text file containing all the reductions located in the present working directory.
```
	clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c -o out.o
	clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
	./out
```
5) To obtain the list of patterns and OpenMP parallelization suggestions, run the python script:

	`python3 main.py --path .`

You should now be able to see the list of patterns found in the target application.
