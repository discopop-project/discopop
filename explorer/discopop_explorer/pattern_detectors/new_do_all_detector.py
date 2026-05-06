# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import logging
import threading
from typing import Dict, List, Optional, Set, Tuple, cast

from tqdm import tqdm  # type: ignore


from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.NodeID import NodeID
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.ContextTaskGraph import ContextTaskGraph
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.InlinedFunctionContext import InlinedFunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Contexts.TaskParentContext import TaskParentContext
from discopop_explorer.classes.TaskGraph.Contexts.WorkContext import WorkContext
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.classes.patterns.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import (
    ParallelRegionInfo,
    TPIType,
    TaskParallelismInfo,
)
from GUI.Visualizers.WithSidebar import WithSidebar as VisualizerWithSideBar

logger = logging.getLogger("Explorer").getChild("DoAll")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[DoAllInfo]:
    logger.info("Starting new do_all detection...")
    result: List[DoAllInfo] = []

    # show_all_plots(task_graph)

    result += identify_simple_doall(task_graph)

    return result


def show_all_plots(tg: TaskGraph) -> None:
    raise NotImplementedError("Show all plots.")


def identify_simple_doall(tg: TaskGraph) -> List[DoAllInfo]:
    """Analyzes the results of the graph simplification and create simple doall patterns.
    Implementation is fundamentally similar to the original doall detector, but implemented in a more maintainable fashion.
    Checks for clean doall opportunities."""
    patterns: List[DoAllInfo] = []
    logger.info("Identifying trivial doall suggestions.")

    prevented_loops: Set[NodeID] = set()

    for node in tg.graph.nodes():
        # check if node is LoopParent
        if not isinstance(node.created_context, LoopParentContext):
            continue
        # check if loop is not already prevented
        if node.pet_node_id in prevented_loops:
            continue
        # get child iterations
        iteration_contexts = [
            ctx for ctx in node.created_context.get_contained_contexts() if isinstance(ctx, IterationContext)
        ]
        if len(iteration_contexts) < 2:
            continue
        # get subtrees of iteration contexts
        subtrees: Dict[IterationContext, Set[Context]] = dict()
        for ic in iteration_contexts:
            subtrees[ic] = ic.get_contained_contexts(inclusive=True)
        # check for dependencies
        dependency_found = False
        for ic_source in iteration_contexts:
            # collect nodes from other iterations
            other_iterations_subnodes: Set[Context] = set()
            for ic_other in iteration_contexts:
                if ic_source == ic_other:
                    continue
                other_iterations_subnodes.add(ic_other)
                other_iterations_subnodes = other_iterations_subnodes.union(subtrees[ic_other])
            # check for do-all preventing dependencies
            for subnode in subtrees[ic_source]:
                for out_dep_target, dep in subnode.outgoing_dependencies:
                    if out_dep_target in other_iterations_subnodes:
                        dependency_found = True
                        break
                if dependency_found:
                    break
            if dependency_found:
                break
        if dependency_found:
            # node is not a valid doall loop
            prevented_loops.add(node.pet_node_id)
            continue
        # node is a valid doall loop. Register a pattern
        pattern = DoAllInfo(tg.pet, tg.pet.node_at(node.pet_node_id))

        # prevent duplicates. Necessary since multiple copies of the same loop might exist
        if pattern.pattern_tag in [p.pattern_tag for p in patterns]:
            continue

        patterns.append(pattern)

    # clean patterns agains prevented loops
    patterns = [p for p in patterns if p.node_id not in prevented_loops]

    return patterns
