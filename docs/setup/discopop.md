---
layout: default
title: DiscoPoP
parent: Setup
nav_order: 1
---

# DiscoPoP Setup
## Prerequisites
- LLVM/clang version 11
- Python version 3.6 or greater

## Setup
```
git clone git@github.com:discopop-project/discopop.git
cd discopop
mkdir build
```

## Build libraries and install Python modules
```
cd build
cmake .. <CMAKE_FLAGS>
make
cd ..
```

where `<CMAKE_FLAGS>` can consist of any combination of the following flags and commonly used CMAKE_FLAGS:
#### Environment configuration
- `-DUSE_LLVM_VERSION=<version>` &ndash; Use a specific Version of LLVM
- `-DLLVM_DIST_PATH=<llvm_base_dir>` &ndash; Use a specific LLVM installation by specifiying the location
#### Profiling configuration
- `-DDP_PTHREAD_COMPATIBILITY_MODE=[0|1]` &ndash; If your application uses PThreads, please specify this flag to serialize the calls to the DiscoPoP runtime functions. Note, however, that this can negatively influence the runtime of the profiling.
- `-DDP_NUM_WORKERS=<int>` &ndash; Specify the number of worker threads available for the dependency analysis during profiling. Default: `3` worker threads. `0` can be used to disable the creation of additional threads for the analysis.
#### Development and debugging
- `-DDP_RTLIB_VERBOSE=[0|1]` &ndash; Enable verbose output during profiling.


## Testing the installation
To test the installation, it is possible to execute the provided set of unit tests.
```
python -m unittest -v
```
