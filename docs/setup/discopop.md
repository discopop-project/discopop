---
layout: default
title: DiscoPoP
parent: Setup
nav_order: 1
---

# DiscoPoP Setup - Package
- Proposed method of installation for `users` of DiscoPoP
- Download the `.deb` package of choice from [releases](https://github.com/tuda-hpclab/discopop/releases).
    - Packages for different targets and configurations might become available in the future
- Install via a package manager of choice (example: `sudo apt install ./<packagename>.deb`)
- Uninstall via a package manager of choice (example: `sudo apt remove discopop`)


# DiscoPoP Setup - Manual
- Proposed method of installation for `developers` of DiscoPoP
## Prerequisites
- LLVM/clang version 19, 20, 21, or 22
- Python version 3.11 or greater
- the versions tested in CI are listed in the matrix of `.github/workflows/ci.yml` (Ubuntu 24.04 and Debian 13, LLVM 19&ndash;22, Python 3.11, 3.12 and 3.13)
- LLVM 21 is not packaged by Ubuntu 24.04 or Debian 13; install it from [apt.llvm.org](https://apt.llvm.org) if needed

## Setup
```
git clone git@github.com:tuda-hpclab/discopop.git
cd discopop
mkdir build
```

## Build libraries and install Python modules
```
cd build
cmake .. <CMAKE_FLAGS>
make
make python_modules
cd ..
```

where `<CMAKE_FLAGS>` can consist of any combination of the following flags and commonly used CMAKE_FLAGS:
#### Environment configuration
- `-DUSE_LLVM_VERSION=<version>` &ndash; Use a specific Version of LLVM
- `-DLLVM_DIST_PATH=<llvm_base_dir>` &ndash; Use a specific LLVM installation by specifiying the location
#### Profiling configuration
- `-DDP_PTHREAD_COMPATIBILITY_MODE=[0|1]` &ndash; If your application uses PThreads, please specify this flag to serialize the calls to the DiscoPoP runtime functions. Note, however, that this can negatively influence the runtime of the profiling. Default: `0`.
- `-DDP_NUM_WORKERS=<int>` &ndash; Specify the number of worker threads available for the dependency analysis during profiling. Default: `3` worker threads. `0` can be used to disable the creation of additional threads for the analysis.
- `-DDP_HYBRID_PROFILING=[0|1]` &ndash; Enbale hybrid profiling. Default: `1`.
- `-DDP_BRANCH_TRACKING=[0|1]`: Toggles the creation of instrumentation calls for tracking taken branches. Required by the graph pruning step of the DiscoPoP optimizer. Default: `0`.

#### Development and debugging
- `-DDP_RTLIB_VERBOSE=[0|1]` &ndash; Enable verbose output during profiling.
- `-DDP_INTERNAL_TIMER=[0|1]`&ndash; Enable timing of runtime library functions.
- `-DDP_BUILD_UNITTESTS=[0|1]`&ndash; Enable building unittests and performance benchmarks. Default: `0`.

#### Code navigation in editors
Editors using [clangd](https://clangd.llvm.org) (e.g. VS Code with the clangd extension, Neovim, Emacs, CLion, Zed) need the compiler flags of every source file to resolve the LLVM headers and to follow definitions across files.
CMake writes them to `compile_commands.json` in the build directory; `-DCMAKE_EXPORT_COMPILE_COMMANDS=OFF` turns this off.
clangd finds `build/compile_commands.json` on its own. For a build directory with a different name, link its database into the source directory once (the link is ignored by git):
```
ln -s <build_dir>/compile_commands.json .
```
Configure again after adding a source file, so that it is listed. The `.clangd` file in the source directory removes a GCC-only flag which clang rejects.
The database lists the default configuration: code disabled by a `-DDP_...` flag is not indexed.
A profiler installed via `pip install ./profiler` is built without such a database.



## Testing the installation
To test the installation, it is possible to execute the provided set of unit tests.
```
cd <dp_source_dir>
venv/bin/python -m pytest
```

The tests below `test/wip_end_to_end` are work in progress and are skipped by default.
To include them, set `DP_RUN_WIP_TESTS=1`:
```
DP_RUN_WIP_TESTS=1 venv/bin/python -m pytest test/wip_end_to_end
```
