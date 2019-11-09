from graph_tool import Vertex, Graph

from utils import find_subnodes, depends

forks = set()
workloadThreshold = 10000
minParallelism = 3

def merge_tasks(graph: Graph, fork: Vertex):
    pass


def run_detection(graph: Graph):
    """computes the Task Parallelism Pattern for a node:
    (Automatic Parallel Pattern Detection in the Algorithm Structure Design Space p.46)
    1.) first merge all children of the node -> all children nodes get the dependencies
        of their children nodes and the list of the children nodes (saved in node.childrenNodes)
    2.) To detect Task Parallelism, we use Breadth First Search (BFS)
        a.) the hotspot becomes a fork
        b.) all child nodes become first worker if they are not marked as worker before
        c.) if a child has dependence to more than one parent node, it will be marked as barrier
    3.) if two barriers can run in parallel they are marked as barrierWorkers.
        Two barriers can run in parallel if there is not a directed path from one to the other
    """
    for node in graph.vertices():
        if graph.vp.type[node] == '3':
            continue
        if find_subnodes(graph, node, 'child'):
            # print(graph.vp.id[node])
            detect_task_parallelism(graph, node)

        if graph.vp.mwType[node] == 'NONE':
            graph.vp.mwType[node] = 'ROOT'

    main_node = None
    for node in graph.vertices():
        if graph.vp.name[node] == 'main':
            main_node = node
            break

    forks.clear()
    create_task_tree(graph, main_node)

    # ct = [graph.vp.id[v] for v in graph.vp.childrenTasks[main_node]]
    # ctt = [graph.vp.id[v] for v in forks]

    for fork in forks:
        merge_tasks(graph, fork)
    #    if fork.children_nodes:
    #       print("Task Parallelism")
    #        print("start line:", graph.vp.startsAtLine[fork.children_nodes[0]], "end line:",
    #             graph.vp.endsAtLine[fork.children_nodes[-1]])

    # for node in graph.vertices():
    # if graph.vp.type[node] != '3':
    # print(graph.vp.id[node] + ' ' + graph.vp.mwType[node])


def detect_task_parallelism(graph: Graph, main_node: Vertex):
    """The mainNode we want to compute the Task Parallelism Pattern for it
    use Breadth First Search (BFS) to detect all barriers and workers.
    1.) all child nodes become first worker if they are not marked as worker before
    2.) if a child has dependence to more than one parent node, it will be marked as barrier
    Returns list of BARRIER_WORKER pairs 2
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

    return pairs


def create_task_tree(graph: Graph, root: Vertex):
    forks.add(root)
    # TODO create task and save
    create_task_tree_helper(graph, root, root, [])


def create_task_tree_helper(graph: Graph, current, root, visited_func):
    if graph.vp.type[current] == '1':
        if current in visited_func:
            return
        else:
            visited_func.append(current)

    for child in find_subnodes(graph, root, 'child'):
        mw_type = graph.vp.mwType[child]

        if mw_type in ['BARRIER', 'BARRIER_WORKER', 'WORKER', 'FORK']:
            # TODO create task and save
            if mw_type == 'FORK' and not graph.vp.startsAtLine[child].endswith('16383'):
                forks.add(child)
            else:
                graph.vp.childrenTasks[root].add(child)
            create_task_tree_helper(graph, child, child, visited_func)
        else:
            create_task_tree_helper(graph, child, root, visited_func)
