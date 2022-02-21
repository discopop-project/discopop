from typing import Dict, List, Tuple
from discopop_validation.classes.OmpPragma import PragmaType
from discopop_validation.classes.OmpPragma import OmpPragma
from discopop_validation.data_race_prediction.task_graph.classes.EdgeType import EdgeType


def identify_target_sections_from_pragma(task_graph, pragma: OmpPragma) -> List[Tuple[str, str, str, str, str, str]]:
    """extracts relevant section in the original source code from the given suggestion and reports it as a tuple.
    Output format: [(<section_id>, <file_id>, <start_line>, <end_line>, <var_name>, <suggestion_type>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str, str, str]] = []
    # include parallel, parallel for and single pragmas
    if pragma.get_type() in [PragmaType.PARALLEL_FOR, PragmaType.PARALLEL, PragmaType.SINGLE, PragmaType.TASK]:
        # split pragma region if outgoing contains-edges exist
        pragma_target_regions: List[Tuple[int, int]] = [(pragma.start_line, pragma.end_line)]
        for edge in task_graph.graph.out_edges(task_graph.pragma_to_node_id[pragma]):
            # check if edge type is "CONTAINS"
            if task_graph.graph.edges[edge]["type"] == EdgeType.CONTAINS:
                # split pragma regions around contained pragma
                contained_pragma_start_line = task_graph.graph.nodes[edge[1]]["data"].pragma.start_line
                contained_pragma_end_line = task_graph.graph.nodes[edge[1]]["data"].pragma.end_line
                # get regions which need to be removed (resp. split) and newly created
                remove_regions = []
                add_regions = []
                for region_start, region_end in pragma_target_regions:
                    if contained_pragma_start_line >= region_start and contained_pragma_end_line <= region_end:
                        remove_regions.append((region_start, region_end))
                        add_regions.append((region_start, contained_pragma_start_line-1))
                        add_regions.append((contained_pragma_end_line+1, region_end))
                # remove or add regions
                for region in remove_regions:
                    pragma_target_regions.remove(region)
                for region in add_regions:
                    pragma_target_regions.append(region)

        for p_start_line, p_end_line in pragma_target_regions:
            # list of variable names must end with ','!
            interim_result.append((pragma.file_id, p_start_line, p_end_line, ",".join(pragma.get_variables_listed_as("shared"))+",", pragma.get_type()))
            result: List[Tuple[str, str, str, str, str]] = []
            for idx, r in enumerate(interim_result):
                result.append((str(idx), str(r[0]), str(r[1]), str(r[2]), str(r[3]), str(r[4])))
        return result
    else:
        return []

