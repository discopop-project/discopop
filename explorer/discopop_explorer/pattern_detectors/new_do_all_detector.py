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

from discopop_explorer.utils import classify_loop_variables
from discopop_explorer.functions.PEGraph.queries.edges import in_edges, out_edges
from discopop_explorer.classes.variable import Variable
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import MemoryRegion, VarName
from discopop_explorer.enums.DepOrigin import DepOrigin
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo

logger = logging.getLogger("Explorer").getChild("DoAll")


def run_detection(pet: PEGraphX, task_graph: TaskGraph) -> List[DoAllInfo | ReductionInfo]:
    logger.info("Starting new do_all and reduction detection...")
    result: List[DoAllInfo | ReductionInfo] = []

    result += identify_simple_doall_and_reduction(task_graph)

    show_plot(task_graph)

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

        ax3 = tg.create_plot("Task Graph")
        print("Plotting task graph...")
        if len(tg.graph.nodes()) < 500:
            tg.update_plot(ax3)

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


def identify_simple_doall_and_reduction(tg: TaskGraph) -> List[DoAllInfo | ReductionInfo]:
    """Analyzes the results of the graph simplification and create simple doall patterns.
    Implementation is fundamentally similar to the original doall detector, but implemented in a more maintainable fashion.
    Checks for clean doall opportunities."""
    patterns: List[DoAllInfo | ReductionInfo] = []
    logger.info("Identifying trivial doall suggestions.")

    show_plot(tg)

    prevented_loops: Set[NodeID] = set()

    for node in tg.graph.nodes():
        # check if node is LoopParent
        if not isinstance(node.created_context, LoopParentContext):
            continue
        # check if loop is not already preventedvariables
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
        loop_variables = node.created_context.loop_variables
        # check for dependencies
        dependency_found = False
        reduction_info: List[Tuple[Context, Context, Dependency, Dict[str, str]]] = []
        potential_breaking_dependencies: List[Tuple[Context, Context, Dependency]] = []
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
                        # check if the preventing dependency is a reduction dependency.
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
                        if is_reduction_dependency:
                            # not a valid doall loop
                            reduction_info.append((subnode, out_dep_target, dep, red_var_dict))
                        #                            dependency_found = True
                        #                            break

                        # check for and allow accesses to the loop variable
                        if (dep.var_name, dep.memory_region) in loop_variables or is_reduction_dependency:
                            # dependency on loop variable or reduction variable
                            pass
                        else:
                            # check if dep.origin is static. If so, give it a "second chance", which is tested after classifying variables in the loop.
                            # --> In this case it is a valid doall, if the variable is firstwritten inside the loop
                            print(
                                "Prevents doall:",
                                dep.dtype,
                                dep.source_line,
                                dep.sink_line,
                                dep.var_name,
                                dep.memory_region,
                                "origin:",
                                dep.origin,
                                "source:",
                                subnode.get_code_scope(tg.pet, inclusive=True),
                                "out_dep_target:",
                                out_dep_target.get_code_scope(tg.pet, inclusive=True),
                                "source_ctx:",
                                ic_source,
                                "target_ctx:",
                                out_dep_target,
                            )
                            if dep.origin == DepOrigin.DYNAMIC_ANALYSIS:
                                # dependency is trustworthy and definitely breaks doall
                                dependency_found = True
                                break
                            else:
                                # dependency is static and may be too pessimistic.
                                # dependency is not problematic, if the variable is first written in the loop
                                potential_breaking_dependencies.append((ic_source, out_dep_target, dep))
                if dependency_found:
                    break
            if dependency_found:
                break
        if dependency_found:
            # node is not a valid doall loop
            prevented_loops.add(node.pet_node_id)
            continue
        # get contexts contained in loopparent for later check
        loopparent_contained_ctxs = node.created_context.get_contained_contexts(inclusive=True)
        # node is a valid doall loop. Detect data sharing clauses
        print("CURRENT LOOP: ", node.created_context.get_code_scope(tg.pet))
        firstprivate, private, lastprivate, shared, firstwritten, init = detect_doall_sharing_clauses(
            tg.pet, iteration_contexts, loopparent_contained_ctxs, set([v[0] for v in loop_variables])
        )
        reduction: Set[str] = set([ri[2].var_name for ri in reduction_info if ri[2].var_name is not None])
        # check potential_breaking_dependencies for cases which actually prevent doall
        for src_ctx, dst_ctx, dep in potential_breaking_dependencies:
            if dep.var_name not in firstwritten.union(init).union(reduction):
                # node is not a valid doall loop
                prevented_loops.add(node.pet_node_id)
                print("LOOP: ", node.created_context.get_code_scope(tg.pet))
                print("SECOND CHANCEs missed!: ", dep.dtype, dep.var_name)
                continue
            else:
                # static dependency does not actually prevent doall parallelization, as privatization is possible
                pass
        if len(potential_breaking_dependencies) > 0:
            print(
                "HERE DUE TO SECOND CHANCEs!: ", [(d[2].dtype, d[2].var_name) for d in potential_breaking_dependencies]
            )

        # Register a pattern
        pattern: DoAllInfo | ReductionInfo
        if len(reduction) == 0:
            # register DoAll pattern
            pattern = DoAllInfo(tg.pet, tg.pet.node_at(node.pet_node_id))
            pattern.first_private = [Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in firstprivate]
            pattern.private = [Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in private]
            pattern.last_private = [Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in lastprivate]
            pattern.shared = [Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in shared]
        else:
            # register reduction pattern
            reduction_vars: List[Variable] = []
            for ri in reduction_info:
                if ri[2].var_name is None:
                    continue
                var = Variable(type="unknown", name=VarName(ri[2].var_name), defLine="LineNotFound")
                # correct operation
                red_op = ri[3]["operation"]
                print("RED OP:", red_op, "var:", var.name)
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
            pattern.first_private = [
                Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in firstprivate if v not in reduction
            ]
            pattern.private = [
                Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in private if v not in reduction
            ]
            pattern.last_private = [
                Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in lastprivate if v not in reduction
            ]
            pattern.shared = [
                Variable(type="UNKNOWN", name=VarName(v), defLine="UNKNOWN") for v in shared if v not in reduction
            ]

        # prevent duplicates. Necessary since multiple copies of the same loop might exist
        if pattern.pattern_tag in [p.pattern_tag for p in patterns]:
            continue
        patterns.append(pattern)

    # clean patterns agains prevented loops
    patterns = [p for p in patterns if p.node_id not in prevented_loops]

    return patterns


