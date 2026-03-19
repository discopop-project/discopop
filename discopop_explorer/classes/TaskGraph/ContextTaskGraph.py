# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
from typing import Dict, List, Optional, Set, Tuple, cast
from matplotlib import pyplot as plt
import networkx as nx  # type: ignore
from matplotlib.axes import Axes
from networkx import Graph
from tqdm import tqdm  # type: ignore
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.TaskGraph.Contexts.BranchingParentContext import BranchingParentContext
from discopop_explorer.classes.TaskGraph.Contexts.BranchContext import BranchContext
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.classes.TaskGraph.Contexts.FunctionContext import FunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.InlinedFunctionContext import InlinedFunctionContext
from discopop_explorer.classes.TaskGraph.Contexts.WorkContext import WorkContext
from discopop_explorer.classes.TaskGraph.Contexts.TaskParentContext import TaskParentContext
from discopop_explorer.classes.TaskGraph.Contexts.TaskEndContext import TaskEndContext
from discopop_explorer.classes.TaskGraph.Contexts.LoopParentContext import LoopParentContext
from discopop_explorer.classes.TaskGraph.Contexts.IterationContext import IterationContext
from discopop_explorer.classes.TaskGraph.TGNode import TGNode
from discopop_explorer.classes.TaskGraph.TaskGraph import TaskGraph
from termcolor import cprint
from enum import IntEnum
import matplotlib.lines as mlines

logger = logging.getLogger("Explorer")


class CombinedContext(Context):
    def get_label(self) -> str:
        return "CombinedCTX\nsize: " + str(len(self.contained_contexts))


class CTGEdgeType(IntEnum):
    CONTROL = 1
    DATA = 2

class CTGEdgeInfo(object):
    type: CTGEdgeType
    dep_obj: Optional[Dependency]

    def __init__(self, type: CTGEdgeType, dep_obj: Optional[Dependency] = None):
        self.type = type
        self.dep_obj = dep_obj



