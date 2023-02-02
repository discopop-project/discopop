# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from enum import IntEnum
from typing import List, Tuple, cast, Dict, Optional, Set, Any

from discopop_explorer.PETGraphX import EdgeType, CUNode, Dependency, PETGraphX, DepType, NodeType
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPULoop import GPULoopPattern
from discopop_explorer.pattern_detectors.simple_gpu_patterns.GPURegions import GPURegionInfo


class UpdateType(IntEnum):
    TO_DEVICE = 0
    FROM_DEVICE = 1
    # TO_FROM should not occur ideally, since data should only be modified either on the host or the device for now
    TO_FROM_DEVICE = 2


class EntryPointType(IntEnum):
    TO_DEVICE = 0
    ALLOCATE = 1
    ASYNC_TO_DEVICE = 2
    ASYNC_ALLOCATE = 3


class ExitPointType(IntEnum):
    FROM_DEVICE = 0
    DELETE = 1
    ASYNC_FROM_DEVICE = 2


class ExitPointPositioning(IntEnum):
    BEFORE_CU = 0
    AFTER_CU = 1


class EntryPointPositioning(IntEnum):
    BEFORE_CU = 0
    AFTER_CU = 1


class CombinedGPURegion(PatternInfo):
    contained_regions: List[GPURegionInfo]
    update_instructions: List[
        Tuple[str, str, UpdateType, str, str]
    ]  # (source_cu_id, sink_cu_id, UpdateType, target_vars, meta_line_num)
    target_data_regions: Dict[str, List[Tuple[List[str], str, str, str, str]]]
    # {var: ([contained cu_s], entry_cu, exit_after_cu, meta_entry_line_num, meta_exit_line_num)
    data_region_entry_points: List[
        Tuple[str, str, EntryPointType, str, EntryPointPositioning]
    ]  # [(var, cu_id, entry_point_type, meta_line_num)]
    data_region_exit_points: List[
        Tuple[str, str, ExitPointType, str, ExitPointPositioning]
    ]  # [(var, cu_id, exit_point_type, meta_line_num)]
    data_region_depend_in: List[
        Tuple[str, str, str, EntryPointPositioning]
    ]  # [(var, cu_id, meta_line_num)]
    data_region_depend_out: List[
        Tuple[str, str, str, ExitPointPositioning]
    ]  # [(var, cu_id, meta_line_num)]
    device_cu_ids: List[str]
    host_cu_ids: List[str]
    # meta information, mainly for display and overview purposes
    meta_device_lines: List[str]
    meta_host_lines: List[str]
    meta_device_liveness: Dict[str, List[str]]
    meta_host_liveness: Dict[str, List[str]]

    def __init__(self, pet: PETGraphX, contained_regions: List[GPURegionInfo]):
        node_id = sorted([region.node_id for region in contained_regions])[0]
        device_cu_ids = []
        for region in contained_regions:
            device_cu_ids += region.contained_cu_ids
            device_cu_ids = list(set(device_cu_ids))
        PatternInfo.__init__(self, pet.node_at(node_id))
        self.contained_regions = contained_regions
        self.device_cu_ids = device_cu_ids
        self.start_line = min([l.start_line for l in contained_regions])
        self.end_line = max([l.end_line for l in contained_regions])
        self.host_cu_ids = self.__get_host_cu_ids(pet)
        print("\n\n")
        print("HOST CU IDS: ")
        print(self.host_cu_ids)
        print("DEVICE CU IDS: ")
        print(self.device_cu_ids)
        pairwise_reachability = self.__get_pairwise_reachability(pet)
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]] = []
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]] = []

        #        # get a representation of the currently available mapping information
        #        entry_points, exit_points = self.__translate_mapping_to_explicit_data_entry_and_exit_points(
        #            pet
        #        )

        # ### STEP 1: INITIALIZATION

        # discard current mapping information
        entry_points = []
        exit_points = []

        # get written memory regions by CU
        written_memory_regions_by_cu: Dict[str, Set[str]] = self.__get_written_memory_regions_by_cu(
            pet
        )

        # get memory region and variable associations for each CU
        cu_and_variable_to_memory_regions: Dict[
            str, Dict[str, Set[str]]
        ] = self.__get_memory_region_and_variable_associations(pet, written_memory_regions_by_cu)

        # ### STEP 2: CALCULATE LIVE DATA

        # calculate live data
        device_liveness = self.__populate_live_data(pet, ignore_update_instructions=True)

        # extend device liveness with memory regions
        device_liveness_plus_memory_regions: Dict[
            str, List[Tuple[str, Set[str]]]
        ] = self.__add_memory_regions_to_device_liveness(
            device_liveness, cu_and_variable_to_memory_regions
        )

        # propagate memory regions
        device_liveness_plus_memory_regions = self.__propagate_memory_regions(
            device_liveness_plus_memory_regions
        )

        # extend data liveness
        # todo add the option to create memory or data transmission optimal liveness and thus data mappings
        #  For now, a minimal amount of data transmissions is targeted (by extending the data livespan).
        device_liveness_plus_memory_regions = self.__extend_data_lifespan(
            pet, device_liveness_plus_memory_regions
        )

        # calculate host liveness
        host_liveness: Dict[str, List[Tuple[str, Set[str]]]] = self.__calculate_host_liveness(pet)

        # extend host livespan
        host_liveness = self.__extend_data_lifespan(pet, host_liveness)

        # ### STEP 3: MARK WRITTEN VARIABLES

        # mark written variables for device
        extended_device_liveness = self.__mark_dirty_variables(
            pet,
            device_liveness_plus_memory_regions,
            written_memory_regions_by_cu,
            cu_and_variable_to_memory_regions,
            considered_cu_ids=self.device_cu_ids,
        )

        # mark written variables for host
        extended_host_liveness = self.__mark_dirty_variables(
            pet,
            host_liveness,
            written_memory_regions_by_cu,
            cu_and_variable_to_memory_regions,
            not_considered_cu_ids=self.device_cu_ids,
        )

        print("Extended device liveness: ")
        print(extended_device_liveness)

        # ### STEP 4: IDENTIFY SYNCHRONOUS UPDATE INSTRUCTIONS

        self.update_instructions = []
        self.update_instructions = self.__get_update_instructions_based_on_liveness(
            pet, extended_device_liveness, extended_host_liveness
        )

        #######################################

        # cautious property: remove calling cu's from liveness, if the called function has dependencies to any gpu loop.
        # device_liveness = self.__remove_liveness_for_calling_cus_if_required(pet, device_liveness)

        # self.__encapsulate_called_functions_which_share_data_with_device_cus(pet, liveness)

        # entry_points, exit_points = self.__optimize_data_mapping_entries(
        #    pet, entry_points, exit_points, liveness
        # )

        # todo restrict search for updates to function body, ignore called functions

        # move update instructions out of gpu loops
        #        self.__move_update_instructions_out_of_gpu_loops(pet)

        #       entry_points, exit_points = self.__find_data_mapping_exits(
        #           pet, entry_points, exit_points, liveness
        #       )

        # replace updates with entries and exits, if no predecessor / successor exists
        # TODO CURRENT WORKPACKAGE: NON-VALID EXIT FROM FOR SAXPY_ASYNC (X1)
        #        entry_points, exit_points = self.__replace_updates_with_entry_or_exit_points_if_possible(
        #            pet, entry_points, exit_points
        #        )

        # todo validate entry and exit points

        # self.__optimize_data_mapping(pet, pairwise_reachability)
        #    entry_points, exit_points = self.__get_explicit_data_entry_and_exit_points(pet)

        # todo: if incoming dependencies which can not be mapped to

        print("EXIT POINTS: ")
        print(exit_points)

        # find asynchronous mapping points
        # (
        #    self.data_region_entry_points,
        #    self.data_region_exit_points,
        #    self.data_region_depend_in,
        #    self.data_region_depend_out,
        # ) = self.__find_async_loading_points(pet, entry_points, exit_points)

        # todo re-enable, and disable async ?
        self.data_region_entry_points = entry_points
        self.data_region_exit_points = exit_points
        self.data_region_depend_in = []
        self.data_region_depend_out = []

        #        print("Entry Points:")
        #        print(entry_points)
        #        print("Exit Points:")
        #        print(exit_points)
        print("Update instructions:")
        print(self.update_instructions)
        print("Updated Entry Points:")
        print(self.data_region_entry_points)
        print("Updated Exit Points:")
        print(self.data_region_exit_points)

        print("Depend(in): ")
        print(self.data_region_depend_in)
        print("Depend(out):")
        print(self.data_region_depend_out)
        self.meta_device_lines = []
        self.meta_host_lines = []
        self.__get_metadata(pet, extended_device_liveness, extended_host_liveness)

    def __str__(self):
        raise NotImplementedError()  # used to identify necessity to call to_string() instead

    def to_string(self, pet: PETGraphX):
        contained_regions_str = "\n" if len(self.contained_regions) > 0 else ""
        for region in self.contained_regions:
            region_str = region.to_string(pet)
            # pretty printing
            region_str = "".join(["\t" + s + "\n" for s in region_str.split("\n")])
            contained_regions_str += region_str

        return (
            f"COMBINED GPU Region at: {self.node_id}\n"
            f"Start line: {self.start_line}\n"
            f"End line: {self.end_line}\n"
            f"Device CUs: {self.device_cu_ids}\n"
            f"Host CUs: {self.host_cu_ids}\n"
            f"Device lines: {self.meta_device_lines}\n"
            f"Host lines: {self.meta_host_lines}\n"
            f"Contained regions: {contained_regions_str}\n"
        )

    def __find_data_mapping_exits(
        self,
        pet: PETGraphX,
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
        liveness: Dict[str, List[str]],
    ):
        for region in self.contained_regions:
            for gpu_loop in region.contained_loops:
                print("GPU LOOP: ", gpu_loop.node_id)
                loop_subtree = [
                    n.id for n in pet.subtree_of_type(pet.node_at(gpu_loop.node_id), NodeType.CU)
                ]
                exit_cus_outside = [
                    pair[0]
                    for pair in self.__get_successors_outside_region(
                        pet, gpu_loop.node_id, loop_subtree + [gpu_loop.node_id]
                    )
                ]
                print("EXIT CUS: ", exit_cus_outside)

                # get killed data
                live_in_region: Set[Tuple[str, str]] = set()
                live_after_region: Set[Tuple[str, str]] = set()
                killing: Set[Tuple[str, str]] = set()
                for var_name in liveness:
                    for region_cu_id in loop_subtree:
                        if region_cu_id in liveness[var_name]:
                            live_in_region.add((var_name, region_cu_id))
                for var_name in liveness:
                    for exit_cu_id in exit_cus_outside:
                        if exit_cu_id in liveness[var_name]:
                            live_after_region.add((var_name, exit_cu_id))
                        else:
                            killing.add((var_name, exit_cu_id))

                to_be_killed: Set[Tuple[str, str]] = live_in_region
                for live_var_name_after_region, live_cu_id_after_region in live_after_region:
                    do_not_kill: Set[Tuple[str, str]] = set()
                    for var_name, in_cu_id in to_be_killed:
                        if var_name == live_var_name_after_region:
                            if pet.is_predecessor(in_cu_id, live_cu_id_after_region):
                                do_not_kill.add((var_name, in_cu_id))
                    to_be_killed = to_be_killed ^ do_not_kill

                identified_exit_points: Set[Tuple[str, str, ExitPointType]] = set()
                print("TO BE KILLED: ")
                print(to_be_killed)
                for var_name, live_cu_id in to_be_killed:
                    print("VAR Name: ", var_name, " live_cu_id: ", live_cu_id)
                    ept = ExitPointType.DELETE
                    in_raw_deps = pet.in_edges(live_cu_id, EdgeType.DATA)
                    # ept = FROM if incoming RAW edge to var_name exists

                    # TEST: check unfiltered deps for aliasing
                    unfiltered_in_raw_deps: List[Tuple[str, str, Dependency]] = [
                        (s, t, d)
                        for (s, t, d) in in_raw_deps
                        if d.dtype == DepType.RAW and s not in loop_subtree
                    ]
                    print("\t", [(str(s), str(t), str(d)) for s, t, d in unfiltered_in_raw_deps])

                    alias_raw_deps: List[Tuple[str, str, Dependency]] = [
                        (s, t, d)
                        for (s, t, d) in unfiltered_in_raw_deps
                        if pet.unused_check_alias(s, t, d, pet.node_at(gpu_loop.node_id))
                    ]
                    print(
                        "\t ALIAS DEPS: ", [(str(s), str(t), str(d)) for s, t, d in alias_raw_deps]
                    )
                    # since the de-aliasing is not trivial, assume each variable written in the targeted line
                    # is required to persist after the gpu region

                    # check if var_name is written at the line of any alias dep
                    alias_based_raw_deps: List[Tuple[Any, Any, Any]] = []
                    for s, t, d in alias_raw_deps:
                        line_num = d.source_line
                        print("\t\tLine num: ", line_num)
                        written_in_line: List[str] = []
                        # get incoming RAW edges
                        # get outgoing WAR / WAW edges

                        # check if s has incoming RAW dependencies at line_num for var_name
                        for dep_source, dep_target, in_dep in pet.in_edges(t, EdgeType.DATA):
                            if in_dep.dtype != DepType.RAW:
                                continue
                            if in_dep.var_name != var_name:
                                continue
                            alias_based_raw_deps.append((dep_source, dep_target, in_dep))
                            print(
                                "\t\tIN DEP TO: ",
                                dep_source,
                                dep_target,
                                in_dep.var_name,
                                in_dep.dtype,
                            )

                        # check if s has outgoing WAR or WAW dependencies at line_num for var_name
                        for dep_source, dep_target, out_dep in pet.out_edges(t, EdgeType.DATA):
                            if not (out_dep.dtype == DepType.WAR or out_dep.dtype == DepType.WAW):
                                continue
                            if out_dep.var_name != var_name:
                                continue
                            print(
                                "\t\tOUT DEP TO: ",
                                dep_source,
                                dep_target,
                                out_dep.var_name,
                                out_dep.dtype,
                            )
                            alias_based_raw_deps.append((dep_source, dep_target, out_dep))

                    # END TEST

                    filtered_in_raw_deps = [
                        (s, t, d)
                        for (s, t, d) in in_raw_deps
                        if d.dtype == DepType.RAW
                        and d.var_name == var_name
                        and s not in loop_subtree
                    ]
                    if len(filtered_in_raw_deps + alias_based_raw_deps) > 0:
                        ept = ExitPointType.FROM_DEVICE

                    # determine killing cu
                    for killed_var_name, killing_cu_id in killing:
                        if var_name == killed_var_name:
                            if pet.is_predecessor(live_cu_id, killing_cu_id):
                                identified_exit_points.add((var_name, killing_cu_id, ept))

                # cleanup identified exit points (required to remove deletions if map type from should be used instead)
                to_be_removed: Set[Tuple[str, str, ExitPointType]] = set()
                for elem_1 in identified_exit_points:
                    for elem_2 in identified_exit_points:
                        if elem_1 == elem_2:
                            continue
                        if elem_1[0] == elem_2[0] and elem_1[1] == elem_2[1]:
                            if (
                                elem_1[2] == ExitPointType.DELETE
                                and elem_2[2] == ExitPointType.FROM_DEVICE
                            ):
                                to_be_removed.add(elem_1)

                for elem in to_be_removed:
                    identified_exit_points.remove(elem)

                # create exit points
                for var_name, killing_cu_id, ept in identified_exit_points:
                    exit_cu_node = pet.node_at(killing_cu_id)
                    # check if location data for cu_id exists. may not be the case at the end of functions
                    if (
                        exit_cu_node.start_position() == "262143:16383"
                        or exit_cu_node.end_position() == "262143:16383"
                    ):
                        # no valid location data for killing_cu, get end of predecessor instead
                        predecessors = [
                            s for s, t, d in pet.in_edges(killing_cu_id, EdgeType.SUCCESSOR)
                        ]
                        for predecessor_id in predecessors:
                            predecessor_parent = [
                                s for s, t, d in pet.in_edges(predecessor_id, EdgeType.CHILD)
                            ][0]
                            exit_point = (
                                var_name,
                                killing_cu_id,
                                ept,
                                pet.node_at(predecessor_parent).end_position(),
                                ExitPointPositioning.AFTER_CU,
                            )
                            exit_points.append(exit_point)
                    else:
                        exit_point = (
                            var_name,
                            killing_cu_id,
                            ept,
                            pet.node_at(killing_cu_id).start_position(),
                            ExitPointPositioning.BEFORE_CU,
                        )
                    exit_points.append(exit_point)

        # remove duplicates
        exit_points = list(set(exit_points))

        return entry_points, exit_points

    def __get_successors_outside_region(
        self, pet: PETGraphX, root_node_id: str, region_node_ids: List[str]
    ) -> List[Tuple[str, str]]:
        """returns a list of tuples consisting of immediate successor nodes of the region and the last node within the region"""
        queue: List[Tuple[str, str]] = [(root_node_id, "")]
        visited: List[str] = []
        successors: List[Tuple[str, str]] = []
        while queue:
            current, predecessor = queue.pop(0)
            visited.append(current)
            if current not in region_node_ids:
                successors.append((current, predecessor))
                continue
            # add direct successors to queue
            queue += [
                (n.id, current)
                for n in pet.direct_successors(pet.node_at(current))
                if n.id not in visited and n.id not in queue
            ]
            # add children to queue
            queue += [
                (n.id, current)
                for n in pet.direct_children(pet.node_at(current))
                if n.id not in visited
                and n.id not in queue
                and n.id
                not in [
                    t for s, t, d in pet.out_edges(current, EdgeType.CALLSNODE)
                ]  # do not consider called functions as children
            ]
        return successors

    def __optimize_data_mapping_entries(
        self,
        pet: PETGraphX,
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
        liveness: Dict[str, List[str]],
    ):
        # optimize map to and map alloc
        to_be_removed: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]] = []
        for entry_point in entry_points:
            # check if entered data is already known on the device
            var_name, cu_id, ept, line_num, positioning = entry_point
            predecessors = [s for s, _, _ in pet.in_edges(cu_id, EdgeType.SUCCESSOR)]
            if len(predecessors) == 0 and len(pet.direct_children(pet.node_at(cu_id))) > 0:
                # add predecessors of first child to predecessors list (e.g. required for loops)
                first_child_id = pet.direct_children(pet.node_at(cu_id))[0].id
                predecessors += [s for s, _, _ in pet.in_edges(first_child_id, EdgeType.SUCCESSOR)]

            data_exists_on_all_predecessors = True
            for pred_id in predecessors:
                if pred_id not in liveness[var_name]:
                    data_exists_on_all_predecessors = False
                    break
            if data_exists_on_all_predecessors:
                to_be_removed.append(entry_point)
        # remove entry points
        for entry_point in to_be_removed:
            entry_points.remove(entry_point)
        return entry_points, exit_points

    def __get_function_body_cus_without_called_functions(
        self, pet: PETGraphX, function_node: CUNode
    ) -> List[str]:
        queue = [t for s, t, d in pet.out_edges(function_node.id, EdgeType.CHILD)]
        visited: Set[str] = set()
        while queue:
            current = queue.pop(0)
            visited.add(current)
            current_node = pet.node_at(current)

            # add children if they do not result from a call
            children = [t for s, t, d in pet.out_edges(current, EdgeType.CHILD)]
            called = [t for s, t, d in pet.out_edges(current, EdgeType.CALLSNODE)]
            queue += [
                c for c in children if c not in visited and c not in called
            ]  # todo add check for call
        return list(visited)

    def __get_update_instructions(
        self, pet: PETGraphX
    ) -> List[Tuple[str, str, UpdateType, str, str]]:
        """Identify update points and create a list of required update instructions to be inserted into
        the combined GPU region.
        Updates point are defined by data dependencies between host and device cu's."""
        update_instructions: List[
            Tuple[str, str, UpdateType, str, str]
        ] = []  # (source_cu_id, sink_cu_id, UpdateType, target_vars, meta_line_num)

        def determine_updates(source_cu_ids, sink_cu_ids, update_type):
            for sink_cu_id in sink_cu_ids:
                out_deps = [
                    (target_id, dep)
                    for _, target_id, dep in pet.out_edges(sink_cu_id)
                    if dep.var_name is not None and dep.dtype == DepType.RAW
                ]
                filtered_deps: List[Tuple[str, Dependency]] = [
                    (t, d) for (t, d) in out_deps if t in source_cu_ids
                ]
                # report UpdateInstructions
                for source_cu_id, dep in filtered_deps:
                    # use Host code to handle updates
                    if update_type == UpdateType.TO_DEVICE:
                        pragma_position = dep.sink_line
                    elif update_type == UpdateType.FROM_DEVICE:
                        pragma_position = dep.source_line
                    else:
                        raise ValueError("Unsupported update type: ", update_type)
                    update_instructions.append(
                        (
                            source_cu_id,
                            sink_cu_id,
                            update_type,
                            cast(str, dep.var_name),
                            pragma_position,
                        )
                    )

        # determine all host CU's within the parent function (superset of self.host_cu_ids)
        if not len(self.contained_regions) > 0:
            raise ValueError("No region contained!")
        parent_function = pet.get_parent_function(pet.node_at(self.contained_regions[0].node_id))
        # get host cu ids without called function bodies
        all_function_body_cu_ids = self.__get_function_body_cus_without_called_functions(
            pet, parent_function
        )
        all_host_cu_ids = [
            cu_id for cu_id in all_function_body_cu_ids if cu_id not in self.device_cu_ids
        ]

        # determine device to host updates
        determine_updates(self.device_cu_ids, all_host_cu_ids, UpdateType.FROM_DEVICE)

        # determine host to device updates
        determine_updates(all_host_cu_ids, self.device_cu_ids, UpdateType.TO_DEVICE)

        # cleanup update instructions (remove duplicates, combine updates of equal data for successors and children)
        # remove duplicates
        update_instructions = list(set(update_instructions))
        # if multiple updates with equal source and data exist, allow only such updates which have a predecessor on a
        # different device
        to_be_removed: List[Tuple[str, str, UpdateType, str, str]] = []
        for update_1 in update_instructions:
            for update_2 in update_instructions:
                if update_1 == update_2 or update_1[3] != update_2[3] or update_1[0] != update_2[0]:
                    continue
                # two updates with identical source and target variable found
                # if one is a successor of the other, keep the predecessor
                sink_1 = pet.node_at(update_1[1])
                sink_2 = pet.node_at(update_2[1])

                if pet.check_reachability(
                    sink_2, sink_1, [EdgeType.SUCCESSOR]
                ) and not pet.check_reachability(sink_1, sink_2, [EdgeType.SUCCESSOR]):
                    # sink_1 is a true predecessor of sink_2
                    to_be_removed.append(update_2)
                elif pet.check_reachability(
                    sink_1, sink_2, [EdgeType.SUCCESSOR]
                ) and not pet.check_reachability(sink_2, sink_1, [EdgeType.SUCCESSOR]):
                    # sink_2 is a true predecessor of sink_1
                    to_be_removed.append(update_1)
                else:
                    # no true predecessor relation (e.g. due to loops)
                    # determine predecessor based on predecessor location if possible
                    diff_device_predecessors = []
                    if update_1[1] in self.device_cu_ids:
                        diff_device_predecessors += [
                            s
                            for s, _, _ in pet.in_edges(update_1[1], EdgeType.SUCCESSOR)
                            if s in all_host_cu_ids
                        ]
                    elif update_1[2] in all_host_cu_ids:
                        diff_device_predecessors += [
                            s
                            for s, _, _ in pet.in_edges(update_1[1], EdgeType.SUCCESSOR)
                            if s in self.device_cu_ids
                        ]
                    if len(diff_device_predecessors) > 0:
                        to_be_removed.append(update_2)
                    else:
                        # else, determine predecessor based on start_line
                        if sink_1.start_line < sink_2.start_line:
                            to_be_removed.append(update_2)

        # ignore update instructions which result from the initialization of gpu for loops
        for update in update_instructions:
            source_cu_id, sink_cu_id, update_type, var_name, pragma_position = update
            for region in self.contained_regions:
                for gpu_loop in region.contained_loops:
                    # remove update if:
                    # sink in gpu_loop and
                    # source is predecessor of sink and
                    # dep.source line num == gpu_loop.start_line
                    if pet.node_at(sink_cu_id) in pet.direct_children(
                        pet.node_at(gpu_loop.node_id)
                    ):
                        if pet.node_at(sink_cu_id) in pet.direct_successors(
                            pet.node_at(source_cu_id)
                        ):
                            if pragma_position == gpu_loop.start_line:
                                to_be_removed.append(update)

        to_be_removed = list(set(to_be_removed))
        for update_1 in to_be_removed:
            if update_1 in update_instructions:
                update_instructions.remove(update_1)
        return update_instructions

    def __get_metadata(
        self,
        pet: PETGraphX,
        device_liveness: Dict[str, List[Tuple[str, Set[str], bool]]],
        host_liveness: Dict[str, List[Tuple[str, Set[str], bool]]],
    ):
        """Create metadata and store it in the respective fields."""
        for device_cu_id in self.device_cu_ids:
            device_cu = pet.node_at(device_cu_id)
            self.meta_device_lines = list(
                set(
                    self.meta_device_lines
                    + self.__get_contained_lines(
                        device_cu.start_position(), device_cu.end_position()
                    )
                )
            )
        for host_cu_id in self.host_cu_ids:
            host_cu = pet.node_at(host_cu_id)
            self.meta_host_lines = list(
                set(
                    self.meta_host_lines
                    + self.__get_contained_lines(host_cu.start_position(), host_cu.end_position())
                )
            )
        # get device liveness as metadata
        self.meta_device_liveness = dict()
        lines: Set[str] = set()
        for var_name in device_liveness:
            lines = set()
            for cu_id, memory_regions, dirty in device_liveness[var_name]:
                cu_node = pet.node_at(cu_id)
                for line in range(cu_node.start_line, cu_node.end_line + 1):
                    lines.add(
                        "" + str(cu_node.file_id) + ":" + str(line) + ":" + ("*" if dirty else "")
                    )
            self.meta_device_liveness[var_name] = list(lines)
        # get host liveness as metadata
        self.meta_host_liveness = dict()
        for var_name in host_liveness:
            lines = set()
            for cu_id, memory_regions, dirty in host_liveness[var_name]:
                cu_node = pet.node_at(cu_id)
                for line in range(cu_node.start_line, cu_node.end_line + 1):
                    lines.add(
                        "" + str(cu_node.file_id) + ":" + str(line) + ":" + ("*" if dirty else "")
                    )
            self.meta_host_liveness[var_name] = list(lines)

    def __get_contained_lines(self, start_line: str, end_line: str) -> List[str]:
        """Returns a list of line numbers inbetween start_line and end_line"""
        file_id = start_line.split(":")[0]
        if file_id != end_line.split(":")[0]:
            raise ValueError("File-ids not equal! ", start_line, end_line)
        line_numbers: List[int] = list(
            range(int(start_line.split(":")[1]), int(end_line.split(":")[1]) + 1)
        )
        result = [file_id + ":" + str(num) for num in line_numbers]
        return result

    def __get_host_cu_ids(self, pet: PETGraphX) -> List[str]:
        """identify CUs within the region which are not offloaded to a device."""
        host_cu_ids: List[str] = []
        for node_id_1 in self.device_cu_ids:
            for node_id_2 in self.device_cu_ids:
                if node_id_1 == node_id_2:
                    continue
                cu_ids_inbetween: List[str] = []
                # construct all paths from node_id_1 to node_id_2 and get all visited nodes
                queue: List[CUNode] = [pet.node_at(node_id_1)]
                while queue:
                    current = queue.pop()
                    if current.id == node_id_2:
                        # found target, stop searching on this branch
                        continue
                    else:
                        # add current to cu_ids_inbetween
                        cu_ids_inbetween.append(current.id)
                        # continue search for successors as long as line numbers potentially allow a match
                        queue += [
                            n
                            for n in pet.direct_successors(current)
                            if n.id not in cu_ids_inbetween
                            and n.id.split(":")[0] == node_id_2.split(":")[0]
                            and int(n.id.split(":")[1]) <= int(node_id_2.split(":")[1])
                        ]
                host_cu_ids += [
                    cu_id for cu_id in cu_ids_inbetween if cu_id not in self.device_cu_ids
                ]
        host_cu_ids = list(set(host_cu_ids))
        host_cu_ids = sorted(host_cu_ids)
        return host_cu_ids

    def __old_optimize_data_mapping(
        self, pet: PETGraphX, pairwise_reachability: List[Tuple[GPURegionInfo, GPURegionInfo]]
    ):
        """rely on the explicit update instructions for data synchronization within the region.
        Optimize mapping instructions for an efficient use within the region.
        Keep mapping instructions TO the first and FROM the last small GPU region in the combined GPU Region.
        Returns liveness information for each target variable."""
        if not len(self.contained_regions) > 1:
            # only optimize such data regions which contain at least two GPU regions
            return
        modification_found = True
        while modification_found:
            modification_found = False
            self.opt_split_map_type_to_from()
            modification_found = modification_found or self.opt_map_type_to(pairwise_reachability)
            modification_found = modification_found or self.opt_map_type_from(pairwise_reachability)
            self.opt_find_map_type_to_from()

        #        # calculate data liveness
        #        liveness: Dict[str, List[str]] = self.__analyze_live_data(pet)  # {var_name: [cu_ids]}
        #        print("LIVENESS")
        #        for key in liveness:
        #            print(key)
        #            live_lines = [pet.node_at(v).start_line for v in liveness[key]]
        #            live_lines = list(set(live_lines))
        #            live_lines = sorted(live_lines)
        #            print("\t", live_lines)
        #        print()

    def __unused_group_liveness(
        self, pet: PETGraphX, liveness: Dict[str, List[str]]
    ) -> Dict[str, List[List[str]]]:
        """Groups liveness information into reachable regions"""
        grouped_liveness: Dict[str, List[List[str]]] = dict()
        for var in liveness:
            groups: List[List[str]] = []
            for cu_1 in liveness[var]:
                # check if cu_1 belongs to a group
                belongs_to_any_group = False
                for idx, group in enumerate(groups):
                    belongs_to_group = False
                    for cu_2 in group:
                        if pet.check_reachability(
                            pet.node_at(cu_2), pet.node_at(cu_1), [EdgeType.SUCCESSOR]
                        ):
                            belongs_to_group = True
                    if belongs_to_group:
                        # append cu_1 to current group
                        groups[idx].append(cu_1)
                        belongs_to_any_group = True
                if not belongs_to_any_group:
                    # create a new group
                    groups.append([cu_1])
            grouped_liveness[var] = groups
        return grouped_liveness

    def opt_find_map_type_to_from(self):
        """Find pairs in map type TO and FROM and combine them into map type TO_FROM."""
        for region in self.contained_regions:
            buffer: List[str] = []
            for var_1 in region.map_to_vars:
                for var_2 in region.map_from_vars:
                    if var_1 == var_2:
                        # found match
                        buffer.append(var_1)
            buffer = list(set(buffer))
            for var in buffer:
                region.map_to_vars.remove(var)
                region.map_from_vars.remove(var)
                region.map_to_from_vars.append(var)
            region.map_to_from_vars = list(set(region.map_to_from_vars))

    def opt_split_map_type_to_from(self):
        """Split map type TO_FROM into TO and FROM for easier optimization."""
        for region in self.contained_regions:
            for var in region.map_to_from_vars:
                region.map_to_vars.append(var)
                region.map_from_vars.append(var)
                region.map_to_vars = list(set(region.map_to_vars))
                region.map_from_vars = list(set(region.map_from_vars))
            region.map_to_from_vars = []

    def opt_map_type_from(
        self, pairwise_reachability: List[Tuple[GPURegionInfo, GPURegionInfo]]
    ) -> bool:
        """Only allow map type FROM, if the data is not used by any successor.
        Return True if modification has been found."""
        modification_found = False
        for region in self.contained_regions:
            to_be_removed: List[str] = []
            successors = [s for p, s in pairwise_reachability if p == region]
            for succ in successors:
                for var in region.map_from_vars:
                    if var in succ.consumed_vars:
                        to_be_removed.append(var)
            to_be_removed = list(set(to_be_removed))
            for var in to_be_removed:
                if var in region.map_from_vars:
                    region.map_from_vars.remove(var)
                    modification_found = True
        return modification_found

    def opt_map_type_to(
        self, pairwise_reachability: List[Tuple[GPURegionInfo, GPURegionInfo]]
    ) -> bool:
        """Only allow map type TO, if the data is not mapped TO by any predecessor.
        Return True, if a modification has been found."""
        modification_found = False
        for region in self.contained_regions:
            to_be_removed: List[str] = []
            predecessors = [p for p, s in pairwise_reachability if s == region]
            for pred in predecessors:
                # validate map_type_to variables of region against pred
                for var in region.map_to_vars:
                    if var in pred.map_to_vars + pred.map_alloc_vars:
                        to_be_removed.append(var)
            to_be_removed = list(set(to_be_removed))
            for var in to_be_removed:
                if var in region.map_to_vars:
                    region.map_to_vars.remove(var)
                    modification_found = True
        return modification_found

    #        # todo below here should be replaced with a more intelligent solution
    #        # replace TOFROM with explicit TO and FROM mappings (note: TO and FROM to same variable in one pragma not valid)
    #        for region in self.contained_regions:
    #            for var in region.map_to_from_vars:
    #                region.map_to_vars.append(var)
    #                region.map_to_vars = list(set(region.map_to_vars))
    #                region.map_from_vars.append(var)
    #                region.map_from_vars = list(set(region.map_from_vars))
    #            region.map_to_from_vars = []
    #
    #        modification_found = True
    #        while modification_found:
    #            modification_found = False
    #            for region_1, region_2 in self.pairwise_reachability:
    #                # region_1 is a predecessor of region_2
    #                if self.__opt_move_TO_and_FROM_mappings(region_1, region_2):
    #                    modification_found = True
    #                    break

    def __opt_move_TO_and_FROM_mappings(self, region_1: GPURegionInfo, region_2: GPURegionInfo):
        """moves TO mappings forwards as far as possible.
        moves FROM mappings backwards as far as possible.
        returns True if a modifications has been done."""
        # todo only update if region_2 is a true successor of region_1 (currently, CombinedGPURegions can only consist of True successors)
        # todo determine mappings more intelligently
        # move TO mappings to the front
        # keep data alive if possible
        move_forwards = [
            var
            for var in region_2.map_to_vars
            if var in region_1.map_to_vars + region_1.map_alloc_vars
        ]
        region_2.map_to_vars = [var for var in region_2.map_to_vars if var not in move_forwards]
        if len(move_forwards) > 0:
            return True

        # move FROM mappings to the back
        # copy from at last region
        move_backwards = [var for var in region_1.map_from_vars if var in region_2.map_from_vars]
        region_1.map_from_vars = [
            var for var in region_1.map_from_vars if var not in move_backwards
        ]
        if len(move_backwards) > 0:
            return True

    def __get_pairwise_reachability(self, pet) -> List[Tuple[GPURegionInfo, GPURegionInfo]]:
        """Create a list of pairs of GPURegionInfo which represents pairwise reachability relation from
        Tuple[0] to Tuple[1]."""

        def is_successor_bfs(source_cu, target_cu):
            # returns true, if target_cu is a successor of source_cu
            # searches along successor paths using bfs search
            if source_cu == target_cu:
                return True
            queue: List[CUNode] = [source_cu]
            visited: List[CUNode] = []
            while queue:
                current = queue.pop(0)
                visited.append(current)
                if current == target_cu:
                    return True
                queue += [n for n in pet.direct_successors(current) if n not in visited]
            return False

        reachable_pairs: List[Tuple[GPURegionInfo, GPURegionInfo]] = []
        for region_1 in self.contained_regions:
            for region_2 in self.contained_regions:
                if region_1 == region_2:
                    continue
                successor_relation = True
                for region_1_entry_cu_id in region_1.get_entry_cus(pet):
                    for region_2_entry_cu_id in region_2.get_entry_cus(pet):
                        if not is_successor_bfs(
                            pet.node_at(region_1_entry_cu_id), pet.node_at(region_2_entry_cu_id)
                        ):
                            successor_relation = False
                            break
                    if not successor_relation:
                        break
                if successor_relation:
                    reachable_pairs.append((region_1, region_2))
        return reachable_pairs

    def __populate_live_data(
        self, pet: PETGraphX, ignore_update_instructions=False
    ) -> Dict[str, List[str]]:
        """calculate List of cu-id's in the combined region for each variable in which the respective data is live.
        The gathered information is used for the optimization / creation of data mapping instructions afterwards."""
        liveness: Dict[str, List[str]] = dict()
        # Problem: regions to course grained
        # populate liveness sets based on regions
        #        for region in self.contained_regions:
        #            live_in_region = (
        #                region.map_to_vars
        #                + region.map_to_from_vars
        #                + region.map_alloc_vars
        #                # + region.consumed_vars
        #            )
        #            # set liveness within region
        #            for var in live_in_region:
        #                for region_cu in region.contained_cu_ids:
        #                    if var not in liveness:
        #                        liveness[var] = []
        #                    liveness[var].append(region_cu)

        # populate liveness sets based on gpu loops
        for region in self.contained_regions:
            for gpu_loop in region.contained_loops:
                live_in_loop = (
                    gpu_loop.map_type_to
                    + gpu_loop.map_type_tofrom
                    + gpu_loop.map_type_alloc
                    + [v.name for v in gpu_loop.reduction_vars_ids]
                )
                # set liveness within loop
                subtree = pet.subtree_of_type(pet.node_at(gpu_loop.node_id), NodeType.CU)
                for var in live_in_loop:
                    if var not in liveness:
                        liveness[var] = []
                    for cu in subtree:
                        liveness[var].append(cu.id)

        if not ignore_update_instructions:
            # populate liveness sets based on update instructions
            for source_id, sink_id, update_type, var, meta_line_num in self.update_instructions:
                if var not in liveness:
                    liveness[var] = []
                if update_type == UpdateType.TO_DEVICE:
                    liveness[var].append(sink_id)
                elif update_type == UpdateType.FROM_DEVICE:
                    liveness[var].append(source_id)
                else:
                    raise ValueError("Unsupported Update type: ", update_type)

        return liveness

    def __extend_data_lifespan(
        self, pet: PETGraphX, live_data: Dict[str, List[Tuple[str, Set[str]]]]
    ) -> Dict[str, List[Tuple[str, Set[str]]]]:
        """Extends the lifespan of the data on the device to allow as little data movement as possible."""
        # todo not very efficient
        modification_found = True
        while modification_found:
            modification_found = False
            new_entries: List[Tuple[str, str, Tuple[str, ...]]] = []
            for var_name in live_data:
                for cu_id, memory_regions in live_data[var_name]:
                    # check if data is live in any successor.
                    # If so, set var_name to live in each of the encountered CUs.
                    for potential_successor_cu_id, _ in live_data[var_name]:
                        if cu_id == potential_successor_cu_id:
                            continue
                        reachable, path_nodes = pet.check_reachability_and_get_path_nodes(
                            pet.node_at(potential_successor_cu_id),
                            pet.node_at(cu_id),
                            [EdgeType.SUCCESSOR, EdgeType.CHILD],
                        )
                        if reachable:
                            # if path_node is located within a loop, add the other loop cu's to the path as well
                            to_be_added: List[CUNode] = []
                            for path_node in path_nodes:
                                parent_node = [
                                    pet.node_at(s)
                                    for s, t, d in pet.in_edges(path_node.id, EdgeType.CHILD)
                                ][0]
                                if parent_node.type == NodeType.LOOP:
                                    for _, loop_cu_id, _ in pet.out_edges(
                                        parent_node.id, EdgeType.CHILD
                                    ):
                                        loop_cu = pet.node_at(loop_cu_id)
                                        if loop_cu not in path_nodes and loop_cu not in to_be_added:
                                            to_be_added.append(loop_cu)
                            for loop_cu in to_be_added:
                                path_nodes.append(loop_cu)

                            # mark var_name live in all path_nodes and their children
                            for path_node in path_nodes:
                                # todo replace with subtree calculation after merging with refactoring changes
                                # calculate subtree without including called functions
                                subtree_without_called_functions = [
                                    cu
                                    for cu in pet.direct_children(path_node)
                                    if cu
                                    not in [
                                        pet.node_at(t)
                                        for s, t, d in pet.out_edges(
                                            path_node.id, EdgeType.CALLSNODE
                                        )
                                    ]
                                ]
                                # add path_node itself to the subtree
                                subtree_without_called_functions.append(path_node)
                                # todo end of section to be replaced
                                #  subtree = pet.subtree_of_type(path_node, NodeType.CU)  # subtree contains path_node
                                for subtree_node in subtree_without_called_functions:
                                    if subtree_node.id not in [
                                        cu_id for cu_id, _ in live_data[var_name]
                                    ]:
                                        new_entries.append(
                                            (var_name, subtree_node.id, tuple(memory_regions))
                                        )
            new_entries = list(set(new_entries))
            if len(new_entries) > 0:
                modification_found = True
            for var_name, new_cu_id, memory_regions_tuple in new_entries:
                live_data[var_name].append((new_cu_id, set(memory_regions_tuple)))
        return live_data

    def __translate_mapping_to_explicit_data_entry_and_exit_points(
        self, pet: PETGraphX
    ) -> Tuple[
        List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
    ]:
        """Returns a tuple containing the explicit entry and exit points of target data regions."""
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]] = []
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]] = []
        # create entry and exit points for contained loops
        for region in self.contained_regions:
            for gpu_loop in region.contained_loops:
                cu_node_id = gpu_loop.node_id
                start_position = pet.node_at(cu_node_id).start_position()

                # create TO_DEVICE entry points
                for var in gpu_loop.map_type_to + gpu_loop.map_type_tofrom:
                    entry_points.append(
                        (
                            var,
                            cu_node_id,
                            EntryPointType.TO_DEVICE,
                            start_position,
                            EntryPointPositioning.BEFORE_CU,
                        )
                    )
                # create ALLOC entry points
                for var in gpu_loop.map_type_alloc:
                    entry_points.append(
                        (
                            var,
                            cu_node_id,
                            EntryPointType.ALLOCATE,
                            start_position,
                            EntryPointPositioning.BEFORE_CU,
                        )
                    )

        return entry_points, exit_points

    def __unused_get_explicit_data_entry_and_exit_points(
        self, pet: PETGraphX
    ) -> Tuple[
        List[Tuple[str, str, EntryPointType, str]], List[Tuple[str, str, ExitPointType, str]]
    ]:
        """Returns a tuple containing the explicit entry and exit points of target data regions."""
        entry_points: List[Tuple[str, str, EntryPointType, str]] = []
        exit_points: List[Tuple[str, str, ExitPointType, str]] = []
        for region in self.contained_regions:

            for cu_id in region.get_entry_cus(pet):
                # open data region on to
                # open data region on to_from
                for var in list(set(region.map_to_vars + region.map_to_from_vars)):
                    entry_points.append(
                        (var, cu_id, EntryPointType.TO_DEVICE, pet.node_at(cu_id).start_position())
                    )
                # open data region on alloc
                for var in list(set(region.map_alloc_vars)):
                    entry_points.append(
                        (var, cu_id, EntryPointType.ALLOCATE, pet.node_at(cu_id).start_position())
                    )

            region_cu_ids, outside_cu_ids = region.get_exit_cus(pet)
            for cu_id in outside_cu_ids:  # cu_id -> first cu's after region
                # close data region on to_from
                # close data region on from
                for var in list(set(region.map_to_from_vars + region.map_from_vars)):
                    exit_points.append(
                        (var, cu_id, ExitPointType.FROM_DEVICE, pet.node_at(cu_id).start_position())
                    )
                # close data region on delete
                for var in list(set(region.map_delete_vars)):
                    exit_points.append(
                        (var, cu_id, ExitPointType.DELETE, pet.node_at(cu_id).start_position())
                    )

        return entry_points, exit_points

    def __find_async_loading_points(
        self,
        pet: PETGraphX,
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
    ) -> Tuple[
        List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
        List[Tuple[str, str, str, EntryPointPositioning]],
        List[Tuple[str, str, str, ExitPointPositioning]],
    ]:
        """Checks if asynchronous preloading of data is possible. Returns the modified lists of entry_ and
        exit_points."""
        updated_entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]] = []
        updated_exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]] = []
        in_dependencies: List[Tuple[str, str, str, EntryPointPositioning]] = []
        out_dependencies: List[Tuple[str, str, str, ExitPointPositioning]] = []
        # find options for async H2D copying
        for var, entry_point_cu, entry_point_type, meta_location, entry_positioning in entry_points:
            if entry_point_type == EntryPointType.ALLOCATE:
                updated_entry_points.append(
                    (
                        var,
                        entry_point_cu,
                        entry_point_type,
                        pet.node_at(entry_point_cu).start_position(),
                        entry_positioning,
                    )
                )
                continue
            # todo estimate workload of skipped section and determine whether preloading is worth it
            # find locations of accesses to var which are predecessors to entry_point_cu
            found_update = False
            for dev_cu_id in self.device_cu_ids:
                for _, t, dep in pet.out_edges(dev_cu_id, EdgeType.DATA):
                    if dep.var_name != var:
                        continue
                    if t in self.device_cu_ids:
                        continue
                    if entry_point_cu == t:
                        # not checking this would result in asynchronous transfers without computation
                        # inbetween in and out dependency location
                        continue
                    # check if t is a predecessor of entry_point_cu
                    if pet.is_predecessor(t, entry_point_cu):
                        # update entry point
                        ept = (
                            EntryPointType.ASYNC_ALLOCATE
                            if entry_point_type == EntryPointType.ALLOCATE
                            else EntryPointType.ASYNC_TO_DEVICE
                        )
                        updated_entry_points.append(
                            (
                                var,
                                t,
                                ept,
                                cast(str, dep.source_line),
                                EntryPointPositioning.AFTER_CU,
                            )
                        )
                        found_update = True
                        # create dependency
                        in_dependencies.append(
                            (
                                var,
                                entry_point_cu,
                                pet.node_at(entry_point_cu).start_position(),
                                EntryPointPositioning.BEFORE_CU,
                            )
                        )
                        out_dependencies.append(
                            (var, t, cast(str, dep.source_line), ExitPointPositioning.AFTER_CU)
                        )
                if found_update:
                    break
            if not found_update:
                updated_entry_points.append(
                    (
                        var,
                        entry_point_cu,
                        entry_point_type,
                        pet.node_at(entry_point_cu).start_position(),
                        entry_positioning,
                    )
                )

        # find options for async D2H copying
        for var, exit_point_cu, exit_point_type, meta_location, exit_positioning in exit_points:
            if exit_point_type == ExitPointType.DELETE:
                updated_exit_points.append(
                    (
                        var,
                        exit_point_cu,
                        exit_point_type,
                        pet.node_at(exit_point_cu).start_position(),
                        exit_positioning,
                    )
                )
            # todo estimate workload of skipped section and determine whether async copying is worth it
            # find locations of accesses to var which are successors to exit_point_cu
            found_update = False
            for dev_cu_id in self.device_cu_ids:
                for s, _, dep in pet.in_edges(dev_cu_id, EdgeType.DATA):
                    if dep.var_name != var:
                        continue
                    if dep.dtype == DepType.WAR or dep.dtype == DepType.WAW:
                        # since value on device is not read, ignore the dependency
                        continue
                    if s in self.device_cu_ids:
                        continue
                    if exit_point_cu == s:
                        # not checking this would result in asynchronous transfers without computation
                        # inbetween in and out dependency location
                        continue

                    # check if s is a successor of exit_point_cu
                    if pet.is_predecessor(exit_point_cu, s):
                        # update exit point
                        updated_exit_points.append(
                            (
                                var,
                                exit_point_cu,
                                ExitPointType.ASYNC_FROM_DEVICE,
                                pet.node_at(exit_point_cu).start_position(),
                                ExitPointPositioning.AFTER_CU,
                            )
                        )
                        found_update = True
                        # create dependency
                        out_dependencies.append(
                            (
                                var,
                                exit_point_cu,
                                pet.node_at(exit_point_cu).start_position(),
                                ExitPointPositioning.AFTER_CU,
                            )
                        )
                        in_dependencies.append(
                            (
                                var,
                                s,
                                pet.node_at(s).start_position(),
                                EntryPointPositioning.BEFORE_CU,
                            )
                        )
                if found_update:
                    break
            if not found_update:
                updated_exit_points.append(
                    (
                        var,
                        exit_point_cu,
                        exit_point_type,
                        pet.node_at(exit_point_cu).start_position(),
                        ExitPointPositioning.BEFORE_CU,
                    )
                )

        # remove duplicates
        updated_entry_points = list(set(updated_entry_points))
        updated_exit_points = list(set(updated_exit_points))
        in_dependencies = list(set(in_dependencies))
        out_dependencies = list(set(out_dependencies))

        return updated_entry_points, updated_exit_points, in_dependencies, out_dependencies

    def __replace_updates_with_entry_or_exit_points_if_possible(
        self,
        pet: PETGraphX,
        entry_points: List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]],
        exit_points: List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]],
    ):
        # separate entry points and exit points by variable name
        entry_point_dict: Dict[
            str, List[Tuple[str, str, EntryPointType, str, EntryPointPositioning]]
        ] = dict()
        exit_point_dict: Dict[
            str, List[Tuple[str, str, ExitPointType, str, ExitPointPositioning]]
        ] = dict()
        for entry_point in entry_points:
            if entry_point[0] not in entry_point_dict:
                entry_point_dict[entry_point[0]] = []
            entry_point_dict[entry_point[0]].append(entry_point)
        for exit_point in exit_points:
            if exit_point[0] not in exit_point_dict:
                exit_point_dict[exit_point[0]] = []
            exit_point_dict[exit_point[0]].append(exit_point)

        to_be_removed = []
        create_entry_from = []
        create_exit_from = []
        for update in self.update_instructions:
            # unpack update
            source_id, sink_id, update_type, var, meta_line_num = update
            if update_type == UpdateType.TO_DEVICE:
                # check if preceding entry point exists
                preceding_ep_exists = False
                if var in entry_point_dict:
                    for entry_point in entry_point_dict[var]:
                        if pet.is_predecessor(entry_point[1], source_id):
                            preceding_ep_exists = True
                            break
                if not preceding_ep_exists:
                    to_be_removed.append(update)
                    create_entry_from.append(update)
            elif update_type == UpdateType.FROM_DEVICE:
                # check if successive exit point exists
                successive_ep_exists = False
                if var in exit_point_dict:
                    for exit_point in exit_point_dict[var]:
                        if pet.is_predecessor(sink_id, exit_point[1]):
                            successive_ep_exists = True
                            break
                if not successive_ep_exists:
                    to_be_removed.append(update)
                    create_exit_from.append(update)
        # apply identified changes
        for update in to_be_removed:
            self.update_instructions.remove(update)
        for update in create_entry_from:
            # unpack update
            source_id, sink_id, update_type, var, meta_line_num = update
            entry_points.append(
                (
                    var,
                    sink_id,
                    EntryPointType.TO_DEVICE,
                    meta_line_num,
                    EntryPointPositioning.AFTER_CU,
                )
            )
        for update in create_exit_from:
            # unpack update
            source_id, sink_id, update_type, var, meta_line_num = update
            exit_points.append(
                (
                    var,
                    source_id,
                    ExitPointType.FROM_DEVICE,
                    meta_line_num,
                    ExitPointPositioning.BEFORE_CU,
                )
            )

        return entry_points, exit_points

    def __encapsulate_called_functions_which_share_data_with_device_cus(
        self, pet: PETGraphX, liveness: Dict[str, List[str]]
    ):
        # identify host CUs which contain function calls
        parent_function = pet.get_parent_function(pet.node_at(self.contained_regions[0].node_id))
        all_function_body_cu_ids = self.__get_function_body_cus_without_called_functions(
            pet, parent_function
        )
        all_host_cu_ids = [
            cu_id for cu_id in all_function_body_cu_ids if cu_id not in self.device_cu_ids
        ]
        # detect called functions and calling cu's
        calling_cu_ids: Set[str] = set()
        called_functions_dict: Dict[str, Set[str]] = dict()
        for host_cu_id in all_host_cu_ids:
            calls_edges = pet.out_edges(host_cu_id, EdgeType.CALLSNODE)
            if len(calls_edges) > 0:
                calling_cu_ids.add(host_cu_id)
                if not host_cu_id in called_functions_dict:
                    called_functions_dict[host_cu_id] = set()
                called_functions_dict[host_cu_id].update([t for s, t, d in calls_edges])

        # surround calling cu ids with map type from and map type to for each live variable before / after the cu,
        # if the called function shares data with any device CU
        for calling_cu in calling_cu_ids:
            # detect data sharing between the called function and device nodes
            called_function_shares_data_with_device_cus = False
            for called_function in called_functions_dict[calling_cu]:
                subtree = pet.subtree_of_type(pet.node_at(called_function), NodeType.CU)
                # check if a dependency between subtree and any device cu exists
                for sub_node in subtree:
                    deps_to: Set[str] = set()
                    deps_to.update([s for s, t, d in pet.in_edges(sub_node.id, EdgeType.DATA)])
                    deps_to.update([t for s, t, d in pet.out_edges(sub_node.id, EdgeType.DATA)])
                    if len([cu_id for cu_id in deps_to if cu_id in self.device_cu_ids]) > 0:
                        called_function_shares_data_with_device_cus = True
                        break
                if called_function_shares_data_with_device_cus:
                    break
            if not called_function_shares_data_with_device_cus:
                continue
            # called function shares data with device cu's
            # cover it with update instructions
            predecessor_cus = [s for s, t, d in pet.in_edges(calling_cu, EdgeType.SUCCESSOR)]
            successor_cus = [t for s, t, d in pet.out_edges(calling_cu, EdgeType.SUCCESSOR)]
            live_in_predecessors: Set[str] = set()
            live_in_successors: Set[str] = set()
            for pred in predecessor_cus:
                for var_name in liveness:
                    if pred in liveness[var_name]:
                        live_in_predecessors.add(var_name)
            for succ in successor_cus:
                for var_name in liveness:
                    if succ in liveness[var_name]:
                        live_in_successors.add(var_name)
            # create update instructions
            for pred in predecessor_cus:
                for var_name in live_in_predecessors:
                    self.update_instructions.append(
                        (
                            pred,
                            calling_cu,
                            UpdateType.FROM_DEVICE,
                            var_name,
                            pet.node_at(calling_cu).start_position(),
                        )
                    )
            for succ in successor_cus:
                for var_name in live_in_successors:
                    self.update_instructions.append(
                        (
                            calling_cu,
                            succ,
                            UpdateType.TO_DEVICE,
                            var_name,
                            pet.node_at(succ).start_position(),
                        )
                    )
        # remove duplicates
        self.update_instructions = list(dict.fromkeys(self.update_instructions))

    def __move_update_instructions_out_of_gpu_loops(self, pet: PETGraphX):
        # gather contained gpu loop cu ids
        gpu_loop_cu_ids: Dict[str, Set[str]] = dict()

        for region in self.contained_regions:
            for gl in region.contained_loops:
                subtree = pet.subtree_of_type(pet.node_at(gl.node_id), NodeType.CU)
                if gl.node_id not in gpu_loop_cu_ids:
                    gpu_loop_cu_ids[gl.node_id] = set()
                gpu_loop_cu_ids[gl.node_id].update([cu.id for cu in subtree])

        # check if update instruction is located within gpu loop
        to_be_removed = []
        to_be_added = []
        for update in self.update_instructions:
            (source_id, sink_id, update_type, var, meta_line_num) = update
            if update_type == UpdateType.TO_DEVICE:
                for gpu_loop_id in gpu_loop_cu_ids:
                    if sink_id in gpu_loop_cu_ids[gpu_loop_id]:
                        to_be_removed.append(update)
                        to_be_added.append(
                            (
                                source_id,
                                gpu_loop_id,
                                update_type,
                                var,
                                pet.node_at(gpu_loop_id).start_position(),
                            )
                        )

            elif update_type == UpdateType.FROM_DEVICE:
                for gpu_loop_id in gpu_loop_cu_ids:
                    if source_id in gpu_loop_cu_ids[gpu_loop_id]:
                        to_be_removed.append(update)
                        to_be_added.append(
                            (
                                gpu_loop_id,
                                sink_id,
                                update_type,
                                var,
                                pet.node_at(sink_id).start_position(),
                            )
                        )
        for update in to_be_removed:
            if update in self.update_instructions:
                self.update_instructions.remove(update)
        for update in to_be_added:
            self.update_instructions.append(update)
        # remove duplicates
        self.update_instructions = list(dict.fromkeys(self.update_instructions))

    def __remove_liveness_for_calling_cus_if_required(
        self, pet: PETGraphX, liveness: Dict[str, List[str]]
    ) -> Dict[str, List[str]]:
        # identify host CUs which contain function calls
        parent_function = pet.get_parent_function(pet.node_at(self.contained_regions[0].node_id))
        all_function_body_cu_ids = self.__get_function_body_cus_without_called_functions(
            pet, parent_function
        )
        all_host_cu_ids = [
            cu_id for cu_id in all_function_body_cu_ids if cu_id not in self.device_cu_ids
        ]
        # detect called functions and calling cu's
        calling_cu_ids: Set[str] = set()
        called_functions_dict: Dict[str, Set[str]] = dict()
        for host_cu_id in all_host_cu_ids:
            calls_edges = pet.out_edges(host_cu_id, EdgeType.CALLSNODE)
            if len(calls_edges) > 0:
                calling_cu_ids.add(host_cu_id)
                if host_cu_id not in called_functions_dict:
                    called_functions_dict[host_cu_id] = set()
                called_functions_dict[host_cu_id].update([t for s, t, d in calls_edges])

        # remove calling cu ids from all liveness sets, if the called function shares data with any device CU.
        # This removal will lead to full Host <--> Device synchronization of all currently living device variables.
        for calling_cu in calling_cu_ids:
            # detect data sharing between the called function and device nodes
            called_function_shares_data_with_device_cus = False
            for called_function in called_functions_dict[calling_cu]:
                subtree = pet.subtree_of_type(pet.node_at(called_function), NodeType.CU)
                # check if a dependency between subtree and any device cu exists
                for sub_node in subtree:
                    deps_to: Set[str] = set()
                    deps_to.update([s for s, t, d in pet.in_edges(sub_node.id, EdgeType.DATA)])
                    deps_to.update([t for s, t, d in pet.out_edges(sub_node.id, EdgeType.DATA)])
                    if len([cu_id for cu_id in deps_to if cu_id in self.device_cu_ids]) > 0:
                        called_function_shares_data_with_device_cus = True
                        break
                if called_function_shares_data_with_device_cus:
                    break
            if not called_function_shares_data_with_device_cus:
                continue
            # called function shares data with device cu's
            # remove it from all liveness sets
            for key in liveness:
                if calling_cu in liveness[key]:
                    liveness[key].remove(calling_cu)
        return liveness

    def __calculate_host_liveness(
        self,
        pet: PETGraphX,
    ) -> Dict[str, List[Tuple[str, Set[str]]]]:
        """
        Variable is live on host, if a dependency between the host cu or any of its children and any device cu for a given variable exists

        """

        host_liveness_lists: Dict[str, List[Tuple[str, Set[str]]]] = dict()

        all_function_cu_ids: Set[str] = set()
        for region in self.contained_regions:
            parent_function = pet.get_parent_function(pet.node_at(region.node_id))
            all_function_cu_ids.update(
                self.__get_function_body_cus_without_called_functions(pet, parent_function)
            )

        all_function_host_cu_ids = [
            cu_id for cu_id in all_function_cu_ids if cu_id not in self.device_cu_ids
        ]

        for cu_id in all_function_host_cu_ids:
            shared_variables: Set[str] = set()
            shared_memory_regions: Set[str] = set()
            # get all data which is accessed by the cu_id and it's children and any device cu
            subtree = pet.subtree_of_type(pet.node_at(cu_id), NodeType.CU)
            for subtree_node_id in [n.id for n in subtree]:
                out_data_edges = pet.out_edges(subtree_node_id, EdgeType.DATA)
                in_data_edges = pet.in_edges(subtree_node_id, EdgeType.DATA)
                for _, target, dep in out_data_edges:
                    if target in self.device_cu_ids:
                        if dep.var_name is not None:
                            shared_variables.add(cast(str, dep.var_name))
                        if dep.aa_var_name is not None:
                            shared_memory_regions.add(cast(str, dep.aa_var_name))

                for source, _, dep in in_data_edges:
                    if source in self.device_cu_ids:
                        if dep.var_name is not None:
                            shared_variables.add(cast(str, dep.var_name))
                        if dep.aa_var_name is not None:
                            shared_memory_regions.add(cast(str, dep.aa_var_name))
            for var_name in shared_variables:
                if var_name not in host_liveness_lists:
                    host_liveness_lists[var_name] = []
                host_liveness_lists[var_name].append((cu_id, shared_memory_regions))

        # convert sets to lists
        host_liveness: Dict[str, List[Tuple[str, Set[str]]]] = dict()
        for key in host_liveness_lists:
            host_liveness[key] = host_liveness_lists[key]
        return host_liveness

    def __mark_dirty_variables(
        self,
        pet: PETGraphX,
        liveness: Dict[str, List[Tuple[str, Set[str]]]],
        written_memory_regions_by_cu: Dict[str, Set[str]],
        cu_and_variable_to_memory_regions: Dict[str, Dict[str, Set[str]]],
        considered_cu_ids: Optional[List[str]] = None,
        not_considered_cu_ids: Optional[List[str]] = None,
    ) -> Dict[str, List[Tuple[str, Set[str], bool]]]:
        extended_liveness: Dict[str, List[Tuple[str, Set[str], bool]]] = dict()
        for var_name in liveness:
            for cu_id, memory_regions in liveness[var_name]:
                dirty = False

                # check if cu_id should be considered for marking
                if considered_cu_ids is not None and cu_id not in cast(
                    List[str], considered_cu_ids
                ):
                    # do not consider cu_id.
                    pass
                elif not_considered_cu_ids is not None and cu_id in cast(
                    List[str], not_considered_cu_ids
                ):
                    # do not consider cu_id
                    pass
                else:
                    # cu_id should be considered. Determine marking
                    cu_node = pet.node_at(cu_id)

                    # get subtree, to check if any child writes to a memory location
                    for subtree_node in pet.subtree_of_type(cu_node, NodeType.CU):
                        # check if a statically identifiable write to var_name exists
                        cu_vars = subtree_node.local_vars + subtree_node.global_vars
                        for cu_var in cu_vars:
                            if cu_var.name == var_name:
                                if "W" in cu_var.accessMode:
                                    dirty = True
                                    break

                        if not dirty:
                            # check if a dynamic dependency writes to var_name or a memory region associated with var_name
                            in_dep_edges = pet.in_edges(subtree_node.id, EdgeType.DATA)
                            out_dep_edges = pet.out_edges(subtree_node.id, EdgeType.DATA)

                            # todo remove this part as it may be incorrect? Variable names are not reliable.
                            # check written variable names
                            written_vars = [
                                d.var_name
                                for s, t, d in in_dep_edges
                                if d.dtype == DepType.RAW or d.dtype == DepType.WAW
                            ]
                            written_vars += [
                                d.var_name
                                for s, t, d in out_dep_edges
                                if d.dtype == DepType.WAR or d.dtype == DepType.WAW
                            ]
                            written_vars = list(set(written_vars))
                            if var_name in written_vars:
                                dirty = True

                            # check written memory regions
                            written_memory_regions = [
                                cast(str, d.aa_var_name)
                                for s, t, d in in_dep_edges
                                if (d.dtype == DepType.RAW or d.dtype == DepType.WAW)
                                and d.aa_var_name is not None
                            ]
                            written_memory_regions += [
                                cast(str, d.aa_var_name)
                                for s, t, d in out_dep_edges
                                if (d.dtype == DepType.WAR or d.dtype == DepType.WAW)
                                and d.aa_var_name is not None
                            ]
                            overlap = [
                                reg for reg in written_memory_regions if reg in memory_regions
                            ]
                            if len(overlap) > 0:
                                dirty = True
                        if dirty:
                            break
                # create entry in extended_liveness
                if var_name not in extended_liveness:
                    extended_liveness[var_name] = []
                extended_liveness[var_name].append((cu_id, memory_regions, dirty))

        return extended_liveness

    def __get_written_memory_regions_by_cu(self, pet: PETGraphX) -> Dict[str, Set[str]]:
        all_function_cu_ids: Set[str] = set()
        for region in self.contained_regions:
            parent_function = pet.get_parent_function(pet.node_at(region.node_id))

            subtree = pet.subtree_of_type(parent_function, NodeType.CU)
            all_function_cu_ids.update([n.id for n in subtree])

        #            all_function_cu_ids.update(
        #                self.__get_function_body_cus_without_called_functions(pet, parent_function)
        #            )

        written_memory_regions_by_cu_id: Dict[str, Set[str]] = dict()
        for cu_id in all_function_cu_ids:
            in_dep_edges = pet.in_edges(cu_id, EdgeType.DATA)
            out_dep_edges = pet.out_edges(cu_id, EdgeType.DATA)

            written_memory_regions = [
                cast(str, d.aa_var_name)
                for s, t, d in in_dep_edges
                if (d.dtype == DepType.RAW or d.dtype == DepType.WAW) and d.aa_var_name is not None
            ]
            written_memory_regions += [
                cast(str, d.aa_var_name)
                for s, t, d in out_dep_edges
                if (d.dtype == DepType.WAR or d.dtype == DepType.WAW) and d.aa_var_name is not None
            ]

            if cu_id not in written_memory_regions_by_cu_id:
                written_memory_regions_by_cu_id[cu_id] = set()
            written_memory_regions_by_cu_id[cu_id] = set(written_memory_regions)
        return written_memory_regions_by_cu_id

    def __get_memory_region_and_variable_associations(
        self, pet: PETGraphX, written_memory_regions_by_cu: Dict[str, Set[str]]
    ) -> Dict[str, Dict[str, Set[str]]]:
        # dict -> {Cu_ID: {var_name: [memory regions]}}
        result_dict: Dict[str, Dict[str, Set[str]]] = dict()

        all_function_cu_ids: Set[str] = set()
        for region in self.contained_regions:
            parent_function = pet.get_parent_function(pet.node_at(region.node_id))

            subtree = pet.subtree_of_type(parent_function, NodeType.CU)
            all_function_cu_ids.update([n.id for n in subtree])

        for cu_id in all_function_cu_ids:
            if cu_id not in result_dict:
                result_dict[cu_id] = dict()

            # only out_deps considered, as in_deps might use variable names
            # which originate from different source code scopes
            out_dep_edges = pet.out_edges(cu_id, EdgeType.DATA)
            for _, _, dep in out_dep_edges:
                if dep.var_name is None or dep.aa_var_name is None:
                    continue
                if dep.var_name not in result_dict[cu_id]:
                    result_dict[cu_id][cast(str, dep.var_name)] = set()
                result_dict[cu_id][cast(str, dep.var_name)].add(cast(str, dep.aa_var_name))

        return result_dict

    def __add_memory_regions_to_device_liveness(
        self,
        device_liveness: Dict[str, List[str]],
        cu_and_variable_to_memory_regions: Dict[str, Dict[str, Set[str]]],
    ) -> Dict[str, List[Tuple[str, Set[str]]]]:
        extended_device_liveness: Dict[str, List[Tuple[str, Set[str]]]] = dict()

        for var_name in device_liveness:
            if var_name not in extended_device_liveness:
                extended_device_liveness[var_name] = []
            for cu_id in device_liveness[var_name]:
                memory_regions: Set[str] = set()
                if cu_id in cu_and_variable_to_memory_regions:
                    if var_name in cu_and_variable_to_memory_regions[cu_id]:
                        memory_regions.update(cu_and_variable_to_memory_regions[cu_id][var_name])
                extended_device_liveness[var_name].append((cu_id, memory_regions))

        return extended_device_liveness

    def __propagate_memory_regions(
        self, device_liveness_plus_memory_regions: Dict[str, List[Tuple[str, Set[str]]]]
    ) -> Dict[str, List[Tuple[str, Set[str]]]]:
        """Propagate memory regions for variables"""
        result_dict: Dict[str, List[Tuple[str, Set[str]]]] = dict()
        for var_name in device_liveness_plus_memory_regions:
            cu_ids: List[str] = []
            memory_regions: Set[str] = set()
            for cu_id, mem_regs in device_liveness_plus_memory_regions[var_name]:
                cu_ids.append(cu_id)
                memory_regions.update(mem_regs)

            if var_name not in result_dict:
                result_dict[var_name] = []
            for cu_id in cu_ids:
                result_dict[var_name].append((cu_id, memory_regions))

        return result_dict

    def __get_update_instructions_based_on_liveness(
        self,
        pet: PETGraphX,
        extended_device_liveness: Dict[str, List[Tuple[str, Set[str], bool]]],
        extended_host_liveness: Dict[str, List[Tuple[str, Set[str], bool]]],
    ) -> List[Tuple[str, str, UpdateType, str, str]]:

        update_instructions: List[Tuple[str, str, UpdateType, str, str]] = []

        # identify parent functions
        parent_functions: Set[CUNode] = set()
        for region in self.contained_regions:
            parent_functions.add(pet.get_parent_function(pet.node_at(region.node_id)))
        # for every parent function
        for parent_function in parent_functions:
            print("PARENT FUNCTION: ", parent_function.name)
            # start update detection at start of the function body
            # entry cu is the only child of type CU with no incoming successor edge
            children_cus = [
                pet.node_at(t) for s, t, d in pet.out_edges(parent_function.id, EdgeType.CHILD)
            ]
            entry_cu = [
                c
                for c in children_cus
                if c.type == NodeType.CU and len(pet.in_edges(c.id, EdgeType.SUCCESSOR)) == 0
            ][0]
            print("\tEntry CU: ", entry_cu, " @ ", entry_cu.start_line)

            # traverse the function body to identify necessary updates
            # save the CUs which have last written a given variable
            # remove the entries in the dicts if an update instruction has been created
            # todo replace last_host_writes and last_device_writes with more general, multi-device implementation

            # Pseudocode:
            # def identify_updates(current_node, last_host_writes, last_device_writes):
            #    while len(configurations_to_check) > 0:
            #       current_node = configurations_to_check.pop()
            #       add current_node to visited_nodes
            #       determine if current_node is on host or device (todo: change to device id)
            #       get current_node_liveness
            #       for each live variable:
            #           check if update is required: reading dependency edge exists and entry in last_write exists?
            #           if update required:
            #               determine update type (TO / FROM)
            #               create an update instruction
            #               delete the corresponding last_x_write entry for the given variable
            # TODO start
            #               remove "written" mark for the now covered access
            #               restart the calculation from the start of the function using the
            #                  now simplified set of marked dirty live variables
            # TODO end
            #       for each written variable:
            #           create / overwrite an entry in last_x_write
            #       next_nodes = current.getNextNodes()
            #       if len(next_nodes) > 1:
            #           for each next node:
            #               if next_node not in visited:
            #                   configurations_to_check.push(next_node)
            #       else:
            #           configurations_to_check.push(current_node.getNext())

            def identify_updates(
                initial_current_node: CUNode,
                initial_last_host_writes: Dict[str, str],
                initial_last_device_writes: Dict[str, str],
                initial_visited_configurations: Set[
                    Tuple[str, Tuple[Tuple[str, str], ...], Tuple[Tuple[str, str], ...]]
                ],
            ):
                # initialize configurations
                configurations_to_check: List[
                    Tuple[
                        CUNode,
                        Dict[str, str],
                        Dict[str, str],
                        Set[Tuple[str, Tuple[Tuple[str, str], ...], Tuple[Tuple[str, str], ...]]],
                    ]
                ] = [
                    (
                        initial_current_node,
                        initial_last_host_writes,
                        initial_last_device_writes,
                        initial_visited_configurations,
                    )
                ]

                while len(configurations_to_check) > 0:
                    (
                        current_node,
                        last_host_writes,
                        last_device_writes,
                        visited_configurations,
                    ) = configurations_to_check.pop(0)
                    # break if current_node has already been visited

                    if (
                        current_node.id,
                        tuple(list(last_host_writes.items())),
                        tuple(list(last_device_writes.items())),
                    ) in visited_configurations:
                        import sys

                        print("SKIP @", current_node.id, file=sys.stderr)
                        continue
                    import sys

                    print(
                        "CHecking: ",
                        current_node.id,
                        tuple(list(last_host_writes.items())),
                        tuple(list(last_device_writes.items())),
                        file=sys.stderr,
                    )

                    # get required node information
                    in_dep_edges = pet.in_edges(current_node.id, EdgeType.DATA)
                    out_dep_edges = pet.out_edges(current_node.id, EdgeType.DATA)
                    # calculate memory regions which are read by the current_node or it's subtree
                    # by analyzing all dependencies in the subtree
                    subtree_in_dep_edges = []
                    for subtree_node in pet.subtree_of_type(current_node, NodeType.CU):
                        subtree_in_dep_edges += pet.in_edges(subtree_node.id, EdgeType.DATA)
                    subtree_out_dep_edges = []
                    for subtree_node in pet.subtree_of_type(current_node, NodeType.CU):
                        subtree_out_dep_edges += pet.out_edges(subtree_node.id, EdgeType.DATA)

                    read_memory_regions = [
                        cast(str, d.aa_var_name)
                        for s, t, d in subtree_in_dep_edges
                        if d.dtype == DepType.WAR and d.aa_var_name is not None
                    ]
                    read_memory_regions += [
                        cast(str, d.aa_var_name)
                        for s, t, d in subtree_out_dep_edges
                        if d.dtype == DepType.RAW and d.aa_var_name is not None
                    ]
                    read_memory_regions = list(set(read_memory_regions))

                    # add current_node to visited_node_ids
                    visited_configurations.add(
                        (
                            current_node.id,
                            tuple(list(last_host_writes.items())),
                            tuple(list(last_device_writes.items())),
                        )
                    )
                    current_is_device_node = current_node.id in self.device_cu_ids
                    liveness = (
                        extended_device_liveness
                        if current_is_device_node
                        else extended_host_liveness
                    )
                    # get current_node_liveness
                    current_node_live_vars: Dict[str, List[Tuple[str, Set[str], bool]]] = dict()
                    for var_name in liveness:
                        for t1, t2, t3 in liveness[var_name]:
                            if t1 == current_node.id:
                                if var_name not in current_node_live_vars:
                                    current_node_live_vars[var_name] = []
                                current_node_live_vars[var_name].append((t1, t2, t3))
                    # for each live variable
                    for var_name in current_node_live_vars:
                        # check if reading dependency edge exists which overlaps with memory region
                        overlapping_memory_regions = []
                        for entry in current_node_live_vars[var_name]:
                            overlapping_memory_regions += [
                                mem_reg for mem_reg in read_memory_regions if mem_reg in entry[1]
                            ]
                        read_dependency_exists = len(overlapping_memory_regions) > 0

                        # check if previous write exists in last_x_writes
                        entry_in_last_write_exists = var_name in (
                            last_host_writes if current_is_device_node else last_device_writes
                        )

                        # check if update is required
                        update_required = read_dependency_exists and entry_in_last_write_exists

                        # import sys
                        # print(file=sys.stderr)
                        # print("Node ID: ", current_node.id, file=sys.stderr)
                        # print("Is Device Node: ", current_is_device_node, file=sys.stderr)
                        # print("VAR NAME: ", var_name, file=sys.stderr)
                        # print(
                        #    "read dep: ",
                        #    read_dependency_exists,
                        #    " -- ",
                        #    read_memory_regions,
                        #    file=sys.stderr,
                        # )
                        # print("Last write: ", file=sys.stderr)
                        # for key in (
                        #     last_host_writes if current_is_device_node else last_device_writes
                        # ):
                        #     print(
                        #         "\t",
                        #         key,
                        #         " --> ",
                        #        (
                        #            last_host_writes
                        #            if current_is_device_node
                        #            else last_device_writes
                        #        )[key].id,
                        #        file=sys.stderr,
                        #    )
                        # print("last_write: ", entry_in_last_write_exists, file=sys.stderr)
                        # print("Update required: ", update_required, file=sys.stderr)

                        if update_required:
                            # determine update type
                            update_type = (
                                UpdateType.TO_DEVICE
                                if current_is_device_node
                                else UpdateType.FROM_DEVICE
                            )
                            # create update instruction
                            meta_line_num = current_node.start_position()
                            last_writing_cu = pet.node_at(
                                (
                                    last_host_writes
                                    if current_is_device_node
                                    else last_device_writes
                                )[var_name]
                            )
                            # determine update var name by checking for overlaps in the list of live variables,
                            # the current value of var_name and the identified, read memory regions.
                            # Get variables names which are live in last_writing_cu and
                            # are associated with the overlapping_memory_regions
                            update_var_names: Set[str] = set()
                            other_device_liveness = (
                                extended_host_liveness
                                if current_is_device_node
                                else extended_device_liveness
                            )
                            for tmp_var_name in other_device_liveness:
                                for tmp_cu_id, tmp_mem_regs, _ in other_device_liveness[
                                    tmp_var_name
                                ]:
                                    # check if entry for last_writing_cu exists
                                    if tmp_cu_id == last_writing_cu.id:
                                        # check if relevant memory regions are targeted
                                        if (
                                            len(
                                                [
                                                    mr
                                                    for mr in tmp_mem_regs
                                                    if mr in overlapping_memory_regions
                                                ]
                                            )
                                            > 0
                                        ):
                                            # tmp_var_name is a candidate to be updated
                                            update_var_names.add(tmp_var_name)

                            for update_var_name in update_var_names:
                                update_instruction: Tuple[str, str, UpdateType, str, str] = (
                                    str(last_writing_cu.id),
                                    str(current_node.id),
                                    update_type,
                                    update_var_name,
                                    meta_line_num,
                                )
                                update_instructions.append(update_instruction)

                            # delete entry in last_x_write
                            del (
                                last_host_writes if current_is_device_node else last_device_writes
                            )[var_name]

                            #   remove "written" mark for the now covered memory access
                            for update_var_name in update_var_names:
                                print("UPDATE VAR: ", update_var_name, file=sys.stderr)
                                print("\tkeys: ", other_device_liveness.keys(), file=sys.stderr)
                                for idx, (tmp_cu_id, tmp_mem_regs, _) in enumerate(
                                    other_device_liveness[update_var_name]
                                ):
                                    if tmp_cu_id == last_writing_cu.id:
                                        import sys

                                        print(
                                            "PRE: ",
                                            other_device_liveness[update_var_name][idx],
                                            file=sys.stderr,
                                        )
                                        # remove "dirty" marking if present
                                        other_device_liveness[update_var_name][idx] = (
                                            tmp_cu_id,
                                            tmp_mem_regs,
                                            False,
                                        )
                                        print(
                                            "POST: ",
                                            other_device_liveness[update_var_name][idx],
                                            file=sys.stderr,
                                        )

                            # todo
                            #  restart the calculation from the start of the function using the
                            #  now simplified set of marked dirty live variables
                            # clear configurations
                            configurations_to_check = []
                            # create new initial entry
                            configurations_to_check.append(
                                (
                                    initial_current_node,
                                    initial_last_host_writes,
                                    initial_last_device_writes,
                                    initial_visited_configurations,
                                )
                            )

                    # for each written variable
                    written_vars = [
                        cast(str, d.var_name)
                        for s, t, d in in_dep_edges
                        if (d.dtype == DepType.RAW or d.dtype == DepType.WAW)
                        and d.var_name is not None
                    ]
                    written_vars += [
                        cast(str, d.var_name)
                        for s, t, d in out_dep_edges
                        if (d.dtype == DepType.WAR or d.dtype == DepType.WAW)
                        and d.var_name is not None
                    ]
                    written_vars = list(set(written_vars))
                    for var_name in written_vars:
                        # create entry in last_x_write of the device the CU is executed on
                        tmp_dict_1 = (
                            last_device_writes if current_is_device_node else last_host_writes
                        )
                        tmp_dict_1[var_name] = current_node.id

                        # remove the entry if existent from the other dict
                        tmp_dict_2 = (
                            last_host_writes if current_is_device_node else last_device_writes
                        )
                        if var_name in tmp_dict_2:
                            del tmp_dict_2[var_name]

                    # proceed
                    next_nodes = [
                        pet.node_at(t)
                        for _, t, _ in pet.out_edges(current_node.id, EdgeType.SUCCESSOR)
                    ]

                    for next_node in next_nodes:
                        configurations_to_check.append(
                            (
                                next_node,
                                copy.deepcopy(last_host_writes),
                                copy.deepcopy(last_device_writes),
                                copy.deepcopy(visited_configurations),
                            )
                        )

            identify_updates(cast(CUNode, entry_cu), dict(), dict(), set())

        # remove duplicates
        update_instructions = list(dict.fromkeys(update_instructions))

        return update_instructions


