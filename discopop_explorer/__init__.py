# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from pathlib import Path
from typing import List, Optional

from pluginbase import PluginBase  # type:ignore

from .PETGraphX import PETGraphX, NodeType
from ._version import __version__
from .parser import parse_inputs
from .pattern_detection import DetectionResult, PatternDetectorX
from .GPULoop import GPULoopPattern
from .GPURegions import GPURegions
import time


def sort_by_nodeID(e: GPULoopPattern):
    """ used to sort a list of gpu patterns by their node ids

    :return:
    :param e:
    """
    return e.nodeID


def run(
    cu_xml: str,
    dep_file: str,
    loop_counter_file: str,
    reduction_file: str,
    plugins: List[str],
    file_mapping: Optional[str] = None,
    cu_inst_result_file: Optional[str] = None,
    llvm_cxxfilt_path: Optional[str] = None,
    discopop_build_path: Optional[str] = None,
    enable_task_pattern: bool = False,
) -> DetectionResult:
    pet = PETGraphX.from_parsed_input(
        *parse_inputs(cu_xml, dep_file, loop_counter_file, reduction_file, file_mapping)
    )
    # TODO add visualization

    plugin_base = PluginBase(package="plugins")

    plugin_source = plugin_base.make_plugin_source(searchpath=[Path(__file__).parent / "plugins"])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin before: " + plugin_name)
        pet = p.run_before(pet)

    pattern_detector = PatternDetectorX(pet)

    res: DetectionResult = pattern_detector.detect_patterns(
        cu_xml,
        dep_file,
        loop_counter_file,
        reduction_file,
        file_mapping,
        cu_inst_result_file,
        llvm_cxxfilt_path,
        discopop_build_path,
        enable_task_pattern,
    )

    gpu_patterns: List[GPULoopPattern] = []

    for node in pet.all_nodes(NodeType.LOOP):
        if any(node.id == d.node_id for d in res.do_all) or any(node.id == r.node_id for r in res.reduction):
            gpulp = GPULoopPattern(pet, node.id, node.start_line, node.end_line,
                                   node.loop_iterations)
            gpulp.getNestedLoops(node.id)
            gpulp.setParentLoop(node.id)
            gpulp.classifyLoopVars(pet, node)
            gpu_patterns.append(gpulp)

    # print("\nnumber of detected patterns: " + str(len(gpu_patterns)))
    # print("-------------------------------------------------------------------------------")

    regions = GPURegions(pet, gpu_patterns)

    for i in gpu_patterns:
        i.setCollapseClause(i.node_id)
        # print("id: " + i.node_id + " start: " +
        #       i.start_line + " COLLAPSE: " + str(i.collapse))

    regions.identifyGPURegions()
    #regions.old_mapData()
    regions.determineDataMapping()

    # print("-------------------------------------------------------------------------------")

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        # print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res
