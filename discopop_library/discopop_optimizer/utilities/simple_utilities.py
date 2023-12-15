from discopop_library.discopop_optimizer.classes.nodes.GenericNode import GenericNode


import networkx as nx  # type: ignore


from typing import cast


def data_at(graph: nx.DiGraph, node_id: int) -> GenericNode:
    """Return the data object stored at the networkx node with id node_id."""
    return cast(GenericNode, graph.nodes[node_id]["data"])
