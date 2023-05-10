# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import networkx as nx  # type: ignore

from discopop_library.OptimizationGraph.Variables.Environment import Environment
from discopop_library.OptimizationGraph.suggestions.importers.do_all import (
    import_suggestion as import_doall,
)
from discopop_library.OptimizationGraph.suggestions.importers.reduction import (
    import_suggestion as import_reduction,
)


def import_suggestions(
    detection_result, graph: nx.DiGraph, get_next_free_node_id_function, environment: Environment
) -> nx.DiGraph:
    """Imports the suggestions specified in res into the passed graph and returns the modified graph"""

    # import do-all
    for suggestion in detection_result.do_all:
        graph = import_doall(graph, suggestion, get_next_free_node_id_function, environment)

    # import reduction
    for suggestion in detection_result.reduction:
        break
        graph = import_reduction(graph, suggestion, get_next_free_node_id_function, environment)
    return graph
