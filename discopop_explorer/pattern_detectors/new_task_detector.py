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

logger = logging.getLogger("Explorer").getChild("Tasking")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[PatternInfo]:
    logger.info("Starting task detection...")
    result: List[PatternInfo] = []

    logger.info("--> Constructing context task graph from main function...")
    context_task_graph = ContextTaskGraph(task_graph)

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
    ## PLOT
    import tkinter as tk
    import numpy as np
    from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk  # type: ignore
    from matplotlib.figure import Figure

    root = tk.Tk()
    root.title("Context Task Graph")

    def close_window() -> None:
        root.quit()
        root.destroy()

    root.grid_rowconfigure(0, weight=20)
    root.grid_rowconfigure(1, weight=1)
    root.grid_rowconfigure(2, weight=20)
    root.grid_columnconfigure(0, weight=40)
    root.grid_columnconfigure(1, weight=1)
    root.grid_columnconfigure(2, weight=40)

    # ---- First independent figure ----
    frame1 = tk.Frame(root)
    fig1 = Figure()  # Figure(figsize=(5, 4))
    ax1 = fig1.add_subplot(111)
    ax1.set_title("Task graph")
    canvas1 = FigureCanvasTkAgg(fig1, master=frame1)
    canvas1.draw()
    canvas1.get_tk_widget().grid(row=0, sticky="nsew")
    toolbar1 = NavigationToolbar2Tk(canvas1, pack_toolbar=False)  # , root)
    toolbar1.update()
    toolbar1.grid(row=1)
    frame1.grid_rowconfigure(0, weight=1)
    frame1.grid_columnconfigure(0, weight=1)
    frame1.grid(column=0, row=0, sticky="nswe")

    # ---- Second independent figure ----
    frame2 = tk.Frame(root)
    fig2 = Figure()  # figsize=(5, 4))
    ax2 = fig2.add_subplot(111)
    ax2.set_title("Task graph (context graph)")
    canvas2 = FigureCanvasTkAgg(fig2, master=frame2)
    canvas2.draw()
    canvas2.get_tk_widget().grid(row=0, sticky="nsew")
    toolbar2 = NavigationToolbar2Tk(canvas2, pack_toolbar=False)  # , root)
    toolbar2.update()
    toolbar2.grid(row=1)
    frame2.grid_rowconfigure(0, weight=1)
    frame2.grid_columnconfigure(0, weight=1)
    frame2.grid(row=0, column=2, sticky="nswe")

    # ---- Third independent figure ----
    frame3 = tk.Frame(root)
    fig3 = Figure()  # figsize=(5, 4))
    ax3 = fig3.add_subplot(111)
    ax3.set_title("Task graph (context debug graph)")
    canvas3 = FigureCanvasTkAgg(fig3, master=frame3)
    canvas3.draw()
    canvas3.get_tk_widget().grid(row=0, sticky="nswe")
    toolbar3 = NavigationToolbar2Tk(canvas3, pack_toolbar=False)  # , root)
    toolbar3.update()
    toolbar3.grid(row=1)
    frame3.grid_rowconfigure(0, weight=1)
    frame3.grid_columnconfigure(0, weight=1)
    frame3.grid(row=2, column=0, sticky="nswe")

    # ---- Fourth independent figure ----
    frame4 = tk.Frame(root)
    fig4 = Figure()  # figsize=(5, 4))
    ax4 = fig4.add_subplot(111)
    ax4.set_title("Context task graph")
    canvas4 = FigureCanvasTkAgg(fig4, master=frame4)
    canvas4.draw()
    canvas4.get_tk_widget().grid(row=0, sticky="nsew")
    toolbar4 = NavigationToolbar2Tk(canvas4, pack_toolbar=False)  # , root)
    toolbar4.update()
    toolbar4.grid(row=1)
    frame4.grid_rowconfigure(0, weight=1)
    frame4.grid_columnconfigure(0, weight=1)
    frame4.grid(row=2, column=2, sticky="nswe")

    # ---- Spacer widgets ----
    spacer1 = tk.Frame(root, background="grey", width=10, height=10)
    spacer1.grid(row=0, column=1, rowspan=3, sticky="nswe")
    spacer1 = tk.Frame(root, background="grey", width=10, height=10)
    spacer1.grid(row=1, column=0, columnspan=3, sticky="nswe")

    # ---- Render contents
    print("Plotting task graph...")
    context_task_graph.task_graph.update_plot(ax1)
    print("Plotting task graph (context graph)...")
    context_task_graph.task_graph.plot_context_graph(ax2)
    print("Plotting task graph (context debug graph)...")
    context_task_graph.task_graph.plot_context_debug_graph(ax3)
    print("Plotting context task graph...")
    context_task_graph.update_plot(ax4, highlight_nodes=list(highlight_nodes) if highlight_nodes is not None else None)

    # ---- start main loop
    root.protocol("WM_DELETE_WINDOW", close_window)
    root.mainloop()

    context_task_graph.task_graph.pet.show()


def identify_simple_tasking(context_task_graph: ContextTaskGraph) -> List[TaskParallelismInfo]:
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
