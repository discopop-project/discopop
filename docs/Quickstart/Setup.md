---
layout: default
title: Setup
parent: Quickstart
nav_order: 1
---

# Quickstart - Setup
A detailed explanation of the Setup can be found on the [setup](../Setup.md) page

```
	sudo apt-get install git build-essential cmake libclang-11-dev clang-11 llvm-11 python3-pip
	git clone https://github.com/discopop-project/discopop.git
	cd discopop && mkdir build && cd build
	cmake .. && make && cd ..
	pip install .
```