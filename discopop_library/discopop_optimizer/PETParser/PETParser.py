# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
from typing import Dict, List, Optional, Tuple, Set, cast

import networkx as nx  # type: ignore
import warnings

from discopop_explorer.PEGraphX import (
    PEGraphX,
    FunctionNode,
    EdgeType,
    LoopNode,
    CUNode,
    NodeID,
    MemoryRegion,
)
from discopop_explorer.utils import calculate_workload
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.discopop_optimizer.PETParser.DataAccesses.FromCUs import (
    get_data_accesses_for_cu,
)
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.edges.SuccessorEdge import SuccessorEdge
from discopop_library.discopop_optimizer.classes.nodes.ContextMerge import ContextMerge
from discopop_library.discopop_optimizer.classes.nodes.ContextRestore import ContextRestore
from discopop_library.discopop_optimizer.classes.nodes.ContextSave import ContextSave
from discopop_library.discopop_optimizer.classes.nodes.ContextSnapshot import ContextSnapshot
from discopop_library.discopop_optimizer.classes.nodes.ContextSnapshotPop import ContextSnapshotPop
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.classes.nodes.Loop import Loop
from discopop_library.discopop_optimizer.classes.nodes.Workload import Workload
from discopop_library.discopop_optimizer.utilities.MOGUtilities import (
    add_dataflow_edge,
    get_all_nodes_in_function,
    get_all_parents,
    get_nodes_by_functions,
    get_parent_function,
    get_parents,
    get_path_entry,
    get_predecessors,
    get_successors,
    get_children,
    add_successor_edge,
    add_child_edge,
    add_temporary_edge,
    redirect_edge,
    convert_temporary_edges,
    get_all_function_nodes,
    get_read_and_written_data_from_subgraph,
    remove_edge,
    show,
    show_function,
)
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at


