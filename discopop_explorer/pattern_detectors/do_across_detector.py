# Detect all of the data races
from ..PETGraphX import *
from ..utils import classify_loop_variables

class DoAcrossInfo(object):
    """Class, that contains do-all detection result
    """

    def __init__(self, pet:PETGraphX, loop_node:CUNode, node: CUNode):
        """
        :param pet: PET graph
        :param loop_node: loop node, where do-across was detected
        :param node: node, where do-across was detected
        """
        fp, p, lp, s, r = classify_loop_variables(pet, loop_node)
        self.first_private = fp
        self.private = p
        self.last_private = lp
        self.shared = s
        self.reduction = r
        self.lnode = loop_node
        self.node = node

    def __str__(self):
        return f'Doacross loop at: {self.lnode.id}\n'\
               f'Start line: {self.lnode.file_id}:{self.lnode.start_line}\n'\
               f'End line: {self.lnode.file_id}:{self.lnode.end_line}\n'\
               f'pragma: "pragma omp parallel for ordered"\n'\
               f'Ordered directive pragma: "pragma omp ordered"\n'\
               f'Ordered directive line: {self.node.start_line} - {self.node.end_line}\n' \
               f'private: {[v.name for v in self.private]}\n' \
               f'shared: {[v.name for v in self.shared]}\n' \
               f'first private: {[v.name for v in self.first_private]}\n' \
               f'reduction: {[v.name for v in self.reduction]}\n' \
               f'last private: {[v.name for v in self.last_private]}'

def get_dep(pet: PETGraphX, source: CUNode, target: CUNode, root_loop: CUNode,
            children_cache: Dict[CUNode, List[CUNode]] = None,
            dep_cache: Dict[Tuple[CUNode, CUNode], Set[CUNode]] = None):
    dep_list = []
    raw = False

    if children_cache is not None:
        if target in children_cache:
            children = children_cache[target]
        else:
            children = pet.subtree_of_type(target, NodeType.CU)
            children_cache[target] = children
    else:
        children = pet.subtree_of_type(target, NodeType.CU)

    if dep_cache is not None:
        if (source, root_loop) in dep_cache:
            dependencies = dep_cache[(source, root_loop)]
        else:
            dependencies = pet.get_all_dependencies(source, root_loop)
            dep_cache[(source, root_loop)] = dependencies
    else:
        dependencies = pet.get_all_dependencies(source, root_loop)

    for dep in dependencies:
        if dep in children:
            dep_list.append(dep)
            raw = True

    return dep_list, raw

def __detect_do_across(pet:PETGraphX, root:CUNode):
    """Calculate do-across value for node
       :param pet: PET graph
       :param root: root node
       """

    subnodes = [pet.node_at(t) for s, t, d in pet.out_edges(root.id, EdgeType.CHILD)]
    for i in range (0, len(subnodes)):
        children_cache: Dict[CUNode, List[CUNode]] = dict()
        dependency_cache: Dict[Tuple[CUNode, CUNode], set[CUNode]] = dict()
        for j in range(i, len(subnodes)):
            dep_list, raw = get_dep(pet, subnodes[i], subnodes[j], root, children_cache=children_cache, dep_cache=dependency_cache)
            if raw:
                return dep_list, raw

    return None, False

def run_detection(pet:PETGraphX) -> List[DoAcrossInfo]:
    """Search for do-across loop pattern
       :param pet: PET graph
       :return: List of detected pattern info
       """

    result = []
    for node in pet.all_nodes(NodeType.LOOP):
        dep_list, raw = __detect_do_across(pet, node)
        if raw:
            node.do_across = True
            if not node.reduction and not node.do_all and node.loop_iterations > 0 and len(dep_list) > 0:
                for dep in dep_list:
                    result.append(DoAcrossInfo(pet, node, dep))

    return result