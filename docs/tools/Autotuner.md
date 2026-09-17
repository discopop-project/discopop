---
layout: default
title: Empirical autotuner
parent: Tools
nav_order: 7
---

# DiscoPoP Empirical Autotuner
## Executable
`discopop_auto_tuner`

## Purpose
Identify the best configuration of parallel code which is achievable by applying a combination of the parallelization suggestion found by the [DiscoPoP Explorer](../tools/Explorer.md) or [optimizer](../tools/Optimizer.md). Internally, the [DiscoPoP patch applicator](../tools/Patch_applicator.md) is used to create different parallel codes, which will be compiled, executed, and evaluated based on the observed execution time and result validity.
To find a beneficial configuration in a comparatively short amount of time, a greedy search is performed as described in the following.
- Initialize the "best_configuration" as the sequential code
- Focus on identified hotspots, followed by code regions which might be hotspots, and lastly coldspots
- Sort the loops in each category in descending order by their average runtime, thus focusing on "more important" loops wrt. execution time first
- For each loop, create a parallel version of the code for each suggestion applicable to this loop
- Compile the parallel code, execute, and verify it.
- Select the best parallel code and and save it as the new best_configuration
- Continue with the next loop, and successively hotspot category

## Required input
- `Parallel patterns` in the form of a `JSON` file, created by the [Explorer](Explorer.md)
- `Detected hotspots` in the form of a `JSON` file, created by the [Hotspot detection](https://github.com/discopop-project/Hotspot-Detection)
- `Prepared patch files` created by the [DiscoPoP patch generator](Patch_generator.md)
- An `execution configuration` created by the [project manager](Project_manager.md), which provides the `compile.sh` and `execute.sh` scripts used to compile and execute the created parallel code. Its optional `validate.sh` validates the results, and its optional `compile_validate.sh` builds the code that `validate.sh` runs whenever validation requires a different build than the timed execution.

## Output
The parallel code representing the identified best configuration will be stored in a copy of the project directory.
Information on the configuration can be found in the included `.discopop` directory.

## Limitations
Due to the empirical nature of the optimization approach described above, varying sets of input data might yield differing selected configurations.
For this reason it is important, that the used input data (typically specified in `execute.sh`) is representative for a production run of the software and large enough to allow for beneficial parallelizations.

## Note
For a more detailed description of the available run-time arguments, please refer to the help string of the respective tool.
```
discopop_auto_tuner --help
```
