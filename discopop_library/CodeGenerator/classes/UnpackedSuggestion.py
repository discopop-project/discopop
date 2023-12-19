# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import Dict, List, Any, Optional

from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Enums import (
    EntryPointType,
    EntryPointPositioning,
    UpdateType,
    ExitPointType,
    ExitPointPositioning,
)
from discopop_library.CodeGenerator.classes.Enums import (
    OmpConstructPositioning,
    PragmaPosition,
)
from discopop_library.CodeGenerator.classes.Pragma import Pragma
from discopop_library.discopop_optimizer.classes.system.devices.DeviceTypeEnum import DeviceTypeEnum
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID


class UnpackedSuggestion(object):
    type: str
    values: Dict[str, Any]
    file_id: int
    start_line: int
    end_line: int
    device_id: Optional[DeviceID]
    device_type: Optional[DeviceTypeEnum]
    host_device_id: int

    def __init__(self, type_str: str, values: Dict[str, Any], device_id=None, device_type=None, host_device_id=0):
        self.type = type_str
        self.values = values
        self.device_id = device_id
        self.device_type = device_type
        self.host_device_id = host_device_id

        # get start and end line of target section
        self.file_id = int(self.values["start_line"].split(":")[0])
        self.start_line = int(self.values["start_line"].split(":")[1])
        self.end_line = int(self.values["end_line"].split(":")[1])

        # read device id and type if present
        if self.device_id is None and "device_id" in self.values:
            if self.values["device_id"] is not None:
                self.device_id = int(self.values["device_id"])
        if self.device_type is None and "device_type" in self.values:
            if self.values["device_type"] is not None:
                self.device_type = self.values["device_type"]


    def __get_device_update_pragmas(self):
        pragmas = []
        pragma = Pragma()

        source_device_id = int(self.values["source_device_id"])
        target_device_id = int(self.values["target_device_id"])
        var_name = self.values["var_name"]
        is_first_data_occurrence: bool = self.values["is_first_data_occurrence"]
        openmp_source_device_id = self.values["openmp_source_device_id"]
        openmp_target_device_id = self.values["openmp_target_device_id"]
        print("IS FIRST DATA OCCURRENCE?: ", is_first_data_occurrence)

        if source_device_id == self.host_device_id and target_device_id == self.host_device_id:
            # no update required
            pass
        elif source_device_id == self.host_device_id and target_device_id != self.host_device_id:
            # update type to
            if is_first_data_occurrence:
                pragma.pragma_str = "#pragma omp target enter data map(to:"
            else:
                pragma.pragma_str = "#pragma omp target update to("
            pragma.pragma_str += (
                var_name
                + ") device("
                # + str(openmp_source_device_id)
                # + " -> "
                + str(openmp_target_device_id)
                + ")"
            )

        elif source_device_id != self.host_device_id and target_device_id == self.host_device_id:
            # update type from
            if is_first_data_occurrence:
                pragma.pragma_str = "#pragma omp target exit data map(from:"
            else:
                pragma.pragma_str = "#pragma omp target update from("

            pragma.pragma_str += (
                var_name
                + ") device("
                + str(openmp_source_device_id)
                # + " -> "
                # + str(openmp_target_device_id)
                + ")"
            )

        else:
            # todo Implement updates between devices
            #  Suggest two update instructions instead of one, or make sure that openMP supports device-device updates

            # raise NotImplementedError("Updates between devices are not yet implemented!")
            # update between two devices
            pragma.pragma_str = (
                "#pragma omp target update Device("
                + str(source_device_id)
                + ") --> Device("
                + str(openmp_source_device_id)
                + " -> "
                + str(openmp_target_device_id)
                + ") Var("
                + var_name
                + ")"
            )

        #            #  map to host
        #            pragma.pragma_str = (
        #                # "#pragma omp target map(from:"
        #                    "#pragma omp target enter data map(to:"
        #                    + var_name
        #                    + ") device("
        #                    + str(source_device_id)
        #                    + ")"
        #            )
        #            #  map from host to second device
        #            pragma.pragma_str = (
        #                    "#pragma omp target data map(from:"
        #                    + var_name
        #                    + ") device("
        #                    + str(target_device_id)
        #                    + ")"
        #            )

        pragma.file_id = self.file_id
        pragma.start_line = self.start_line
        pragma.end_line = self.end_line
        pragma.pragma_position = PragmaPosition.BEFORE_END

        if len(pragma.pragma_str) != 0:
            pragmas.append(pragma)
        return pragmas

    def __get_do_all_and_reduction_pragmas(self, is_gpu_pragma: bool) -> List[Pragma]:
        pragmas = []
        pragma = Pragma()
        if is_gpu_pragma:
            # get device id for execution (else branch for compatibility with "legacy" gpu suggestions)
            if self.device_id is not None:
                device_id = self.device_id
            else:
                device_id = self.values["dp_optimizer_device_id"]

            pragma.pragma_str = "#pragma omp target teams distribute parallel for "
            pragma.pragma_str += "device(" + str(device_id) + ") "
        else:
            pragma.pragma_str = "#pragma omp parallel for "
        if len(self.values["first_private"]) > 0:
            pragma.pragma_str += "firstprivate(" + ",".join(self.values["first_private"]) + ") "
        if len(self.values["private"]) > 0:
            pragma.pragma_str += "private(" + ",".join(self.values["private"]) + ") "
        if len(self.values["last_private"]) > 0:
            pragma.pragma_str += "lastprivate(" + ",".join(self.values["last_private"]) + ") "
        if len(self.values["shared"]) > 0:
            pragma.pragma_str += "shared(" + ",".join(self.values["shared"]) + ") "
        if len(self.values["reduction"]) > 0:
            reductions_dict: Dict[str, List[str]] = dict()
            for entry in self.values["reduction"]:
                red_type: str = entry.split(":")[0]
                var: str = entry.split(":")[1]
                if red_type not in reductions_dict:
                    reductions_dict[red_type] = []
                reductions_dict[red_type].append(var)
            for red_type in reductions_dict:
                pragma.pragma_str += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "

        pragma.file_id = self.file_id
        pragma.start_line = self.start_line
        pragma.end_line = self.end_line

        pragmas.append(pragma)
        return pragmas

    def __get_pipeline_pragmas(self) -> List[Pragma]:
        pragmas = []

        for stage in self.values["stages"]:
            pragma = Pragma()
            pragma.file_id = self.file_id
            pragma.start_line = int(stage["startsAtLine"].split(":")[1])
            pragma.end_line = int(stage["endsAtLine"].split(":")[1])
            pragma.pragma_str = "#pragma omp task "
            if len(stage["first_private"]) > 0:
                pragma.pragma_str += "firstprivate(" + ",".join(stage["first_private"]) + ") "
            if len(stage["private"]) > 0:
                pragma.pragma_str += "private(" + ",".join(stage["private"]) + ") "
            if len(stage["shared"]) > 0:
                pragma.pragma_str += "shared(" + ",".join(stage["shared"]) + ") "
            if len(stage["reduction"]) > 0:
                reductions_dict: Dict[str, List[str]] = dict()
                for entry in stage["reduction"]:
                    red_type: str = entry.split(":")[0]
                    var: str = entry.split(":")[1]
                    if red_type not in reductions_dict:
                        reductions_dict[red_type] = []
                    reductions_dict[red_type].append(var)
                for red_type in reductions_dict:
                    pragma.pragma_str += "reduction(" + red_type + ":" + ",".join(reductions_dict[red_type]) + ") "
            if len(stage["in_deps"]) > 0:
                pragma.pragma_str += "depends(in:" + ",".join(stage["in_deps"]) + ") "
            if len(stage["out_deps"]) > 0:
                pragma.pragma_str += "depends(out:" + ",".join(stage["out_deps"]) + ") "
            if len(stage["in_out_deps"]) > 0:
                pragma.pragma_str += "depends(inout:" + ",".join(stage["in_out_deps"]) + ") "
            pragmas.append(pragma)
        return pragmas

    def __get_simple_gpu_pragmas(
        self,
        region_start,
        region_end,
        contained_loops,
        map_to_vars,
        map_from_vars,
        map_to_from_vars,
        map_alloc_vars,
        map_delete_vars,
        consumed_vars,
        produced_vars,
        indentation: int = 0,
        ignore_mapping_clauses: bool = False,
    ) -> List[Pragma]:
        pragmas = []

        region_start_line = int(region_start.split(":")[1])
        region_end_line = int(region_end.split(":")[1])
        for loop in contained_loops:
            loop_start = loop["start_line"]
            loop_start_line = int(loop_start.split(":")[1])
            loop_end = loop["end_line"]
            loop_end_line = int(loop_end.split(":")[1])
            loop_pragma = Pragma()
            loop_pragma.start_line = loop_start_line
            loop_pragma.end_line = loop_end_line
            loop_pragma.file_id = int(loop_start.split(":")[0])
            for construct in loop["constructs"]:
                construct_start = construct["line"]
                mark_invalid = False
                if ":" not in construct_start:
                    # invalid construct, line has no position
                    mark_invalid = True
                    construct_start = loop_start
                construct_start_line = int(construct_start.split(":")[1])
                child_pragma = Pragma()
                if mark_invalid:
                    child_pragma.pragma_str = "// INVALID - MISSING POSITION:: " + construct["name"] + " "
                else:
                    child_pragma.pragma_str = construct["name"] + " "
                if loop["collapse"] > 1:
                    child_pragma.pragma_str += "collapse(" + str(loop["collapse"]) + ") "
                for clause in construct["clauses"]:
                    if ignore_mapping_clauses:
                        if clause.startswith("map("):
                            continue
                    child_pragma.pragma_str += clause + " "
                # determine start_line and end_line
                if construct_start_line == loop_start_line:
                    # if construct targets loop, use loop scope
                    start_line = loop_start_line
                    end_line = loop_end_line
                elif loop_start_line <= construct_start_line <= loop_end_line:
                    # if construct is inside loop scope, start at construct line and end at loop scope
                    # (should not be used currently)
                    start_line = construct_start_line
                    end_line = loop_end_line
                else:
                    # else, use construct line
                    start_line = construct_start_line
                    end_line = construct_start_line
                # determine positioning of the pragma
                if construct["positioning"] == OmpConstructPositioning.BEFORE_LINE:
                    child_pragma.pragma_position = PragmaPosition.BEFORE_START
                elif construct["positioning"] == OmpConstructPositioning.AFTER_LINE:
                    child_pragma.pragma_position = PragmaPosition.AFTER_START
                else:
                    raise ValueError("Unsupported positioning information: ", construct["positioning"])
                # create pragma for visualization
                child_pragma.start_line = start_line
                child_pragma.end_line = end_line
                child_pragma.file_id = self.file_id
                loop_pragma.children.append(child_pragma)
            pragmas.append(loop_pragma)
        return pragmas

    def __get_update_pragmas(self, update_instructions) -> List[Pragma]:
        pragmas = []
        for source_cu_id, sink_cu_id, update_type, target_var, pragma_line in update_instructions:
            pragma = Pragma()
            pragma.pragma_str = "#pragma omp target update "

            if update_type == UpdateType.TO_DEVICE:
                # to device means host is writing, so update after the instruction
                pragma.pragma_position = PragmaPosition.BEFORE_START  # PragmaPosition.AFTER_END
                pragma.pragma_str += "to("
            elif update_type == UpdateType.FROM_DEVICE:
                # from device means host is reading, so update before the instruction
                pragma.pragma_position = PragmaPosition.BEFORE_START
                pragma.pragma_str += "from("
            elif update_type == UpdateType.ALLOCATE:
                # allocate memory, not written to before
                pragma.pragma_position = PragmaPosition.BEFORE_START
                pragma.pragma_str += "alloc("
            else:
                raise ValueError("Unsupported update type: ", update_type)
            pragma.pragma_str += target_var + ") "
            pragma.pragma_str += " // @CU " + source_cu_id + " -> " + sink_cu_id + " "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragmas.append(pragma)
        return pragmas

    def __get_data_region_dependencies(self, depend_in, depend_out) -> List[Pragma]:
        pragmas = []
        for var_name, cu_id, pragma_line in depend_in:
            pragma = Pragma()
            pragma.pragma_str = "#depend in(" + var_name + ") @ " + cu_id + " "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragma.pragma_position = PragmaPosition.BEFORE_START
            pragmas.append(pragma)

        for var_name, cu_id, pragma_line in depend_out:
            pragma = Pragma()
            pragma.pragma_str = "#depend out(" + var_name + ") @ " + cu_id + " "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            pragma.pragma_position = PragmaPosition.BEFORE_START
            pragmas.append(pragma)

        return pragmas

    def __get_data_region_pragmas(self, entry_points, exit_points) -> List[Pragma]:
        pragmas = []
        for (
            var_name,
            source_cu_id,
            sink_cu_id,
            entry_point_type,
            pragma_line,
            entry_point_positioning,
        ) in entry_points:
            pragma = Pragma()
            pragma.pragma_str = "#pragma omp target enter data "
            if entry_point_type == EntryPointType.TO_DEVICE:
                pragma.pragma_str += "map(to: "
            elif entry_point_type == EntryPointType.ALLOCATE:
                pragma.pragma_str += "map(alloc: "
            elif entry_point_type == EntryPointType.ASYNC_TO_DEVICE:
                pragma.pragma_str += "nowait map(to: "
            elif entry_point_type == EntryPointType.ASYNC_ALLOCATE:
                pragma.pragma_str += "nowait map(alloc:"
            else:
                raise ValueError("Usupported EntryPointType: ", entry_point_type)
            pragma.pragma_str += var_name + ") "
            pragma.pragma_str += " // @CU " + source_cu_id + " -> " + sink_cu_id + " "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            if entry_point_positioning == EntryPointPositioning.BEFORE_CU:
                pragma.pragma_position = PragmaPosition.BEFORE_START
            elif entry_point_positioning == EntryPointPositioning.AFTER_CU:
                pragma.pragma_position = PragmaPosition.AFTER_END
            else:
                raise ValueError("Usupported ExitPointPositioning: ", entry_point_positioning)
            pragmas.append(pragma)

        for (
            var_name,
            source_cu_id,
            sink_cu_id,
            exit_point_type,
            pragma_line,
            exit_point_positioning,
        ) in exit_points:
            pragma = Pragma()
            pragma.pragma_str = "#pragma omp target exit data "
            if exit_point_type == ExitPointType.FROM_DEVICE:
                pragma.pragma_str += "map(from: "
            elif exit_point_type == ExitPointType.DELETE:
                pragma.pragma_str += "map(delete: "
            elif exit_point_type == ExitPointType.ASYNC_FROM_DEVICE:
                pragma.pragma_str += "nowait map(from: "
            else:
                raise ValueError("Usupported ExitPointType: ", exit_point_type)
            pragma.pragma_str += var_name + ") "
            pragma.pragma_str += " // @CU " + source_cu_id + " -> " + sink_cu_id + " "
            pragma_line_num = int(pragma_line.split(":")[1])
            pragma.start_line = pragma_line_num
            pragma.end_line = pragma_line_num
            pragma.file_id = self.file_id
            if exit_point_positioning == ExitPointPositioning.BEFORE_CU:
                pragma.pragma_position = PragmaPosition.BEFORE_START
            elif exit_point_positioning == ExitPointPositioning.AFTER_CU:
                pragma.pragma_position = PragmaPosition.AFTER_END
            else:
                raise ValueError("Usupported ExitPointPositioning: ", exit_point_positioning)
            pragmas.append(pragma)
        return pragmas

    def __get_combined_gpu_pragmas(self) -> List[Pragma]:
        pragmas = []
        # add async data movement
        pragmas += self.__get_data_region_pragmas(
            self.values["data_region_entry_points"], self.values["data_region_exit_points"]
        )
        # add dependencies
        pragmas += self.__get_data_region_dependencies(
            self.values["data_region_depend_in"], self.values["data_region_depend_out"]
        )

        # add update instructions to pragmas
        pragmas += self.__get_update_pragmas(self.values["update_instructions"])

        # add gpu loops
        for region in self.values["contained_regions"]:
            pragmas += self.__get_simple_gpu_pragmas(
                region["start_line"],
                region["end_line"],
                region["contained_loops"],
                region["map_to_vars"],
                region["map_from_vars"],
                region["map_to_from_vars"],
                region["map_alloc_vars"],
                region["map_delete_vars"],
                region["consumed_vars"],
                region["produced_vars"],
                indentation=0,
                ignore_mapping_clauses=True,
            )

        return pragmas

    def get_pragmas(self) -> List[Pragma]:
        """returns a list of source code lines and pragmas to be inserted into the code preview"""
        pragmas = []

        if self.type in ["do_all", "reduction", "gpu_do_all", "gpu_reduction"]:
            execute_on_gpu = "gpu_" in self.type or self.device_type == DeviceTypeEnum.GPU
            pragmas += self.__get_do_all_and_reduction_pragmas(execute_on_gpu)
            return pragmas
        elif self.type == "pipeline":
            pragmas += self.__get_pipeline_pragmas()
        elif self.type == "simple_gpu":
            pragmas += self.__get_simple_gpu_pragmas(
                self.values["start_line"],
                self.values["end_line"],
                self.values["contained_loops"],
                self.values["map_to_vars"],
                self.values["map_from_vars"],
                self.values["map_to_from_vars"],
                self.values["map_alloc_vars"],
                self.values["map_delete_vars"],
                self.values["consumed_vars"],
                self.values["produced_vars"],
            )
        elif self.type == "combined_gpu":
            pragmas += self.__get_combined_gpu_pragmas()
        elif self.type == "device_update":
            pragmas += self.__get_device_update_pragmas()
        else:
            pragma = Pragma()
            pragma.file_id = self.file_id
            pragma.start_line = self.start_line
            pragma.end_line = self.end_line
            pragma.pragma_str = "#CURRENTLY UNSUPPORTED PREVIEW FOR TYPE: " + self.type
            pragmas.append(pragma)
        return pragmas
