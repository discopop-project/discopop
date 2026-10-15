<!--
 /*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */
 -->

# DiscoPoP Explorer
The explorer (`discopop-explorer`) is the pattern detection of DiscoPoP. It reads the data written by the profiler (`.discopop/profiler`), builds the program execution graph, detects parallel patterns (do-all loops and reductions by default; tasks experimentally) and writes the suggestions to `.discopop/explorer`, including `patterns.json`. Patches for the suggestions are created in `.discopop/patch_generator`.

Console script: `discopop_explorer`, run from inside the `.discopop` folder of a profiled project.

It is installed as part of `pip install discopop` (or on its own with `pip install discopop-explorer`; it depends on `discopop-library`). The unit tests are in `explorer/discopop_explorer` and run with `python -m pytest explorer/discopop_explorer`.

Documentation: [Explorer](https://tuda-hpclab.github.io/discopop/tools/Explorer/).

## License
© DiscoPoP is available under the terms of the BSD-3-Clause license, as specified in the LICENSE file.
