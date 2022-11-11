---
layout: default
title: Detailed Example - TODO
parent: Quickstart
nav_order: 2
---

# Detailed Quickstart Example

## Assigning IDs to different files in the program - TODO CORRECT CONTENT OF CREATED FILEMAPPING.TXT

DiscoPoP can analyze projects containing multiple files scattered in different directories. We have developed a script (i.e., `dp-fmap`) that assigns a unique ID to each file in the project. You can find the script in the scripts directory under the DiscoPoP root directory. Currently, we support the following file types:

```
c|cc|cpp|h|hpp
```

However, it might be the case that you have c/c++ files which have a different file extension (e.g., “.C”). In this case, you can add the desired extension by changing the content of the `dp-fmap` file.

Running `dp-fmap` in the tutorial directory, a `FileMapping.txt` file with the following content is generated:

```
1    /$DiscoPoP_root/test/tutorial/src-parallel-cpu/tutorial.c
```