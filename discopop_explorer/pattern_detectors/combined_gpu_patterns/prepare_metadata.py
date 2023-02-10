# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import sys
from typing import Set, List, Tuple

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import VarName, CUID
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Dependency import Dependency
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    EntryPointPositioning,
    ExitPointPositioning,
)


def get_dependencies_as_metadata(
    pet: PETGraphX, all_dependencies: Set[Dependency]
) -> Tuple[List[Tuple[VarName, CUID, str]], List[Tuple[VarName, CUID, str]],]:
    in_deps_metadata: Set[Tuple[VarName, CUID, str]] = set()
    out_deps_metadata: Set[Tuple[VarName, CUID, str]] = set()

    for dependency in all_dependencies:
        # create out dependency metadata
        for var_name in dependency.var_names:
            out_deps_metadata.add(
                (
                    var_name,
                    dependency.source,
                    pet.node_at(dependency.source).end_position(),
                )
            )

        # create in dependency metadata
        for var_name in dependency.var_names:
            in_deps_metadata.add(
                (
                    var_name,
                    dependency.sink,
                    pet.node_at(dependency.sink).start_position(),
                )
            )

    return list(in_deps_metadata), list(out_deps_metadata)
