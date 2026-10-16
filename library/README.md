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

# DiscoPoP Library
The library (`discopop-library`) holds the tools around the explorer: the project manager with the graphical user interface, the patch generator, applicator and repair, the empirical autotuner, the optimizer and several helper tools. It also provides shared utilities for the other packages.

Console scripts: `discopop_gui` (the graphical user interface), `discopop_project_manager` (alias `discopop`), `discopop_patch_generator`, `discopop_patch_applicator`, `discopop_patch_repair`, `discopop_auto_tuner`, `discopop_optimizer`, `discopop_config_provider`, `discopop_sanity_checker`, `discopop_preprocessor`, `discopop_dependency_comparator` and `discopop_parallel_region_merger`.

It is installed as part of `pip install discopop` and depends on `discopop-hotspot-detection`. The unit tests are colocated with the source and run with `python -m pytest library/discopop_library`.

Documentation: [Manual](https://tuda-hpclab.github.io/discopop/manual/) and [Tools](https://tuda-hpclab.github.io/discopop/Tools).

## License
© DiscoPoP is available under the terms of the BSD-3-Clause license, as specified in the LICENSE file.
