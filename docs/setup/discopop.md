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
- In case you want to use a specific Version of LLVM, it is possible to specify the `-DUSE_LLVM_VERSION=<version>` flag.
- In case you want to use a specific LLVM installation, specify the location via the `-DLLVM_DIST_PATH=<llvm_base_dir>` flag.
- In case your application uses PThreads, please specify `-DDP_PTHREAD_COMPATIBILITY_MODE=[0|1]`. Note, however, that this can influence the runtime of the profiling.
- In case you require a more verbose output of the runtime library, specify the `-DDP_RTLIB_VERBOSE=[0|1]` flag.
- In case you want to specify the number of Workers available for the profiling step, specify the `-DDP_NUM_WORKERS=<int>` flag.

## Testing the installation
To test the installation, it is possible to execute the provided set of unit tests.
```
python -m unittest -v
```
