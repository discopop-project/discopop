# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from typing import List, cast

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
        # check if recursive function call occurs inside loop (check if line contained in lines of any loop cu)
        contained_in_loop: bool = False
        for tmp_cu in pet.all_nodes(NodeType.LOOP):
            if __line_contained_in_region(recursive_function_call.split(" ")[-1].replace(",", ""),
                                          tmp_cu.start_position(), tmp_cu.end_position()):
                contained_in_loop = True
        # check if recursive function call is called multiple times
        called_multiple_times = False
        for tmp_func_cu in pet.all_nodes(NodeType.FUNC):
            # 1. get parent function of recursive function call
            if not __line_contained_in_region(recursive_function_call.split(" ")[-1].replace(",", ""),
                                              tmp_func_cu.start_position(), tmp_func_cu.end_position()):
                continue
            # recursive function call contained in tmp_func_cu
            # 2. check if multiple calls to recursive function exist in tmp_func_cus body
            # by listing cu nodes in function body.
            # get cu's inside function by traversing child edges
            queue: List[CUNode] = [tmp_func_cu]
            contained_cus: List[CUNode] = []
            while len(queue) > 0:
                cur_cu = queue.pop(0)
                if __line_contained_in_region(cur_cu.start_position(), tmp_func_cu.start_position(),
                                              tmp_func_cu.end_position()) and \
                        __line_contained_in_region(cur_cu.end_position(), tmp_func_cu.start_position(),
                                                   tmp_func_cu.end_position()):
                    # cur_cu contained in tmp_func_cu's scope
                    if cur_cu not in contained_cus:
                        contained_cus.append(cur_cu)
                    # append cur_cu children to queue
                    for child_edge in pet.out_edges(cur_cu.id, EdgeType.CHILD):
                        child_cu = pet.node_at(child_edge[1])
                        if child_cu not in queue:
                            if child_cu not in contained_cus:
                                queue.append(child_cu)
            # get recursive function calls from contained_cus
            rec_calls: List[str] = []
            for tmp_cu in contained_cus:
                rec_calls += tmp_cu.recursive_function_calls
            # remove None and prune rec_calls to called function names only
            rec_calls = [e for e in rec_calls if e is not None]
            rec_calls = [e.split(" ")[0] for e in rec_calls]
            # check if recursive_function_call occurs at least twice
            if rec_calls.count(recursive_function_call.split(" ")[0]) > 1:
                called_multiple_times = True

        # check if recursive function is called inside loop or multiple times
        if not (contained_in_loop or called_multiple_times):
            continue

        output_file.write(recursive_function_call + " ")

        children_ids: List[str] = []
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
                if dep[2].source is None or dep[2].var_name is None or dep[2].sink is None:
                    continue
                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(cast(str, dep[2].sink) + "|RAW|" + cast(str, dep[2].source) + "|" + cast(str, dep[
                        2].var_name) + ",")

            for dep in pet.in_edges(child_id, EdgeType.DATA):
                if dep[2].dtype is not DepType.WAR:
                    continue
                if dep[2].source is None or dep[2].var_name is None or dep[2].sink is None:
                    continue
                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(cast(str, dep[2].sink) + "|WAR|" + cast(str, dep[2].source) + "|" + cast(str, dep[
                        2].var_name) + ",")

            for dep in pet.in_edges(child_id, EdgeType.DATA):
                if dep[2].dtype is not DepType.WAW:
                    continue
                if dep[2].source is None or dep[2].var_name is None or dep[2].sink is None:
                    continue

                # check if the CUid of the dep exists in children_ids
                if dep[0] in children_ids:
                    # CUid found in children_ids. So print the line numbers of this dependence
                    output_file.write(cast(str, dep[2].sink) + "|WAW|" + cast(str, dep[2].source) + "|" + cast(str, dep[
                        2].var_name) + ",")

        output_file.write("\n")


def cu_instantiation_input_cpp(pet: PETGraphX, output_dir: str):
    """translation of CUInstantiationInput.cpp, previously contained in discopop-analyzer/analyzer/src.
    Wrapper to gather information on recursive function calls for CU Instantiation.
    :param pet: PET Graph
    :param output_dir: Path to storage location of generated Data_CUInst.txt"""
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


def __line_contained_in_region(test_line: str, start_line: str, end_line: str) -> bool:
    """check if test_line is contained in [startLine, endLine].
    Return True if so. False else.
    :param test_line: <fileID>:<line>
    :param start_line: <fileID>:<line>
    :param end_line: <fileID>:<line>
    :return: bool
    """
    test_line_file_id = int(test_line.split(":")[0])
    test_line_line = int(test_line.split(":")[1])
    start_line_file_id = int(start_line.split(":")[0])
    start_line_line = int(start_line.split(":")[1])
    end_line_file_id = int(end_line.split(":")[0])
    end_line_line = int(end_line.split(":")[1])
    if test_line_file_id == start_line_file_id == end_line_file_id and \
            start_line_line <= test_line_line <= end_line_line:
        return True
    return False
