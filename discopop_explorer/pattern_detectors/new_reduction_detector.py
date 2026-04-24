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
from discopop_explorer.classes.variable import Variable
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo
from discopop_explorer.pattern_detectors.task_parallelism.classes import (
    ParallelRegionInfo,
    TPIType,
    TaskParallelismInfo,
)
from GUI.Visualizers.WithSidebar import WithSidebar as VisualizerWithSideBar
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import VarName

logger = logging.getLogger("Explorer").getChild("Reduction")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[ReductionInfo]:
    logger.info("Starting new reduction detection...")
    result: List[ReductionInfo] = []

    result += identify_simple_reduction(task_graph)

    return result


def identify_simple_reduction(tg: TaskGraph) -> List[ReductionInfo]:
    """Identifies simple reduction loops.
    Implementation is fundamentally similar to the original doall detector, but implemented in a more maintainable fashion.
    Checks for clean reduction opportunities."""
    patterns: List[ReductionInfo] = []
    logger.info("Identifying trivial reduction suggestions.")

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
        non_reduction_dependency_found = False
        reduction_info: List[Tuple[Context, Context, Dependency, Dict[str, str]]] = []
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
                        # check if the preventing dependency is a reduction dependency.
                        # If all preventing dependencies are reduction dependencies, a trivial reduction loop is possible.
                        is_reduction_dependency = False
                        for red_var_dict in tg.pet.reduction_vars:
                            # check for correct parent loop
                            if red_var_dict["loop_line"] not in node.created_context.get_code_scope(tg.pet):
                                continue
                            # check for variable name
                            if red_var_dict["name"] != dep.var_name:
                                continue
                            # check for source code position
                            if red_var_dict["reduction_line"] not in subnode.get_code_scope(tg.pet):
                                continue
                            if red_var_dict["reduction_line"] not in out_dep_target.get_code_scope(tg.pet):
                                continue
                            # all of the previous requirements are met
                            is_reduction_dependency = True
                            reduction_info.append((subnode, out_dep_target, dep, red_var_dict))

                        if not is_reduction_dependency:
                            non_reduction_dependency_found = True
                            break

                if non_reduction_dependency_found:
                    break
            if non_reduction_dependency_found:
                break

        if non_reduction_dependency_found:
            # node is not a valid reduction loop. skip.
            prevented_loops.add(node.pet_node_id)
            continue

        # node is a valid reduction loop, if reduction_info contains some elements.
        # Otherwise, it is a regular doll loop
        if len(reduction_info) == 0:
            continue

        # node is a valid reduction loop. Register a pattern
        reduction_vars: List[Variable] = []
        for ri in reduction_info:
            if ri[2].var_name is None:
                continue
            var = Variable(type="unknown", name=VarName(ri[2].var_name), defLine="LineNotFound")
            # correct operation
            red_op = ri[3]["operation"]
            if red_op == ">":
                red_op = "max"
            if red_op == "<":
                red_op = "min"
            var.operation = red_op
            # prevent duplicates
            duplicate = True if len(reduction_vars) > 0 else False
            for key in var.__dict__:
                for elem in reduction_vars:
                    if var.__dict__[key] != elem.__dict__[key]:
                        duplicate = False
                        break
                if duplicate:
                    break
            if not duplicate:
                reduction_vars.append(var)

        if node.created_context.parent_loop is None:
            continue
        pattern = ReductionInfo(tg.pet, tg.pet.node_at(node.created_context.parent_loop), reduction=reduction_vars)

        # prevent duplicates. Necessary since multiple copies of the same loop might exist
        if pattern.pattern_tag in [p.pattern_tag for p in patterns]:
            continue

        patterns.append(pattern)

    # clean patterns against prevented loops
    patterns = [p for p in patterns if p.node_id not in prevented_loops]

    return patterns
