# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, List, Tuple, Set

import networkx as nx  # type: ignore

from discopop_explorer.PETGraphX import PETGraphX, FunctionNode, EdgeType, LoopNode, CUNode, NodeID
from discopop_explorer.utils import calculate_workload
from discopop_library.OptimizationGraph.PETParser.DataAccesses.FromCUs import (
    get_data_accesses_for_cu,
)
from discopop_library.OptimizationGraph.classes.nodes.ContextMerge import ContextMerge
from discopop_library.OptimizationGraph.classes.nodes.ContextRestore import ContextRestore
from discopop_library.OptimizationGraph.classes.nodes.ContextSave import ContextSave
from discopop_library.OptimizationGraph.classes.nodes.ContextSnapshot import ContextSnapshot
from discopop_library.OptimizationGraph.classes.nodes.ContextSnapshotPop import ContextSnapshotPop
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.classes.nodes.Loop import Loop
from discopop_library.OptimizationGraph.classes.nodes.Workload import Workload
from discopop_library.OptimizationGraph.utilities.MOGUtilities import (
    data_at,
    get_successors,
    get_children,
    add_successor_edge,
    add_child_edge,
    add_temporary_edge,
    redirect_edge,
    convert_temporary_edges,
)


class PETParser(object):
    pet: PETGraphX
    graph: nx.DiGraph
    next_free_node_id: int
    cu_id_to_graph_node_id: Dict[NodeID, int]

    def __init__(self, pet: PETGraphX):
        self.pet = pet
        self.graph = nx.DiGraph()
        self.next_free_node_id = 0
        self.cu_id_to_graph_node_id = dict()

    def parse(self) -> Tuple[nx.DiGraph, int]:
        self.__add_cu_nodes()
        self.__add_functions()
        self.__add_pet_successor_edges()
        self.__add_loop_nodes()

        self.__parse_branched_sections()
        convert_temporary_edges(self.graph)

        return self.graph, self.next_free_node_id

    def get_new_node_id(self) -> int:
        """returns the next free node id and increments the counter"""
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

    def __parse_branched_sections(self):
        """Branched sections in the CU Graph are represented by a serialized version in the MOG.
        To make this possible, Context Snapshot, Restore and Merge points are added to allow a synchronization
        'between' the different branches"""
        visited_nodes: Set[int] = set()
        for function_node in self.pet.all_nodes(FunctionNode):
            _, _ = self.__parse_raw_node(
                self.cu_id_to_graph_node_id[function_node.id], visited_nodes
            )

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
        self.graph.add_node(context_snapshot_id, data=ContextSnapshot(context_snapshot_id))
        add_temporary_edge(self.graph, duplicate_node_id, context_snapshot_id)

        # Step 3: parse branches
        last_added_node_id = context_snapshot_id
        for successor in get_successors(self.graph, root_node_id):
            # Step 3.1: create and connect context restore node
            branch_context_restore_id = self.get_new_node_id()
            self.graph.add_node(
                branch_context_restore_id, data=ContextRestore(branch_context_restore_id)
            )
            add_temporary_edge(self.graph, last_added_node_id, branch_context_restore_id)

            # Step 3.2: parse branch
            branch_entry, branch_exit = self.__parse_raw_node(successor, visited_nodes)

            # Step 3.3: create context save node
            branch_context_save_id = self.get_new_node_id()
            self.graph.add_node(branch_context_save_id, data=ContextSave(branch_context_save_id))

            # Step 3.3: connect restore and save node to branch entry and exit
            add_temporary_edge(self.graph, branch_context_restore_id, branch_entry)
            add_temporary_edge(self.graph, branch_exit, branch_context_save_id)

            # update last_added_node_id
            last_added_node_id = branch_context_save_id

        # step 4: create and connect context merge node
        context_merge_node_id = self.get_new_node_id()
        self.graph.add_node(context_merge_node_id, data=ContextMerge(context_merge_node_id))
        add_temporary_edge(self.graph, last_added_node_id, context_merge_node_id)

        # Step 5: create and connect context snapshot pop
        context_snapshot_pop_id = self.get_new_node_id()
        self.graph.add_node(
            context_snapshot_pop_id, data=ContextSnapshotPop(context_snapshot_pop_id)
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
            written_memory_regions, read_memory_regions = get_data_accesses_for_cu(
                self.pet, cu_node.id
            )
            print("CUID: ", cu_node)
            print("\twritten: ", [str(e) for e in written_memory_regions])
            print("\tread: ", [str(e) for e in read_memory_regions])
            self.graph.add_node(
                new_node_id,
                data=Workload(
                    node_id=new_node_id,
                    cu_id=cu_node.id,
                    workload=calculate_workload(self.pet, cu_node),
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

            # create new node for Loop
            new_node_id = self.get_new_node_id()
            self.cu_id_to_graph_node_id[loop_node.id] = new_node_id
            self.graph.add_node(
                new_node_id,
                data=Loop(
                    node_id=new_node_id,
                    cu_id=loop_node.id,
                    workload=calculate_workload(self.pet, loop_node),
                    iterations=loop_node.loop_iterations,
                ),
            )
            # connect loop node and entry node via a child edge
            entry_node_cu_id = loop_node.get_entry_node(self.pet).id
            add_child_edge(self.graph, new_node_id, self.cu_id_to_graph_node_id[entry_node_cu_id])

            # redirect edges from outside the loop to the entry node to the Loop node
            for s, t, d in self.pet.in_edges(entry_node_cu_id, EdgeType.SUCCESSOR):
                if self.pet.node_at(s) not in loop_subtree:
                    redirect_edge(
                        self.graph,
                        old_source_id=self.cu_id_to_graph_node_id[s],
                        new_source_id=self.cu_id_to_graph_node_id[s],
                        old_target_id=self.cu_id_to_graph_node_id[entry_node_cu_id],
                        new_target_id=new_node_id,
                    )

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
                    node_id=new_node_id, cu_id=function_node.id, name=function_node.name
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
            for successor_cu_id in [
                t for s, t, d in self.pet.out_edges(cu_node.id, EdgeType.SUCCESSOR)
            ]:
                add_successor_edge(
                    self.graph,
                    self.cu_id_to_graph_node_id[cu_node.id],
                    self.cu_id_to_graph_node_id[successor_cu_id],
                )
