from typing import List, Tuple, Optional, cast

from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType as PETEdgeType, DepType, Dependency, NodeType
from discopop_explorer.utils import is_loop_index2
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation
from discopop_validation.data_race_prediction.behavior_modeller.classes.OperationModifierType import \
    OperationModifierType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PCGraph import PCGraph
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaBarrierNode import \
    PragmaBarrierNode
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.PragmaTaskwaitNode import \
    PragmaTaskwaitNode
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.memory_access_graph.AccessMetaData import AccessMetaData
from discopop_validation.memory_access_graph.MAGDataRace import MAGDataRace
from discopop_validation.memory_access_graph.MemoryAccessGraph import MemoryAccessGraph


def detect_data_races(ma_graph: MemoryAccessGraph, pc_graph: PCGraph, pet: PETGraphX) -> List[MAGDataRace]:
    """starts the detection of data races for each node of the graph"""
    if ma_graph.run_configuration.verbose_mode:
        print("#########")
        print("Detecting data races...")
        print("#########")
    data_races: List[MAGDataRace] = []
    # start data race detection for each node in the graph
    for node in ma_graph.graph.nodes:
        # get the set of incoming access edges for node
        incoming_accesses = ma_graph.graph.in_edges(node, keys=True)
        # create all possible pairs of incoming edges
        incoming_edge_pairs = ((i, j) for i in incoming_accesses for j in incoming_accesses if i != j)
        # check each pair for present data races
        for edge_1, edge_2 in incoming_edge_pairs:
            optional_data_race = __data_race_in_edge_pair(ma_graph, node, edge_1, edge_2, pc_graph, pet)
            if optional_data_race is not None:
                data_race_object = cast(MAGDataRace, optional_data_race)
                data_races.append(data_race_object)
    return data_races


def print_data_races(data_races: List[MAGDataRace], ma_graph: MemoryAccessGraph):
    buffer: List[MAGDataRace] = []
    print("### Detected data races: ###")
    for data_race in data_races:
        if data_race in buffer:
            # do not print duplicates
            continue
        print(data_race.operation_1)
        print(data_race.operation_2)
        if data_race.is_weak:
            print("\t==> Weak")
        print()
        buffer.append(data_race)

def __originated_from_loop_without_inter_iteration_dependences(ma_graph: MemoryAccessGraph, amd_1: AccessMetaData, amd_2: AccessMetaData):
    # check if both operations stem from the same loop
    amd_1_loop_modifiers = [mod[1] for mod in amd_1.operation.modifiers if
                            mod[0] == OperationModifierType.LOOP_OPERATION]
    amd_2_loop_modifiers = [mod[1] for mod in amd_2.operation.modifiers if
                            mod[0] == OperationModifierType.LOOP_OPERATION]
    # if overlap exists, both accesses occured from the same loop.
    if len([mod for mod in amd_1_loop_modifiers if mod in amd_2_loop_modifiers]) == 0:
        # no overlap, return False
        return False

    # check if amd_1 and amd_2 originate from inter-iteration dependency producing instructions
    # inter-iteration dependencies exists for variable, if:
    # -> parent CU is child of loop node
    # -> dependency edge to self exists
    # -> variable is not a loop index

    # check if amd_1 and amd_2 originated from same CU
    amd_1_cu = get_pet_node_id_from_source_code_lines(ma_graph.pet, int(amd_1.operation.file_id),
                                                      int(amd_1.operation.line), int(amd_1.operation.line),
                                                      accessed_var_name=amd_1.operation.target_name)
    amd_2_cu = get_pet_node_id_from_source_code_lines(ma_graph.pet, int(amd_2.operation.file_id),
                                                      int(amd_2.operation.line), int(amd_2.operation.line),
                                                      accessed_var_name=amd_2.operation.target_name)

    if amd_1_cu != amd_2_cu:
        return False

    print()
    print("AMD1: ", amd_1.operation)
    print("AMD2: ", amd_2.operation)
    print("CU: ", amd_1_cu)
    print("Node ID: ", ma_graph.pet.node_at(amd_1_cu).id)

    # check if CU is a child of a loop node
    parent_loop_nodes = [source for source, _, _ in ma_graph.pet.in_edges(ma_graph.pet.node_at(amd_1_cu).id, PETEdgeType.CHILD) if
                         ma_graph.pet.node_at(source).type == NodeType.LOOP]
    print("parent loop nodes: ", parent_loop_nodes)
    if len(parent_loop_nodes) == 0:
        return False

    # check if inter-iteration dependency edge to own CU node exists
    II_in_dep_edges = ma_graph.pet.get_dep(ma_graph.pet.node_at(amd_1_cu), DepType.IIRAW, reversed=False)
    II_in_dep_edges += ma_graph.pet.get_dep(ma_graph.pet.node_at(amd_1_cu), DepType.IIWAR, reversed=False)

