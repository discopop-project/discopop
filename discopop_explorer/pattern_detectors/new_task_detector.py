# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import logging
from typing import List, Set, Tuple

from tqdm import tqdm


from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Loops.TGStartLoopNode import TGStartLoopNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from discopop_explorer.classes.patterns.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import TPIType, TaskParallelismInfo

logger = logging.getLogger("Explorer").getChild("tasking")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[PatternInfo]:
    logger.info("Starting task detection...")
    result: List[PatternInfo] = []

    # result += identify_simple_taskloop(pet, task_graph)
    result += identify_simple_tasking(task_graph)

    # identify immediate successive contexts with no dependencies between them
    logger.info("--> Identifying simple asynchronous tasking ... TODO")
    # identify non-immediate successive contexts with no dependencies between them, such that asynchronous execution is possible
    logger.info("--> Identifying dependent tasking... TODO")
    logger.info("--> Identifying multi-dependent tasking... TODO")
    logger.info("--> Identifying loop tasking... TODO")
    logger.info("--> Identifying recursive tasking... TODO?")

    return result


# def identify_simple_taskloop(pet: PEGraphX, task_graph: TaskGraph) -> List[TaskParallelismInfo]:
#    logger.info("--> Identifying simple taskloop...")
#    patterns: List[TaskParallelismInfo] = []
#    # collect all pairs of immediately successive contexts
#    immediate_successors: List[Tuple[Context, Context]] = []
#    for ctx in task_graph.contexts:
#        if ctx.successor is not None:
#            immediate_successors.append((ctx, ctx.successor))
#    # filter pairs by node types
#    filtered_immediate_successors: List[Tuple[Context, Context]] = []
#    for pred, succ in immediate_successors:
#        to_be_considered = False
#        if isinstance(pred, IterationContext) and isinstance(succ, IterationContext):
#            to_be_considered = True
#        if to_be_considered:
#            filtered_immediate_successors.append((pred, succ))
#
#    # iterate over all pairs, collect their contained contexts, and check for dependencies between the contexts. If no dependencies exist, a #simple tasking without critical sections is possible
#    for pred, succ in tqdm(filtered_immediate_successors):
#        pred_contained_ctxs = pred.get_contained_contexts(inclusive=True)
#        pred_contained_ctxs.add(pred)
#        succ_contained_ctxs = succ.get_contained_contexts(inclusive=True)
#        succ_contained_ctxs.add(succ)
#        print("PRED: ", pred)
#        print("PRED_CONTAINED: ", pred_contained_ctxs)
#        print("SUCC: ", succ)
#        print("SUCC_CONTAINED: ", succ_contained_ctxs)
#        # collect dependencies to predecessor's contexts outgoing from succ_contained_ctxs
#        critical_dependencies: Set[Tuple[Context, Dependency]] = set()
#        for scc in succ_contained_ctxs:
#            print("SCC: " + scc.get_label())
#            for target, dep in scc.outgoing_dependencies:
#                print("--> target: ", target.get_label())
#                if target in pred_contained_ctxs:
#                    print("-----> TARGET IN PRED_CONTAINED!")
#                    critical_dependencies.add((target, dep))
#
#        # if critical_dependencies is not empty, the successor has a dependency to the predecessor
#        if len(critical_dependencies) != 0:
#            # trivial tasking not possible.
#            # TODO Check for possibility of adding critical section etc.
#            print("CRIT DEPS EXIST!")
#            for tpl in critical_dependencies:
#                print(" ---> ", tpl[1].dtype, tpl[1].source_line, tpl[1].sink_line, tpl[1].var_name)
#
#            continue
#
#        logger.info("FOUND TRIVIAL TASKLOOP: " + pred.get_label() + " " + succ.get_label())
#        if pred.parent_context is None:
#            continue
#        parent_loops = [n for n in pred.parent_context.contained_nodes if isinstance(n, TGStartLoopNode)]
#        logger.info("Parent loops: " + str(parent_loops))
#        if len(parent_loops) == 0:
#            continue
#        if len(parent_loops) > 1:
#            raise ValueError("More than one parent loop found for IterationContext!")
#        if parent_loops[0].pet_node_id is None:
#            continue
#        patterns.append(
#            TaskParallelismInfo(
#                node=pet.node_at(parent_loops[0].pet_node_id),
#                type=TPIType.TASKLOOP,
#                pragma=["#pragma omp taskloop"],
#                pragma_line=pet.node_at(parent_loops[0].pet_node_id).start_position(),
#                first_private=[],
#                private=[],
#                shared=[],
#            )
#        )
#
#        # logger.info("preceeding: " + str(pred.get_preceeding_contexts()))
#        # logger.info("successive: " + str(pred.get_successive_contexts()))
#
#        # TODO check the dependencies for "acceptance" and detect data sharing clauses, if required
#
#    return patterns


