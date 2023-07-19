# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os

import jsonpickle  # type: ignore

from discopop_library.discopop_optimizer.OptimizationGraph import OptimizationGraph
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show
from discopop_library.result_classes.DetectionResult import DetectionResult
from .PETGraphX import DummyNode, LoopNode, PETGraphX, EdgeType
from .pattern_detectors.do_all_detector import run_detection as detect_do_all
from .pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd
from .pattern_detectors.simple_gpu_patterns.gpu_pattern_detector import run_detection as detect_gpu
from .pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from .pattern_detectors.reduction_detector import run_detection as detect_reduction
from discopop_explorer.pattern_detectors.task_parallelism.task_parallelism_detector import (
    build_preprocessed_graph_and_run_detection as detect_tp,
)


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
            if not loop_type or isinstance(node, LoopNode):
                if remove_dummies and isinstance(node, DummyNode):
                    continue
                for s, t, e in self.pet.out_edges(node.id, [EdgeType.CHILD, EdgeType.CALLSNODE]):
                    if remove_dummies and isinstance(self.pet.node_at(t), DummyNode):
                        dummies_to_remove.add(t)

        for n in dummies_to_remove:
            self.pet.g.remove_node(n)

    def detect_patterns(
        self,
        cu_dict,
        dependencies,
        loop_data,
        reduction_vars,
        file_mapping,
        cu_inst_result_file,
        llvm_cxxfilt_path,
        discopop_build_path,
        enable_task_pattern,
    ):
        """Runs pattern discovery on the CU graph"""
        self.__merge(False, True)
        self.pet.map_static_and_dynamic_dependencies()
        self.pet.calculateFunctionMetadata()
        res = DetectionResult(self.pet)

        # reduction before doall!
        res.reduction = detect_reduction(self.pet)
        print("REDUCTION DONE.")
        res.do_all = detect_do_all(self.pet)
        print("DOALL DONE.")
        res.pipeline = detect_pipeline(self.pet)
        # print("PIPELINE DONE.")
        res.geometric_decomposition = detect_gd(self.pet)
        # print("GEO. DEC. DONE.")

        # check if task pattern should be enabled
        if enable_task_pattern:
            res.task = detect_tp(
                cu_dict,
                dependencies,
                reduction_vars,
                file_mapping,
                cu_inst_result_file,
                llvm_cxxfilt_path,
                discopop_build_path,
            )

        project_folder_path = os.path.dirname(os.path.abspath(file_mapping))

        # detect GPU patterns based on previously identified patterns
        res.simple_gpu = detect_gpu(self.pet, res, project_folder_path)

        # detect combined GPU patterns
        # disabled currently due to high additional overhead.
        # will be moved and calculated based on the optimization graph
        # res.combined_gpu = detect_combined_gpu(self.pet, res, project_folder_path)

        # identify scheduling clauses
        res = self.__identify_scheduling_clauses(res, project_folder_path, file_mapping)

        return res

    def __identify_scheduling_clauses(
        self, res: DetectionResult, project_folder_path: str, file_mapping_path: str
    ) -> DetectionResult:
        """Identifies scheduling clauses for suggestions and returns the updated DetectionResult"""
        # construct optimization graph (basically an acyclic representation of the PET)
        experiment = Experiment(project_folder_path, res, file_mapping_path)
        optimization_graph = OptimizationGraph(project_folder_path, experiment)

        import sys

        print("CREATED OPT GRAPH!\n################", file=sys.stderr)
        sys.exit(0)

        # todo
        return res
