# Hotspot-Detection

Hotspot-Detection is an open-source tool that helps software developers to detect hotspots in their programs. This allows to focus optimization efforts to where it really matters.

Code regions (loops and functions) are categorized into three classes (HOT, WARM, COLD) according to the following criteria:

A) the code region contributes a lot to the total runtime of the program. \
B) the runtime of the code region increases a lot when using different program parameters.

- HOT code regions fulfill both _(A and B)_
- WARM code regions fulfill only one _(A xor B)_
- COLD code regions fulfill neither  _(not(A or B))_


## Installation

Install the requirements:

```
sudo apt install git build-essential cmake libclang-11-dev clang-11 llvm-11 python3
```

Install the Hotspot-Detection:

```
git clone git@github.com:discopop-project/Hotspot-Detection.git
cd Hotspot-Detection
mkdir build
cd build
cmake ..
make
```


## Usage

The Hotspot-Detection is built on the llvm project and has two core components:
- The **llvm optimizer pass** modifies the program during compilation. With these modifications we automatically monitor how much time your program spends in any code region.
- A **python tool** analyzes the measured runtimes of the code regions and reports hotspots.

It is possible to manually use these components on (almost) any project. However we also provide a script that wraps the CMake build process to automatically apply the llvm optimizer pass for you. Simply perform the following steps to analyze any project that is built using CMake.

### 1) Build your project and apply the hotspot-detection instrumentation

```
cd <your_project_directory>
mkdir build
cd build
<HOTSPOT_DETECTION_BUILD>/scripts/CMAKE_wrapper.sh ..
make
```

Note that it is possible to add your own custom flags for the cmake build.

### 2) Run the instrumented program

Run your program multiple times with varying parameters.

```
./<your_program_name> <your_program arguments_1>
./<your_program_name> <your_program arguments_2>
./<your_program_name> <your_program arguments_3>
# ...
```

### 3) Analyze the results

Change your working directory so you are inside the `.discopop` directory. By default it is located inside the build directory.

```
hotspot_analyzer
```

You can now find the analysis results inside `.discopop/hotspot_detection`.

### Publication

1. Seyed Ali Mohammadi, Lukas Rothenberger, Gustavo de Morais, Bertin Nico Görlich, Erik Lille, Hendrik Rüthers, and Felix Wolf. 2023. Filtering and Ranking of Code Regions for Parallelization via Hotspot Detection and OpenMP Overhead Analysis. In Proceedings of the SC '23 Workshops of The International Conference on High Performance Computing, Network, Storage, and Analysis (SC-W '23). Association for Computing Machinery, New York, NY, USA, 1368–1379. https://doi.org/10.1145/3624062.3624206

### Citation

Please cite in your publications if it helps your research:

@inproceedings{10.1145/3624062.3624206,
	author = {Mohammadi, Seyed Ali and Rothenberger, Lukas and de Morais, Gustavo and G\"{o}rlich, Bertin Nico and Lille, Erik and R\"{u}thers, Hendrik and Wolf, Felix},
	title = {Filtering and Ranking of Code Regions for Parallelization via Hotspot Detection and OpenMP Overhead Analysis},
	year = {2023},
	isbn = {9798400707858},
	publisher = {Association for Computing Machinery},
	address = {New York, NY, USA},
	url = {https://doi.org/10.1145/3624062.3624206},
	doi = {10.1145/3624062.3624206},
	abstract = {Many high-performance computing applications reach millions of code lines and hundreds of code regions. Analyzing all code regions for parallelization with OpenMP is neither efficient nor necessary. To facilitate this task and minimize the effort by the user, the code regions of the application need to be filtered and ranked. We provide a simple filtering method to detect the critical code regions by clearly defining a hotspot. Afterward, we identify parallelizable loops by analyzing their data dependencies using an automatic tool. As the number of parallel opportunities can be high and the users must verify these parallel suggestions, we suggest a ranking strategy based on parallelization overhead to help them prioritize their endeavors and present a set of OpenMP microbenchmarks for overhead analysis. We calculate optimistic expected benefits using overhead estimations as ranking metrics and show how our ranking provides an improvement on the ranking based on serial runtime.},
	booktitle = {Proceedings of the SC '23 Workshops of The International Conference on High Performance Computing, Network, Storage, and Analysis},
	pages = {1368–1379},
	numpages = {12},
	keywords = {parallelization overhead, expected benefits, OpenMP microbenchmarks, Hotspot detection, ranking, performance analysis},
	location = {Denver, CO, USA},
	series = {SC-W '23}
}

