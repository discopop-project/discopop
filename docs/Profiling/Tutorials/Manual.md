---
layout: default
title: Manual instrumentation and execution - TODO
parent: Tutorials
grand_parent: Profiling
nav_order: 3
---

# DiscoPoP Profiler - Manual instrumentation and execution

## Assigning IDs to different files in the program

DiscoPoP can analyze projects containing multiple files scattered in different directories. We have developed a script (`scripts/dp-fmap`) that assigns a unique ID to each file in the project. You can find the script in the scripts directory under the DiscoPoP root directory. Currently, we support the following file types:

```
c|cc|cpp|h|hpp
```

However, it might be the case that you have c/c++ files which have a different file extension (e.g., “.C”). In this case, you can add the desired extension by changing the content of the `dp-fmap` file.

Executing the `dp-fmap` script in the target directory will result in a file named `FileMapping.txt`.
Each line of this file assigns a unique id to a file located in the project using the format shown in the following example:

```
1    /home/user/project_source/sample.c
```