def find_combined_gpu_regions(
    pet: PETGraphX, gpu_regions: List[GPURegionInfo]
) -> List[CombinedGPURegion]:
    # create combined gpu regions from original gpu regions
    combined_gpu_regions = []
    for gpu_region in gpu_regions:
        combined_gpu_regions.append(CombinedGPURegion(pet, [gpu_region]))

    # determine relations between single-element regions
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion]
    ] = __find_all_pairwise_gpu_region_combinations(combined_gpu_regions, pet)

    intra_function_combinations = __find_combinations_within_function_body(pet, combinable_pairs)

    true_successor_combinations = __find_true_successor_combinations(
        pet, intra_function_combinations
    )

    # combine regions
    for combinable_1, combinable_2 in true_successor_combinations:
        combined_gpu_regions.remove(combinable_1)
        combined_gpu_regions.remove(combinable_2)
        combined_gpu_regions.append(__combine_regions(pet, combinable_1, combinable_2))

    # todo add update instructions
    # todo merge data regions

    return combined_gpu_regions


def __combine_regions(
    pet: PETGraphX, region_1: CombinedGPURegion, region_2: CombinedGPURegion
) -> CombinedGPURegion:
    """Combines regions. Individual contained regions are not yet merged!
    Analysis of Live-data and necessary update pragmas needs ti happen in a subsequent step."""
    combined_region = CombinedGPURegion(
        pet, region_1.contained_regions + region_2.contained_regions
    )
    return combined_region


