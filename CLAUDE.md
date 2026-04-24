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
## Type checking
### Python
- to execute type checking of python files use the following command as the basis: `python -m mypy --config-file=mypy.ini -p`

## Testing
### Python
- to execute python unit tests, use 'venv/bin/python -m unittest -v -k "*.end_to_end.*"'
### C++
#### Profiler
- to execute unit tests for the profiler, enter the directory `test/profiler`, build using the `make` command, and execute the unittests via use 'DP_TEST_PROFILER_CONFIG=build_hybrid ../../venv/bin/python -m pytest'
