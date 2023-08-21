---
layout: default
title: DiscoPoP Profiler
has_children: true
permalink: /Profiling
nav_order: 4
---

# DiscoPoP Profiler
The DiscoPoP pattern detection requires different sets of information on the structure and characteristics of the target source code.
This data is gathered using a mixture of static and dynamic code analyses.
The static code analyses as well as the instrumentation of the target code for the dynamic analyses are conveniently bundled into a single `DiscoPoP` optimizer pass.
Detailed instructions on how to apply the pass, typically referenced to as `DiscoPoP Profiler`, can be found at the [Tutorials](../Tutorials/Tutorials.md) pages.

A detailed explanation of the gathered data, and in particular the used formats can be found [here](Data_Details.md).

An explanation of the filemapping required by several steps of the DiscoPoP pipeline can be found [here](File_Mapping.md).


