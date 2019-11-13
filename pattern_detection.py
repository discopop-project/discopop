import utils
from PETGraph import PETGraph
from pattern_detectors.do_all_detector import run_detection as detect_do_all
from pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd
from pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from pattern_detectors.reduction_detector import run_detection as detect_reduction
from pattern_detectors.task_parallelism_detector import run_detection as detect_tp


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

            # TODO optimization opportunity: copy all dependency edges to the root node

    def detect_patterns(self):
        """Runs pattern discovery on the CU graph
        """
        self.__merge(False, True)

        print('===DETECTING PIPELINE===')
        for pipeline in detect_pipeline(self.pet):
            print(pipeline, '\n')

        print('===DETECTING REDUCTION===')
        # reduction before doall!
        if self.pet.reduction_vars is not None:
            for reduction in detect_reduction(self.pet):
                print(reduction, '\n')
        else:
            print('reduction variables are required for this detector\n')

        print('===DETECTING DO ALL===')
        for do_all in detect_do_all(self.pet):
            print(do_all, '\n')

        print('===DETECTING TASK PARALLELISM===')
        if self.pet.loop_data is not None:
            for tp in detect_tp(self.pet):
                print(tp, '\n')
        else:
            print('loop iteration data is required for this detector\n')

        print('===DETECTING GEOMETRIC DECOMPOSITION===')
        if self.pet.loop_data is not None:
            for gd in detect_gd(self.pet):
                print(gd, '\n')
        else:
            print('loop iteration data is required for this detector\n')
