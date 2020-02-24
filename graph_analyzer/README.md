# Graph Analyzer
Pattern detection and CU graph analysis. The graph-analyzer is an open source tool designed to detect potential parallelism in programs and suggest parallelization pattern.

Currently five patterns are supported:
* Reduction
* Do-All
* Pipeline
* Geometric Decomposition
* Task Parallelism

## Getting started
### Requirements
graph_analyzer uses python3.6

you need to install necessary requirements

`pip install -r requirements.txt`

For graph representation we use graph-tool https://graph-tool.skewed.de/
You can compile it from sources or install from a repository

CU-graph-analyzer uses the output provided by DiscoPoP. In order to run pattern discovery you need at least **CU** and **dependencies output** from DiscoPoP. Follow DiscoPoP manual to generate necessary files for your code.

Some pattern require additional data, that can be generated using reduction pass. It will generate **loop counter** and **reduction**, which are required for Geometric Decomposition, Task Parallelism and Reduction.

Here is input overview using default names:
* Data.xml - CU nodes
* dep.txt - data dependencies
* loop_counter_output.txt - loop iteration data
* reduction.txt - reduction variables


### Usage
First generate input files like this
```
DP_PATH="<path to discopop build>"

echo "===FILE MAPPING==="
$DP_PATH"/scripts/dp-fmap"

echo "===GENERATE CU==="
clang++-8 -g -O0 -fno-discard-value-names -Xclang -load -Xclang $DP_PATH/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c $1 -o out.o
echo "===GENERATE DEPENDENCIES==="
clang++-8 -g -O0 -fno-discard-value-names -Xclang -load -Xclang $DP_PATH/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c $1 -o out.o
clang++-8 out.o -L $DP_PATH/rtlib/ -lDiscoPoP_RT -lpthread
./a.out
echo "===REDUCTION PASS==="
clang++-8 -g -O0 -fno-discard-value-names -Xclang -load -Xclang $DP_PATH/libi/LLVMDPReduction.so -mllvm -fmap -mllvm ./FileMapping.txt -c $1 -o out.o
clang++-8 out.o -L $DP_PATH/rtlib/ -lDiscoPoP_RT -lpthread
./a.out
```

To run parallelism detection you need to run 

`python3 main.py --path <path-to-your-output>`

You can specify specific path for each file, by default the analyser will search in directory provided as path

    `main.py [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] [--loop-counter <loopcount>] [--reduction <reduction>] [--json <json>]`

Options:
```
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml].
    --dep-file=<depfile>        Dependencies text file [default: dep.txt].
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt].
    --reduction=<reduction>     Reduction variables file [default: reduction.txt].
    --plugins=<plugs>           Plugins to execute
    --json                      Output result as a json file to spicified path
    -h --help                   Show this screen.
    --version                   Show version.
```

The **example/** folder contains some precomputed inputs for testing e.g. atax from polybench.