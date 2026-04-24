# Development Guidelines
This document contains critical information about working with this codebase. Follow these guidelines precisely.

# Code Style
- verify the type correctness of python code
- verify correctness of code using the unittests

# Tools
## Type checking
### Python
- to execute type checking of python files use the following command as the basis: `python -m mypy --config-file=mypy.ini -p`

## Testing
### Python
- to execute python unit tests, use 'venv/bin/python -m unittest -v -k "*.end_to_end.*"'
### C++
#### Profiler
- to execute unit tests for the profiler, use 'venv/bin/python -m unittest -v -k *test.profiler.*'