#    in_dep_edges = ma_graph.pet.get_dep(ma_graph.pet.node_at(amd_1_cu), DepType.RAW, reversed=False)
#    in_dep_edges += ma_graph.pet.get_dep(ma_graph.pet.node_at(amd_1_cu), DepType.WAR, reversed=False)
#    in_dep_edges += ma_graph.pet.get_dep(ma_graph.pet.node_at(amd_1_cu), DepType.WAW, reversed=False)

    # filter in dep edges for variable and source
    circular_dependencies = [(source, target, dep) for source, target, dep in II_in_dep_edges if source == amd_1_cu and
                             target == amd_1_cu and dep.var_name == amd_1.operation.target_name]
    print("circular deps: ")
    for dep in circular_dependencies:
        print("\t--> ", dep[0], dep[1], dep[2].var_name)
    if len(circular_dependencies) == 0:
        return False

    # check if variable is a loop index
    for parent_loop_id in parent_loop_nodes:
        print("Parent_loop: ", parent_loop_id)
        if is_loop_index2(ma_graph.pet, ma_graph.pet.node_at(parent_loop_id), amd_1.operation.target_name):
            print("Is loop index: ", amd_1.operation.target_name)
            # since access originated from loop index, no inter-iteration dependency => not a potential data race
            return True

    # accesses originated from inter-iteration dependency => potential data race
    return False