class PETParser(object):
    pet: PEGraphX
    graph: nx.DiGraph
    next_free_node_id: int
    cu_id_to_graph_node_id: Dict[NodeID, int]
    experiment: Experiment
    in_data_flow: Dict[int, Set[int]]
    out_data_flow: Dict[int, Set[int]]
    invalid_functions: Set[int]

    def __init__(self, experiment: Experiment):
        self.pet = experiment.detection_result.pet
        self.graph = nx.DiGraph()
        self.next_free_node_id = 0
        self.cu_id_to_graph_node_id = dict()
        self.experiment = experiment
        self.invalid_functions = set()

    def parse(self) -> Tuple[nx.DiGraph, int]:
        if self.experiment.arguments.verbose:
            print("PARSING PET")
        self.__add_cu_nodes()
        if self.experiment.arguments.verbose:
            print("added cu nodes")
        self.__add_functions()
        if self.experiment.arguments.verbose:
            print("added functions")
        self.__add_pet_successor_edges()
        if self.experiment.arguments.verbose:
            print("added successor edges")
        self.__add_loop_nodes()
        if self.experiment.arguments.verbose:
            print("added loop nodes")

        if self.experiment.arguments.verbose:
            print("remove non-hotspot function bodys")
        self.__remove_non_hotspot_function_bodys()

        # self.__add_branch_return_node()
        #self.__add_function_return_node()

        #self.__new_parse_branched_sections()

        self.__flatten_function_graphs()

        convert_temporary_edges(self.graph)
        if self.experiment.arguments.verbose:
            print("converted temporary edges")

        #        self.__mark_branch_affiliation()
        #        print("marked branch affiliations")
        self.__calculate_data_flow()
        if self.experiment.arguments.verbose:
            print("calculated data flow")

        self.__propagate_reads_and_writes()
        if self.experiment.arguments.verbose:
            print("Propagated read/write information")

        # remove invalid functions
        self.__remove_invalid_functions()
        
        show(self.graph, show_dataflow=False, show_mutex_edges=False)

        return self.graph, self.next_free_node_id

    def get_new_node_id(self) -> int:
        """returns the next free node id and increments the counter"""
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
    
    def __flatten_function_graphs(self):
        for function in get_all_function_nodes(self.graph):
            function_node = cast(FunctionRoot, data_at(self.graph, function))
            print("Flattening function:", function_node.name)
            show_function(self.graph, function_node, show_dataflow=False, show_mutex_edges=False)
            # prepare individual branches by replacing nodes with more than one predecessor
            # effectively, this leads to a full duplication of all possible branches
            modification_found = True
            while modification_found:
                modification_found = False
                for node in get_all_nodes_in_function(self.graph, function):
                    print("Node: ", node, type(node))
                    if len(get_predecessors(self.graph, node)) > 1:
                        print("Too many predecessors: ", node)
                        modification_found = self.__fix_too_many_predecessors(node)
                        if modification_found:
                            break  
                if modification_found:
                    show_function(self.graph, function_node, show_dataflow=False, show_mutex_edges=False)
            # combine branches by adding context nodes
            # effectively, this step creates a single, long branch from the functions body
            modification_found = True
            while modification_found:
                modification_found = False
                for node in get_all_nodes_in_function(self.graph, function):
                    print("Node: ", node, type(node))
                    if len(get_successors(self.graph, node)) > 1:
                        print("Too many successors: ", node)
                        modification_found = self.__fix_too_many_successors(node)
                        print("\tfix applied: ", modification_found)
                        if modification_found:
                            break  

    def __fix_too_many_successors(self, node) -> bool:
        """Return True if a graph modification has been applied. False otherwise."""
        retval = False

        # check if a node with more than one successor is located on any of the branches starting at node
        # if so, this node is not suited for the application of a fix.
        # Effectively, this leads to a bottom-up branch combination.
        for succ in get_successors(self.graph, node):
            # traverse succeeding branches to check for contained path splits
            queue = [succ]
            while len(queue) > 0:
                current = queue.pop()
                if len(get_successors(self.graph, current)) > 1:
                    # node not suited for fix application
                    return False
                queue += [s for s in get_successors(self.graph, current) if s not in queue]
            # end of branch reached without encountering a path split.
        
        # none of the succeeding paths contained a path split.
        # --> node qualifies for the application of a fix
        



        retval = True
        return retval

    def __fix_too_many_predecessors(self, node) -> bool:
        """Return True if a graph modification has been applied. False otherwise."""
        retval = False
        for pred in get_predecessors(self.graph, node):
            new_node_id = self.get_new_node_id()
            node_copy_data = copy.deepcopy(data_at(self.graph, node))
            node_copy_data.node_id = new_node_id
            node_copy = self.graph.add_node(new_node_id, data=node_copy_data)
            # copy non-successors type incoming edges
            for in_edge in self.graph.in_edges(node, data="data"):
                if type(in_edge[2]) == SuccessorEdge:
                    continue
                self.graph.add_edge(in_edge[0], new_node_id, data=copy.deepcopy(in_edge[2]))
                print("Added edge: ", in_edge[0], new_node_id, "type: ", type(copy.deepcopy(in_edge[2])))
            # connect copied node to pred
            self.graph.add_edge(pred, new_node_id, data=SuccessorEdge())

            # copy outgoing edges
            for out_edge in self.graph.out_edges(node, data="data"):
                self.graph.add_edge(new_node_id, out_edge[1], data=copy.deepcopy(out_edge[2]))
                print("Added edge: ", new_node_id, out_edge[1], "type: ", type(copy.deepcopy(out_edge[2])))

        # delete node
        self.graph.remove_node(node)
            
        retval = True
        return retval




    def __remove_non_hotspot_function_bodys(self):
        if len(self.experiment.hotspot_functions) == 0:
            return
        all_hotspot_functions_raw: List[Tuple[int, str]] = []
        for key in self.experiment.hotspot_functions:
            for file_id, line_num, hs_node_type, name in self.experiment.hotspot_functions[key]:
                if hs_node_type == HotspotNodeType.FUNCTION:
                    all_hotspot_functions_raw.append((file_id, name))

        # convert raw information to node ids
        for file_id, name in all_hotspot_functions_raw:
            for function in get_all_function_nodes(self.graph):
                function_node = data_at(self.graph, function)
                if int(function_node.original_cu_id.split(":")[0]) == file_id:
                    print("FID EQUAL")
                    print("CHECK NAME: ", function_node.name, name)
                    if function_node.name == name:
                        print("NAME EQQUAL")
                        self.experiment.hotspot_function_node_ids.append(function)

        print("HOTPSOT FUNCTIONS: ")
        print(self.experiment.hotspot_function_node_ids)

        for function in get_all_function_nodes(self.graph):
            if function not in self.experiment.hotspot_function_node_ids and len(self.experiment.hotspot_function_node_ids) > 0:
                print("DELETING FUNCTION BODY: ", data_at(self.graph, function).name)
                # remove function body
                for node in get_all_nodes_in_function(self.graph, function):
                    self.graph.remove_node(node)
                # leave the function node

    def __remove_invalid_functions(self):
        for function in self.invalid_functions:
            if self.experiment.arguments.verbose:
                print("Removing body of invalid function: ", data_at(self.graph, function).name)
            # delete all nodes in function body
            for node in get_all_nodes_in_function(self.graph, function):
                self.graph.remove_node(node)
            # leave the function node for compatibility reasons

    def __add_function_return_node(self):
        function_node_ids = get_all_function_nodes(self.graph)
        dummy_return_nodes: Set[int] = set()
        function_return_nodes: Dict[int, int] = dict()
        for function in function_node_ids:
            return_dummy_id = self.get_new_node_id()
            self.graph.add_node(return_dummy_id, data=Workload(return_dummy_id, None, None, None, None))
            function_return_nodes[function] = return_dummy_id
            dummy_return_nodes.add(return_dummy_id)

        for node in self.graph.nodes():
            if node in dummy_return_nodes:
                continue
            if len(get_successors(self.graph, node)) == 0:
                # node is end of path
                # check if node is contained in function
                parent_functions = [e for e in get_all_parents(self.graph, node) if e in function_node_ids]
                if len(parent_functions) > 0:
                    for parent_func in parent_functions:
                        # connect end of path to the dummy return node
                        add_successor_edge(self.graph, node, function_return_nodes[parent_func])

    #                        if self.experiment.arguments.verbose:
    #                            print("ADDED DUMMY CONNECTION: ", node, function_return_nodes[parent_func])

    def __add_branch_return_node(self):
        """makes sure every branching section has a merge node"""
        path_return_nodes: Dict[int, int] = dict()

        for node in copy.deepcopy(self.graph.nodes()):
            if len(get_successors(self.graph, node)) == 0:
                path_entry = get_path_entry(self.graph, node)
                if path_entry not in path_return_nodes:
                    # create new dummy return node
                    dummy_return_node_id = self.get_new_node_id()
                    self.graph.add_node(
                        dummy_return_node_id, data=Workload(dummy_return_node_id, self.experiment, None, None, None)
                    )
                    path_return_nodes[path_entry] = dummy_return_node_id
                # connect to existing return node
                add_successor_edge(self.graph, node, path_return_nodes[path_entry])
                print("ADDED EDGE: ", node, "->", path_return_nodes[path_entry])

    def __new_parse_branched_sections(self):
        """Branched sections in the CU Graph are represented by a serialized version in the MOG.
        To make this possible, Context Snapshot, Restore and Merge points are added to allow a synchronization
        'between' the different branches"""

        all_functions = get_all_function_nodes(self.graph)
        nodes_by_functions = get_nodes_by_functions(self.graph)
        for idx, function in enumerate(all_functions):
            if function not in self.experiment.hotspot_function_node_ids and len(self.experiment.hotspot_function_node_ids) > 0:
                if data_at(self.graph, function).name == "main":
                    print("SKIPPING NON HOTSPOT FUNCTION: ", data_at(self.graph, function).name)
                continue
            #try:
            if self.experiment.arguments.verbose:
                if data_at(self.graph, function).name == "main":
                    print("FUNCTION: ", data_at(self.graph, function).name, idx, "/", len(all_functions))
            nodes_in_function = nodes_by_functions[function]

            post_dominators = self.__get_post_dominators(nodes_in_function)

            path_splits = self.__get_path_splits(nodes_in_function)
            merge_nodes = self.__get_merge_nodes(path_splits, post_dominators)

            if data_at(self.graph, function).name == "main":
                print("showing..")
                show_function(self.graph, data_at(self.graph, function), show_dataflow=False, show_mutex_edges=False)

            
            added_node_ids = self.__fix_empty_branches(merge_nodes, post_dominators)

            if data_at(self.graph, function).name == "main":
                print("showing..")
                show_function(self.graph, data_at(self.graph, function), show_dataflow=False, show_mutex_edges=False)
            nodes_in_function = list(set(nodes_in_function).union(set(added_node_ids)))

            # re-calculate post_dominators and merge nodes
            #            post_dominators = self.__get_post_dominators(nodes_in_function)
            #            path_splits = self.__get_path_splits(nodes_in_function)
            #            merge_nodes = self.__get_merge_nodes(path_splits, post_dominators)

            self.__insert_context_nodes(nodes_in_function)
            if data_at(self.graph, function).name == "main":
                print("showing..")
                show_function(self.graph, data_at(self.graph, function), show_dataflow=False, show_mutex_edges=False)

                # sanity check
            #                fix_applied = True
            #                while fix_applied:
            #                    fix_applied = False
            #                    for node in get_all_nodes_in_function(self.graph, function):
            #                        if len(get_predecessors(self.graph, node)) > 1:
            #                            warnings.warn("SANITY CHECK FAILED FOR NODE " +  str(node) + " . Removing random edge to try an fix the problem.")
            #                            remove_edge(self.graph, get_predecessors(self.graph, node)[0], node)
            #                            fix_applied = True
            #                            break
            #except ValueError:
            #    if self.experiment.arguments.verbose:
            #        print("NPBS: Function",  data_at(self.graph, function).name ,"invalid due to graph construction issues. Skipping.")
            #    self.invalid_functions.add(function)

    def __fix_empty_branches(
        self, merge_nodes: Dict[int, Optional[int]], post_dominators: Dict[int, Set[int]]
    ) -> List[int]:
        """do not allow empty branches. Adds an empty dummy node if necessary"""
        empty_branches: Set[Tuple[int, int]] = set()
        for split_node in merge_nodes:
            if merge_nodes[split_node] is None:
                raise ValueError("No branching without merge allowed!")
            for branch_entry in get_successors(self.graph, split_node):
                for branch_exit in get_predecessors(self.graph, cast(int, merge_nodes[split_node])):
                    if branch_exit == split_node and branch_entry == merge_nodes[split_node]:
                        empty_branches.add((branch_exit, branch_entry))

        added_node_ids: List[int] = []
        for entry, exit in empty_branches:
            dummy_node_id = self.get_new_node_id()
            self.graph.add_node(dummy_node_id, data=Workload(dummy_node_id, self.experiment, None, None, None))
            #            if self.experiment.arguments.verbose:
            #                print("Added dummy node: ", entry, "->", dummy_node_id, "->", exit)
            redirect_edge(self.graph, entry, entry, exit, dummy_node_id)
            add_successor_edge(self.graph, dummy_node_id, exit)
            added_node_ids.append(dummy_node_id)
        return added_node_ids

    def __insert_context_nodes(self, node_list: List[int]):
        """flattens the graph via inserting context nodes"""
        modification_found = True
        from time import time
        timeout = 30
        start_time = int(time())
        while modification_found:
            
            
            modification_found = False
            post_dominators = self.__get_post_dominators(node_list)
            path_splits = self.__get_path_splits(node_list)
            merge_nodes = self.__get_merge_nodes(path_splits, post_dominators)

            for split_node in merge_nodes:
                iteration_time = int(time())
                print("Iteration: ", "time:", iteration_time - start_time)
                if iteration_time - start_time > timeout:
                    raise ValueError("Timeout expired.")
                
                if merge_nodes[split_node] is None:
                    # no merge exists -> no merge necessary since a return is encountered
                    continue

                # save information for later linearization step
                branch_entry_to_exit: Dict[int, int] = dict()
                branch_entry_to_updated_entry: Dict[int, int] = dict()
                branch_exit_to_updated_exit: Dict[int, int] = dict()
                empty_branches: Set[Tuple[int, int]] = set()

                for branch_entry in get_successors(self.graph, split_node):
                    for branch_exit in get_predecessors(self.graph, cast(int, merge_nodes[split_node])):
                        if branch_exit == split_node and branch_entry == merge_nodes[split_node]:
                            empty_branches.add((branch_entry, branch_exit))

                        if branch_entry not in post_dominators:
                            continue
                        if branch_exit in post_dominators[branch_entry]:
                            branch_entry_to_exit[branch_entry] = branch_exit
                if len(empty_branches) != 0:
                    raise ValueError("No empty branches allowed!")
                # initialize dicts
                for branch_entry in get_successors(self.graph, split_node):
                    branch_entry_to_updated_entry[branch_entry] = branch_entry
                for branch_exit in get_predecessors(self.graph, cast(int, merge_nodes[split_node])):
                    branch_exit_to_updated_exit[branch_exit] = branch_exit

                # create context snapshot
                context_snapshot_id = self.get_new_node_id()
                self.graph.add_node(context_snapshot_id, data=ContextSnapshot(context_snapshot_id, self.experiment))
                node_list.append(context_snapshot_id)
                add_temporary_edge(self.graph, split_node, context_snapshot_id)

                # create branch entries
                for successor in get_successors(self.graph, split_node):
                    # create and connect context restore node
                    branch_context_restore_id = self.get_new_node_id()
                    self.graph.add_node(
                        branch_context_restore_id,
                        data=ContextRestore(branch_context_restore_id, self.experiment),
                    )
                    node_list.append(branch_context_restore_id)
                    add_temporary_edge(self.graph, context_snapshot_id, branch_context_restore_id)

                    # redirect branch to restore node
                    redirect_edge(self.graph, split_node, branch_context_restore_id, successor, successor)
                    branch_entry_to_updated_entry[successor] = branch_context_restore_id
                    modification_found = True

                # create and connect create merge node and snapshot pop node
                context_merge_node_id = self.get_new_node_id()
                self.graph.add_node(context_merge_node_id, data=ContextMerge(context_merge_node_id, self.experiment))
                context_snapshot_pop_node_id = self.get_new_node_id()
                self.graph.add_node(
                    context_snapshot_pop_node_id, data=ContextSnapshotPop(context_snapshot_pop_node_id, self.experiment)
                )
                add_temporary_edge(self.graph, context_merge_node_id, context_snapshot_pop_node_id)
                add_temporary_edge(self.graph, context_snapshot_pop_node_id, cast(int, merge_nodes[split_node]))
                node_list.append(context_merge_node_id)
                node_list.append(context_snapshot_pop_node_id)

                # create branch exits
                for predecessor in get_predecessors(self.graph, cast(int, merge_nodes[split_node])):
                    # create context save node
                    context_save_node_id = self.get_new_node_id()
                    self.graph.add_node(context_save_node_id, data=ContextSave(context_save_node_id, self.experiment))
                    node_list.append(context_save_node_id)
                    # connect context save node
                    add_temporary_edge(self.graph, context_save_node_id, context_merge_node_id)
                    redirect_edge(
                        self.graph, predecessor, predecessor, cast(int, merge_nodes[split_node]), context_save_node_id
                    )
                    branch_exit_to_updated_exit[predecessor] = context_save_node_id

                # linearize the branched section by concatenating all branches
                last_node_id = context_snapshot_id
                for entry in branch_entry_to_exit:
                    if last_node_id != context_snapshot_id:
                        self.graph.remove_edge(last_node_id, context_merge_node_id)
                    exit = branch_entry_to_exit[entry]
                    updated_entry = branch_entry_to_updated_entry[entry]
                    updated_exit = branch_exit_to_updated_exit[exit]
                    # redirect entry
                    redirect_edge(self.graph, context_snapshot_id, last_node_id, updated_entry, updated_entry)
                    last_node_id = updated_exit

                #            # linearize empty branches
                #            for entry,  exit in empty_branches:
                #                updated_entry = branch_entry_to_updated_entry[entry]
                #                updated_exit = branch_exit_to_updated_exit[updated_entry]
                #                print("EMPTY: ", entry, exit)
                #                # redirect entry
                #                redirect_edge(self.graph, context_snapshot_id, last_node_id, updated_entry, updated_entry)
                #                last_node_id = updated_exit

                # connect exit of linearized section
                # add_temporary_edge(self.graph, last_node_id, context_merge_node_id)

                # DEBUG
                if modification_found:
                    break
            convert_temporary_edges(self.graph)

    def __get_merge_nodes(
        self, path_splits: Set[int], post_dominators: Dict[int, Set[int]]
    ) -> Dict[int, Optional[int]]:
        """Calculates and returns the merge nodes for paths starting a the given node"""

        def get_merge_nodes(node_list, initial_post_dominators=None):
            candidates = initial_post_dominators
            for node in node_list:
                for succ in get_successors(self.graph, node):
                    if candidates is None:
                        candidates = post_dominators[succ]
                    candidates = candidates.intersection(post_dominators[succ])
            modification_found = True
            while modification_found:
                modification_found = False
                for c1 in candidates:
                    for c2 in candidates:
                        if c1 == c2:
                            continue
                        if c1 in post_dominators[c2]:
                            candidates.remove(c1)
                            modification_found = True
                            break
                    if modification_found:
                        break
            return candidates

        merge_nodes: Dict[int, Optional[int]] = dict()
        for node in path_splits:
            # cleanup candidates to get the earliest merge
            candidates = get_merge_nodes([node], post_dominators[node])

            while len(candidates) > 1:
                candidates = get_merge_nodes(candidates)

            # prepare return value
            if len(candidates) == 0:
                merge_nodes[node] = None
            elif len(candidates) == 1:
                merge_nodes[node] = list(candidates)[0]
            else:
                raise ValueError(
                    "More than one merge node identified for path split: " + str(node) + " : " + str(candidates)
                )
        return merge_nodes

    def __get_path_splits(self, node_list: List[int]) -> Set[int]:
        """Returns nodes which result in path splits"""
        path_splits: Set[int] = set()
        for node in node_list:
            if len(get_successors(self.graph, node)) > 1:
                path_splits.add(node)
        return path_splits

    def __get_post_dominators(self, node_list: List[int]) -> Dict[int, Set[int]]:
        """calculates and returns the post dominators for all nodes in the function"""
        post_dominators: Dict[int, Set[int]] = dict()
        # initialize
        modified: Set[int] = set()
        for node in node_list:
            post_dominators[node] = {node}
            modified.add(node)

        # iterate
        while len(modified) > 0:
            new_modified: Set[int] = set()
            for node in modified:
                predecessors = get_predecessors(self.graph, node)
                for pred in predecessors:
                    len_pre = len(post_dominators[pred])
                    post_dominators[pred] = post_dominators[pred].union(post_dominators[node])
                    if len_pre != len(post_dominators[pred]):
                        new_modified.add(pred)
            modified = new_modified
        return post_dominators

    def __parse_branched_sections(self):
        """Branched sections in the CU Graph are represented by a serialized version in the MOG.
        To make this possible, Context Snapshot, Restore and Merge points are added to allow a synchronization
        'between' the different branches"""
        visited_nodes: Set[int] = set()
        for idx, function_node in enumerate(self.pet.all_nodes(FunctionNode)):
            print("parsing ", function_node.name, idx, "/", len(self.pet.all_nodes(FunctionNode)))
            _, _ = self.__parse_raw_node(self.cu_id_to_graph_node_id[function_node.id], visited_nodes)

        # remove visited nodes, since duplicates exist now
        for node_id in visited_nodes:
            self.graph.remove_node(node_id)

    def __parse_raw_node(self, root_node_id: int, visited_nodes: Set[int]) -> Tuple[int, int]:
        """parses the nodes starting from the root node and returns the id of the first and last node in the created linearized path"""
        visited_nodes.add(root_node_id)
        # if this node has children, parse them before proceeding
        children_entry_points: List[int] = []
        for child_id in get_children(self.graph, root_node_id):
            child_entry_point, _ = self.__parse_raw_node(child_id, visited_nodes)
            children_entry_points.append(child_entry_point)

        if len(get_successors(self.graph, root_node_id)) <= 1:
            return self.__parse_path_node(root_node_id, children_entry_points, visited_nodes)
        else:
            return self.__parse_branching_point(root_node_id, children_entry_points, visited_nodes)

    def __parse_path_node(
        self, root_node_id: int, connect_to_children: List[int], visited_nodes: Set[int]
    ) -> Tuple[int, int]:
        """parses a regular path node, i.e. one with at most one successor node.
        returns the id of the first and last node in the created linearized path"""

        # create a duplicate of the root node
        duplicate_node_id = self.get_new_node_id()
        tmp_node_data = data_at(self.graph, root_node_id)
        self.graph.add_node(duplicate_node_id, data=tmp_node_data)

        # connect duplicated entry node to children
        for children_id in connect_to_children:
            add_child_edge(self.graph, duplicate_node_id, children_id)

        if len(get_successors(self.graph, root_node_id)) == 0:
            # root is a path end
            return duplicate_node_id, duplicate_node_id
        else:
            # proceed to successor
            successor_id = get_successors(self.graph, root_node_id)[0]
            path_entry, path_end = self.__parse_raw_node(successor_id, visited_nodes)

            # connect created duplicate to the successor
            add_temporary_edge(self.graph, duplicate_node_id, path_entry)

            return duplicate_node_id, path_end

    def __parse_branching_point(
        self, root_node_id: int, connect_to_children: List[int], visited_nodes: Set[int]
    ) -> Tuple[int, int]:
        """parses a branching point, i.e. a node with more than one successor.
        returns the id of the first and last node in the created linearized path"""

        #########
        # Step 1: create duplicate of root node
        # Step 2: create and connect context snapshot
        # Step 3: parse branches
        #   Step 3.1: create and connect context restore node
        #   Step 3.2: parse branch
        #   Step 3.3: create context save node
        #   Step 3.3: connect restore and save not to branch entry and exit
        # step 4: create and connect context merge node
        # Step 5: create and connect context snapshot pop
        ########

        # Step 1: create duplicate of root node
        duplicate_node_id = self.get_new_node_id()
        tmp_node_data = data_at(self.graph, root_node_id)
        self.graph.add_node(duplicate_node_id, data=tmp_node_data)

        # Step 2: create and connect context snapshot
        context_snapshot_id = self.get_new_node_id()
        self.graph.add_node(context_snapshot_id, data=ContextSnapshot(context_snapshot_id, self.experiment))
        add_temporary_edge(self.graph, duplicate_node_id, context_snapshot_id)

        # Step 3: parse branches
        last_added_node_id = context_snapshot_id
        for successor in get_successors(self.graph, root_node_id):
            # Step 3.1: create and connect context restore node
            branch_context_restore_id = self.get_new_node_id()
            self.graph.add_node(
                branch_context_restore_id,
                data=ContextRestore(branch_context_restore_id, self.experiment),
            )
            add_temporary_edge(self.graph, last_added_node_id, branch_context_restore_id)

            # Step 3.2: parse branch
            branch_entry, branch_exit = self.__parse_raw_node(successor, visited_nodes)

            # Step 3.3: create context save node
            branch_context_save_id = self.get_new_node_id()
            self.graph.add_node(branch_context_save_id, data=ContextSave(branch_context_save_id, self.experiment))

            # Step 3.3: connect restore and save node to branch entry and exit
            add_temporary_edge(self.graph, branch_context_restore_id, branch_entry)
            add_temporary_edge(self.graph, branch_exit, branch_context_save_id)

            # update last_added_node_id
            last_added_node_id = branch_context_save_id

        # step 4: create and connect context merge node
        context_merge_node_id = self.get_new_node_id()
        self.graph.add_node(context_merge_node_id, data=ContextMerge(context_merge_node_id, self.experiment))
        add_temporary_edge(self.graph, last_added_node_id, context_merge_node_id)

        # Step 5: create and connect context snapshot pop
        context_snapshot_pop_id = self.get_new_node_id()
        self.graph.add_node(
            context_snapshot_pop_id,
            data=ContextSnapshotPop(context_snapshot_pop_id, self.experiment),
        )
        add_temporary_edge(self.graph, context_merge_node_id, context_snapshot_pop_id)

        # connect duplicated entry node to children
        for children_id in connect_to_children:
            add_child_edge(self.graph, duplicate_node_id, children_id)

        return duplicate_node_id, context_snapshot_pop_id

    def __add_cu_nodes(self):
        """adds Workload nodes which represent the CU Nodes to the graph.
        The added nodes will not be connected in any way."""
        for cu_node in self.pet.all_nodes(CUNode):
            # create new node for CU
            new_node_id = self.get_new_node_id()
            self.cu_id_to_graph_node_id[cu_node.id] = new_node_id
            # calculate accessed data
            written_memory_regions, read_memory_regions = get_data_accesses_for_cu(self.pet, cu_node.id)
            try:
                parallelizable_workload = calculate_workload(
                    self.pet, cu_node, ignore_function_calls_and_cached_values=True
                )
            except RecursionError as rerr:
                warnings.warn("Cost calculation not possible for node: " + str(cu_node.id) + "!")
                parallelizable_workload = 0
            self.graph.add_node(
                new_node_id,
                data=Workload(
                    node_id=new_node_id,
                    experiment=self.experiment,
                    cu_id=cu_node.id,
                    sequential_workload=0,
                    parallelizable_workload=parallelizable_workload,
                    written_memory_regions=written_memory_regions,
                    read_memory_regions=read_memory_regions,
                ),
            )

    def __add_loop_nodes(self):
        """adds Loop Nodes to the graph.
        connects contained nodes using Children edges"""
        for loop_node in self.pet.all_nodes(LoopNode):
            # calculate metadata
            loop_subtree = self.pet.subtree_of_type(loop_node, CUNode)

            # get iteration count for loop
            if loop_node.loop_data is not None:
                iteration_count = max(1, loop_node.loop_data.average_iteration_count)
            else:
                # loop has not been executed, thus, no information was gathered during the profiling
                # set iteration_count to prevent divisions by zero
                iteration_count = 1

            # create new node for Loop
            new_node_id = self.get_new_node_id()
            self.cu_id_to_graph_node_id[loop_node.id] = new_node_id
            try:
                discopop_workload = calculate_workload(
                    self.pet, loop_node, ignore_function_calls_and_cached_values=True
                )
            except RecursionError as rerr:
                warnings.warn("Cost calculation not possible for node: " + str(loop_node.id) + "!")
                discopop_workload = 0
            self.graph.add_node(
                new_node_id,
                data=Loop(
                    node_id=new_node_id,
                    cu_id=loop_node.id,
                    discopop_workload=discopop_workload,
                    iterations=iteration_count,
                    position=loop_node.start_position(),
                    experiment=self.experiment,
                ),
            )
            # connect loop node and entry node via a child edge
            entry_node_cu_id = loop_node.get_entry_node(self.pet).id
            add_child_edge(self.graph, new_node_id, self.cu_id_to_graph_node_id[entry_node_cu_id])

            # redirect edges from outside the loop to the entry node to the Loop node
            print()
            for s, t, d in self.pet.in_edges(entry_node_cu_id, EdgeType.SUCCESSOR):
                if self.pet.node_at(s) not in loop_subtree:
                    print("s: ", s)
                    print("t: ", t)
                    print("entry: ", entry_node_cu_id)
                    print("source:", self.cu_id_to_graph_node_id[s])
                    print("old target: ", self.cu_id_to_graph_node_id[entry_node_cu_id])
                    print("new target: ", new_node_id)
                    try:
                        redirect_edge(
                            self.graph,
                            old_source_id=self.cu_id_to_graph_node_id[s],
                            new_source_id=self.cu_id_to_graph_node_id[s],
                            old_target_id=self.cu_id_to_graph_node_id[entry_node_cu_id],
                            new_target_id=new_node_id,
                        )
                    except KeyError as ke:
                        if self.experiment.arguments.verbose:
                            print("ignoring redirect of edge due to KeyError: ", ke)

            # redirect edges to the outside of the loop
            for s, t, d in self.pet.out_edges(entry_node_cu_id, EdgeType.SUCCESSOR):
                if self.pet.node_at(t) not in loop_subtree:
                    redirect_edge(
                        self.graph,
                        old_source_id=self.cu_id_to_graph_node_id[entry_node_cu_id],
                        new_source_id=new_node_id,
                        old_target_id=self.cu_id_to_graph_node_id[t],
                        new_target_id=self.cu_id_to_graph_node_id[t],
                    )

            # copy entry node
            entry_node_id = self.cu_id_to_graph_node_id[entry_node_cu_id]
            entry_node_data = data_at(self.graph, entry_node_id)
            copied_entry_node_id = self.get_new_node_id()
            self.graph.add_node(copied_entry_node_id, data=entry_node_data)

            # redirect edges from inside the loop to the copy of the entry node
            for s, t, d in self.pet.in_edges(entry_node_cu_id, EdgeType.SUCCESSOR):
                if self.pet.node_at(s) in loop_subtree:
                    redirect_edge(
                        self.graph,
                        old_source_id=self.cu_id_to_graph_node_id[s],
                        new_source_id=self.cu_id_to_graph_node_id[s],
                        old_target_id=self.cu_id_to_graph_node_id[entry_node_cu_id],
                        new_target_id=copied_entry_node_id,
                    )

            # redirect accesses to the cu_id of the entry node to the newly created loop node
            self.cu_id_to_graph_node_id[entry_node_cu_id] = new_node_id

    def __add_functions(self):
        """parse function nodes in the PET graph.
        Results in the creation of a forest of function graphs."""
        for function_node in self.pet.all_nodes(FunctionNode):
            # create function root node and register it in the graph
            new_node_id = self.get_new_node_id()
            self.graph.add_node(
                new_node_id,
                data=FunctionRoot(
                    node_id=new_node_id,
                    experiment=self.experiment,
                    cu_id=function_node.id,
                    name=function_node.name,
                ),
            )
            # connect function node to its entry node
            add_child_edge(
                self.graph,
                new_node_id,
                self.cu_id_to_graph_node_id[function_node.get_entry_cu_id(self.pet)],
            )
            # save ID
            self.cu_id_to_graph_node_id[function_node.id] = new_node_id

    def __add_pet_successor_edges(self):
        for cu_node in self.pet.all_nodes(CUNode):
            for successor_cu_id in [t for s, t, d in self.pet.out_edges(cu_node.id, EdgeType.SUCCESSOR)]:
                add_successor_edge(
                    self.graph,
                    self.cu_id_to_graph_node_id[cu_node.id],
                    self.cu_id_to_graph_node_id[successor_cu_id],
                )

    def __mark_branch_affiliation(self):
        """Mark each nodes' branch affiliation to allow a simple check for 'on same branch' relation
        without considering the successor relation."""

        def mark_branched_section(node, branch_stack):
            node_data = data_at(self.graph, node)
            if isinstance(node_data, ContextSnapshot):
                branch_stack.append(node)
            elif isinstance(node_data, ContextSnapshotPop):
                branch_stack.pop()
            # mark current node
            node_data.branch_affiliation = copy.deepcopy(branch_stack)

            # mark children
            for child in get_children(self.graph, node):
                mark_branched_section(child, copy.deepcopy(branch_stack))

            # mark successors (at most one successor can exist,
            # since parallelization suggestions have not been imported yet)
            for successor in get_successors(self.graph, node):
                mark_branched_section(successor, copy.deepcopy(branch_stack))

        for function_node in get_all_function_nodes(self.graph):
            current_node = get_children(self.graph, function_node)[0]
            mark_branched_section(current_node, [])

    def __calculate_data_flow(self):
        self.in_data_flow = dict()
        self.out_data_flow = dict()

        def inlined_data_flow_calculation(current_node, current_last_writes):
            while current_node is not None:
                # check if current_node uses written data
                reads, writes = get_read_and_written_data_from_subgraph(
                    self.graph, current_node, ignore_successors=True
                )

                for mem_reg in current_last_writes:
                    # check if incoming data flow exists
                    if mem_reg in reads or mem_reg in writes:
                        # uses written data
                        # create incoming data flow
                        if current_node not in self.in_data_flow:
                            self.in_data_flow[current_node] = set()
                        self.in_data_flow[current_node].add(current_last_writes[mem_reg])
                        # create outgoing data flow
                        if current_last_writes[mem_reg] not in self.out_data_flow:
                            self.out_data_flow[current_last_writes[mem_reg]] = set()
                        self.out_data_flow[current_last_writes[mem_reg]].add(current_node)
                # save write to calculate outgoing data flow
                for mem_reg in writes:
                    current_last_writes[mem_reg] = current_node

                # inline children
                for child in get_children(self.graph, current_node):
                    current_last_writes = inlined_data_flow_calculation(child, current_last_writes)

                # continue to successor
                successors = get_successors(self.graph, current_node)
                if len(successors) > 1:
                    raise ValueError("only a single successor should exist at this stage in the process!")

                elif len(successors) == 1:
                    current_node = successors[0]
                else:
                    current_node = None

            return current_last_writes

        # Note: at this point in time, the graph MUST NOT have branched sections
        for function_node in get_all_function_nodes(self.graph):
            if function_node not in self.experiment.hotspot_function_node_ids and len(self.experiment.hotspot_function_node_ids) > 0:
                print("SKIPPING NON-HOTSPOT FUNCTION: ", data_at(self.graph, function_node).name)
                continue

            try:
                last_writes: Dict[MemoryRegion, int] = dict()
                inlined_data_flow_calculation(get_children(self.graph, function_node)[0], last_writes)
            except ValueError:
                if self.experiment.arguments.verbose:
                    print("CDF: Function:", data_at(self.graph, function_node).name, "invalid due to graph construction errors. Skipping.")
                    show_function(self.graph, data_at(self.graph, function_node), show_dataflow=False, show_mutex_edges=False)
                self.invalid_functions.add(function_node)

        for key in self.out_data_flow:
            for entry in self.out_data_flow[key]:
                if not self.graph.has_edge(key, entry):
                    add_dataflow_edge(self.graph, key, entry)

    def __propagate_reads_and_writes(self):
        # initialize queue
        queue = [n for n in self.graph.nodes]

        while queue:
            current = queue.pop()
            current_data = data_at(self.graph, current)
            parents = get_all_parents(self.graph, current)
            queue += [p for p in parents if p not in queue]
            for p in parents:
                data_at(self.graph, p).written_memory_regions.update(current_data.written_memory_regions)
                data_at(self.graph, p).read_memory_regions.update(current_data.read_memory_regions)
