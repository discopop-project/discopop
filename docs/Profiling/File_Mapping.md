---
layout: default
title: File Mapping
parent: DiscoPoP Profiler
nav_order: 2
---

# File Mapping
Several steps of DiscoPoP's pipeline require a mapping of <b>unique file ids</b> to <b>file paths</b>, which is referred to as the filemapping.
To create this mapping, the following utility scripts can be used:

`<DP_build>/scripts/dp-fmap`

## Execution
The scripts has to be executed from the top folder of the target project by simply executing the following command without any parameters:

`<DP_build>/scripts/dp-fmap`

When executed, the scripts saves the current working directory and assings ids to all found and relevant files.

## Output
The script will create a file named `FileMapping.txt` in the current working directory.
Each line in this file will correspond to an individual file.
The format used to report the assigned file ids is as follows:

```
<file_id_1> <file_path_1>
<file_id_2> <file_path_3>
...
```
