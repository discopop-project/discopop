from typing import Dict, List, Tuple, Set

import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.context.ContextObject import ContextObject
from discopop_library.OptimizationGraph.classes.context.Update import Update
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.utilities.MOGUtilities import get_successors


def calculate_data_transfers(graph: nx.DiGraph, function_performance_models: Dict[FunctionRoot, List[CostModel]]) -> Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]]:
    """Calculate data transfers for each performance model and append the respective ContextObject to the result."""
    for function in function_performance_models:
        for model in function_performance_models[function]:
            # create a ContextObject for the current path
            print()
            context = ContextObject()
            context = get_path_context(function.node_id, graph, model, context)
            print()
    # todo
    #  replace with something useful
    return dict()


def get_path_context(node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject) -> ContextObject:
    """passes the context Object along the path and returns the context once the end has been reached"""
    print("get_path_context: NodeID: ", node_id)
    # calculate context modifications for the current node
    # todo
    #  context = __check_current_node(node_id, graph, model, context)

    # calculate context modifications for the children of the current node
    # todo
    #  context = __check_children(node_id, graph, model, context)

    # pass context to the right successor of the current node
    # At most a single node can be a successor, since the given model represents a single path through the graph.
    successors = get_successors(graph, node_id)
    if len(successors) == 1:
        # pass context to the single successor
        print("Sole Successor: ", successors[0])
        return get_path_context(successors[0], graph, model, context)

    elif len(successors) == 0:
        print("No successor")
        # no successor exists, return the current context
        return context

    else:
        # multiple successors exist
        # find the successor which represents the path decision included in the model
        suitable_successors = [succ for succ in successors if succ in model.path_decisions]
        if len(suitable_successors) != 1:
            raise ValueError("Invalid amount of potential successors (", len(suitable_successors), ") for path split at node:", node_id)
        # suitable successor identified.
        # pass the current context to the successor
        print("Found suitable successor: ", suitable_successors[0])
        return get_path_context(suitable_successors[0], graph, model, context)


def __check_current_node(node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject) -> ContextObject:
    raise NotImplementedError("TODO")

def __check_children(node_id: int, graph: nx.DiGraph, model: CostModel, context: ContextObject) -> ContextObject:
    raise NotImplementedError("TODO")