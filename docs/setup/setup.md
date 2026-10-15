---
layout: default
title: Setup
has_children: true
permalink: /Setup
nav_order: 4
---

# Setup

Choose the route that fits what you want to do.

| I want to ... | Use | Page |
|---|---|---|
| use DiscoPoP on my own programs | the PyPI packages: `pip install discopop` in a virtual environment | [Installation](./discopop.md#install-from-pypi) |
| change DiscoPoP or try the current development state | a checkout of the repository: `make` | [Installation](./discopop.md#install-from-a-checkout) |
| change how the profiler is built (worker threads, hybrid profiling, sanitizers, ...) | CMake options | [Build options](./build_options.md) |
| configure the tools and the profiling runtime | environment variables and `dp.conf` | [Environment variables and runtime settings](./environment_variables.md) |
| browse suggestions and hotspots inside VS Code | the VS Code extension, used together with the GUI | [VS Code extension](./vscx.md) |

Both routes build the LLVM pass of the profiler on your machine, so LLVM/clang 19&ndash;22, CMake and a C++20 compiler have to be installed first. The list of prerequisites is on the [Installation](./discopop.md#prerequisites) page.

If you want to contribute to DiscoPoP, continue with [How to contribute](../How_to_contribute.md) after the installation from a checkout.
