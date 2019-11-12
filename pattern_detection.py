import os
from typing import Dict, List

from PETGraph import PETGraph
from pattern_detectors.do_all_detector import run_detection as detect_do_all
from pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd
from pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from pattern_detectors.reduction_detector import run_detection as detect_reduction
from pattern_detectors.task_parallelism_detector import run_detection as detect_tp
from utils import loop_data


class PatternDetector(object):
    pet: PETGraph
    path: str
    reduction_vars: List[Dict[str, str]]
    # loop_data: Dict[str, int]

    def __init__(self, pet_graph: PETGraph, path):
        """This class runs detection algorithms on CU graph

        :param pet_graph: CU graph
        :param path: directory with input data
        """
        self.pet = pet_graph
        self.path = path
        self.reduction_vars = []
        #self.loop_data = {}

        with open(os.path.join(path, 'loop_counter_output.txt')) as f:
            content = f.readlines()
        for line in content:
            s = line.split(' ')
            # line = FileId + LineNr
            loop_data[s[0] + ':' + s[1]] = int(s[2])

        # parse reduction variables
        with open(os.path.join(path, 'reduction.txt')) as f:
            content = f.readlines()

        for line in content:
            s = line.split(' ')
            # line = FileId + LineNr
            var = {'loop_line': s[3] + ':' + s[8], 'name': s[17]}
            self.reduction_vars.append(var)

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

            # TODO optimization opportunity: copy all dependency edges to the root node

    def detect_patterns(self):
        """Runs pattern discovery on the CU graph
        """
        self.__merge(False, True)

        print('===DETECTING PIPELINE===')
        for pipeline in detect_pipeline(self.pet.graph):
            print(pipeline, '\n')

        print('===DETECTING REDUCTION===')
        # reduction before doall!
        for reduction in detect_reduction(self.pet.graph, self.reduction_vars):
            print(reduction, '\n')

        print('===DETECTING DO ALL===')
        for do_all in detect_do_all(self.pet.graph):
            print(do_all, '\n')

        print('===DETECTING TASK PARALLELISM===')
        for tp in detect_tp(self.pet.graph):
            print(tp, '\n')

        print('===DETECTING GEOMETRIC DECOMPOSITION===')
        for gd in detect_gd(self.pet.graph, loop_data):
            print(gd, '\n')
