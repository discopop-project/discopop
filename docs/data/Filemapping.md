---
layout: default
title: Filemapping
parent: Data
nav_order: 4
---

# Filemapping

Creating the instrumented version of the program will create a file named `FileMapping.txt` in the current working directory.
Each line in this file corresponds to an individual file encountered during the static analysis.
The format used to report the assigned file ids is as follows:

```
<file_id_1> <file_path_1>
<file_id_2> <file_path_3>
...
```

## Usage
In general, the `FileMapping.txt` can be used to map `file-ids`, e.g. used in the representation of identified `CUs`, to the file path of the corresponding file.

## Utilities
For a simplified use from python modules, utilities for loading a filemapping can be imported from `discopop_library/PathManagement`.
