# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import logging
import threading
from typing import List, Optional, Set, Tuple, cast

from tqdm import tqdm  # type: ignore


from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.ContextTaskGraph import ContextTaskGraph
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.InlinedFunctionContext import InlinedFunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Contexts.WorkContext import WorkContext
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.classes.patterns.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import TPIType, TaskParallelismInfo
from GUI.Visualizers.Base import Base as Visualizer

logger = logging.getLogger("Explorer").getChild("Tasking")


def run_detection(pet: PEGraphX, task_graph: TaskGraph, visualizer: Visualizer | None) -> List[PatternInfo]:
    logger.info("Starting task detection...")
    result: List[PatternInfo] = []

    logger.info("--> Constructing context task graph from main function...")
    context_task_graph = ContextTaskGraph(task_graph, visualizer)

    # result += identify_simple_taskloop(pet, task_graph)
    result += identify_simple_tasking(context_task_graph)

    # identify immediate successive contexts with no dependencies between them
    logger.info("--> Identify tasking with data sharing clauses ... TODO")
    logger.info("--> Identifying simple asynchronous tasking ... TODO")
    # identify non-immediate successive contexts with no dependencies between them, such that asynchronous execution is possible
    logger.info("--> Identifying dependent tasking... TODO")
    logger.info("--> Identifying multi-dependent tasking... TODO")
    logger.info("--> Identifying loop tasking... TODO")
    logger.info("--> Identifying recursive tasking... TODO?")

    return result


