import os
from typing import List

from .PETGraphX import PETGraphX, NodeType, CUNode, DepType, EdgeType
from .parser import parse_inputs


def __collect_children_ids(pet: PETGraphX, parent_id: str, children_ids: List[str]):
    if parent_id in children_ids:
        # this id has already been processed. No need to go through it again
        return children_ids
    children_ids.append(parent_id)
    children_ids = list(set(children_ids))
    # collect all of its children
    for child_node in pet.direct_children(pet.node_at(parent_id)):
        children_ids += __collect_children_ids(pet, child_node.id, children_ids)
        children_ids = list(set(children_ids))
    return children_ids


def __search_recursive_calls(pet: PETGraphX, output_file, node: CUNode):
    if node.type != NodeType.CU:
        return
    for recursive_function_call in node.recursive_function_calls:
        if recursive_function_call is None:
            continue
        output_file.write(recursive_function_call + " ")

        children_ids = []
        # Output RAW deps. First collect all children IDs of currently called
        # function. Then go through the CU type nodes in them and record all deps
        # that are on the cus in this list.
        children_ids = __collect_children_ids(pet, node.id, children_ids)

        for child_id in children_ids:
            # node type is not cu so goto next node
            if pet.node_at(child_id).type is not NodeType.CU:
                continue

            for dep in pet.in_edges(child_id, EdgeType.DATA):
                if dep[2].dtype is not DepType.RAW:
                    continue
                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(dep[2].sink + "|RAW|" + dep[2].source + "|" + dep[2].var_name + ",")

            for dep in pet.in_edges(child_id, EdgeType.DATA):
                if dep[2].dtype is not DepType.WAR:
                    continue
                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(dep[2].sink + "|WAR|" + dep[2].source + "|" + dep[2].var_name + ",")

            for dep in pet.in_edges(child_id, EdgeType.DATA):
                if dep[2].dtype is not DepType.WAW:
                    continue
                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(dep[2].sink + "|WAW|" + dep[2].source + "|" + dep[2].var_name + ",")

        output_file.write("\n")


def cu_instantiation_input_cpp(pet: PETGraphX, output_dir: str):
    """translation of CUInstantiationInput.cpp, previously contained in discopop-analyzer/analyzer/src.
    TODO documentation"""
    output_dir = output_dir if output_dir.endswith("/") else output_dir + "/"
    data_cu_inst_file = open(output_dir + "Data_CUInst.txt", "w+") if output_dir is not None else open(
        "Data_CUInst.txt", "w+")
    for node in pet.all_nodes():
        __search_recursive_calls(pet, data_cu_inst_file, node)
    data_cu_inst_file.flush()
    data_cu_inst_file.close()


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def wrapper(cu_xml, dep_file, loop_counter_file, reduction_file, output_dir):
    """Wrapper to generate the Data_CUInst.txt file, required for the generation of CUInstResult.txt"""
    # 1. generate PET Graph
    pet = PETGraphX.from_parsed_input(*parse_inputs(cu_xml, dep_file, loop_counter_file, reduction_file))
    # 2. Generate Data_CUInst.txt
    cu_instantiation_input_cpp(pet, output_dir)
