# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List

from .PETGraphX import PETGraphX, NodeType, EdgeType
from .pattern_detectors.do_all_detector import run_detection as detect_do_all, DoAllInfo
from .pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd, GDInfo
from .pattern_detectors.pipeline_detector import run_detection as detect_pipeline, PipelineInfo
from .pattern_detectors.reduction_detector import run_detection as detect_reduction, ReductionInfo
from .pattern_detectors.task_parallelism_detector import build_preprocessed_graph_and_run_detection \
    as detect_tp
from .pattern_detectors.PatternInfo import PatternInfo


class DetectionResult(object):
    reduction: List[ReductionInfo]
    do_all: List[DoAllInfo]
    pipeline: List[PipelineInfo]
    geometric_decomposition: List[GDInfo]
    task: List[PatternInfo]

    def __init__(self):
        pass

    def __str__(self):
        return '\n\n\n'.join(["\n\n".join([str(v2) for v2 in v]) for v in self.__dict__.values() if v])


class PatternDetectorX(object):
    pet: PETGraphX

    def __init__(self, pet_graph: PETGraphX) -> None:
        """This class runs detection algorithms on CU graph

        :param pet_graph: CU graph
        """
        self.pet = pet_graph

    def __merge(self, loop_type: bool, remove_dummies: bool):
        """Removes dummy nodes

        :param loop_type: loops only
        :param remove_dummies: remove dummy nodes
        """
        dummies_to_remove = set()
        for node in self.pet.all_nodes():
            if not loop_type or node.type == NodeType.LOOP:
                if remove_dummies and node.type == NodeType.DUMMY:
                    continue
                for s, t, e in self.pet.out_edges(node.id, EdgeType.CHILD):
                    if remove_dummies and self.pet.node_at(t).type == NodeType.DUMMY:
                        dummies_to_remove.add(t)

        for n in dummies_to_remove:
            self.pet.g.remove_node(n)

    def detect_patterns(self, cu_dict, dependencies, loop_data, reduction_vars, file_mapping, cu_inst_result_file,
                        llvm_cxxfilt_path):
        """Runs pattern discovery on the CU graph
        """
        self.__merge(False, True)

        res = DetectionResult()

        # reduction before doall!
        res.reduction = detect_reduction(self.pet)
        res.do_all = detect_do_all(self.pet)
        res.pipeline = detect_pipeline(self.pet)
        res.geometric_decomposition = detect_gd(self.pet)

        # check if task pattern should be enabled
        if file_mapping is None or cu_inst_result_file is None:
            return res
        if cu_inst_result_file.endswith("/None"):
            return res
        res.task = detect_tp(cu_dict, dependencies, loop_data, reduction_vars, file_mapping, cu_inst_result_file,
                             llvm_cxxfilt_path)
        return res
