---
layout: default
title: Patch applicator
parent: Tools
nav_order: 4
---

# DiscoPoP patch applicator
## Executable
`discopop_patch_applicator`

## Purpose
Offer the managed application, rollback, clearing and restoring of parallelism suggestions in the form of patch files created by the [patch generator](../tools/Patch_generator.md).

## Required input
- Execution mode (apply, rollback, clear, load)
- Pattern ids to be considered

## Output
The patch applicator will not create any new output but modify the files targeted by the specified patch files in-place.


## Note
For a more detailed description of the available run-time arguments, please refer to the help string of the respective tool.
```
discopop_patch_applicator --help
```
