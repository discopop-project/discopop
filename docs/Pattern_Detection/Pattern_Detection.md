---
layout: default
title: Pattern Detection
has_children: true
permalink: /Pattern_Detection
nav_order: 5
---

# Pattern Detection and Parallelization Suggestions
The Pattern Detection is the next step after executing the [DiscoPoP Profiler](../Profiling/Profiling.md).
In this step, a set of parallel patterns can be identified on the basis of the profiling results.
In case that one or more parallel patterns have been identified, a potential parallel implementation is suggested via OpenMP pragmas.
Both steps, the identification and the so called implementation of the parallel patterns are executed by the [DiscoPoP Explorer](DiscoPoP_Explorer.md), and are described in more detail on the linked page.
An overview of the supported parallel patterns as well as detailed explanations how to interpret the respective suggestions can be found [here](Patterns/Patterns.md).
