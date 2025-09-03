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
from discopop_explorer.classes.TaskGraph.ContextTaskGraph import ContextTaskGraph
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
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
    context_task_graph.plot()

    # result += identify_simple_taskloop(pet, task_graph)
    result += identify_simple_tasking(context_task_graph)

    # identify immediate successive contexts with no dependencies between them
    logger.info("--> Identifying simple asynchronous tasking ... TODO")
    # identify non-immediate successive contexts with no dependencies between them, such that asynchronous execution is possible
    logger.info("--> Identifying dependent tasking... TODO")
    logger.info("--> Identifying multi-dependent tasking... TODO")
    logger.info("--> Identifying loop tasking... TODO")
    logger.info("--> Identifying recursive tasking... TODO?")

    return result


def identify_simple_tasking(context_task_graph: ContextTaskGraph) -> List[TaskParallelismInfo]:
    logger.info("--> Identifying simple tasking...")
    patterns: List[TaskParallelismInfo] = []
    return patterns
