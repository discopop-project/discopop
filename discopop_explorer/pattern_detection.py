# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os
import sys

from alive_progress import alive_bar  # type: ignore

from discopop_explorer.pattern_detectors.task_parallelism.task_parallelism_detector import (
    build_preprocessed_graph_and_run_detection as detect_tp,
)
from discopop_explorer.variable import Variable
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json
from discopop_library.discopop_optimizer.OptimizationGraph import OptimizationGraph
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.system.System import System
from discopop_library.discopop_optimizer.scheduling.workload_delta import (
    get_workload_delta_for_cu_node,
)
from discopop_library.discopop_optimizer.utilities.MOGUtilities import get_nodes_from_cu_id
from discopop_library.result_classes.DetectionResult import DetectionResult
from .PEGraphX import DummyNode, LoopNode, NodeID, PEGraphX, EdgeType
from .pattern_detectors.do_all_detector import DoAllInfo, run_detection as detect_do_all
from .pattern_detectors.geometric_decomposition_detector import run_detection as detect_gd
from .pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from .pattern_detectors.reduction_detector import run_detection as detect_reduction
from .pattern_detectors.simple_gpu_patterns.gpu_pattern_detector import run_detection as detect_gpu


class PatternDetectorX(object):
    pet: PEGraphX

    def __init__(self, pet_graph: PEGraphX) -> None:
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
        project_path,
        cu_dict,
        dependencies,
        loop_data,
        reduction_vars,
        file_mapping,
        cu_inst_result_file,
        llvm_cxxfilt_path,
        discopop_build_path,
        enable_patterns,
        enable_task_pattern,
        enable_detection_of_scheduling_clauses,
        hotspots,
    ):
        """Runs pattern discovery on the CU graph"""
        self.__merge(False, True)
        self.pet.map_static_and_dynamic_dependencies()
        self.pet.calculateFunctionMetadata(hotspots)
        self.pet.calculateLoopMetadata()
        res = DetectionResult(self.pet)

        # reduction before doall!

        if "*" in enable_patterns or "reduction" in enable_patterns:
            print("REDUCTIONS...")
            res.patterns.reduction = detect_reduction(self.pet, hotspots)
            print("\tDONE.")
        if "*" in enable_patterns or "doall" in enable_patterns:
            print("DOALL...")
            res.patterns.do_all = detect_do_all(self.pet, hotspots, res.patterns.reduction)
            print("\tDONE.")
        if "*" in enable_patterns or "pipeline" in enable_patterns:
            print("PIPELINE...")
            res.patterns.pipeline = detect_pipeline(self.pet, hotspots)
            print("\tDONE.")
        if "*" in enable_patterns or "geodec" in enable_patterns:
            print("GEO. DEC...")
            res.patterns.geometric_decomposition = detect_gd(self.pet, hotspots)
            print("\tDONE.")

        # check if task pattern should be enabled
        if enable_task_pattern:
            res.patterns.task = detect_tp(
                cu_dict,
                dependencies,
                reduction_vars,
                file_mapping,
                cu_inst_result_file,
                llvm_cxxfilt_path,
                discopop_build_path,
                hotspots,
            )

        # detect GPU patterns based on previously identified patterns
        if "*" in enable_patterns or "simplegpu" in enable_patterns:
            print("SIMPLE GPU...")
            res.patterns.simple_gpu = detect_gpu(self.pet, res, project_path)
            print("\tDONE.")

        # detect combined GPU patterns
        # disabled currently due to high additional overhead.
        # will be moved and calculated based on the optimization graph
        # res.combined_gpu = detect_combined_gpu(self.pet, res, project_folder_path)

        #        if enable_detection_of_scheduling_clauses:
        # identify scheduling clauses
        #            return self.__identify_scheduling_clauses(res, project_path, file_mapping)
        return res

    # todo: re-enable identification of scheduling clauses
    #   def __identify_scheduling_clauses(
    #       self,
    #       res: DetectionResult,
    #       project_folder_path: str,
    #       file_mapping_path: str,
    #   ) -> DetectionResult:
    #       """Identifies scheduling clauses for suggestions and returns the updated DetectionResult"""
    #       # construct optimization graph (basically an acyclic representation of the PET)
    #       system = System()
    #       discopop_output_path = project_folder_path
    #       discopop_optimizer_path = "INVALID_DUMMY"
    #       code_export_path = "INVALID_DUMMY"
    #       arguments_1 = {"--compile-command": "make"}
    #       experiment = Experiment(
    #           project_folder_path,
    #           discopop_output_path,
    #           discopop_optimizer_path,
    #           code_export_path,
    #           file_mapping_path,
    #           system,
    #           res,
    #           arguments_1,
    #       )
    #       arguments_2 = {"--exhaustive-search": False, "--headless-mode": True}
    #       optimization_graph = OptimizationGraph(project_folder_path, experiment, arguments_2, None, False)
    #
    #        for do_all_suggestion in res.do_all:
    #            for node_id in get_nodes_from_cu_id(experiment.optimization_graph, do_all_suggestion.node_id):
    #                workload_delta, min_workload, max_workload = get_workload_delta_for_cu_node(experiment, node_id)
    #                print(
    #                    "DOALL @ ",
    #                    do_all_suggestion.node_id,
    #                    " -> ",
    #                    "node_id: ",
    #                    node_id,
    #                    " --> Delta WL: ",
    #                    workload_delta,
    #                    " (",
    #                    min_workload,
    #                    "/",
    #                    max_workload,
    #                    ")",
    #                    file=sys.stderr,
    #                )
    #                # todo
    #                #  very naive and non-robust approach, needs improvement in the future
    #                #  reflects the behavior as described in https://dl.acm.org/doi/pdf/10.1145/3330345.3330375
    #                if workload_delta != 0:
    #                    do_all_suggestion.scheduling_clause = "dynamic"
    #
    #        return res

    def load_existing_doall_and_reduction_patterns(
        self,
        project_path,
        cu_dict,
        dependencies,
        loop_data,
        reduction_vars,
        file_mapping,
        cu_inst_result_file,
        llvm_cxxfilt_path,
        discopop_build_path,
        enable_patterns,
        enable_task_pattern,
        enable_detection_of_scheduling_clauses,
        hotspots,
    ):
        """skips the pattern discovery on the CU graph and loads a pre-existing pattern file"""
        self.__merge(False, True)
        self.pet.map_static_and_dynamic_dependencies()
        self.pet.calculateFunctionMetadata(hotspots)
        self.pet.calculateLoopMetadata()
        res = DetectionResult(self.pet)

        # init pattern lists
        res.patterns.reduction = []
        res.patterns.do_all = []
        res.patterns.pipeline = []
        res.patterns.geometric_decomposition = []
        res.patterns.task = []
        res.patterns.simple_gpu = []
        res.patterns.combined_gpu = []
        res.patterns.optimizer_output = []
        res.patterns.merged_pattern = []

        if not os.path.exists(os.path.join("explorer", "patterns.json")):
            raise FileNotFoundError(os.path.join("explorer", "patterns.json"))

        pattern_contents = read_patterns_from_json_to_json(
            os.path.join("explorer", "patterns.json"), ["do_all", "reduction"]
        )
        print("PATTERNS:")
        print(pattern_contents)

        def __get_var_obj_from_name(name):
            return Variable(type="", name=name, defLine="", accessMode="", sizeInByte="0")

        def __get_red_var_obj_from_name(name):
            split_name = name.split(":")
            v = Variable(type="", name=split_name[0], defLine="", accessMode="", sizeInByte="0")
            v.operation = split_name[1]
            return v

        # unpack do_all
        for pattern_json_str in pattern_contents["do_all"]:
            pattern_dict = json.loads(pattern_json_str)
            pt = DoAllInfo(self.pet, self.pet.node_at(pattern_dict["node_id"]))
            # patternBase
            pt.pattern_id = pattern_dict["pattern_id"]
            pt.node_id = pattern_dict["node_id"]
            pt.start_line = pattern_dict["start_line"]
            pt.end_line = pattern_dict["end_line"]
            pt.applicable_pattern = pattern_dict["applicable_pattern"]
            # patternInfo
            pt.iterations_count = pattern_dict["iterations_count"]
            pt.average_iteration_count = pattern_dict["average_iteration_count"]
            pt.entries = pattern_dict["entries"]
            pt.workload = pattern_dict["workload"]
            pt.per_iteration_workload = pattern_dict["per_iteration_workload"]
            pt.device_id = pattern_dict["device_id"]
            pt.device_type = pattern_dict["device_type"]
            # doall specific
            pt.first_private = [__get_var_obj_from_name(v) for v in pattern_dict["first_private"]]
            pt.private = [__get_var_obj_from_name(v) for v in pattern_dict["private"]]
            pt.last_private = [__get_var_obj_from_name(v) for v in pattern_dict["last_private"]]
            pt.shared = [__get_var_obj_from_name(v) for v in pattern_dict["shared"]]
            pt.reduction = [__get_red_var_obj_from_name(v) for v in pattern_dict["reduction"]]
            pt.scheduling_clause = pattern_dict["scheduling_clause"]
            pt.collapse_level = pattern_dict["collapse_level"]
            res.patterns.do_all.append(pt)

        # unpack reduction
        for pattern_json_str in pattern_contents["reduction"]:
            pattern_dict = json.loads(pattern_json_str)
            pt = DoAllInfo(self.pet, self.pet.node_at(pattern_dict["node_id"]))
            # patternBase
            pt.pattern_id = pattern_dict["pattern_id"]
            pt.node_id = pattern_dict["node_id"]
            pt.start_line = pattern_dict["start_line"]
            pt.end_line = pattern_dict["end_line"]
            pt.applicable_pattern = pattern_dict["applicable_pattern"]
            # patternInfo
            pt.iterations_count = pattern_dict["iterations_count"]
            pt.average_iteration_count = pattern_dict["average_iteration_count"]
            pt.entries = pattern_dict["entries"]
            pt.workload = pattern_dict["workload"]
            pt.per_iteration_workload = pattern_dict["per_iteration_workload"]
            pt.device_id = pattern_dict["device_id"]
            pt.device_type = pattern_dict["device_type"]
            # reduction specific
            pt.first_private = [__get_var_obj_from_name(v) for v in pattern_dict["first_private"]]
            pt.private = [__get_var_obj_from_name(v) for v in pattern_dict["private"]]
            pt.last_private = [__get_var_obj_from_name(v) for v in pattern_dict["last_private"]]
            pt.shared = [__get_var_obj_from_name(v) for v in pattern_dict["shared"]]
            pt.reduction = [__get_red_var_obj_from_name(v) for v in pattern_dict["reduction"]]
            res.patterns.reduction.append(pt)

        return res
