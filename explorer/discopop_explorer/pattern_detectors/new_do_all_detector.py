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
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import (
    ParallelRegionInfo,
    TPIType,
    TaskParallelismInfo,
)
from discopop_gui.Visualizers.WithSidebar import WithSidebar as VisualizerWithSideBar

logger = logging.getLogger("Explorer").getChild("DoAll")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[DoAllInfo]:
    logger.info("Starting new do_all detection...")
    result: List[DoAllInfo] = []

    show_plot(task_graph)

    result += identify_simple_doall(task_graph)

    return result


def show_plot(tg: TaskGraph) -> None:
    if tg.plottable() == False:
        return

    def draw_plots() -> None:
        ax = tg.create_plot("Context Graph")
        print("Plotting task graph (context graph)...")
        if len(tg.graph.nodes()) < 500:
            tg.plot_context_graph(ax)

        ax2 = tg.create_plot("Context Debug Graph")
        print("Plotting task graph (context debug graph)...")
        if len(tg.graph.nodes()) < 500:
            tg.plot_context_debug_graph(ax2)

    def on_filter(filter_text: str) -> None:
        print("Filter text:", filter_text)

        # Extra processing here

        for frame_name in [
            "Graphs",
            "Task Graph",
            "Task graph (context graph)",
            "Task graph (context debug graph)",
            "Context task graph",
        ]:
            try:
                tg.delete_frame(frame_name)
            except KeyError:
                pass

    tg.set_filter_callback(on_filter)
    draw_plots()
    tg.run_visualizer()


def identify_simple_doall(tg: TaskGraph) -> List[DoAllInfo]:
    """Analyzes the results of the graph simplification and create simple doall patterns.
    Implementation is fundamentally similar to the original doall detector, but implemented in a more maintainable fashion.
    Checks for clean doall opportunities."""
    patterns: List[DoAllInfo] = []
    logger.info("Identifying trivial doall suggestions.")

    show_plot(tg)


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
        # get loop variables for later check 
        loop_variables = cast(LoopParentContext, node.created_context).loop_variables
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
                    # WAR dependencies between iterations are non-critical, as they overwrite data and thus can be privatized
                    if dep.etype == EdgeType.DATA and dep.dtype == DepType.WAR:
                        continue

                    if out_dep_target in other_iterations_subnodes:
                        # check for and allow accesses to the loop variable
                        if (dep.var_name, dep.memory_region) in loop_variables:
                            print("Dependency on Loop variable! ")
                            pass
                        else:
                            print(
                                "Prevents doall:",
                                dep.dtype,
                                dep.source_line,
                                dep.sink_line,
                                dep.var_name,
                                dep.memory_region,
                                "source:",
                                subnode.get_code_scope(tg.pet, inclusive=True),
                                "out_dep_target:",
                                out_dep_target.get_code_scope(tg.pet, inclusive=True),
                                "source_ctx:", ic_source,
                                "target_ctx:", out_dep_target
                            )
                            dependency_found = True
                            break
                if dependency_found:
                    break
            if dependency_found:
                break
        if dependency_found:
            # node is not a valid doall loop
            prevented_loops.add(node.pet_node_id)
            print("PREVENTED: 1")
            continue
        # node is a valid doall loop. Register a pattern
        pattern = DoAllInfo(tg.pet, tg.pet.node_at(node.pet_node_id))

        # prevent duplicates. Necessary since multiple copies of the same loop might exist
        if pattern.pattern_tag in [p.pattern_tag for p in patterns]:
            continue
        print(" FOUND 1")
        patterns.append(pattern)

    # clean patterns agains prevented loops
    patterns = [p for p in patterns if p.node_id not in prevented_loops]

    return patterns
