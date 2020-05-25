# Walk-through example
The following walk-through example demonstrates how to use DiscoPoP to analyze a sequential sample application and identify its parallelization opportunities. In this example, we use the program `SimplePipeline`. As its name suggests, this program involves a pipeline pattern. We assume that you have successfully installed DiscoPoP. The following diagram depicts the whole workflow of obtaining the parallelization suggestions.

[DPWorkflow]: img/DPWorkflow.svg "DiscoPoP workflow diagram"

First, switch to the `/test/simple_pipeline` folder which contains the program `SimplePipeline.c`. Then, please run the following commands step-by-step to obtain the desired results.

1) Run the `dp-fmap` script to obtain the list of files. The output will be written in a file named FileMapping.txt.

    `<DISCOPOP_PATH>/scripts/dp-fmap`

2) To obtain the computational unit (CU) graph, please run the following command.

    `clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c`

The output is an XML file, which contains all the CU nodes. You should be able to obtain an XML file as in [`SimplePipelineData.xml`](simple_pipeline/data/SimplePipelineData.xml). Using the information in this file, we can generate a CU Graph.

3) To obtain data dependences, we need to instrument the application and run it. 
```
    clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c -o out.o
    clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
    ./out
```
The output is a text file that contains all the dependences. You should be able to obtain a CU graph as in [`SimplePipelineDep.txt`](simple_pipeline/data/SimplePipelineDep.txt).
A data dependence is represented as a triple `<sink, type, source>`. `type` is the dependence type (`RAW`, `WAR` or `WAW`). Note that a special type `INIT` represents the first write operation to a memory address. `source` and `sink` are the source code locations of the former and the latter memory access, respectively. `sink` is further represented as a pair `<fileID:lineID>`, while source is represented as a triple `<fileID:lineID|variableName>`. The keyword `NOM` (short for "NORMAL") indicates that the source line specified by aggregated `sink` has no control-flow information. Otherwise, `BGN` and `END` represent the entry and exit points of a control region, respectively.

4) Although there is no reduction pattern in SimplePipeline, we strongly suggest that you run the reduction analysis to avoid missing any pattern and obtain necessary loop information. This pass instruments the target application and analyzes its loops to identify their iteration counts and obtain the list of potential reduction operations. Running the instrumented application will result in a text file containing all the reductions located in the working directory.
```
    clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_DIR>/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c SimplePipeline.c -o out.o
    clang++ out.o -L<PATH_TO_DISCOPOP_BUILD_DIR>/rtlib -lDiscoPoP_RT -lpthread
    ./out
```
Besides the list of reduction loops, this step generates two important files named `loop_counter_output.txt` and `loop_meta.txt`. These files along with CU graph and dependences are required for the pattern analysis in the next step.

5) To obtain the list of patterns and OpenMP parallelization suggestions, run the Python script in the `/graph_analyzer` directory:

    `python3 graph_analyzer.py --cu-xml=SimplePipelineData.xml --dep-file=SimplePipelineDep.txt`

You should now be able to see the pipeline pattern found in the target application along with its stages plus suitable OpenMP constructs for parallelization. You can access a sample output in [patterns.txt](simple_pipeline/data/patterns.txt). Using these hints you can start parallelizing the target application.
