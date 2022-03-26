from typing import Dict, List, Tuple, Optional
from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType


def identify_target_sections_from_pragma(task_graph, pragma: OmpPragma, task_graph_node_id) -> List[Tuple[str, str, str, str, str, str]]:
    """extracts relevant section in the original source code from the given suggestion and reports it as a tuple.
    Output format: [(<section_id>, <file_id>, <start_line>, <end_line>, <var_name>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str, str, str]] = []
    # include parallel, parallel for and single pragmas
    if pragma.get_type() in [PragmaType.FOR, PragmaType.PARALLEL, PragmaType.SINGLE, PragmaType.TASK]:
        pragma_target_regions: List[Tuple[int, int, Optional[List[str]]]] = [(pragma.start_line, pragma.end_line, None)]
        # add body of called functions to pragma_target_regions
        outgoing_calls_edges = [edge for edge in task_graph.graph.out_edges(task_graph_node_id) if task_graph.graph.edges[edge]["type"] == EdgeType.CALLS]
        for _, target in outgoing_calls_edges:
            called_function_body_start = task_graph.graph.nodes[target]["data"].start_line
            called_function_body_end = task_graph.graph.nodes[target]["data"].end_line
            # get shared variables used in contained pragmas
            used_shared_variables = []
            target_outgoing_contains_edges = [edge for edge in task_graph.graph.out_edges(target) if task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS]
            for _, inner_target in target_outgoing_contains_edges:
                inner_target_pragma = task_graph.graph.nodes[inner_target]["data"].pragma
                if inner_target_pragma is not None:
                    used_shared_variables += inner_target_pragma.get_variables_listed_as("shared")
            # remove duplicates
            used_shared_variables = list(set(used_shared_variables))
            pragma_target_regions.append((called_function_body_start, called_function_body_end, used_shared_variables))

        # split pragma region if outgoing contains-edges exist
        for edge in task_graph.graph.out_edges(task_graph.pragma_to_node_id[pragma]):
            # check if edge type is "CONTAINS"
            if task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                # split pragma regions around contained pragma
                contained_pragma_start_line = task_graph.graph.nodes[edge[1]]["data"].pragma.start_line
                contained_pragma_end_line = task_graph.graph.nodes[edge[1]]["data"].pragma.end_line
                # get regions which need to be removed (resp. split) and newly created
                remove_regions = []
                add_regions = []
                for region_start, region_end, shared_variables in pragma_target_regions:
                    if contained_pragma_start_line >= region_start and contained_pragma_end_line <= region_end:
                        remove_regions.append((region_start, region_end, shared_variables))
                        add_regions.append((region_start, contained_pragma_start_line-1, shared_variables))
                        add_regions.append((contained_pragma_end_line+1, region_end, shared_variables))
                # remove or add regions
                for region in remove_regions:
                    pragma_target_regions.remove(region)
                for region in add_regions:
                    pragma_target_regions.append(region)

        for p_start_line, p_end_line, shared_variables in pragma_target_regions:
            # list of variable names must end with ','!
            if shared_variables is None:
                interim_result.append((pragma.file_id, p_start_line, p_end_line,
                                       ",".join(pragma.get_variables_listed_as("shared"))+",", pragma.get_type()))
            else:
                interim_result.append((pragma.file_id, p_start_line, p_end_line,
                                       ",".join(shared_variables) + ",", pragma.get_type()))
            result: List[Tuple[str, str, str, str, str]] = []
            for idx, r in enumerate(interim_result):
                result.append((str(idx), str(r[0]), str(r[1]), str(r[2]), str(r[3]), str(r[4])))
        return result
    else:
        return []

