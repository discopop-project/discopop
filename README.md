# cu-graph-analyzer
Pattern detection and CU graph analysis. CU-graph-analyzer  is an open source tool designed to detect potential parallelism in programs and suggest parallelization pattern.

Currently five patterns are supported:
* Pipeline
* Do-All
* Reduction
* Geometric Decomposition
* Task Parallelism.

## Getting started
### requirements
CU-graph-analyzer uses the output provided by DiscoPoP. In order to run pattern discovery you need at least cu-xml and dependencies-txt output of DiscoPoP. Follow DiscoPoP manual to generate them for your code.

Some pattern requirere additional data, that can be generated using reduction.sh script. It will generate loop_counter_output.txt and reduction.txt, which are required for Geometric Decomposition, Task Parallelism and Reduction.

CU-graph-analyzer uses python3.6

you also need to install necessary requirements ´pip install -r requirements.txt´

### Usage
To run parallelism detection you need to run ´python3 main.py´

You can specify additinoal parameters
