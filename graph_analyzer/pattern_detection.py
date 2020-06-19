# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List

import utils
from PETGraph import PETGraph
from PETGraphX import PETGraphX, CuType, EdgeType
from pattern_detectors.do_all_detector import run_detection as detect_do_all, DoAllInfo
from pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd, GDInfo
from pattern_detectors.pipeline_detector import run_detection as detect_pipeline, PipelineInfo
from pattern_detectors.reduction_detector import run_detection as detect_reduction, ReductionInfo
from pattern_detectors.task_parallelism_detector import run_detection as detect_tp, TaskParallelismInfo


class DetectionResult(object):
    reduction: List[ReductionInfo]
    do_all: List[DoAllInfo]
    pipeline: List[PipelineInfo]
    geometric_decomposition: List[GDInfo]
    task_parallelism: List[TaskParallelismInfo]

    def __init__(self):
        pass

    def __str__(self):
        return '\n\n\n'.join(["\n\n".join([str(v2) for v2 in v]) for v in self.__dict__.values() if v])


class PatternDetector(object):
    pet: PETGraph

    def __init__(self, pet_graph: PETGraph):
        """This class runs detection algorithms on CU graph

        :param pet_graph: CU graph
        """
        self.pet = pet_graph

        utils.loop_data = pet_graph.loop_data

    def __merge(self, loop_type: bool, remove_dummies: bool):
        """Removes dummy nodes

        :param loop_type: loops only
        :param remove_dummies: remove dummy nodes
        """
        # iterate through all entries of the map -> Nodes
        # set the ids of all children
        for node in self.pet.graph.vertices():
            if not loop_type or self.pet.graph.vp.type[node] == 'loop':
                # if the main node is dummy and we should remove dummies, then do not
                # insert it in nodeMapComputed
                if remove_dummies and self.pet.graph.vp.type[node] == 'dummy':
                    continue

                sub_nodes = []
                for e in node.out_edges():
                    if self.pet.graph.ep.type[e] == 'child':
                        if remove_dummies and self.pet.graph.vp.type[e.target()] == 'dummy':
                            self.pet.graph.remove_edge(e)
                        else:
                            sub_nodes.append(e.target())

    def detect_patterns(self):
        """Runs pattern discovery on the CU graph
        """
        self.__merge(False, True)

        res = DetectionResult()

        # reduction before doall!
        res.reduction = detect_reduction(self.pet)
        res.do_all = detect_do_all(self.pet)
        res.pipeline = detect_pipeline(self.pet)
        res.geometric_decomposition = detect_gd(self.pet)
        res.task_parallelism = detect_tp(self.pet)

        return res


class PatternDetectorX(object):
    pet: PETGraphX

    def __init__(self, pet_graph: PETGraphX):
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
            if not loop_type or node.type == CuType.LOOP:
                if remove_dummies and node.type == CuType.DUMMY:
                    continue
                for s, t, e in self.pet.out_edges(node.id, EdgeType.CHILD):
                    if remove_dummies and self.pet.node_at(t).type == CuType.DUMMY:
                        dummies_to_remove.add(t)

        for n in dummies_to_remove:
            self.pet.g.remove_node(n)

    def detect_patterns(self):
        """Runs pattern discovery on the CU graph
        """
        self.__merge(False, True)

        res = DetectionResult()

        # reduction before doall!
        res.reduction = detect_reduction(self.pet)
        res.do_all = detect_do_all(self.pet)
        return res
        res.pipeline = detect_pipeline(self.pet)
        res.geometric_decomposition = detect_gd(self.pet)
        res.task_parallelism = detect_tp(self.pet)

        return res