# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Dict, Set, Tuple, cast

from discopop_explorer.PETGraphX import CUNode, NodeType, PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.gpu_patterns.GPULoop import GPULoopPattern
from discopop_explorer.pattern_detectors.gpu_patterns.GPURegions import GPURegions
from discopop_explorer.variable import Variable


def run_detection(pet: PETGraphX, res) -> List[PatternInfo]:
    """Search for do-all loop pattern

    :param pet: PET graph
    :param res: DetectionResult object
    :return: List of detected pattern info
    """
    gpu_patterns: List[GPULoopPattern] = []

    for node in pet.all_nodes(NodeType.LOOP):
        if any(node.id == d.node_id for d in res.do_all) or any(
            node.id == r.node_id for r in res.reduction
        ):
            reduction_vars: List[Variable] = []
            if node.id in [r.node_id for r in res.reduction]:
                parent_reduction = [r for r in res.reduction if r.node_id == node.id][0]
                reduction_vars = parent_reduction.reduction
            gpulp = GPULoopPattern(
                pet, node.id, node.start_line, node.end_line, node.loop_iterations, reduction_vars
            )
            gpulp.getNestedLoops(pet, node.id)
            gpulp.setParentLoop(node.id)
            gpulp.classifyLoopVars(pet, node)
            gpu_patterns.append(gpulp)

    regions = GPURegions(pet, gpu_patterns)

    for i in gpu_patterns:
        i.setCollapseClause(pet, i.node_id)

    regions.identifyGPURegions()
    # regions.old_mapData()
    regions.determineDataMapping()

    # construct GPURegions
    gpu_region_info: List[PatternInfo] = cast(List[PatternInfo], regions.get_gpu_region_info(pet))

    return gpu_region_info
