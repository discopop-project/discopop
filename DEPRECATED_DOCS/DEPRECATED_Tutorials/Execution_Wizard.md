---
layout: default
title: Execution Wizard - Script
parent: Tutorials
nav_order: 2
---


# Execution Wizard

The Execution Wizard allows to simply analyze projects that are built using the Make buildsystem. The Makefile must allow to configure the compiler using the `CC` and `CXX` variables for the Execution Wizard to work correctly.

Please note that shared libraries will not be analyzed!

## Important Note

If you want to make use of the [Configuration](Configuration_Wizard.md) or [Execution Wizard](Execution_Wizard.md) for a simplified analysis of your project, you additionally need a working installation of [gllvm](https://github.com/SRI-CSL/gllvm) which also requires [go](https://go.dev/doc/install).

## Running the Wizard

Execute the runDiscoPoP script with the --help option to get a list of required and optional arguments.

    DP_BUILD/scripts/runDiscoPoP --help