def detect_doall_sharing_clauses(
    pet: PEGraphX,
    iteration_contexts: List[IterationContext],
    loopparent_contained_ctxs: Set[Context],
    loop_variables: Set[str],
) -> Tuple[Set[str], Set[str], Set[str], Set[str], Set[str], Set[str]]:
    """classifies variables used inside the iterations and returns the classifications in the following structure:
    (firstprivate, private, lastprivate, shared, firstwritten, init)
    firstwritten and init are not data sharing clauses, but required to validate potential doall-breaking dependencies originating from static information.
    """
    print("-------------------- LOOP START ---------------------")
    # Initialization
    # calculate CUs contained in the loop parent for later use dureing filtering
    contained_tg_nodes_in_loopparent: List[TGNode] = []
    for ctx in loopparent_contained_ctxs:
        contained_tg_nodes_in_loopparent += ctx.contained_nodes
    contained_cu_node_ids_in_loopparent = set(
        [tg.pet_node_id for tg in contained_tg_nodes_in_loopparent if tg.pet_node_id is not None]
    )

    # shared:
    # - no dependency between iterations
    # private:
    # - no dependency between iterations && first written in iteration && no RAW from outside to inside of loop
    # lastprivate:
    # - no dependency between iterations && read from outside to inside of loop
    # firstprivate:
    # - no dependency between iterations && first read in iterations && written in iteration
    # IMPORTANT: first- and lastprivate can be applied to one variable at the same time!
    # -> Check them independently
    # -> private and lastprivate / firstprivate can NOT be used at the same time.

    # # TODO update
    # reformatted condition to better suit the available data:
    # shared:
    # - outside dependency but not to or from the other iteration
    # private:
    # - outside dependency but not to or from the other iteration && RAW or WAW between first and second access in contained sequence && no RAW from outside to inside of loop
    # lastprivate:
    # - outside dependency but none to or from the other iteration && RAW or WAW between first and second access in contained sequence && read from outside to inside of loop
    # firstprivate:
    # - outside dependency but none to or from the other iteration && outgoing RAW from first access in contained sequence && RAW or WAR exists within

    private: Set[str] = set()
    shared: Set[str] = set()
    lastprivate: Set[str] = set()
    firstprivate: Set[str] = set()
    firstwritten: Set[str] = set()
    init: Set[str] = set()
    gep_result_access: Set[str] = set()

    for it_ctx in iteration_contexts:
        contained_contexts_in_sequence = it_ctx.get_contained_contexts_in_sequence(pet)
        #        print("contained CTXs in sequence: ", [c.get_code_scope(pet) for c in contained_contexts_in_sequence])
        contained_tg_nodes_in_sequence: List[TGNode] = []
        for ctx in contained_contexts_in_sequence:
            contained_tg_nodes_in_sequence += ctx.contained_nodes
        #        print("contained tg nodes in sequence: ", [(n, n.pet_node_id) for n in contained_tg_nodes_in_sequence])
        contained_cu_node_ids_in_sequence = [
            tg.pet_node_id for tg in contained_tg_nodes_in_sequence if tg.pet_node_id is not None
        ]
        #        print("contained cu nodes in sequence: ", contained_cu_node_ids_in_sequence)

        # -> get lists of firstwritten, firstread, written, read, read_in, read_out for all iterations.
        # -> use the gathered lists to determine sharing clauses after the loop over iteration contexts
        it_init: Set[str] = set()
        written: Set[str] = set()
        read: Set[str] = set()
        it_firstwritten: Set[str] = set()
        firstread: Set[str] = set()
        data_incoming: Set[str] = set()
        data_outgoing: Set[str] = set()

        for cu_node_id in contained_cu_node_ids_in_sequence:
            incoming_deps = in_edges(pet, cu_node_id, EdgeType.DATA)
            outgoing_deps = out_edges(pet, cu_node_id, EdgeType.DATA)

            # TODO:# filter incoming and outgoing deps to ignore nodes within the parent loop
            # TODO: ignore variables defined inside the loop
            # reasone: remove data sharing clauses correlating to loop headers etc.
            incoming_deps = [
                d
                for d in incoming_deps
                if d[0] not in contained_cu_node_ids_in_loopparent - set(contained_cu_node_ids_in_sequence)
            ]
            outgoing_deps = [
                d
                for d in outgoing_deps
                if d[1] not in contained_cu_node_ids_in_loopparent - set(contained_cu_node_ids_in_sequence)
            ]

            # outgoing
            #   RAW: cu reads
            #   WAR: cu overwrites
            #   WAW: cu overwrites
            # incoming:
            #   RAW: value is used after cu wrote the value
            #   WAR: value is overwritten after cu read the value
            #   WAW: value is overwritten after cu wrote the value

            for src, dst, dep in outgoing_deps:
                if dep.var_name is None:
                    continue

                # check if dep is access to array type value (or result of pointer arithmetic)
                if dep.is_gep_result_dependency:
                    gep_result_access.add(dep.var_name)

                if dep.dtype == DepType.RAW:
                    if dep.var_name not in written:
                        firstread.add(dep.var_name)
                    read.add(dep.var_name)
                    if dst not in contained_cu_node_ids_in_sequence:
                        data_incoming.add(dep.var_name)
                elif dep.dtype == DepType.WAR:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    written.add(dep.var_name)
                elif dep.dtype == DepType.WAW:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    written.add(dep.var_name)
                elif dep.dtype == DepType.INIT:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    it_init.add(dep.var_name)
                    written.add(dep.var_name)
                else:
                    raise ValueError("Unsupported dependency type: " + str(dep.dtype))

            for src, dst, dep in incoming_deps:
                if dep.var_name is None:
                    continue
                if dep.dtype == DepType.RAW:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    written.add(dep.var_name)
                    if src not in contained_cu_node_ids_in_sequence:
                        data_outgoing.add(dep.var_name)
                elif dep.dtype == DepType.WAR:
                    if dep.var_name not in written:
                        firstread.add(dep.var_name)
                    read.add(dep.var_name)
                elif dep.dtype == DepType.WAW:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    written.add(dep.var_name)
                elif dep.dtype == DepType.INIT:
                    if dep.var_name not in read:
                        it_firstwritten.add(dep.var_name)
                    it_init.add(dep.var_name)
                    written.add(dep.var_name)
                else:
                    raise ValueError("Usupported dependency type: " + str(dep.dtype))

        #            print("cunode -> ", cu_node_id)
        # print("--> in deps:", [(d[2].dtype, d[0], d[2].var_name) for d in incoming_deps])
        # print("--> out_deps: ", [(d[2].dtype, d[1], d[2].var_name) for d in outgoing_deps])
        print("\t--> written: ", written)
        print("\t--> read: ", read)
        print("\t--> data_incoming: ", data_incoming)
        print("\t--> data_outgoing: ", data_outgoing)
        print("\t--> firstread: ", firstread)
        print("\t--> it_firstwritten: ", it_firstwritten)
        print("\t--> it_init: ", it_init)
        print("\t--> gep_access: ", gep_result_access)
        # dependency between iterations is trivially not possible, as this would invalidate the doall pattern.
        # Classification scheme:
        # shared:
        # - no dependency between iterations
        # private:
        # - no dependency between iterations && first written in iteration && no RAW from outside to inside of loop
        # lastprivate:
        # - no dependency between iterations && read from outside to inside of loop
        # firstprivate:
        # - no dependency between iterations && first read in iterations && written in iteration

        # iterate over all found variable names. use set union via '|'
        it_private: Set[str] = set()
        it_shared: Set[str] = set()
        it_lastprivate: Set[str] = set()
        it_firstprivate: Set[str] = set()

        for var_name in written | read | data_incoming | data_outgoing | firstread | it_firstwritten:
            # ignore loop variables
            if var_name in loop_variables:
                continue
            # -> classification of the variables clauses according to scheme above
            if var_name in written:
                if var_name in data_outgoing:
                    if var_name in gep_result_access:
                        it_shared.add(var_name)
                    else:
                        it_lastprivate.add(var_name)
                if var_name in firstread and var_name not in it_init:
                    it_firstprivate.add(var_name)
                if (
                    var_name not in data_outgoing
                    and var_name not in it_init
                    and var_name not in it_lastprivate
                    and var_name not in it_firstprivate
                ):
                    if var_name in gep_result_access:
                        it_shared.add(var_name)
                    else:
                        it_private.add(var_name)
                if (
                    var_name in data_incoming
                    and var_name in it_firstwritten
                    and var_name not in it_lastprivate
                    and var_name not in it_firstprivate
                    and var_name not in it_private
                ):
                    it_shared.add(var_name)

                if (
                    var_name not in it_private
                    and var_name not in it_shared
                    and var_name not in it_lastprivate
                    and var_name not in it_firstprivate
                    and var_name in it_init
                    and var_name in gep_result_access
                ):
                    # array initializations without immediate successive uses
                    it_shared.add(var_name)

                assert (
                    var_name in it_lastprivate
                    or var_name in it_firstprivate
                    or var_name in it_private
                    or var_name in it_init
                    or var_name in it_shared
                )
            else:
                # read-only
                if var_name in gep_result_access:
                    it_shared.add(var_name)
                else:
                    it_firstprivate.add(var_name)
            assert (
                var_name in it_lastprivate
                or var_name in it_firstprivate
                or var_name in it_private
                or var_name in it_shared
                or var_name in it_init
            )

        print("\tit_private: ", it_private)
        print("\tit_shared: ", it_shared)
        print("\tit_lastprivate: ", it_lastprivate)
        print("\tit_firstprivate: ", it_firstprivate)
        print("\tloop_vars: ", loop_variables)

        # save classifications
        private = private.union(it_private)
        shared = shared.union(it_shared)
        lastprivate = lastprivate.union(it_lastprivate)
        firstprivate = firstprivate.union(it_firstprivate)
        firstwritten = firstwritten.union(it_firstwritten)
        init = init.union(it_init)
        print("----------------------- IT END ------------------")

    # merge classifications
    print()
    print("\tPRE MERGE: private: ", private)
    print("\tPRE MERGE: shared: ", shared)
    print("\tPRE MERGE: lastprivate: ", lastprivate)
    print("\tPRE MERGE: firstprivate: ", firstprivate)
    print()
    firstprivate, private, lastprivate, shared = __merge_classifications(firstprivate, private, lastprivate, shared)
    print("\tPOST MERGE: private: ", private)
    print("\tPOST MERGE: shared: ", shared)
    print("\tPOST MERGE: lastprivate: ", lastprivate)
    print("\tPOST MERGE: firstprivate: ", firstprivate)
    print("---------------------------- LOOP END --------------------")
    print()
    return firstprivate, private, lastprivate, shared, firstwritten, init


def __merge_classifications(
    first_private: Set[str],
    private: Set[str],
    last_private: Set[str],
    shared: Set[str],
) -> Tuple[Set[str], Set[str], Set[str], Set[str]]:
    new_first_private: Set[str] = set()
    new_private: Set[str] = set()
    new_last_private: Set[str] = set()
    new_shared: Set[str] = set()

    remove_from_private: Set[str] = set()
    remove_from_first_private: Set[str] = set()
    remove_from_last_private: Set[str] = set()
    remove_from_shared: Set[str] = set()

    # Rule 1: firstprivate is more restrictive than private
    remove_from_private = first_private.intersection(private)
    # Rule 2: lastprivate is more restrictive than private
    remove_from_private = remove_from_private.union(last_private.intersection(private))
    # Rule 3: shared is less restrictive than first_private or last_private
    remove_from_shared = shared.intersection(first_private.union(last_private))
    # Rule 4: if a variable is classifyable as shared and private, select shared.
    remove_from_private = remove_from_private.union(shared.intersection(private))

    new_first_private = first_private - remove_from_first_private
    new_last_private = last_private - remove_from_last_private
    new_private = private - remove_from_private
    new_shared = shared - remove_from_shared

    return new_first_private, new_private, new_last_private, new_shared