class ContextTaskGraph(object):
    pet: PEGraphX
    task_graph: TaskGraph
    graph: nx.DiGraph
    edge_information: Dict[Context, Dict[Context, List[CTGEdgeInfo]]] = dict()
    imaginary_replacement_edges: Dict[Context, List[Context]] = dict()
    inverse_imaginary_replacement_edges: Dict[Context, List[Context]] = dict()

    def __init__(self, task_graph: TaskGraph) -> None:
        self.pet = task_graph.pet
        self.task_graph = task_graph
        self.graph = nx.MultiDiGraph()
        # define updating plot window
        fig1 = plt.figure(1)
        self.plotting_axis = fig1.add_subplot(1, 1, 1)
        plt.ion()
        # start processing
        self.__construct_from_task_graph()
        try:
            print(nx.find_cycle(self.graph))
        except:
            print("NO CYCLE")
        
        self.__simplify_graph()
        
        try:
            cycle = nx.find_cycle(self.graph)
            print("Cycle: ", cycle)
            cycle_nodes: Set[Context] = set()
            for tpl in cycle:
                cycle_nodes.add(tpl[0])
                cycle_nodes.add(tpl[1])
            plt.ioff()
            # self.plot(highlight_nodes=list(cycle_nodes))
            # plt.pause(1)
        except:
            print("NO CYCLE")

        print("Waiting for user to close the Window...")
        # plt.show(block=True)
        plt.ioff()

    def __construct_from_task_graph(self) -> None:
        """convert the given task graph to a ContextTaskGraph for Task detection. The created graph will be used to determine Forks, Barriers, and Tasks."""
        logger.info("Constructing ContextTaskGraph...")
        logger.info("--> Add context nodes...")
        for ctx in tqdm(self.task_graph.contexts):
            self.add_node(ctx)

        # add edges based on task graph successors
        for tg_node in self.task_graph.graph.nodes:
            if tg_node.created_context is None:
                continue
            successor_contexts: List[Context] = []
            queue = self.task_graph.get_successors(tg_node)
            while len(queue) > 0:
                current = queue.pop()
                if current.created_context is not None:
                    successor_contexts.append(current.created_context)
                    continue
                queue += [nd for nd in self.task_graph.get_successors(current) if nd not in queue]
            for succ_ctx in successor_contexts:
                self.add_edge(tg_node.created_context, succ_ctx, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

        # Extract branched sections
        if False:
            raw_branching_contexts: List[Context] = []
            for node in self.graph.nodes():
                if isinstance(node, BranchingParentContext):
                    raw_branching_contexts.append(node)

            finished_branching_context: List[Context] = []
            replacements: Dict[Context, Context] = dict()
            while len(raw_branching_contexts) > 0:
                current_branching_context = raw_branching_contexts.pop(0)
                # skip, if current_branching_context contains branching contexts
                contained_contexts = current_branching_context.get_contained_contexts(inclusive=True)
                contains_branched_section = (
                    len(
                        [
                            ctx
                            for ctx in contained_contexts
                            if isinstance(ctx, BranchingParentContext) and (ctx not in finished_branching_context)
                        ]
                    )
                    > 0
                )
                if contains_branched_section:
                    raw_branching_contexts.append(current_branching_context)
                    continue
                # found trivial branching context
                replacement_node = WorkContext()
                self.add_node(replacement_node)
                if current_branching_context.parent_context is not None:
                    replacement_node.parent_context = current_branching_context.parent_context
                    replacement_node.parent_context.add_contained_context(replacement_node)

                # redirect edges to replacement_node
                outside_predecessors = self.get_predecessors(current_branching_context)
                for pred in outside_predecessors:
                    self.graph.remove_edge(pred, current_branching_context)
                    self.add_edge(pred, replacement_node, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))
                for node in contained_contexts:
                    for succ in self.get_successors(node):
                        if succ not in contained_contexts:
                            #            outside_successors.add(succ)
                            self.graph.remove_edge(node, succ)
                            self.add_edge(replacement_node, succ, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))
                # register replacements
                for node in contained_contexts:
                    replacements[node] = replacement_node

                finished_branching_context.append(current_branching_context)
                # register non-existing dashed edge for plotting purposes only
                if replacement_node not in self.imaginary_replacement_edges:
                    self.imaginary_replacement_edges[replacement_node] = []
                if current_branching_context not in self.inverse_imaginary_replacement_edges:
                    self.inverse_imaginary_replacement_edges[current_branching_context] = []
                self.imaginary_replacement_edges[replacement_node].append(current_branching_context)
                self.inverse_imaginary_replacement_edges[current_branching_context].append(replacement_node)

        # reconnect graph by:
        #  - removing successor edges
        #  - add contains edges ignoring BranchParents as targets
        #  - removing outgoing edges from BranchParents, saving imaginary connection
        #  - enforce a single landing pad per entry point

        # TEST
        #  - calculate connected components
        #  - find entry point for each component
        #  - find replacement node for each component
        #  - add intra-component dependency edges
        #  - add inter-component dependency edges (to and from replacement nodes)

        # Save successor edges
        saved_successors: Dict[Context, List[Context]] = dict()
        for node in self.graph.nodes:
            saved_successors[node] = self.get_successors(node)

        # remove successor edges
        # self.graph.clear_edges()

        # add contains edges ignoring BranchParents as targets
        for ctx in self.graph.nodes:
            for contained_ctx in cast(Context, ctx).get_contained_contexts(inclusive=False):
                if isinstance(contained_ctx, BranchingParentContext):
                    continue
                self.add_edge(ctx, contained_ctx, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

        # remove outgoing edges from BranchParent, saving imaginary connection
        if False:
            for node in self.graph.nodes:
                if isinstance(node, BranchingParentContext):
                    for succ in self.get_successors(node):
                        self.graph.remove_edge(node, succ)
                        if node not in self.imaginary_replacement_edges:
                            self.imaginary_replacement_edges[node] = []
                        if succ not in self.inverse_imaginary_replacement_edges:
                            self.inverse_imaginary_replacement_edges[succ] = []
                        self.imaginary_replacement_edges[node].append(succ)
                        self.inverse_imaginary_replacement_edges[succ].append(node)

        # enforce a single landing pad per entry point
        entry_points: List[Context] = []
        for ctx in self.graph.nodes:
            if len(self.get_predecessors(ctx)) == 0:
                entry_points.append(ctx)
        for entry in entry_points:
            exit_points: List[Context] = []
            for node in nx.descendants(self.graph, entry):
                if len(self.get_successors(node)) == 0:
                    exit_points.append(node)
            if len(exit_points) > 1:
                landing_pad = WorkContext()
                self.graph.add_node(landing_pad)
                for exit in exit_points:
                    self.graph.add_edge(exit, landing_pad)

        # TEST
        #  - calculate connected components
        # Note: connected_components is a generator!
        connected_components = nx.weakly_connected_components(self.graph)

        #  - find entry point for each component
        component_entry_points: Dict[Tuple[Context, ...], Context] = dict()
        for comp in connected_components:
            for ctx in comp:
                if len(self.get_predecessors(ctx)) == 0:
                    component_entry_points[tuple(comp)] = ctx
                    break
        #  - find replacement nodes for each component
        component_replacements_dict: Dict[Tuple[Context, ...], List[Context]] = dict()
        for comp in component_entry_points:
            entry_point = component_entry_points[comp]
            component_replacements: List[Context] = []
            replacement_candidates: List[Context] = [entry_point]
            visited: List[Context] = []
            while len(replacement_candidates) > 0:
                candidate = replacement_candidates.pop(0)
                visited.append(candidate)

                # check if candidate is instance of WorkNode and not a trivial solution
                if isinstance(candidate, WorkContext):
                    if candidate == entry_point:
                        # trivial solution, ignore, if another solution is possible
                        if candidate in self.inverse_imaginary_replacement_edges:
                            replacement_candidates += [
                                c
                                for c in self.inverse_imaginary_replacement_edges[candidate]
                                if c not in replacement_candidates and c not in visited
                            ]
                    else:
                        # found replacement node
                        component_replacements.append(candidate)
                else:
                    # continue searching for replacement node if possible
                    if candidate in self.inverse_imaginary_replacement_edges:

                        replacement_candidates += [
                            c
                            for c in self.inverse_imaginary_replacement_edges[candidate]
                            if c not in replacement_candidates and c not in visited
                        ]
                    else:
                        # no further step upwards possible. Use the current solution
                        pass
            component_replacements_dict[comp] = list(set(component_replacements))

        # calculate inverse component dictionary
        inverse_component_dict: Dict[Context, Tuple[Context, ...]] = dict()
        for comp in component_replacements_dict:
            for ctx in comp:
                inverse_component_dict[ctx] = comp

        #  - add intra-component dependency edges
        for ctx in tqdm(self.graph.nodes):
            ctx_parent_component = inverse_component_dict[ctx]
            for sink_ctx, dep in ctx.outgoing_dependencies:
                sink_ctx_parent_component = inverse_component_dict[sink_ctx]
                if ctx_parent_component != sink_ctx_parent_component:
                    # not an intra-component dependency
                    continue
                # intra-component dependency
                self.add_edge(sink_ctx, ctx, edge_info=CTGEdgeInfo(CTGEdgeType.DATA, dep_obj=dep))
                # print("ADDED Intra component dependency: ", dep.sink_line, dep.source_line, dep.dtype, dep.var_name)

        #  - add inter-component dependency edges (to and from replacement nodes)
        logger.debug("--> Add inter-component dependency edges (inward)")
        for ctx in tqdm(self.graph.nodes):
            ctx_parent_component = inverse_component_dict[ctx]
            for sink_ctx, dep in ctx.outgoing_dependencies:
                sink_ctx_parent_component = inverse_component_dict[sink_ctx]
                if sink_ctx_parent_component == ctx_parent_component:
                    # intra-component dependency
                    continue
                # inter-component dependency
                # check if sink_ctx_parent_component is a parent of ctx_parent_component
                sink_is_parent_of: Optional[Context] = None
                candidates = component_replacements_dict[ctx_parent_component]
                while len(candidates) > 0:
                    current_candidate = candidates.pop(0)
                    if inverse_component_dict[current_candidate] == sink_ctx_parent_component:
                        # sink_ctx_parent_component is a parent of ctx_parent_component
                        sink_is_parent_of = current_candidate
                        break
                    candidates += [
                        c
                        for c in component_replacements_dict[inverse_component_dict[current_candidate]]
                        if c not in candidates
                    ]

                if sink_is_parent_of is not None:
                    # inward dependency found
                    self.add_edge(sink_ctx, sink_is_parent_of, edge_info=CTGEdgeInfo(CTGEdgeType.DATA, dep_obj=dep))

        logger.debug("--> Add inter-component dependency edges (outward)")
        for ctx in tqdm(self.graph.nodes):
            ctx_parent_component = inverse_component_dict[ctx]
            for sink_ctx, dep in ctx.outgoing_dependencies:
                sink_ctx_parent_component = inverse_component_dict[sink_ctx]
                if sink_ctx_parent_component == ctx_parent_component:
                    # intra-component dependency
                    continue
                # inter-component dependency
                # check if ctx_parent_component is a parent of sink_ctx_parent_component
                source_is_parent_of: Optional[Context] = None
                candidates = component_replacements_dict[sink_ctx_parent_component]
                while len(candidates) > 0:
                    current_candidate = candidates.pop(0)
                    if inverse_component_dict[current_candidate] == ctx_parent_component:
                        # ctx_parent_component is a parent of sink_ctx_parent_component
                        source_is_parent_of = current_candidate
                        break
                    candidates += [
                        c
                        for c in component_replacements_dict[inverse_component_dict[current_candidate]]
                        if c not in candidates
                    ]

                if source_is_parent_of is not None:
                    # outward dependency found
                    self.add_edge(sink_is_parent_of, sink_ctx, edge_info=CTGEdgeInfo(CTGEdgeType.DATA, dep_obj=dep))  # TODO CHECK!
                    logger.debug("ADDED OUTWARD DEPENDENCY")

        # add contained edges. absence of all successor edges might allow searching for parallelism
        if True:
            logger.info("--> Add contained edges...")
            for ctx in tqdm(self.task_graph.contexts):
                for sink_ctx in ctx.get_contained_contexts():
                    # check if sink_ctx is an entry to a successor sequence
                    if sink_ctx.predecessor is None:
                        self.add_edge(ctx, sink_ctx, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

        return

        # filling the structure with successor edges
        targets: Set[Context] = set()
        for source in saved_successors:
            for target in saved_successors[source]:
                if len(self.get_predecessors(target)) == 0:
                    targets.add(target)

        for source in saved_successors:
            for target in saved_successors[source]:
                if target not in targets:
                    continue
                self.add_edge(source, target, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

        return

        logger.info("--> Add dependencies on called functions...")
        for ctx in tqdm(self.task_graph.contexts):
            for sink_ctx in ctx.get_contained_contexts():
                if isinstance(sink_ctx, InlinedFunctionContext):
                    self.add_edge(ctx, sink_ctx, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

       

        # TODO Branching durch WORK knoten ersetzen. Branches individuell analysieren
        logger.info("--> Add dependencies to force synchronization at exit nodes via synthetic landing pads...")
        required_synthetic_landing_pads: List[List[Context]] = []
        for ctx in tqdm(self.graph.nodes):
            # filter for entry nodes
            ## TODO: REMOVE THE INSTANCE CHECKS, make sure the graph structure is correct!
            if len(self.get_predecessors(ctx)) != 0 or not (
                isinstance(ctx, WorkContext) or isinstance(ctx, FunctionContext)
            ):
                continue
            # found entry node
            # get descendants without successors, aka leaf nodes
            leaf_nodes: List[Context] = []
            for desc in nx.descendants(self.graph, ctx):
                if len(self.get_successors(desc)) != 0:
                    continue
                # found leaf node
                leaf_nodes.append(desc)
            # register a synthetic landing pad for later creation
            if len(leaf_nodes) > 1:
                required_synthetic_landing_pads.append(leaf_nodes)
        # create synthetic landing pads
        for leaf_nodes in required_synthetic_landing_pads:
            landing_pad = WorkContext()
            self.add_node(landing_pad)
            for leaf in leaf_nodes:
                self.add_edge(leaf, landing_pad, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))
            logger.info("----> Added synthetic landing pad")

    #        # DEBUG - TO BE REMOVED
    #        cleaning_found = True
    #        while cleaning_found:
    #            cleaning_found = False
    #            for node in self.graph.nodes:
    #                if len(self.get_predecessors(node)) == 0 and not (isinstance(node, WorkContext) or isinstance(node, FunctionContext)):
    #                    self.graph.remove_node(node)
    #                    cleaning_found = True
    #                    break
    #        # !DEBUG

    def __simplify_graph(self) -> bool:
        """Execute the simplification pipeline."""
        self.__print_graph_statistics("Pre simplification", color="yellow")
        
        modification_applied = True
        while modification_applied:
            modification_applied = False

            if True:
                # note: THIS IS A WORK IN PROGRESS, NOT SURE IT IS BENEFICIAL!
                # spli control sequences into tasks
                stcs_res = self.__split_taskable_control_sequence()
                if stcs_res:
                    self.__print_graph_statistics("Post split taskable work sequence", color="yellow")
                else:
                    cprint("-> No effect: split taskable work sequence", "yellow")
                modification_applied = modification_applied or stcs_res

            # todo: replace task region with CombinedContext

            # todo: replace "trivial" BranchParent with CombinedContext (trivial: both branches consist of exaclty one node)

            # todo: merge only-childs with parents
            if True:
                moc_res = self.__merge_only_childs_with_parents()
                if moc_res:
                    self.__print_graph_statistics("Post merge only-childs with parents", color="yellow")
                else:
                    cprint("-> No effect: merge only-childs with parents", "yellow")
                modification_applied = modification_applied or moc_res

            # todo: non-trivial sequence combination (latter node has incoming dependencies)


            if True:
                css_res = self.__trivial_control_sequence_simplification()
                if css_res:
                    self.__print_graph_statistics("Post trivial_control sequence simplification", color="yellow")
                else:
                    cprint("-> No effect: trivial_control sequence simplification", "yellow")
                modification_applied = modification_applied or css_res

            
            if True:
                bt_res = self.__break_triangles()
                if bt_res:
                    self.__print_graph_statistics("Post break triangles", color="yellow")
                else:
                    cprint("-> No effect: break triangles", "yellow")
                modification_applied = modification_applied or bt_res

            # collapse inlined functions from bottom up (bottom up to save computing time for subgraphs)


        self.__print_graph_statistics("Post simplification", color="yellow")

        # OLD IMPLEMENTATION. BREAK TRIANGLES IS SIMPLER AND MORE ELEGANT
        #self.__replace_triangles()
    
    def __merge_only_childs_with_parents(self) -> bool:
        """Merges two successive nodes, if the first node is the parent node of the second, successive node.
        The seconde node must be of type WorkContext or CombinedContext, so that it contains at least some work.
        Returns true, if a modification was applied."""
        modification_applied = False
        nodes_merged = True
        while nodes_merged:
            nodes_merged = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                # ensure node is of allowed type
                if not (isinstance(node, WorkContext) or isinstance(node, CombinedContext)):
                    continue
                # check if node has exactly one CONTROL predecessor
                control_edge_predecessors = [ctx for ctx in self.get_predecessors(node) if (len([info for info in self.get_edge_info(ctx, node) if info.type == CTGEdgeType.CONTROL])>0)]
                if len(control_edge_predecessors) != 1:
                    continue
                predecessor = control_edge_predecessors[0]
                # check if predecessor has exactly one successor
                pred_control_edge_successors = [ctx for ctx in self.get_successors(predecessor) if len([info for info in self.get_edge_info(predecessor, ctx) if info.type == CTGEdgeType.CONTROL])>0]
                if len(pred_control_edge_successors) != 1:
                    continue

                # check if predecessor is the parent of node
                if node.parent_context != predecessor:
                    continue
                                
                # combine both nodes into CombinedContext node 
                combined_context_node = CombinedContext()
                combined_context_node.register_parent_context(predecessor.parent_context)
                if isinstance(predecessor, CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        predecessor.contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(predecessor)
                if isinstance(node, CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        node.contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(node)
                # redirect incoming edges                
                in_edges_with_info: List[Tuple[Context, List[CTGEdgeInfo]]] = [(pred, self.get_edge_info(pred, predecessor)) for pred in self.get_predecessors(predecessor)]
                for pred, info in in_edges_with_info:
                    for info_elem in info:
                        self.add_edge(pred, combined_context_node, info_elem)
                # redirect outgoing edges
                out_edges_with_info: List[Tuple[Context, List[CTGEdgeInfo]]] = [(succ, self.get_edge_info(node, succ )) for succ in self.get_successors(node)]
                for succ, info in out_edges_with_info:
                    for info_elem in info:
                        self.add_edge(combined_context_node, succ, info_elem)
                # delete original nodes
                self.graph.remove_node(predecessor)
                self.graph.remove_node(node)
                
                nodes_merged = True
                modification_applied = True
                break  # break, so that queue will be newly constructed as it might contain deleted nodes.

        return modification_applied


    def __INVALID_merge_successive_TaskParentContext_nodes(self) -> bool:
        """Merges two TaskParentContext nodes, if one is a direct control edge successor of another.
        Iterates until no further optimizations could be found.
        Only CONTROL edges are checked / modified, since TaskParentContext nodes should only be connected to those.
        Returns True, if a modification was applied.
        NOTE: CURRENTLY INVALID DUE TO ADDITION OF TASKENDCONTEXTS!"""

        nodes_merged = True
        modification_applied = False

        while nodes_merged:
            nodes_merged = False    
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                # check if node is of type TaskParentContext
                if not isinstance(node, TaskParentContext):
                    continue
                # iterate over outgoing edges and search for control edges
                node_control_edge_successors = [ctx for ctx in self.get_successors(node) if len([info for info in self.get_edge_info(node, ctx) if info.type == CTGEdgeType.CONTROL])>0]
                to_be_removed: List[TaskParentContext] = []
                for successor in node_control_edge_successors:
                    # check if successor is of type TaskParentContext
                    if not isinstance(successor, TaskParentContext):
                        continue
                    # merge successor into node
                    control_edge_predecessors = [ctx for ctx in self.get_predecessors(successor) if (len([info for info in self.get_edge_info(ctx, successor) if info.type == CTGEdgeType.CONTROL])>0)]
                    # redirect incoming control edges to node
                    for pred in control_edge_predecessors:
                        if pred == node:
                            continue
                        self.add_edge(pred, node, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # redirect outgoing control edges
                    succ_control_edge_successors = [ctx for ctx in self.get_successors(successor) if len([info for info in self.get_edge_info(successor, ctx) if info.type == CTGEdgeType.CONTROL])>0]
                    for succ in succ_control_edge_successors:
                        self.add_edge(node, succ, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # register successor for removal from the graph
                    to_be_removed.append(successor)
                    nodes_merged = True
                    modification_applied = True
                # remove nodes
                for ctx in to_be_removed:
                    self.graph.remove_node(ctx)
                # if modification was applied, queue might now contain deleted nodes. and thus be invalid. Start new outer iteration
                if nodes_merged:
                    break

        return modification_applied


    def __split_taskable_control_sequence(self) -> bool:
        """Split Control sequence between two Work or CombinedContext nodes, if there is no DATA edge between them.
        To Perform the split, a TaskParent dummy node is inserted before the first node of the sequence and both sequence nodes will become direct successors of the TaskParent node.
        Implementation relies on the successive application of __break_triangles for cleanup, as it will not remove the edge between the first node in the sequence and its predecessor.
        Returns True, if the graph was modified."""
        sequences_split = True
        modification_applied = False
        while sequences_split:
            sequences_split = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                # check if node is of type Work or CombinedContext
                if not (isinstance(node, WorkContext) or isinstance(node, CombinedContext)):
                    continue
                # iterate over outgoing edges and search for control edges
                control_edge_successors = [ctx for ctx in self.get_successors(node) if len([info for info in self.get_edge_info(node, ctx) if info.type == CTGEdgeType.CONTROL])>0]
                # ensure that node has exactly one control edge successor  (todo: this might be extended in the future, but should not be necessary for regular operation)
                if len(control_edge_successors) != 1:
                    continue
                # at this point, control_edge_successors should only contain a single element, otherwise multiple TaskParents and TaskEnds would be spawned
                for successor in control_edge_successors:
                    # check if successor is of type Work or CombinedContext
                    if not (isinstance(successor, WorkContext) or isinstance(successor, CombinedContext)):
                        continue
                    # check if a data dependency between both nodes exist, i.e., whether both can be executed in parallel or not
                    if len([info for info in self.get_edge_info(node, successor) if info.type == CTGEdgeType.DATA]) > 0:
                        continue
                    # check that both nodes share the same parent
                    if node.parent_context != successor.parent_context:
                        continue
                    print(" === FOUND TASK ===")

                    # both can be executed in parallel. Create a TaskParent node and connect. 
                    task_parent_node = TaskParentContext()
                    task_end_node = TaskEndContext()
                    task_parent_node.set_task_end(task_end_node)
                    task_end_node.set_task_parent(task_parent_node)
                    # get source nodes of incoming control edges of node
                    control_edge_predecessors = [ctx for ctx in self.get_predecessors(node) if (len([info for info in self.get_edge_info(ctx, node) if info.type == CTGEdgeType.CONTROL])>0)]
                    # connect predecessors to task_parent_node
                    for pred in control_edge_predecessors:
                        self.add_edge(pred, task_parent_node, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # connect task_parent_node to node
                    self.add_edge(task_parent_node, node, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # connect task_parent_node to successor
                    self.add_edge(task_parent_node, successor, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # remove control edge between node and successor
                    self.graph.remove_edge(node, successor)
                    # connect node to task_end_node
                    self.add_edge(node, task_end_node, CTGEdgeInfo(CTGEdgeType.CONTROL))
                    # redirect outgoing control edges of successor through task_end_node (again, __break_cycles will cleanup) 
                    succ_control_edge_successors = [ctx for ctx in self.get_successors(successor) if len([info for info in self.get_edge_info(successor, ctx) if info.type == CTGEdgeType.CONTROL])>0]
                    for succ in succ_control_edge_successors:
                        self.add_edge(task_end_node, succ, CTGEdgeInfo(CTGEdgeType.CONTROL))
                        self.graph.remove_edge(successor, succ)
                    # connect successor to task_end_node
                    self.add_edge(successor, task_end_node, CTGEdgeInfo(CTGEdgeType.CONTROL))

                    sequences_split = True   
                    modification_applied = True           

        return modification_applied

    def __trivial_control_sequence_simplification(self) -> bool:
        """Replace trivial, linear control sequences with a CombinedContext node. Loop until no further linear sequences exist.
        Trivial sequences can consist of WorkContext and CombinedContext nodes only.
        Trivial sequences must contain at least some work. 
        trivial sequences must share a common parent.
        This is enforced by requiring, that either a WorkContext or a CombinedContext are contained.
        CombinedContexts themselves have the same requirement.
        Returns True, if a modification was applied."""
        sequences_replaced = True
        modification_applied = False
        while sequences_replaced:
            sequences_replaced = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                # check if node is a valid sequence entry
                predecessors = self.get_predecessors(node)
                successors = self.get_successors(node)
                if len(successors) != 1 or len(predecessors) != 1:
                    continue
                # ensure existing control edge to successor
                if len([info for info in self.get_edge_info(node, successors[0]) if info.type == CTGEdgeType.CONTROL]) < 1:
                    continue

                sequence: List[Context] = []
                # construct the longest possible sequence
                current: Optional[Context] = node
                while current is not None:
                    # ensure current is of either allowed type of sequence members
                    if not (isinstance(current, WorkContext) or isinstance(current, CombinedContext) or isinstance(current, IterationContext) or isinstance(current, InlinedFunctionContext) or isinstance(current, FunctionContext)):
                        # not a valid sequence member
                        break
                    
                    # check if node is a valid sequence member
                    predecessors = self.get_predecessors(current)
                    successors = self.get_successors(current)
                    if len(predecessors) != 1:
                        # not a valid sequence member
                        break
                    if len(successors) != 1:
                        # end of the current sequence, but a valid member
                        sequence.append(current)
                        break
                    # ensure sequence members share a common parent
                    if node.parent_context != current.parent_context:
                        break
                    
                    # valid sequence member
                    sequence.append(current)

                    # ensure existing control edge to successor
                    if len([info for info in self.get_edge_info(current, successors[0]) if info.type == CTGEdgeType.CONTROL]) < 1:
                        # end of the sequence
                        current = None
                        break
                    # check successor
                    current = successors[0]
                # ensure sequence consists of at least two elements
                if len(sequence) < 2:
                    continue
                # ensure that the sequence contains at least one WorkContext or CombinedContext element, so that the Sequence performs at least some minor work.
                if len([seq_elem for seq_elem in sequence if isinstance(seq_elem, WorkContext) or isinstance(seq_elem, CombinedContext)]) < 1:
                    # no work contained in the sequence
                    continue
                # combine sequence into CombinedContext node 
                combined_context_node = CombinedContext()
                combined_context_node.register_parent_context(sequence[0].parent_context)
                for seq_elem in sequence:
                    if isinstance(seq_elem, CombinedContext):
                        combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                            seq_elem.contained_contexts
                        )
                    else:
                        combined_context_node.contained_contexts.add(seq_elem)
                # redirect incoming edges                
                in_edges_with_info: List[Tuple[Context, List[CTGEdgeInfo]]] = [(pred, self.get_edge_info(pred, sequence[0])) for pred in self.get_predecessors(sequence[0])]
                for pred, info in in_edges_with_info:
                    for info_elem in info:
                        self.add_edge(pred, combined_context_node, info_elem)
                # redirect outgoing edges
                out_edges_with_info: List[Tuple[Context, List[CTGEdgeInfo]]] = [(succ, self.get_edge_info(sequence[-1], succ )) for succ in self.get_successors(sequence[-1])]
                # print("OEWI: ", out_edges_with_info)
                for succ, info in out_edges_with_info:
                    for info_elem in info:
                        self.add_edge(combined_context_node, succ, info_elem)
                # delete sequence nodes
                for seq_elem in sequence:
                    if seq_elem in queue:
                        queue.remove(seq_elem)
                    self.graph.remove_node(seq_elem)
                sequences_replaced = True
                modification_applied = True
        return modification_applied


    def __break_triangles(self) -> bool:
        """search for triangles. If a triangle is found, delete the direct edge between triangle entry and exit node. 
        As a result, the __control_sequence_simplification can combine the triangle into one CombinedContext node.
        Returns True, if a modification was applied."""
        logger.info("Breaking triangles...")
        triangles_broken = True
        modification_applied = False
        while triangles_broken:
            logger.info("--> iterating...")
            triangles_broken = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                predecessors = self.get_predecessors(node)
                if len(predecessors) < 2:
                    continue
                # check all combinations of predecessors for triangles
                triangle_nodes: Optional[Tuple[Context, Context]] = None
                for pred_1 in predecessors:
                    for pred_2 in predecessors:
                        if pred_1 == pred_2:
                            continue
                        # triangle exists, if pred_1 is a predecessor of pred_2 or vice versa
                        if pred_1 in self.get_predecessors(pred_2):
                            triangle_nodes = (pred_1, pred_2)
                            break
                        if pred_2 in self.get_predecessors(pred_1):
                            triangle_nodes = (pred_2, pred_1)
                if triangle_nodes is None:
                    # did not find a triangle
                    continue
                # delete the short triangle edge
                self.graph.remove_edge(triangle_nodes[0], node)
                triangles_broken = True
                modification_applied = True
        return modification_applied





    def __replace_triangles(self) -> None:
        """Replace triangles in the graph with a CombinedContext node. Loop until no further triangles exist."""
        logger.info("Replacing triangles...")
        triangles_replaced = True
        while triangles_replaced:
            logger.info("--> iterating...")
            triangles_replaced = False
            queue: List[Context] = list(self.graph.nodes())
            while len(queue) > 0:
                node = queue.pop()
                predecessors = self.get_predecessors(node)
                if len(predecessors) < 2:
                    continue
                # check all combinations of predecessors for triangles
                triangle_nodes: Optional[Tuple[Context, Context]] = None
                for pred_1 in predecessors:
                    for pred_2 in predecessors:
                        if pred_1 == pred_2:
                            continue
                        # triangle exists, if pred_1 is a predecessor of pred_2 or vice versa
                        if pred_1 in self.get_predecessors(pred_2) :
                            triangle_nodes = (pred_1, pred_2)
                            break
                        if pred_2 in self.get_predecessors(pred_1):
                            triangle_nodes = (pred_2, pred_1)
                            break
                if triangle_nodes is None:
                    # did not find a triangle
                    continue
                # replace triangle with CombinedContext
                combined_context_node = CombinedContext()
                combined_context_node.register_parent_context(triangle_nodes[0].parent_context)
                self.add_node(combined_context_node)
                # register contained contexts
                if isinstance(node, CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        node.contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(node)

                if isinstance(triangle_nodes[0], CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        triangle_nodes[0].contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(triangle_nodes[0])

                if isinstance(triangle_nodes[1], CombinedContext):
                    combined_context_node.contained_contexts = combined_context_node.contained_contexts.union(
                        triangle_nodes[1].contained_contexts
                    )
                else:
                    combined_context_node.contained_contexts.add(triangle_nodes[1])

                # check validity of the transformation. Do not allow the creation of bi-directional edges
                # -> get predecessors and successors
                raw_outside_predecessors = [
                    n
                    for n in self.get_predecessors(node)
                    + self.get_predecessors(triangle_nodes[0])
                    + self.get_predecessors(triangle_nodes[1])
                ]
                raw_outside_successors = [
                    n
                    for n in self.get_successors(node)
                    + self.get_successors(triangle_nodes[0])
                    + self.get_successors(triangle_nodes[1])
                ]
                # -> remove duplicates
                raw_outside_predecessors = list(set(raw_outside_predecessors))
                raw_outside_successors = list(set(raw_outside_successors))
                # -> cleanup
                outside_predecessors = [
                    n
                    for n in raw_outside_predecessors
                    if not (n == node or n == triangle_nodes[0] or n == triangle_nodes[1])
                ]
                outside_successors = [
                    n
                    for n in raw_outside_successors
                    if not (n == node or n == triangle_nodes[0] or n == triangle_nodes[1])
                ]
                # -> check if bi-directional edges would be created
                skip_triangle = False
                for pred in outside_predecessors:
                    if pred in outside_successors:
                        # bi-directional edge would be created! Ignore triangle.
                        skip_triangle = True
                        break
                if skip_triangle:
                    continue

                # redirect incoming edges
                for pred in outside_predecessors:
                    self.add_edge(pred, combined_context_node, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

                # redirect outgoing edges
                for succ in outside_successors:
                    self.add_edge(combined_context_node, succ, edge_info=CTGEdgeInfo(CTGEdgeType.CONTROL))

                # remove triangle nodes from queue
                if triangle_nodes[0] in queue:
                    queue.remove(triangle_nodes[0])
                if triangle_nodes[1] in queue:
                    queue.remove(triangle_nodes[1])
                # delete triangle nodes
                self.graph.remove_node(node)
                self.graph.remove_node(triangle_nodes[0])
                self.graph.remove_node(triangle_nodes[1])
                # allow one more iteration
                triangles_replaced = True

        logger.info("--> removing trivial nodes")
        to_be_removed: List[Context] = []
        for node in tqdm(self.graph.nodes):
            if len(self.get_predecessors(node)) == 0 and len(self.get_successors(node)) == 0:
                to_be_removed.append(node)
        for node in to_be_removed:
            self.graph.remove_node(node)

    def __print_graph_statistics(self, label: str = "", color="yellow") -> None:
        #logger.info("####################")
        #logger.info("# Graph statistics: " + label)
        #logger.info("# Node count: " + str(len(self.graph.nodes)))
        #logger.info("# Edge count:  " + str(len(self.graph.edges)))
        #logger.info("####################")
        cprint("####################", color)
        cprint("# Graph statistics: " + label, color)
        cprint("# Node count: " + str(len(self.graph.nodes)), color)
        cprint("# Edge count:  " + str(len(self.graph.edges)), color)
        cprint("####################", color)

    def get_predecessors(self, node: Optional[Context]) -> List[Context]:
        if node is None:
            return []
        predecessors = list(set([s for s, t in self.graph.in_edges(node)]))
        return predecessors

    def get_successors(self, node: Optional[Context]) -> List[Context]:
        if node is None:
            return []
        successors = list(set([t for s, t in self.graph.out_edges(node)]))
        return successors

    def plot(self, highlight_nodes: Optional[List[Context]] = None) -> None:
        import tkinter as tk
        import numpy as np
        from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk  # type: ignore
        from matplotlib.figure import Figure
        root = tk.Tk()
        root.title("Context Task Graph")
        def close_window() -> None:
            root.quit()
            root.destroy()

        frame1 = tk.Frame(root)
        fig1 = Figure()  # Figure(figsize=(5, 4))
        
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Context Task Graph")
        canvas1 = FigureCanvasTkAgg(fig1, master=frame1)
        canvas1.draw()
        canvas1.get_tk_widget().grid(row=0, sticky="nsew")
        toolbar1 = NavigationToolbar2Tk(canvas1, pack_toolbar=False)  # , root)
        toolbar1.update()
        toolbar1.grid(row=1)
        frame1.grid(column=0, row=0, sticky="nswe")
        
        self.update_plot(ax1, highlight_nodes)
        print("Waiting for user to close the Window...")
        # ---- start main loop
        root.protocol("WM_DELETE_WINDOW", close_window)
        root.mainloop()
        # plt.show()

    def update_plot(self, axis: Axes, highlight_nodes: Optional[List[Context]] = None) -> None:
        logger.info("Plotting...")

        logger.info("---> generating layout...")
        # positions = nx.nx_pydot.pydot_layout(self.graph, prog="sfdp")  # prog="dot")
        positions = nx.nx_pydot.pydot_layout(self.graph, prog="dot")
        # positions = self.quick_layout(self.graph)
        logger.info("--->    Done.")

        # draw regular nodes
        if highlight_nodes is None:
            nx.draw_networkx_nodes(self.graph, positions, ax=axis)
        else:
            nx.draw_networkx_nodes(
                self.graph, positions, nodelist=[n for n in self.graph.nodes() if n not in highlight_nodes], ax=axis
            )
        # draw highlighted nodes
        if highlight_nodes is not None:
            nx.draw_networkx_nodes(self.graph, positions, nodelist=highlight_nodes, node_color="red", ax=axis)
        # draw control edges
        tmp_graph = self.graph
        edgelist: List[Tuple[Context, Context]] = []
        for source, target in [(s, t) for s, t in self.graph.edges()]:
            edge_info = self.get_edge_info(source, target)            
            is_control_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.CONTROL]) > 0 else False
            is_data_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.DATA]) > 0 else False
            if is_control_edge and not is_data_edge:
                tmp_graph.add_edge(source, target)
                edgelist.append((source, target))
        nx.draw_networkx_edges(tmp_graph, positions, edgelist=edgelist, edge_color="black", ax=axis)
        for tpl in edgelist:
            tmp_graph.remove_edge(tpl[0], tpl[1])
        # draw data edges
        edgelist.clear()
        for source, target in [(s, t) for s, t in self.graph.edges()]:
            edge_info = self.get_edge_info(source, target)            
            is_control_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.CONTROL]) > 0 else False
            is_data_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.DATA]) > 0 else False
            if is_data_edge and not is_control_edge:
                tmp_graph.add_edge(source, target)
                edgelist.append((source, target))
        nx.draw_networkx_edges(tmp_graph, positions, edgelist=edgelist, edge_color="red", ax=axis, connectionstyle="arc3,rad=0.2")
        for tpl in edgelist:
            tmp_graph.remove_edge(tpl[0], tpl[1])
        # draw combined control and data edges
        edgelist.clear()
        for source, target in [(s, t) for s, t in self.graph.edges()]:
            edge_info = self.get_edge_info(source, target)            
            is_control_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.CONTROL]) > 0 else False
            is_data_edge = True if len([info for info in edge_info if info.type == CTGEdgeType.DATA]) > 0 else False
            if is_data_edge and is_control_edge:
                tmp_graph.add_edge(source, target)
                edgelist.append((source, target))
        nx.draw_networkx_edges(tmp_graph, positions, edgelist=edgelist, edge_color="blue", ax=axis, connectionstyle="arc3,rad=0.2")
        for tpl in edgelist:
            tmp_graph.remove_edge(tpl[0], tpl[1])

        # draw imaginary edges
        edgelist.clear()
        for source in self.imaginary_replacement_edges:
            for target in self.imaginary_replacement_edges[source]:
                tmp_graph.add_edge(source, target)
                edgelist.append((source, target))
        try:
            nx.draw_networkx_edges(tmp_graph, positions, edgelist=edgelist, edge_color="green", ax=axis)
        except KeyError:
            logger.info("KeyError during plotting of imaginary replacement edges. Skipping.")
            pass
        for source in self.imaginary_replacement_edges:
            for target in self.imaginary_replacement_edges[source]:
                tmp_graph.remove_edge(source, target)

        # get node labels
        labels = {}
        for node in self.graph.nodes():
            labels[node] = node.get_label()
        try:
            nx.draw_networkx_labels(self.graph, positions, labels, font_size=7, ax=axis)
        except KeyError:
            logger.info("KeyError during plotting node labels. Skipping.")
            pass
        
        # define legend
        black_line = mlines.Line2D([], [], color='black', # marker='*',
                          markersize=15, label='control')
        red_line = mlines.Line2D([], [], color='red', # marker='*',
                          markersize=15, label='data')
        blue_line = mlines.Line2D([], [], color='blue', # marker='*',
                          markersize=15, label='control + data')
        green_line = mlines.Line2D([], [], color='green', # marker='*',
                          markersize=15, label='imaginary replacement edges')

        axis.legend(loc="upper left", handles=[black_line, red_line, blue_line, green_line] ) # labels=["control", "data", "control + data", "imaginary"], labelcolor=["black", "red", "blue", "green"], )

    def quick_layout(self, subgraph: Optional[Graph] = None) -> Dict[TGNode, Tuple[float, float]]:
        logger.info("----> generating quick layout...")
        if subgraph is None:
            graph = self.graph
        else:
            graph = subgraph
        positions: Dict[TGNode, Tuple[float, float]] = dict()
        entries: List[TGNode] = []
        for node in graph.nodes:
            if graph.in_degree(node) > 0:
                continue
            entries.append(node)

        # assign positions by dfs-traversing
        occupied_positions: Dict[int, int] = dict()
        current_x_offset = 0
        for entry in entries:
            # get x offset of the current tree and reset the occupied positions
            current_x_offset = max(occupied_positions.values()) if len(occupied_positions.values()) > 0 else 0
            occupied_positions.clear()
            # assign positions
            queue: List[Tuple[TGNode, int]] = [(entry, 0)]
            while len(queue) > 0:
                current_node, current_level = queue.pop()
                if current_node in positions:
                    continue

                if current_level not in occupied_positions:
                    occupied_positions[current_level] = current_x_offset
                occupied_positions[current_level] += 1
                current_position = occupied_positions[current_level]
                positions[current_node] = (float(current_position), float(-current_level))

                out_edges = graph.out_edges(current_node)

                for _, target in out_edges:
                    queue.append((target, current_level + 1))
        return positions

    def add_node(self, node: Context) -> None:
        self.graph.add_node(node)

    def add_edge(self, source: Optional[Context], target: Optional[Context], edge_info: CTGEdgeInfo) -> None:
        if source is None or target is None:
            return
        # disallow duplicate edges
        if not self.graph.has_edge(source, target):
            self.graph.add_edge(source, target)
            
        # attach edge_info to the edge
        if source not in self.edge_information:
            self.edge_information[source] = dict()
        if target not in self.edge_information[source]:
            self.edge_information[source][target] = []
        if edge_info not in self.edge_information[source][target]:
            self.edge_information[source][target].append(edge_info)
    
    def get_edge_info(self, source: Context, target: Context) -> List[CTGEdgeInfo]:
        if source not in self.edge_information:
            return []
        if target not in self.edge_information[source]:
            return []
        return self.edge_information[source][target]
