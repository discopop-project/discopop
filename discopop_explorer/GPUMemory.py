from enum import Enum
from typing import List, Set
from .variable import Variable
from .PETGraphX import PETGraphX, CUNode, NodeType, DepType
from .utils import is_func_arg, is_global, __get_dep_of_type as get_dep_of_type


def map_node(pet: PETGraphX, nodeID: str) -> CUNode:
    return pet.node_at(nodeID)


class map_type_t(Enum):
    MT_TO = 1
    MT_FROM = 2
    MT_TOFROM = 3
    MT_ALLOC = 4
    MT_NONE = 5


def set_find(x: str, s: Set[str]) -> str:
    """ implements the cpp function set::find

    :param x: Node to find in set
    :param s: Set to search for given node
    :return: returns either node if it is found, last elem otherwise
    """
    if x in s:
        return x  # found node
    elif not s:
        return ""  # given set empty
    else:
        return s.pop()  # returns last elem of set


def set_end(s: Set[str]) -> str:
    """ implements the cpp function set::end

    :param s: set of Node IDs
    :return: last elem of given set
    """
    if not s:
        return ""  # given set empty
    else:
        return s.pop()  # returns last elem of set without popping


def getCalledFunctions(pet: PETGraphX, node: CUNode,
                       calledFunctions: Set[str], dummyFunctions: Set[str]) -> Set[str]:
    """ This function traverses all children nodes of 'node' and adds every
        encountered function (non-dummy) to the 'calledFunctions' set.
        Dummy functions (e.g. functions from linked libraries) are added to the
        'dummyFunctions' set.
        (not recursive anymore, but called function subtree_of_type is)

    :param pet:
    :param node:
    :param calledFunctions:
    :param dummyFunctions:
    :return:
    """
    sub_func = pet.subtree_of_type(node, NodeType.FUNC)
    for e in sub_func:
        calledFunctions.update(e.id)

    # unnecessary in this i think
    sub_dummy = pet.subtree_of_type(node, NodeType.DUMMY)
    for e in sub_dummy:
        dummyFunctions.update(e.id)

    return calledFunctions


def getDeps(cuIDs: List[CUNode], pet: PETGraphX,
            RAWDepsOn: Set, WARDepsOn: Set, WAWDepsOn: Set,
            reverseRAWDepsOn: Set,
            reverseWARDepsOn: Set,
            reverseWAWDepsOn: Set) -> None:
    """ gather all dependencies of the nodes specified in 'cuIDs'
        ---doesnt work here because addresses---

    :param pet:
    :param cuIDs:
    :param RAWDepsOn:
    :param WARDepsOn:
    :param WAWDepsOn:
    :param reverseRAWDepsOn:
    :param reverseWARDepsOn:
    :param reverseWAWDepsOn:
    :return:
    """
    for sub_node in cuIDs:
        # insert all entries from child_cu.RAW_deps_on into RAW_deps_on etc.
        RAWDepsOn.update(get_dep_of_type(pet, sub_node, DepType.RAW, False))
        WARDepsOn.update(get_dep_of_type(pet, sub_node, DepType.WAR, False))
        WAWDepsOn.update(get_dep_of_type(pet, sub_node, DepType.WAW, False))
        reverseRAWDepsOn.update(get_dep_of_type(
            pet, sub_node, DepType.RAW, True))
        reverseWARDepsOn.update(get_dep_of_type(
            pet, sub_node, DepType.WAR, True))
        reverseWAWDepsOn.update(get_dep_of_type(
            pet, sub_node, DepType.WAW, True))


def assignMapType(loop: CUNode, loopCUs: List[str], var: Variable, isScalar: bool, pet: PETGraphX,
                  RAWDepsOn: Set, reverseRAWDepsOn: Set) -> map_type_t:
    """ assigns a map-type to the variable 'var'

    WARDepsOn: Set[Dependency], WAWDepsOn: Set[Dependency], reverseWARDepsOn: Set[Dependency],
    reverseWAWDepsOn: Set[Dependency] all unused
    :param loop:
    :param loopCUs:
    :param var:
    :param isScalar:
    :param pet:
    :param RAWDepsOn:
    :param reverseRAWDepsOn:
    :return:
    """
    # The dependencies are scanned to detect where data
    # transfers to or from the device are required.
    copy_to: bool = False
    copy_from: bool = False

    # print("VAR: " + var.name + " in " +
    #       str(loop.start_line) + " " + str(loop.end_line))

    # is_global takes list of nodes, not ids
    loop_nodes: List[CUNode] = []
    for i in loopCUs:
        loop_nodes.append(map_node(pet, i))  # for later

    # a variable need to be copied to target memory if there exists a RAW
    # dependency for this variable with the sink inside the loop and the source
    # outside of it
    # [Tuple[str, str, Dependency]]:
    for dep in RAWDepsOn:
        if var.name != dep[2].var_name:
            continue

        source_in_loop = False
        if dep[2].var_name in loopCUs:
            source_in_loop = True

        if not source_in_loop:
            copy_to = True
            break

    # a variable needs to be copied to host memory after leaving the loop, if
    # there exists a reverseRAW dependency for this variable with the sink
    # outside the loop and the source inside it
    for dep in reverseRAWDepsOn:
        if var.name != dep[2].var_name:
            continue

        sink_in_loop = False
        if dep[2].var_name in loopCUs:
            sink_in_loop = True

        if not sink_in_loop:
            copy_from = True
            break

    # based on which data transfers are required, decide on which map-type to
    # assign to this variable
    if copy_to and not copy_from:
        return map_type_t.MT_TO
    elif not copy_to and copy_from:
        return map_type_t.MT_FROM
    elif copy_to and copy_from:
        return map_type_t.MT_TOFROM

    # no RAW dependencies exist for function arguments and unmodified global variables
    # - however, since the variable is accessed in the loop assume it is read
    if is_func_arg(pet, var.name, loop) or is_global(var.name, loop_nodes):
        return map_type_t.MT_TO

    # if none of the above conditions are fulfilled, no data transfer is required
    return map_type_t.MT_NONE if isScalar else map_type_t.MT_ALLOC