def __find_true_successor_combinations(
    pet, intra_function_combinations: List[Tuple[CombinedGPURegion, CombinedGPURegion]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check for combinations options without branching inbetween.
    As a result, both regions will always be executed in succession."""
    result = []
    # a successor path between region_1 and region_2 must exist.
    # a true successor relation exists, if every successor path outgoing from any child of region_1 arrives at region_2
    for region_1, region_2 in intra_function_combinations:
        true_successors = True
        queue: List[CUNode] = pet.direct_children(
            pet.node_at(region_1.contained_regions[0].node_id)
        )
        visited: List[CUNode] = []
        while queue:
            current_node: CUNode = queue.pop()
            visited.append(current_node)
            if current_node in pet.direct_children(
                pet.node_at(region_2.contained_regions[0].node_id)
            ):
                # reached region_2
                continue
            # region_2 not reached
            successors = pet.direct_successors(current_node)
            if len(successors) == 0:
                # end of the function body reached, region_2 not reached
                true_successors = False
                break
            else:
                # end of the function's body not yet reached, continue searching
                # add successors to queue
                queue += [succ for succ in successors if succ not in visited]
        if true_successors:
            result.append((region_1, region_2))
    return result


def __find_combinations_within_function_body(
    pet: PETGraphX, combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check regions pairwise for reachability via successor edges.
    Only combinations within a function's body are possible in this way since successor edges only exist
    for function body's."""
    result = []
    for region_1, region_2 in combinable_pairs:
        if region_1 == region_2:
            continue
        # check reachability in both directions via successor edges
        # consider children, as loop nodes do not have successors on their own
        for region_1_child in pet.direct_children(
            pet.node_at(region_1.contained_regions[0].node_id)
        ):
            for region_2_child in pet.direct_children(
                pet.node_at(region_2.contained_regions[0].node_id)
            ):
                if region_1_child == region_2_child:
                    continue
                if pet.check_reachability(region_2_child, region_1_child, [EdgeType.SUCCESSOR]):
                    result.append((region_1, region_2))
                elif pet.check_reachability(region_1_child, region_2_child, [EdgeType.SUCCESSOR]):
                    result.append((region_2, region_1))
    # remove duplicates (deterministic ordering not relevant, hence list(set(..)) is fine)
    result = list(set(result))
    return result


def __find_all_pairwise_gpu_region_combinations(
    gpu_regions: List[CombinedGPURegion], pet: PETGraphX
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion]] = []  # [(region1, region2)
    # get all pairwise combinations of gpu regions
    for gpu_region_1 in gpu_regions:
        for gpu_region_2 in gpu_regions:
            if gpu_region_1 == gpu_region_2:
                continue
            combinable_pairs.append((gpu_region_1, gpu_region_2))
    return combinable_pairs


def __unused_common_data_accessed(
    gpu_region_1: GPURegionInfo, gpu_region_2: GPURegionInfo, pet: PETGraphX
) -> bool:
    # common data is accessed, if a transitive RAW / WAR dependency from gpu_region_1 to gpu_region_2 or
    # from gpu_region_2 to gpu_region_1 exists
    for cu_id_1 in gpu_region_1.contained_cu_ids:
        for cu_id_2 in gpu_region_2.contained_cu_ids:
            if __check_reachability_via_transitive_dependency(pet, cu_id_1, cu_id_2):
                return True
    return False


def __check_reachability_via_transitive_dependency(
    pet: PETGraphX, source_id: str, target_id: str
) -> bool:
    # perform BFS from source to target, consider the name of the respective variable
    # add initial values for "previous" variable names
    queue: List[Tuple[str, str, Dependency, str]] = [
        (e[0], e[1], e[2], cast(str, e[2].var_name))
        for e in pet.out_edges(source_id, EdgeType.DATA)
        if e[2].var_name is not None
    ]
    visited: List[Tuple[str, str]] = []
    while queue:
        s_id, t_id, dep, prev_var_name = queue.pop(0)
        if (t_id, prev_var_name) not in visited:
            visited.append((t_id, prev_var_name))
        if t_id == target_id:
            # target reached
            return True
        # target not reached
        # add outgoing edges of t_id with variable prev_var_name to the queue
        queue += [
            (e[0], e[1], e[2], prev_var_name)
            for e in pet.out_edges(t_id, EdgeType.DATA)
            if e[2].var_name == prev_var_name and (e[1], prev_var_name) not in visited
        ]
        # remove duplicates
        queue = list(dict.fromkeys(queue))
    return False
