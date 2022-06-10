from itertools import chain, combinations

from typing import Dict, List

from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode


def get_paths(bb_graph):
    """constructs and returns a list containing a list of all possible paths through the given BBGraph."""
    path_dict: Dict[int, List[List[BBNode]]] = {}

    def __rec_construct_pathlist(root_bb_node: BBNode, entry_point_bb: BBNode, visited_root_bbs: List[BBNode]) -> List[
        List[
            BBNode]]:
        if root_bb_node.id not in bb_graph.graph.nodes:
            return []
        children_paths: List[List[BBNode]] = []
        for out_edge in bb_graph.graph.out_edges(root_bb_node.id):
            child_bb_node: BBNode = bb_graph.graph.nodes[out_edge[1]]["data"]
            if child_bb_node is entry_point_bb:
                continue
            if child_bb_node in visited_root_bbs:
                continue
            visited_root_bbs.append(child_bb_node)
            children_paths += __rec_construct_pathlist(child_bb_node, entry_point_bb, visited_root_bbs)
        # recursion condition
        if len(children_paths) == 0:
            result_paths = [[root_bb_node]]
        else:
            # insert root_bb_node at beginning of each element in children_paths
            result_paths = []
            for path in children_paths:
                path.insert(0, root_bb_node)
                result_paths.append(path)
        return result_paths

    for section_id in bb_graph.section_to_entry_point:
        entry_point = bb_graph.section_to_entry_point[section_id]
        visited_root_bbs = []
        paths = __rec_construct_pathlist(entry_point, entry_point, visited_root_bbs)
        path_dict[section_id] = paths
    return path_dict


def old_get_paths_for_sections(bb_graph):
    """constructs and returns a dictionary containing a mapping from section ids to a list of lists containing all
    possible paths for the given section"""
    path_dict: Dict[int, List[List[BBNode]]] = {}

    def __rec_construct_pathlist(root_bb_node: BBNode, entry_point_bb: BBNode, visited_root_bbs: List[BBNode]) -> List[
        List[
            BBNode]]:
        if root_bb_node.id not in bb_graph.graph.nodes:
            return []
        children_paths: List[List[BBNode]] = []
        for out_edge in bb_graph.graph.out_edges(root_bb_node.id):
            child_bb_node: BBNode = bb_graph.graph.nodes[out_edge[1]]["data"]
            if child_bb_node is entry_point_bb:
                continue
            if child_bb_node in visited_root_bbs:
                continue
            visited_root_bbs.append(child_bb_node)
            children_paths += __rec_construct_pathlist(child_bb_node, entry_point_bb, visited_root_bbs)
        # recursion condition
        if len(children_paths) == 0:
            result_paths = [[root_bb_node]]
        else:
            # insert root_bb_node at beginning of each element in children_paths
            result_paths = []
            for path in children_paths:
                path.insert(0, root_bb_node)
                result_paths.append(path)
        return result_paths

    for section_id in bb_graph.section_to_entry_point:
        entry_point = bb_graph.section_to_entry_point[section_id]
        visited_root_bbs = []
        paths = __rec_construct_pathlist(entry_point, entry_point, visited_root_bbs)
        path_dict[section_id] = paths
    return path_dict


def get_possible_path_combinations_for_sections(bb_graph) -> Dict[int, List[List[List[BBNode]]]]:
    """constructs a dictionary containing a mapping from section id to a list of lists of lists.
    The outermost list contains a list of path combinations.
    The second list contains one combination, ie. a list of paths.
    The innermost list contains BBNodes which belong to one path."""
    path_dict = old_get_paths_for_sections(bb_graph)
    result_dict: Dict[int, List[List[List[BBNode]]]] = {}

    def get_powerset(iterable):
        s = list(iterable)  # allows duplicate elements
        list_of_tuples = list(chain.from_iterable(combinations(s, r) for r in range(len(s) + 1)))
        list_of_lists = []
        for e in list_of_tuples:
            cur_list = []
            for i in range(0, len(e)):
                cur_list.append(e[i])
            list_of_lists.append(cur_list)
        return list_of_lists

    for section_id in path_dict:
        path_combinations = get_powerset(path_dict[section_id])
        result_dict[section_id] = path_combinations
    return result_dict
