# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2019, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# a BSD-style license.  See the LICENSE file in the package base
# directory for details.
from typing import List

import utils
from PETGraph import PETGraph
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
        if self.pet.reduction_vars is not None:
            res.reduction = detect_reduction(self.pet)
        else:
            print('reduction variables are required for this detector\n')

        res.do_all = detect_do_all(self.pet)

        res.pipeline = detect_pipeline(self.pet)

        if self.pet.loop_data is not None:
            res.geometric_decomposition = detect_gd(self.pet)
        else:
            print('loop iteration data is required for this detector\n')

        if self.pet.loop_data is not None:
            res.task_parallelism = detect_tp(self.pet)
        else:
            print('loop iteration data is required for this detector\n')

        return res