def identify_simple_tasking(task_graph: TaskGraph) -> List[TaskParallelismInfo]:
    logger.info("--> Identifying simple tasking...")
    patterns: List[TaskParallelismInfo] = []
    # collect all pairs of immediately successive contexts
    immediate_successors: List[Tuple[Context, Context]] = []
    for ctx in task_graph.contexts:
        if ctx.successor is not None:
            immediate_successors.append((ctx, ctx.successor))
    # filter pairs by node types
    filtered_immediate_successors: List[Tuple[Context, Context]] = []
    for pred, succ in immediate_successors:
        to_be_considered = False
        if isinstance(pred, IterationContext) and isinstance(succ, IterationContext):
            to_be_considered = True
        if isinstance(pred, FunctionContext) and isinstance(succ, FunctionContext):
            to_be_considered = True
        if isinstance(pred, LoopParentContext) and isinstance(succ, LoopParentContext):
            to_be_considered = True
        if isinstance(pred, BranchingParentContext) and isinstance(succ, BranchingParentContext):
            to_be_considered = True
        if isinstance(pred, FunctionContext) and isinstance(succ, LoopParentContext):
            to_be_considered = True
        if isinstance(pred, FunctionContext) and isinstance(succ, BranchingParentContext):
            to_be_considered = True
        if isinstance(pred, LoopParentContext) and isinstance(succ, FunctionContext):
            to_be_considered = True
        if isinstance(pred, LoopParentContext) and isinstance(succ, BranchingParentContext):
            to_be_considered = True
        if isinstance(pred, BranchingParentContext) and isinstance(succ, FunctionContext):
            to_be_considered = True
        if isinstance(pred, BranchingParentContext) and isinstance(succ, LoopParentContext):
            to_be_considered = True
        if to_be_considered:
            filtered_immediate_successors.append((pred, succ))

    # iterate over all pairs, collect their contained contexts, and check for dependencies between the contexts. If no dependencies exist, a simple tasking without critical sections is possible
    for pred, succ in tqdm(filtered_immediate_successors):
        pred_contained_ctxs = pred.get_contained_contexts(inclusive=True)
        pred_contained_ctxs.add(pred)
        succ_contained_ctxs = succ.get_contained_contexts(inclusive=True)
        succ_contained_ctxs.add(succ)
        # collect dependencies to predecessor's contexts outgoing from succ_contained_ctxs
        critical_dependencies: Set[Tuple[Context, Dependency]] = set()
        for scc in succ_contained_ctxs:
            for target, dep in scc.outgoing_dependencies:
                if target in pred_contained_ctxs:
                    critical_dependencies.add((target, dep))

        # if critical_dependencies is not empty, the successor has a dependency to the predecessor
        if len(critical_dependencies) != 0:
            # trivial tasking not possible. Check for possibility of spawning multiple asynchronous tasks, or detecting suitable data sharing clauses (i.e. shared) + critical sections
            # TODO
            print("CRIT DEPS EXIST!")
            for tpl in critical_dependencies:
                print(" ---> ", tpl[1].dtype, tpl[1].source_line, tpl[1].sink_line, tpl[1].var_name)
            continue

        logger.info("FOUND TRIVIAL TASKING: " + pred.get_label() + " " + succ.get_label())

    #        logger.info("preceeding: " + str(pred.get_preceeding_contexts()))
    #        logger.info("successive: " + str(pred.get_successive_contexts()))

    # TODO check the dependencies for "acceptance" and detect data sharing clauses, if required

    return patterns
