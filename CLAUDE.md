<!--
 /*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */
 -->

# Development Guidelines
This document contains critical information about working with this codebase. Follow these guidelines precisely.

# Code Structure
- The code for the static analysis step of the profiler is located in the folder `DiscoPoP`
- The code for the runtime library of the profiler is located in the folders `rtlib` and `share`
- The code for the pattern analysis is located in the folder `discopop_explorer`
- Utilities for the pattern analysis as well as further tools are located in the folder `discopop_library`
- The projects wiki page is defined in the folder`docs`
- The code for the graphical user interface is located in the folder `GUI`

# Code Style
- verify the type correctness of python code
- verify correctness of code using the unittests
- verify correctness of modifications to the profiler using the unittests

# Tools
## Setup
### Setup venv
- in case the `venv` is not set up, execute `python3 -m venv venv` to create a new virtual environment
- always use the `venv` located in the project root directory; if it is not already activated, activate it via `source venv/bin/activate` before running any Python commands

## Type checking
### Python
- install prerequisites via `venv/bin/pip install mypy`
- to execute type checking of python files use the following command as the basis: `venv/bin/python -m mypy --config-file=mypy.ini -p`

## Formatting
### Python
- install prerequisites via `venv/bin/pip install black`
- to execute formatting check, use `venv/bin/pyton -m black -l 120 --check .`
- to execute automatic formatting, use `venv/bin/pyton -m black -l 120 .`

## Testing
### Install python packages
- to install python packages, execute `venv/bin/pip install . ./profiler ./library` from the root directory of the project
- **Important:** The profiler module must be installed without the `-e` (editable) flag. Use `pip install ./profiler`, not `pip install -e ./profiler`. Editable mode breaks the relative paths required by `CXX_wrapper.sh` to locate compiled artifacts like `LLVMDiscoPoP.so`.
### Python
- to execute python unit tests, use 'venv/bin/python -m unittest -v -k "*.end_to_end.*"'

### Coverage report (discopop_explorer)
- the `discopop_explorer` package (`explorer/discopop_explorer`) has pytest-based unit tests colocated with the source as `test_*.py` files (e.g. `explorer/discopop_explorer/utilities/ASTUtils/test_ASTQueries.py`)
- install prerequisites via `venv/bin/pip install pytest pytest-cov`
- to generate a coverage report, run from the repository root:
  `venv/bin/python -m pytest explorer/discopop_explorer --cov=discopop_explorer --cov-report=term-missing --cov-report=html:htmlcov --cov-report=xml:coverage.xml --cov-config=<(echo -e "[run]\nomit =\n    */test_*.py\n")`
- this excludes the test files themselves from the coverage count and produces:
  - a terminal summary with missing line ranges per file
  - an HTML report at `htmlcov/index.html`
  - a Cobertura-style `coverage.xml`
- **Note:** these unit tests do not cover code paths that are only exercised by the end-to-end tests (`test/end_to_end`), since those invoke `discopop_explorer` as a subprocess rather than in-process; the coverage numbers reflect unit-test coverage only

### C++
#### Profiler
- the profiler's C++ unit tests (GoogleTest, in `test/unit_tests`) are only reachable via the root `CMakeLists.txt`, not via `pip install ./profiler`
- to execute them, configure and build from the repository root with `cmake -S . -B build_tests -DCMAKE_BUILD_TYPE=Release -DDP_BUILD_UNITTESTS=1`, then `cmake --build build_tests --target DiscoPoP_UT -j "$(nproc)"`, then run `build_tests/test/unit_tests/DiscoPoP_UT`
- the end-to-end profiler dependency-detection tests (`test/profiler/{RAW,WAR,WAW}`) are separate and run via `venv/bin/python -m unittest -v -k "*test.profiler.*"` from the repository root

### Execute example
You can execute a full example by following the steps below. The example should not raise any errors. Warnings may arise during different parts of the process and can be tolerated.
- setup venv
- install python packages
- clean example via `rm -rf example/a.out example/.discopop`
- execute static analysis and instrumentation via `cd example && ../venv/bin/discopop_cxx example.cpp -o a.out`
- execute profiling via `cd example && ./a.out`
- execute pattern analysis via `cd example/.discopop && ../../venv/bin/discopop_explorer`
- check for existing parallelization suggestions by checking for created patch files in example/.discopop/patch_generator

### Excecute CI Pipeline locally
To execute the CI pipeline locally, use the following command from the root folder: `scripts/dev/run_ci_locally.sh`.
