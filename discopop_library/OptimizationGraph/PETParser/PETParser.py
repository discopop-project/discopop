import networkx as nx  # type: ignore

from discopop_explorer.PETGraphX import PETGraphX, FunctionNode, Node
from discopop_library.OptimizationGraph.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.OptimizationGraph.classes.nodes.GenericNode import GenericNode


class PETParser(object):
    pet: PETGraphX
    graph: nx.DiGraph
    next_free_node_id: int

    def __init__(self, pet: PETGraphX):
        self.pet = pet
        self.graph = nx.DiGraph()
        self.next_free_node_id = 0

    def parse(self) -> nx.DiGraph:
        self.__parse_functions()
        return self.graph

    def get_new_node_id(self)->int:
        """returns the next free node id and increments the counter"""
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

    def __parse_functions(self):
        """parse function nodes in the PET graph.
        Results in the creation of a forest of function graphs."""
        for function_node in self.pet.all_nodes(FunctionNode):
            # create function root node and register it in the graph
            new_node_id = self.get_new_node_id()
            self.graph.add_node(new_node_id, data=FunctionRoot(node_id=new_node_id, name=function_node.name))
            self.__parse_node(self.pet.node_at(function_node.get_entry_cu_id(self.pet)), new_node_id)


    def __parse_node(self, node: Node, connect_to_og_node_id: int):
        """Determine the type of the given PET node and parse it accordingly.
        Connect the representation of the current node to the given og_node_id to create the linearized representation
        of the PET graph."""
        print("parsing: ", node.node_id)