def show_all_plots(context_task_graph: ContextTaskGraph, highlight_nodes: Optional[Set[Context]] = None) -> None:
    if (context_task_graph.plottable() == False):
        return
    
    def draw_plots() -> None:
        [ax1, ax2, ax3, ax4] = context_task_graph.create_multi_plot(
            "Graphs",
            ["Task Graph", "Task graph (context graph)", "Task graph (context debug graph)", "Context task graph"],
            2,
            2
        )

        print("Plotting task graph...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.update_plot(ax1)

        print("Plotting task graph (context graph)...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.plot_context_graph(ax2)

        print("Plotting task graph (context debug graph)...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.plot_context_debug_graph(ax3)

        print("Plotting context task graph...")
        context_task_graph.update_plot(
            ax4,
            highlight_nodes=list(highlight_nodes) if highlight_nodes is not None else None
        )

        ax1 = context_task_graph.create_plot("Task Graph")
        ax2 = context_task_graph.create_plot("Task graph (context graph)")
        ax3 = context_task_graph.create_plot("Task graph (context debug graph)")
        ax4 = context_task_graph.create_plot("Context task graph")

        print("Plotting separate task graph...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.update_plot(ax1)

        print("Plotting separate task graph (context graph)...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.plot_context_graph(ax2)

        print("Plotting separate task graph (context debug graph)...")
        if len(context_task_graph.task_graph.graph.nodes()) < 500:
            context_task_graph.task_graph.plot_context_debug_graph(ax3)

        print("Plotting separate context task graph...")
        context_task_graph.update_plot(
            ax4,
            highlight_nodes=list(highlight_nodes) if highlight_nodes is not None else None
        )

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
                context_task_graph.delete_frame(frame_name)
            except KeyError:
                pass

        draw_plots()

    context_task_graph.set_filter_callback(on_filter)
    draw_plots()
    context_task_graph.run_visualizer()


def identify_simple_tasking(context_task_graph: ContextTaskGraph) -> List[TaskParallelismInfo]:
    """NOTE: THIS SHOULD BE REMOVED / DISABLED, AS IT IS COVERED BY THE TASK DETECTION DURING GRAPH SIMPLIFICATION."""
    logger.info("Identifying trivial tasking potential...")
    patterns: List[TaskParallelismInfo] = []
    fork_join_pairs: List[Tuple[Context, Context]] = []
    logger.info("--> checking nodes")
    for node in tqdm(context_task_graph.graph.nodes):
        # ignore non-root descendants

        # identify fork nodes
        successors = context_task_graph.get_successors(node)
        if len(successors) < 2:
            continue

        # restrict search space. Require at least one inlined function as a child of the fork node
        has_inlined_function = False
        for succ in successors:
            if isinstance(succ, InlinedFunctionContext):
                has_inlined_function = True
                break
        if not has_inlined_function:
            continue

        # node is a fork
        # check if a clean join node exists, i.e., if all branches arrive at the same node without crossing each other
        frontiers: List[Tuple[Context, int]] = [(succ, 1) for succ in successors]
        visited: Set[Context] = set(successors)
        join_nodes: List[Context] = []

        while len(frontiers) > 0:
            current_frontier, counter = frontiers.pop()
            successors = context_task_graph.get_successors(current_frontier)
            predecessors = context_task_graph.get_predecessors(current_frontier)
            # check if the end of the path is reached
            if len(successors) == 0:
                join_nodes.append(current_frontier)
                continue
            # decrease the counter, if a join node is encountered
            if len(predecessors) > 1:
                counter -= 1

            # if the counter falls to zero, the join node that should belong to the original, outer fork node should be encountered
            # -> stop the search on this path.
            if counter == 0:
                join_nodes.append(current_frontier)
                continue

            # increase the counter, if a fork node is encountered. After checking for counter=0 to allow join-fork-nodes
            if len(successors) > 1:
                counter += 1

            for succ in successors:
                if succ not in visited:
                    frontiers.append((succ, counter))
                    visited.add(succ)

        # check if a clean join node has been found
        # -> clean, if exactly one join node is identified along every branch
        join_nodes = list(set(join_nodes))
        clean_join_node: Optional[Context] = None if len(join_nodes) != 1 else join_nodes[0]

        if clean_join_node is None:
            continue

        # ignore cases where the join node is a direct successor of the branch node, i.e., nothing happens in one branch
        if clean_join_node in context_task_graph.get_successors(node):
            continue

        # tasking possible, if a clean join node has been found
        print("----> Found clean JOIN node: " + str(clean_join_node))
        fork_join_pairs.append((node, clean_join_node))

    # convert fork-join-pairs to task entry-barrier-pairs
    task_entry_barrier_pairs: List[Tuple[List[Context], Context]] = []
    for tpl in fork_join_pairs:
        # collect task entry nodes
        task_entry_points: List[Context] = context_task_graph.get_successors(tpl[0])
        task_entry_barrier_pairs.append((task_entry_points, tpl[1]))

    #    # DEBUG
    highlight_nodes: Set[Context] = set()
    for tpl in fork_join_pairs:
        highlight_nodes.add(tpl[0])
        for succ in context_task_graph.get_successors(tpl[0]):
            highlight_nodes.add(succ)
        highlight_nodes.add(tpl[1])

    show_all_plots(context_task_graph, highlight_nodes=highlight_nodes)
    # !DEBUG

    for tpl2 in task_entry_barrier_pairs:
        print("FJP: ", tpl2)
        tmp_patterns: List[TaskParallelismInfo] = []
        # create task pattern for each entry
        last_pet_node = None
        for entry in tpl2[0]:
            pet_node = entry.get_first_pet_node(context_task_graph.pet)
            if pet_node is not None:
                tmp_patterns.append(
                    TaskParallelismInfo(
                        pet_node,
                        type=TPIType.TASK,
                        pragma=["#pragma omp task"],
                        pragma_line=pet_node.start_position(),
                        first_private=[],
                        private=[],
                        shared=[],
                    )
                )
                last_pet_node = pet_node

        # create a barrier pattern for the join
        # link the patterns together
        barrier_location = tpl2[1].get_first_pet_node(context_task_graph.pet)
        if barrier_location is not None:
            tmp_patterns.append(
                TaskParallelismInfo(
                    barrier_location,
                    type=TPIType.TASKWAIT,
                    pragma=["#pragma omp taskwait"],
                    pragma_line=barrier_location.start_position(),
                    first_private=[],
                    private=[],
                    shared=[],
                )
            )
        elif last_pet_node is not None:
            tmp_patterns.append(
                TaskParallelismInfo(
                    last_pet_node,
                    type=TPIType.TASKWAIT,
                    pragma=["#pragma omp taskwait"],
                    pragma_line=last_pet_node.start_position(),
                    first_private=[],
                    private=[],
                    shared=[],
                )
            )

        patterns += tmp_patterns

    return patterns
