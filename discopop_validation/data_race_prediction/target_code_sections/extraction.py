from typing import List, Tuple, Optional

from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.data_race_prediction.parallel_construct_graph.classes.EdgeType import EdgeType


def identify_target_sections_from_pragma(pc_graph, pragma: OmpPragma, pc_graph_node_id) -> List[
    Tuple[str, str, str, str, str]]:
    """extracts relevant section in the original source code from the given suggestion and reports it as a tuple.
    Output format: [(<section_id>, <file_id>, "target_line_0,target_line_1,..." , <var_name>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[int, int, int, str, PragmaType]] = []
    # include parallel, parallel for, single and critical pragmas
    if pragma.get_type() in [PragmaType.FOR, PragmaType.PARALLEL, PragmaType.SINGLE, PragmaType.TASK, PragmaType.CRITICAL]:
        pragma_target_regions: List[Tuple[int, int, Optional[List[str]]]] = [(pragma.start_line, pragma.end_line, None)]
        # add body of called functions to pragma_target_regions, if pragma not contained in called function (recursive call)
#        outgoing_calls_edges = [edge for edge in pc_graph.graph.out_edges(pc_graph_node_id) if
#                                pc_graph.graph.edges[edge]["type"] == EdgeType.CALLS]
#        for _, target in outgoing_calls_edges:
#            target_outgoing_contains_edges = [edge for edge in pc_graph.graph.out_edges(target) if
#                                              pc_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS]
#            # check if pragma is contained in called function and skip it if necessary
#            skip_current_target = False
#            for _, target_contains in target_outgoing_contains_edges:
#                if pragma == pc_graph.graph.nodes[target_contains]["data"].pragma:
#                    skip_current_target = True
#                    break
#            if skip_current_target:
#                continue
#
#            called_function_body_start = pc_graph.graph.nodes[target]["data"].start_line
#            called_function_body_end = pc_graph.graph.nodes[target]["data"].end_line
#            # get shared variables used in contained pragmas
#            used_shared_variables = []
#            for _, inner_target in target_outgoing_contains_edges:
#                inner_target_pragma = pc_graph.graph.nodes[inner_target]["data"].pragma
#                if inner_target_pragma is not None:
#                    used_shared_variables += inner_target_pragma.get_variables_listed_as("shared")
#            # remove duplicates
#            used_shared_variables = list(dict.fromkeys(used_shared_variables))
#            pragma_target_regions.append((called_function_body_start, called_function_body_end, used_shared_variables))

        # split pragma region if outgoing contains-edges exist
        for edge in pc_graph.graph.out_edges(pc_graph.pragma_to_node_id[pragma]):
            # check if edge type is "CONTAINS"
            if pc_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                # split pragma regions around contained pragma
                contained_pragma_start_line = pc_graph.graph.nodes[edge[1]]["data"].pragma.start_line
                contained_pragma_end_line = pc_graph.graph.nodes[edge[1]]["data"].pragma.end_line
                # get regions which need to be removed (resp. split) and newly created
                remove_regions = []
                add_regions = []
                for region_start, region_end, shared_variables in pragma_target_regions:
                    if contained_pragma_start_line >= region_start and contained_pragma_end_line <= region_end:
                        remove_regions.append((region_start, region_end, shared_variables))
                        add_regions.append((region_start, contained_pragma_start_line - 1, shared_variables))
                        add_regions.append((contained_pragma_end_line + 1, region_end, shared_variables))
                # remove or add regions
                for region in remove_regions:
                    pragma_target_regions.remove(region)
                for region in add_regions:
                    pragma_target_regions.append(region)

        for p_start_line, p_end_line, shared_variables in pragma_target_regions:
            # list of variable names must end with ','!
            if shared_variables is None:
                interim_result.append((pragma.file_id, p_start_line, p_end_line,
                                       ",".join(pragma.get_variables_listed_as("shared")) + ",", pragma.get_type()))
            else:
                interim_result.append((pragma.file_id, p_start_line, p_end_line,
                                       ",".join(shared_variables) + ",", pragma.get_type()))
            result: List[Tuple[str, str, str, str, str]] = []
            for idx, r in enumerate(interim_result):
                target_lines = range(r[1], r[2]+1)
                targets_line = ""
                for l in target_lines:
                    targets_line += str(l) + ","
                result.append((str(idx), str(r[0]), targets_line, str(r[3]), str(r[4])))
        return result
    else:
        return []
