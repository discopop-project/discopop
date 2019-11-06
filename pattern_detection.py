from typing import List, Dict, Set

from graph_tool.all import Vertex

from PETGraph import PETGraph
from do_all_detector import detect_do_all_loop
from geometric_decomposition_detector import detect_geometric_decomposition_loop
from pipeline_detector import detect_pipeline_loop
from reduction_detector import detect_reduction_loop
from task_parallelism_detector import detect_task_parallelism_loop


class PatternDetector(object):
    pet: PETGraph
    loop_iterations: Dict[str, int]
    reduction_vars: List[str]
    loop_data: Dict[str, int]
    main_node: Vertex
    forks: Set[Vertex]

    def __init__(self, pet_graph: PETGraph):
        self.pet = pet_graph

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
            if not loop_type or self.pet.graph.vp.type[node] == '2':
                # if the main node is dummy and we should remove dummies, then do not
                # insert it in nodeMapComputed
                if remove_dummies and self.pet.graph.vp.type[node] == '3':
                    continue

                sub_nodes = []
                for e in node.out_edges():
                    if self.pet.graph.ep.type[e] == 'child':
                        if remove_dummies and self.pet.graph.vp.type[e.target()] == '3':
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

        detect_pipeline_loop(self.pet.graph)

        # reduction before doall!
        detect_reduction_loop(self.pet.graph)
        detect_do_all_loop(self.pet.graph)

        detect_task_parallelism_loop(self.pet.graph)
        detect_geometric_decomposition_loop(self.pet.graph)
