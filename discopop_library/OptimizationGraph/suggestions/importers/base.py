import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.suggestions.importers.do_all import import_suggestion as import_doall


def import_suggestions(detection_result, graph: nx.DiGraph, get_next_free_node_id_function) -> nx.DiGraph:
    """Imports the suggestions specified in res into the passed graph and returns the modified graph"""

    # import do-all
    for suggestion in detection_result.do_all:
        graph = import_doall(graph, suggestion, get_next_free_node_id_function)
    return graph