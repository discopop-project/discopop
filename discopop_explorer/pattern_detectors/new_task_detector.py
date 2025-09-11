# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import logging
from typing import List, Optional, Set, Tuple

from tqdm import tqdm


from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.ContextTaskGraph import ContextTaskGraph
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
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

    logger.info("--> Constructing context task graph...")
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


def identify_simple_tasking(context_task_graph: ContextTaskGraph) -> List[TaskParallelismInfo]:
    logger.info("Identifying trivial tasking potential...")
    patterns: List[TaskParallelismInfo] = []
    fork_join_pairs: List[Tuple[Context, Context]] = []
    logger.info("--> checking nodes")
    for node in tqdm(context_task_graph.graph.nodes):
        # identify fork nodes
        successors = context_task_graph.get_successors(node)
        if len(successors) < 2:
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

    # DEBUG
    highlight_nodes: Set[Context] = set()
    for tpl in fork_join_pairs:
        highlight_nodes.add(tpl[0])
        for succ in context_task_graph.get_successors(tpl[0]):
            highlight_nodes.add(succ)
        highlight_nodes.add(tpl[1])
    context_task_graph.plot(highlight_nodes=list(highlight_nodes))
    # !DEBUG

    for tpl in fork_join_pairs:
        tmp_patterns: List[TaskParallelismInfo] = []
        # create task pattern for each entry
        for entry in context_task_graph.get_successors(tpl[0]):
            pet_node = entry.get_first_pet_node(context_task_graph.pet)
        #        tmp_patterns.append(TaskParallelismInfo(pet_node, type=TPIType.TASK, pragma=["#pragma omp task"], pragma_line=pet_node.start_position(), first_private=[], private=[], shared=[]))

        # create a barrier pattern for the join
        # link the patterns together

        patterns += tmp_patterns

    return patterns