def __old_originated_from_loop_without_inter_iteration_dependences(ma_graph: MemoryAccessGraph, amd_1: AccessMetaData, amd_2: AccessMetaData):
    # check if both operations stem from the same loop
    amd_1_loop_modifiers = [mod[1] for mod in amd_1.operation.modifiers if
                            mod[0] == OperationModifierType.LOOP_OPERATION]
    amd_2_loop_modifiers = [mod[1] for mod in amd_2.operation.modifiers if
                            mod[0] == OperationModifierType.LOOP_OPERATION]
    # if overlap exists, both accesses occured from the same loop.
    if len([mod for mod in amd_1_loop_modifiers if mod in amd_2_loop_modifiers]) == 0:
        # no overlap, return False
        return False

    # check if amd_1 and amd_2 originate from inter-iteration dependency producing instructions
    with open(ma_graph.run_configuration.loop_access_pattern_file, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            split_line = line.split(" ")
            if split_line[0] == "InterItDep":
                # unpack access information
                access_1_raw = split_line[1].split("@")
                access_2_raw = split_line[2].split("@")
                access_1_var = access_1_raw[0].split(":")[0]
                access_1_mode = access_1_raw[0].split(":")[1]
                access_1_file_id = access_1_raw[1].split(":")[0]
                access_1_line_num = access_1_raw[1].split(":")[1]
                access_2_var = access_2_raw[0].split(":")[0]
                access_2_mode = access_2_raw[0].split(":")[1]
                access_2_file_id = access_2_raw[1].split(":")[0]
                access_2_line_num = access_2_raw[1].split(":")[1]

                # check if amd_1 and amd_2 are contained. check both ways
                # check if amd_1 is access_1 and amd_2 is access_2
                if access_1_var == amd_1.operation.target_name and \
                        access_1_file_id == str(amd_1.operation.file_id) and \
                        access_1_line_num == str(amd_1.operation.line) and \
                        access_1_mode == amd_1.operation.mode.upper() and \
                        access_2_var == amd_2.operation.target_name and \
                        access_2_file_id == str(amd_2.operation.file_id) and \
                        access_2_line_num == str(amd_2.operation.line) and \
                        access_2_mode == amd_2.operation.mode.upper():
                    # accesses originated from inter-iteration dependencies
                    # data race is possible
                    return False

                # check if amd_1 is access_2 and amd_2 is access_1
                elif access_2_var == amd_1.operation.target_name and \
                        access_2_file_id == str(amd_1.operation.file_id) and \
                        access_2_line_num == str(amd_1.operation.line) and \
                        access_2_mode == amd_1.operation.mode.upper() and \
                        access_1_var == amd_2.operation.target_name and \
                        access_1_file_id == str(amd_2.operation.file_id) and \
                        access_1_line_num == str(amd_2.operation.line) and \
                        access_1_mode == amd_2.operation.mode.upper():
                    # accesses originated from inter-iteration dependencies
                    # data race is possible
                    return False
    return True

def __data_race_in_edge_pair(ma_graph: MemoryAccessGraph, ma_node, edge_1: Tuple[str, str, int], edge_2: Tuple[str, str, int], pc_graph: PCGraph,
                             pet: PETGraphX) -> Optional[MAGDataRace]:
    """checks the given pair of edges for data races.
    Returns True, if a data race has been found.
    Else, returns False.
    """
    # retrieve AccessMetaData objects of edges
    amd_1: AccessMetaData = ma_graph.graph.edges[edge_1]["data"]
    amd_2: AccessMetaData = ma_graph.graph.edges[edge_2]["data"]

    # requirement 1: both accesses happen within the same parallel unit
    # todo might require: both accesses happen within nested parallel units
    if amd_1.parallel_unit != amd_2.parallel_unit:
        return None

    # requirement 2: at least of the accesses must be a write
    if (not amd_1.access_mode == "w") and (not amd_2.access_mode == "w"):
        return None

    # requirement 3: edge_1 not a predecessor of edge_2 or vice-versa
    if __path_predecessor_relation_exists(amd_1.operation_path, amd_2.operation_path):
        # predecessor relation exists
        return None

    # requirement 4: check for PCGraph predecessor relations
    if __pcgraph_predecessor_relation(amd_1, amd_2, pc_graph):
        return None

    # requirement 5: check if the identified data race is backed up by a dependency edge in the PET Graph
    is_weak_data_race = False
    if not __pet_dependency_edge_exists(amd_1, amd_2, pet):
        is_weak_data_race = True
        return None

    # requirement 6: ignore data race if it originates from a reduction operation
    if __originate_from_reduction_operation(amd_1, amd_2):
        return None

    # requirement 7: ignore data race if at least one access originates from a critical section
    if __originate_from_critical_section(amd_1, amd_2):
        return None

    # requirement 8: ignore data races which stem from two different paths through the source code
    if __originated_from_different_paths(amd_1, amd_2):
        return None

    #    print()
    #    print("AMD1: ", amd_1.operation, " -> ", amd_1.origin_bhv_node.node_id)
    #    print("AMD2: ", amd_2.operation, " -> ", amd_2.origin_bhv_node.node_id)

    # requirement 9: ignore data races which stem from the same loop body without inter-iteration dependencies
    if __originated_from_loop_without_inter_iteration_dependences(ma_graph, amd_1, amd_2):
        print("--> NONE")
        return None

    op_1: Operation = ma_graph.graph.edges[edge_1]["data"].operation
    op_2: Operation = ma_graph.graph.edges[edge_2]["data"].operation
    data_race_object = MAGDataRace(ma_node, op_1, op_2, is_weak_data_race)
    return data_race_object


def __originated_from_different_paths(amd_1: AccessMetaData, amd_2: AccessMetaData):
    """checks whether both accesses share a MUTEX-Modifier. If so, the data race is only valid if both accesses
    originated from the same path. This is the case, if the digits after the last ':' are equal."""
    mutexes_1 = [mod for mod in amd_1.operation.modifiers if mod[0] == OperationModifierType.MUTEX]
    mutexes_2 = [mod for mod in amd_2.operation.modifiers if mod[0] == OperationModifierType.MUTEX]
    # split modifiers into mutex-id + path id
    split_mutexes_1 = [(x[:x.rfind(":")], x[x.rfind(":") + 1:]) for _, x in mutexes_1]
    split_mutexes_2 = [(x[:x.rfind(":")], x[x.rfind(":") + 1:]) for _, x in mutexes_2]
    # get overlap based on first value of split_mutexes
    overlap = []
    for mid_1, pid_1 in split_mutexes_1:
        for mid_2, pid_2 in split_mutexes_2:
            if mid_1 == mid_2:
                overlap.append((mid_1, pid_1, pid_2))
    # check if both accesses originated from different paths
    for mutex_id, path_id_1, path_id_2 in overlap:
        if path_id_1 != path_id_2:
            return True
    return False



def __path_predecessor_relation_exists(path_1: List[int], path_2: List[int]) -> bool:
    """checks whether a predecessor relation between path_1 and path_2 exists.
    The check considers both orderings.
    Returns True, if a predecessor relation exists.
    Returns False, otherwise."""

    def check_precedence(inner_path_1: List[int], inner_path_2: List[int]) -> bool:
        for idx, elem in enumerate(inner_path_1):
            if idx == len(inner_path_1) - 1:
                # last element of the list
                # the last element of the list is the only one which may not be matching -> no check required
                return True
            else:
                # regular list element

                # check if element with index idx exists in inner_path_2.
                # If not, inner_path_2 is a predecessor of inner_path_1
                if idx >= len(inner_path_2):
                    return True

                # check if elements at index idx in both lists are equivalent
                if inner_path_1[idx] != inner_path_2[idx]:
                    return False

    # consider both potential precedence relations
    if check_precedence(path_1, path_2) or check_precedence(path_2, path_1):
        return True
    return False


def __pcgraph_predecessor_relation(amd_1: AccessMetaData, amd_2: AccessMetaData, pc_graph: PCGraph):
    """Check if amd_1 is a successor of amd_2 or vice-versa.
    """
    # check both directions
    result = False
#    result = result or pc_graph.is_successor_with_encountered_barrier_or_taskwait(amd_1.origin_bhv_node.node_id,
#                                                                                  amd_2.origin_bhv_node.node_id, [])
#
#    result = result or pc_graph.is_successor_with_encountered_barrier_or_taskwait(amd_2.origin_bhv_node.node_id,
#                                                                                  amd_1.origin_bhv_node.node_id, [])
    # Note: Check for barrier in path is not required anymore since barriers now directly correspond to parallel units.
    result = result or __new_is_successor(amd_1, amd_2)
    result = result or __new_is_successor(amd_2, amd_1)
    return result


def __new_is_successor(amd_1: AccessMetaData, amd_2: AccessMetaData):
    # check if amd_1 in operation_path of amd_2
    amd_2_id_path = [op.node_id for op in amd_2.operation_path[:-2]]  # ignore model and operation id
    if amd_1.origin_bhv_node.node_id in amd_2_id_path:
        # amd_2 is a successor of amd_1
        return True
    return False



def __pet_dependency_edge_exists(amd_1: AccessMetaData, amd_2: AccessMetaData, pet: PETGraphX):
    """
    Checks if the supposed data race is backed up by a corresponding dependency edge in the PET graph.
    """
    pet_node_id_amd_1 = get_pet_node_id_from_source_code_lines(pet, int(amd_1.operation.file_id),
                                                               amd_1.operation.line, amd_1.operation.line,
                                                               accessed_var_name=amd_1.operation.target_name,
                                                               node_type=NodeType.CU)
    pet_node_id_amd_2 = get_pet_node_id_from_source_code_lines(pet, int(amd_2.operation.file_id),
                                                               amd_2.operation.line, amd_2.operation.line,
                                                               accessed_var_name=amd_2.operation.target_name,
                                                               node_type=NodeType.CU)
    out_dependencies_node_1 = pet.out_edges(pet_node_id_amd_1, PETEdgeType.DATA)
    # filter dependencies, only conserve dependencies from pet_node_id_amd_1 to pet_node_id_amd_2
    dependencies_1_2 = [dep for dep in out_dependencies_node_1 if
                        dep[0] == pet_node_id_amd_1 and dep[1] == pet_node_id_amd_2]

    out_dependencies_node_2 = pet.out_edges(pet_node_id_amd_2, PETEdgeType.DATA)
    # filter dependencies, only conserve dependencies from pet_node_id_amd_2 to pet_node_id_amd_1
    dependencies_2_1 = [dep for dep in out_dependencies_node_2 if
                        dep[0] == pet_node_id_amd_2 and dep[1] == pet_node_id_amd_1]

    # combine sets of dependencies
    dependencies = dependencies_1_2
    dependencies += [dep for dep in dependencies_2_1 if dep not in dependencies]

    # ignore INIT type dependencies
    dependencies = [dep for dep in dependencies if dep[2].dtype != DepType.INIT]

    # filter dependencies for variables used in amd_1 and amd_2
    dependencies = [dep for dep in dependencies if
                    dep[2].var_name in [amd_1.operation.target_name, amd_2.operation.target_name]]

    # if the set of dependencies is not empty, a real dependency exists and thus a potential data race
    if len(dependencies) > 0:
        # ==> potential data race backed up by dependency edge
        return True

    return False


def __originate_from_reduction_operation(amd_1: AccessMetaData, amd_2: AccessMetaData):
    """Check whether both accesses originate from the same reduction operation."""
    op_1_modifiers = amd_1.operation.modifiers
    op_2_modifiers = amd_2.operation.modifiers
    # determine overlapping modifiers
    overlapping_modifiers = [modifier for modifier in op_1_modifiers if modifier in op_2_modifiers]
    # check for reduction modifiers. Key can be ignored
    for modifier_type, _ in overlapping_modifiers:
        if modifier_type == OperationModifierType.REDUCTION_OPERATION:
            return True
    return False


def __originate_from_critical_section(amd_1: AccessMetaData, amd_2: AccessMetaData):
    """Check whether at least one access originates from a critical section"""
    # check if amd_1 or amd_2 is contained in a critical section
    for modifier, _ in amd_1.operation.modifiers + amd_2.operation.modifiers:
        if modifier == OperationModifierType.CRITICAL_SECTION_OPERATION:
            return True
    return False


