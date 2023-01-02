# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from enum import IntEnum
from typing import List, Tuple, cast, Dict, Optional

from discopop_explorer.PETGraphX import EdgeType, CUNode, Dependency, PETGraphX, DepType
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
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


class CombinedGPURegion(PatternInfo):
    contained_regions: List[GPURegionInfo]
    update_instructions: List[
        Tuple[str, str, UpdateType, str, str]
    ]  # (source_cu_id, sink_cu_id, UpdateType, target_vars, meta_line_num)
    target_data_regions: Dict[str, List[Tuple[List[str], str, str, str, str]]]
    # {var: ([contained cu_s], entry_cu, exit_after_cu, meta_entry_line_num, meta_exit_line_num)
    device_cu_ids: List[str]
    host_cu_ids: List[str]
    pairwise_reachability: List[Tuple[GPURegionInfo, GPURegionInfo]]
    # meta information, mainly for display and overview purposes
    meta_device_lines: List[str]
    meta_host_lines: List[str]

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
        self.update_instructions = self.__get_update_instructions(pet)
        self.pairwise_reachability = self.__get_pairwise_reachability(pet)
        liveness = self.__optimize_data_mapping(pet)
        entry_points, exit_points = self.__get_explicit_data_entry_and_exit_points(pet)
        (
            entry_points,
            exit_points,
            in_dependencies,
            out_dependencies,
        ) = self.__find_async_loading_points(pet, entry_points, exit_points)
        print("Entry Points:")
        print(entry_points)
        print("Exit Points:")
        print(exit_points)
        print("Depend(in): ")
        print(in_dependencies)
        print("Depend(out):")
        print(out_dependencies)
        self.meta_device_lines = []
        self.meta_host_lines = []
        self.__get_metadata(pet)

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
                filtered_deps = [(t, d) for (t, d) in out_deps if t in source_cu_ids]
                # report UpdateInstructions
                for source_cu_id, dep in filtered_deps:
                    # use Host code to handle updates
                    if update_type == UpdateType.TO_DEVICE:
                        pragma_position = pet.node_at(source_cu_id).start_position()
                    elif update_type == UpdateType.FROM_DEVICE:
                        pragma_position = pet.node_at(sink_cu_id).start_position()
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

        # determine device to host updates
        determine_updates(self.device_cu_ids, self.host_cu_ids, UpdateType.FROM_DEVICE)

        # determine host to device updates
        determine_updates(self.host_cu_ids, self.device_cu_ids, UpdateType.TO_DEVICE)

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
                            if s in self.host_cu_ids
                        ]
                    elif update_1[2] in self.host_cu_ids:
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

        to_be_removed = list(set(to_be_removed))
        for update_1 in to_be_removed:
            if update_1 in update_instructions:
                update_instructions.remove(update_1)
        return update_instructions

    def __get_metadata(self, pet: PETGraphX):
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

    def __optimize_data_mapping(self, pet: PETGraphX) -> Dict[str, List[str]]:
        """rely on the explicit update instructions for data synchronization within the region.
        Optimize mapping instructions for an efficient use within the region.
        Keep mapping instructions TO the first and FROM the last small GPU region in the combined GPU Region.
        Returns liveness information for each target variable."""
        if not len(self.contained_regions) > 1:
            # only optimize such data regions which contain at least two GPU regions
            return dict()

        modification_found = True
        while modification_found:
            modification_found = False
            self.opt_split_map_type_to_from()
            modification_found = modification_found or self.opt_map_type_to()
            modification_found = modification_found or self.opt_map_type_from()
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

        liveness: Dict[str, List[str]] = dict()
        return liveness

    def __group_liveness(
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

    def opt_map_type_from(self) -> bool:
        """Only allow map type FROM, if the data is not used by any successor.
        Return True if modification has been found."""
        modification_found = False
        for region in self.contained_regions:
            to_be_removed: List[str] = []
            successors = [s for p, s in self.pairwise_reachability if p == region]
            for succ in successors:
                for var in region.map_from_vars:
                    if var in succ.consumed_vars:
                        to_be_removed.append(var)
            to_be_removed = list(set(to_be_removed))
            for var in to_be_removed:
                if var in region.map_from_vars:
                    print("REMOVED: FROM:", var, "from", region.start_line)
                    region.map_from_vars.remove(var)
                    modification_found = True
        return modification_found

    def opt_map_type_to(self) -> bool:
        """Only allow map type TO, if the data is not mapped TO by any predecessor.
        Return True, if a modification has been found."""
        modification_found = False
        for region in self.contained_regions:
            print("Region:", region.node_id)
            to_be_removed: List[str] = []
            predecessors = [p for p, s in self.pairwise_reachability if s == region]
            for pred in predecessors:
                # validate map_type_to variables of region against pred
                for var in region.map_to_vars:
                    if var in pred.map_to_vars + pred.map_alloc_vars:
                        to_be_removed.append(var)
                        print("REMOVED: TO:", var, "from", region.start_line)
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

    def __analyze_live_data(self, pet: PETGraphX) -> Dict[str, List[str]]:
        """calculate List of cu-id's in the combined region for each variable in which the respective data is live.
        The gathered information is used for the optimization of data mapping instructions afterwards."""
        liveness: Dict[str, List[str]] = dict()
        # populate liveness sets based on regions
        for region in self.contained_regions:
            live_in_region = (
                region.map_to_vars
                + region.map_to_from_vars
                + region.map_alloc_vars
                + region.consumed_vars
            )
            # set liveness within region
            for var in live_in_region:
                for region_cu in region.contained_cu_ids:
                    if var not in liveness:
                        liveness[var] = []
                    liveness[var].append(region_cu)
        # populate liveness sets based on update instructions
        for source_id, sink_id, update_type, var, meta_line_num in self.update_instructions:
            if var not in liveness:
                liveness[var] = []
            liveness[var].append(source_id)
            liveness[var].append(sink_id)

        return liveness

    def __get_explicit_data_entry_and_exit_points(
        self, pet: PETGraphX
    ) -> Tuple[List[Tuple[str, str, EntryPointType]], List[Tuple[str, str, ExitPointType]]]:
        """Returns a tuple containing the explicit entry and exit points of target data regions."""
        entry_points: List[Tuple[str, str, EntryPointType]] = []
        exit_points: List[Tuple[str, str, ExitPointType]] = []
        for region in self.contained_regions:

            for cu_id in region.get_entry_cus(pet):
                # open data region on to
                # open data region on to_from
                for var in list(set(region.map_to_vars + region.map_to_from_vars)):
                    entry_points.append((var, cu_id, EntryPointType.TO_DEVICE))
                # open data region on alloc
                for var in list(set(region.map_alloc_vars)):
                    entry_points.append((var, cu_id, EntryPointType.ALLOCATE))

            region_cu_ids, outside_cu_ids = region.get_exit_cus(pet)
            for cu_id in outside_cu_ids:  # cu_id -> first cu's after region
                # close data region on to_from
                # close data region on from
                for var in list(set(region.map_to_from_vars + region.map_from_vars)):
                    exit_points.append((var, cu_id, ExitPointType.FROM_DEVICE))
                # close data region on delete
                for var in list(set(region.map_delete_vars)):
                    exit_points.append((var, cu_id, ExitPointType.DELETE))
        print("ENTRY: ", entry_points)
        print("EXIT: ", exit_points)

        return entry_points, exit_points

    def __find_async_loading_points(
        self,
        pet: PETGraphX,
        entry_points: List[Tuple[str, str, EntryPointType]],
        exit_points: List[Tuple[str, str, ExitPointType]],
    ) -> Tuple[
        List[Tuple[str, str, EntryPointType]],
        List[Tuple[str, str, ExitPointType]],
        List[Tuple[str, str]],
        List[Tuple[str, str]],
    ]:
        """Checks if asynchronous preloading of data is possible. Returns the modified lists of entry_ and
        exit_points."""
        updated_entry_points: List[Tuple[str, str, EntryPointType]] = []
        in_dependencies: List[Tuple[str, str]] = []
        out_dependencies: List[Tuple[str, str]] = []
        for var, entry_point_cu, entry_point_type in entry_points:
            if entry_point_type == EntryPointType.ALLOCATE:
                updated_entry_points.append((var, entry_point_cu, entry_point_type))
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
                    # check if t is a predecessor of entry_point_cu
                    if pet.is_predecessor(t, entry_point_cu):
                        # update entry point
                        ept = (
                            EntryPointType.ASYNC_ALLOCATE
                            if entry_point_type == EntryPointType.ALLOCATE
                            else EntryPointType.ASYNC_TO_DEVICE
                        )
                        updated_entry_points.append((var, t, ept))
                        found_update = True
                        # create dependency
                        in_dependencies.append((var, entry_point_cu))
                        out_dependencies.append((var, t))
                if found_update:
                    break
            if not found_update:
                updated_entry_points.append((var, entry_point_cu, entry_point_type))

        return updated_entry_points, exit_points, in_dependencies, out_dependencies


def find_combined_gpu_regions(
    pet: PETGraphX, gpu_regions: List[GPURegionInfo]
) -> List[CombinedGPURegion]:
    # create combined gpu regions from original gpu regions
    combined_gpu_regions = []
    for gpu_region in gpu_regions:
        combined_gpu_regions.append(CombinedGPURegion(pet, [gpu_region]))

    # determine relations between single-element regions
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]
    ] = __find_all_pairwise_gpu_region_combinations(combined_gpu_regions, pet)
    # print combinable gpu regions
    for combinable_1, combinable_2, common_data in combinable_pairs:
        print("Combinable: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        # preliminary calculation of common data. Calculation based on dependencies should be preferred!
        print("Common data: ", common_data)
        print()

    intra_function_combinations = __find_combinations_within_function_body(pet, combinable_pairs)
    for combinable_1, combinable_2 in intra_function_combinations:
        print("INTRA COMBINE: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        print()

    true_successor_combinations = __find_true_successor_combinations(
        pet, intra_function_combinations
    )
    for combinable_1, combinable_2 in true_successor_combinations:
        print("TRUE SUCCESSORS: ")
        print(combinable_1.start_line, combinable_1.end_line)
        print("####")
        print(combinable_2.start_line, combinable_2.end_line)
        print("####")
        print()

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
    print(region_1.to_string(pet))
    print(region_2.to_string(pet))
    combined_region = CombinedGPURegion(
        pet, region_1.contained_regions + region_2.contained_regions
    )
    print("COMBINED REGION: ")
    print(combined_region.to_string(pet))
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
    pet: PETGraphX, combinable_pairs: List[Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]]
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion]]:
    """Check regions pairwise for reachability via successor edges.
    Only combinations within a function's body are possible in this way since successor edges only exist
    for function body's."""
    result = []
    for region_1, region_2, _ in combinable_pairs:
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
) -> List[Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]]:
    combinable_pairs: List[
        Tuple[CombinedGPURegion, CombinedGPURegion, List[str]]
    ] = []  # [(region1, region2, [common data])
    # check pairwise if gpu regions can be combined
    for gpu_region_1 in gpu_regions:
        for gpu_region_2 in gpu_regions:
            if gpu_region_1 == gpu_region_2:
                continue
            # check if same data is accessed
            if __common_data_accessed(
                gpu_region_1.contained_regions[0], gpu_region_2.contained_regions[0], pet
            ):
                common_data = [
                    var
                    for var in gpu_region_1.contained_regions[0].consumed_vars
                    + gpu_region_1.contained_regions[0].produced_vars
                    if var
                    in gpu_region_2.contained_regions[0].produced_vars
                    + gpu_region_2.contained_regions[0].consumed_vars
                ]
                combinable_pairs.append((gpu_region_1, gpu_region_2, common_data))
    return combinable_pairs


def __common_data_accessed(
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
