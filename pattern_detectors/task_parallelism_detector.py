from typing import List

from graph_tool import Vertex, Graph

from utils import find_subnodes, depends, find_main_node

__forks = set()
__workloadThreshold = 10000
__minParallelism = 3


def __merge_tasks(graph: Graph, fork: Vertex):
    """Merges the tasks into having required workload.

    :param graph: CU graph
    :param fork: task node
    """
    pass


class TaskParallelismInfo(object):
    """Class, that contains task parallelism detection result
    """
    node: Vertex
    node_id: str
    start_line: str
    end_line: str

    def __init__(self, graph: Graph, node: Vertex):
        """
        :param graph: CU graph
        :param node: node, where task parallelism was detected
        """
        self.node = node
        self.node_id = graph.vp.id[node]
        self.start_line = graph.vp.startsAtLine[node]
        self.end_line = graph.vp.endsAtLine[node]

    def __str__(self):
        return f'Task parallelism at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}'


def run_detection(graph: Graph) -> List[TaskParallelismInfo]:
    """Computes the Task Parallelism Pattern for a node:
    (Automatic Parallel Pattern Detection in the Algorithm Structure Design Space p.46)
    1.) first merge all children of the node -> all children nodes get the dependencies
        of their children nodes and the list of the children nodes (saved in node.childrenNodes)
    2.) To detect Task Parallelism, we use Breadth First Search (BFS)
        a.) the hotspot becomes a fork
        b.) all child nodes become first worker if they are not marked as worker before
        c.) if a child has dependence to more than one parent node, it will be marked as barrier
    3.) if two barriers can run in parallel they are marked as barrierWorkers.
        Two barriers can run in parallel if there is not a directed path from one to the other

        :param graph: CU graph
        :return: List of detected pattern info
    """
    result = []

    for node in graph.vertices():
        if graph.vp.type[node] == 'dummy':
            continue
        if find_subnodes(graph, node, 'child'):
            # print(graph.vp.id[node])
            __detect_task_parallelism(graph, node)

        if graph.vp.mwType[node] == 'NONE':
            graph.vp.mwType[node] = 'ROOT'

    __forks.clear()
    __create_task_tree(graph, find_main_node(graph))

    # ct = [graph.vp.id[v] for v in graph.vp.childrenTasks[main_node]]
    # ctt = [graph.vp.id[v] for v in forks]

    for fork in __forks:
        __merge_tasks(graph, fork)
    #    if fork.children_nodes:
    #       print("Task Parallelism")
    #        print("start line:", graph.vp.startsAtLine[fork.children_nodes[0]], "end line:",
    #             graph.vp.endsAtLine[fork.children_nodes[-1]])

    return result


def __detect_task_parallelism(graph: Graph, main_node: Vertex):
    """The mainNode we want to compute the Task Parallelism Pattern for it
    use Breadth First Search (BFS) to detect all barriers and workers.
    1.) all child nodes become first worker if they are not marked as worker before
    2.) if a child has dependence to more than one parent node, it will be marked as barrier
    Returns list of BARRIER_WORKER pairs 2
    :param graph: CU graph
    :param main_node: root node
    """

    # first insert all the direct children of main node in a queue to use it for the BFS
    for node in find_subnodes(graph, main_node, 'child'):
        # a child node can be set to NONE or ROOT due a former detectMWNode call where it was the mainNode
        if graph.vp.mwType[node] == 'NONE' or graph.vp.mwType[node] == 'ROOT':
            graph.vp.mwType[node] = 'FORK'

        # while using the node as the base child, we copy all the other children in a copy vector.
        # we do that because it could be possible that two children of the current node (two dependency)
        # point to two different children of another child node which results that the childnode becomes BARRIER
        # instead of WORKER
        # so we copy the whole other children in another vector and when one of the children of the current node
        # does point to the other child node, we just adjust mwType and then we remove the node from the vector
        # Thus we prevent changing to BARRIER due of two dependencies pointing to two different children of
        # the other node

        # create the copy vector so that it only contains the other nodes
        other_nodes = find_subnodes(graph, main_node, 'child')
        other_nodes.remove(node)

        for other_node in other_nodes:
            if depends(graph, other_node, node):
                # print("\t" + graph.vp.id[node] + "<--" + graph.vp.id[other_node])
                if graph.vp.mwType[other_node] == 'WORKER':
                    graph.vp.mwType[other_node] = 'BARRIER'
                else:
                    graph.vp.mwType[other_node] = 'WORKER'

    pairs = []
    # check for Barrier Worker pairs
    # if two barriers don't have any dependency to each other then they create a barrierWorker pair
    # so check every barrier pair that they don't have a dependency to each other -> barrierWorker
    direct_subnodes = find_subnodes(graph, main_node, 'child')
    for n1 in direct_subnodes:
        if graph.vp.mwType[n1] == 'BARRIER':
            for n2 in direct_subnodes:
                if graph.vp.mwType[n2] == 'BARRIER' and n1 != n2:
                    if n2 in [e.target() for e in n1.out_edges()] or n2 in [e.source() for e in n1.in_edges()]:
                        break
                    # so these two nodes are BarrierWorker, because there is no dependency between them
                    pairs.append((n1, n2))
                    graph.vp.mwType[n1] = 'BARRIER_WORKER'
                    graph.vp.mwType[n2] = 'BARRIER_WORKER'

    # return pairs


def __create_task_tree(graph: Graph, root: Vertex):
    """generates task tree data from root node

    :param graph: CU graph
    :param root: root node
    """
    __forks.add(root)
    # TODO create task and save
    __create_task_tree_helper(graph, root, root, [])


def __create_task_tree_helper(graph: Graph, current: Vertex, root: Vertex, visited_func: List[Vertex]):
    """generates task tree data recursively

    :param graph: CU graph
    :param current: current vertex to process
    :param root: root of the subtree
    :param visited_func: visited function nodes
    """
    if graph.vp.type[current] == 'func':
        if current in visited_func:
            return
        else:
            visited_func.append(current)

    for child in find_subnodes(graph, root, 'child'):
        mw_type = graph.vp.mwType[child]

        if mw_type in ['BARRIER', 'BARRIER_WORKER', 'WORKER', 'FORK']:
            # TODO create task and save
            if mw_type == 'FORK' and not graph.vp.startsAtLine[child].endswith('16383'):
                __forks.add(child)
            else:
                graph.vp.childrenTasks[root].add(child)
            __create_task_tree_helper(graph, child, child, visited_func)
        else:
            __create_task_tree_helper(graph, child, root, visited_func)
