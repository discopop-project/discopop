import os

from PETGraph import PETGraph
from pattern_detectors.do_all_detector import run_detection as detect_do_all
from pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd
from pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from pattern_detectors.reduction_detector import run_detection as detect_reduction
from pattern_detectors.task_parallelism_detector import run_detection as detect_tp


class PatternDetector(object):
    pet: PETGraph
    path: str

    def __init__(self, pet_graph: PETGraph, path):
        self.pet = pet_graph
        self.path = path
        self.reduction_vars = []
        self.loop_data = {}

        with open(os.path.join(path, 'loop_counter_output.txt')) as f:
            content = f.readlines()
        for line in content:
            s = line.split(' ')
            # line = FileId + LineNr
            self.loop_data[s[0] + ':' + s[1]] = int(s[2])

        # parse reduction variables
        with open(os.path.join(path, 'reduction.txt')) as f:
            content = f.readlines()

        for line in content:
            s = line.split(' ')
            # line = FileId + LineNr
            var = {'loop_line': s[3] + ':' + s[8], 'name': s[17]}
            self.reduction_vars.append(var)


    '''
    * function					: merges all children and
    dependencies of the children of all nodes
    * @param loopType			: if set to true -> then just look for
    type = loop
    * @param removeDummies		: don't regard the dummy nodes (type = 3)
    Main Level:					   node1
    .......... node2 ....
                                            /			|
    \ Level I:		child1		  child2		child3
                            /    |    \		  / | \			/ | \
    Level II: child11
    ...
    .
    .
    
    * 1.) get node from nodeMap
    *	I.) iterate through all children in Level I
    *	II.) get the whole children nodes (Level II+) of the child in Level I
    and save them in a vector under property node.wholeSubNodes *	III.) iterate
    through all children nodes (Level II+) of the Level I child and adjust the
    dependencies:
    *		a.) the dependencies remain if they that are pointing to any
    other node of the child node (Level I+) of the main node in the Main Level *
    b.) dependencies pointing to any node out of the tree of the node in the Main
    Level are removed
    * 2.) do Step I for all nodes in nodeMap
    '''

    def __merge(self, loop_type: bool, remove_dummies: bool):
        """
        Removes dummy nodes
        :param loop_type: loops only
        :param remove_dummies: remove dummy nodes
        :return:
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
        """
        Runs pattern discovery on the CU graph
        :return:
        """
        self.__merge(False, True)

        detect_pipeline(self.pet.graph)

        # reduction before doall!
        detect_reduction(self.pet.graph, self.reduction_vars)
        detect_do_all(self.pet.graph)

        detect_tp(self.pet.graph)
        detect_gd(self.pet.graph, self.loop_data)
