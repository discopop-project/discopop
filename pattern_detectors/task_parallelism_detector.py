from typing import List

from graph_tool import Vertex

import PETGraph
from pattern_detectors.PatternInfo import PatternInfo
from utils import find_subnodes, depends, calculate_workload, \
    total_instructions_count, classify_task_variables

__forks = set()
__workloadThreshold = 10000
__minParallelism = 3


class Task(object):
    """This class represents task in task parallelism pattern
    """
    nodes: List[Vertex]
    child_tasks: List['Task']
    start_line: str
    end_line: str

    def __init__(self, pet: PETGraph, node: Vertex):
        self.node_id = pet.graph.vp.id[node]
        self.nodes = [node]
        self.start_line = pet.graph.vp.startsAtLine[node]
        self.end_line = pet.graph.vp.endsAtLine[node]
        self.mw_type = pet.graph.vp.mwType[node]
        self.instruction_count = total_instructions_count(pet, node)
        self.workload = calculate_workload(pet, node)
        self.child_tasks = []

    def aggregate(self, other: 'Task'):
        """Aggregates given task into current task

        :param other: task to aggregate
        """
        self.nodes.extend(other.nodes)
        self.end_line = other.end_line
        self.workload += other.workload
        self.instruction_count += other.instruction_count
        self.mw_type = 'BARRIER_WORKER' if other.mw_type == 'BARRIER_WORKER' else 'WORKER'


def __merge_tasks(pet: PETGraph, task: Task):
    """Merges the tasks into having required workload.

    :param pet: PET graph
    :param task: task node
    """
    for i in range(len(task.child_tasks)):
        child_task: Task = task.child_tasks[i]
        if child_task.workload < __workloadThreshold:  # todo child child_tasks?
            if i > 0:
                pred: Task = task.child_tasks[i - 1]
                if __neighbours(pred, child_task):
                    pred.aggregate(child_task)
                    pred.child_tasks.remove(child_task)
                    __merge_tasks(pet, task)
                    return
            if i + 1 < len(task.child_tasks) - 1:  # todo off by one?, elif?
                succ: Task = task.child_tasks[i + 1]
                if __neighbours(child_task, succ):
                    child_task.aggregate(succ)  # todo odd aggregation in c++
                    task.child_tasks.remove(succ)
                    __merge_tasks(pet, task)
                    return
            task.child_tasks.remove(child_task)
            __merge_tasks(pet, task)
            return

    if task.child_tasks and len(task.child_tasks) < __minParallelism:
        max_workload_task = max(task.child_tasks, key=lambda t: t.workload)
        task.child_tasks.extend(max_workload_task.child_tasks)
        task.child_tasks.remove(max_workload_task)
        __merge_tasks(pet, task)
        return

    for child in task.child_tasks:
        if pet.graph.vp.type[child.nodes[0]] == 'loop':
            pass  # todo add loops?


def __neighbours(first: Task, second: Task):
    """Checks if second task immediately follows first task

    :param first: predecessor task
    :param second: successor task
    :return: true if second task immediately follows first task
    """
    fel = int(first.end_line.split(':')[1])
    ssl = int(second.start_line.split(':')[1])
    return fel == ssl or fel + 1 == ssl or fel + 2 == ssl


class TaskParallelismInfo(PatternInfo):
    """Class, that contains task parallelism detection result
    """

    def __init__(self, pet: PETGraph, node: Vertex):
        """
        :param pet: PET graph
        :param node: node, where task parallelism was detected
        """
        PatternInfo.__init__(self, pet, node)
        self.pragma = "INVALID"
        self.first_private = []
        self.private = []
        self.shared = []

    def __init__(self, pet: PETGraph, node: Vertex, pragma, first_private, private, shared):
        """
        :param pet: PET graph
        :param node: node, where task parallelism was detected
        :param pragma: pragma to be used (task / taskwait)
        :param first_private: list of varNames
        :param private: list of varNames
        :param shared: list of varNames
        """
        PatternInfo.__init__(self, pet, node)
        self.pragma = pragma
        self.first_private = first_private
        self.private = private
        self.shared = shared

    def __str__(self):
        return f'Task parallelism at: {self.node_id}\n' \
               f'Start line: {self.start_line}\n' \
               f'End line: {self.end_line}\n' \
               f'pragma: "#pragma omp {" ".join(self.pragma)}"\n' \
               f'first_private: {" ".join(self.first_private)}\n' \
               f'private: {" ".join(self.private)}\n' \
               f'shared: {" ".join(self.shared)}'


def run_detection(pet: PETGraph) -> List[TaskParallelismInfo]:
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

        :param pet: PET graph
        :return: List of detected pattern info
    """
    result = []

    for node in pet.graph.vertices():
        if pet.graph.vp.type[node] == 'dummy':
            continue
        if find_subnodes(pet, node, 'child'):
            # print(graph.vp.id[node])
            __detect_task_parallelism(pet, node)

        if pet.graph.vp.mwType[node] == 'NONE':
            pet.graph.vp.mwType[node] = 'ROOT'

    __forks.clear()
    __create_task_tree(pet, pet.main)

    # ct = [graph.vp.id[v] for v in pet.graph.vp.childrenTasks[main_node]]
    # ctt = [graph.vp.id[v] for v in forks]
    fs = [f for f in __forks if f.node_id == '130:0']
    for fork in fs:
        # todo __merge_tasks(graph, fork)
        if fork.child_tasks:
            result.append(TaskParallelismInfo(pet, fork.nodes[0]))

    result = result + __test_suggestions(pet)

    return result


def __test_suggestions(pet: PETGraph):
    """creates task parallelism suggestions and returns them as a list of
    TaskParallelismInfo objects.
    Currently relies on previous processing steps and suggests WORKER CUs
    as Tasks and BARRIER/BARRIER_WORKER as Taskwaits.

    :param pet: PET graph
    :return List[TaskParallelismInfo]
    """
    # TODO replace / merge with __detect_task_parallelism

    # read RAW vars from CUInstResult
    # get function scopes -> make suggestions only inside scopes -> no start / end
    # get modifier for each RAW Var
    # get source line for OMP suggestion

    # suggestions contains a map from LID to a set of suggestions. This is required to
    # detect multiple suggestions for a single line of source code.
    suggestions = dict()  # LID -> set<list<set<string>>>
    # list[0] -> task / taskwait
    # list[1] -> first_private Clause
    # list[2] -> private clause
    # list[3] -> shared clause

    # omp_suggestions = ""

    for it in pet.graph.vertices():
        current_suggestions = [[], [], [], []]

        # only include cu and func nodes
        if not ('func' in pet.graph.vp.type[it] or "cu" in pet.graph.vp.type[it]):
            continue

        if pet.graph.vp.mwType[it] == "WORKER":
            # suggest task
            first_private_vars = []
            private_vars = []
            last_private_vars = []
            shared_vars = []
            depend_in_vars = []
            depend_out_vars = []
            depend_in_out_vars = []
            reduction_vars = []
            in_deps = []
            out_deps = []
            classify_task_variables(pet, it, "", first_private_vars, private_vars,
                                    shared_vars, depend_in_vars, depend_out_vars,
                                    depend_in_out_vars, reduction_vars,
                                    in_deps, out_deps)
            # suggest task
            current_suggestions[0].append("task")
            for vid in first_private_vars:
                current_suggestions[1].append(vid.name)
            for vid in private_vars:
                current_suggestions[2].append(vid.name)
            for vid in shared_vars:
                current_suggestions[3].append(vid.name)

        if pet.graph.vp.mwType[it] == "BARRIER":
            current_suggestions[0].append("taskwait")

        if pet.graph.vp.mwType[it] == "BARRIER_WORKER":
            current_suggestions[0].append("taskwait")

        # insert current_suggestions into suggestions
        # check, if current_suggestions contains an element
        if len(current_suggestions[0]) >= 1:
            # current_suggestions contains something
            if not pet.graph.vp.startsAtLine[it] in suggestions:
                # LID not contained in suggestions
                tmp_set = []
                suggestions[it] = tmp_set
                suggestions[it].append(current_suggestions)
            else:
                # LID already contained in suggestions
                suggestions[it].append(current_suggestions)
    # end of for loop

    # construct return value (list of TaskParallelismInfo)
    result = []
    for it in suggestions:
        for single_suggestions in suggestions[it]:
            pragma = single_suggestions[0]
            first_private = single_suggestions[1]
            private = single_suggestions[2]
            shared = single_suggestions[3]
            result.append(TaskParallelismInfo(pet, it, pragma, first_private, private, shared))

    print("#### DEBUG VERSION!!! ONLY WORKERS SUGGESTED AS TASKS! ####")
    return result


def __detect_task_parallelism(pet: PETGraph, main_node: Vertex):
    """The mainNode we want to compute the Task Parallelism Pattern for it
    use Breadth First Search (BFS) to detect all barriers and workers.
    1.) all child nodes become first worker if they are not marked as worker before
    2.) if a child has dependence to more than one parent node, it will be marked as barrier
    Returns list of BARRIER_WORKER pairs 2
    :param pet: PET graph
    :param main_node: root node
    """

    # first insert all the direct children of main node in a queue to use it for the BFS
    for node in find_subnodes(pet, main_node, 'child'):
        # a child node can be set to NONE or ROOT due a former detectMWNode call where it was the mainNode
        if pet.graph.vp.mwType[node] == 'NONE' or pet.graph.vp.mwType[node] == 'ROOT':
            pet.graph.vp.mwType[node] = 'FORK'

        # while using the node as the base child, we copy all the other children in a copy vector.
        # we do that because it could be possible that two children of the current node (two dependency)
        # point to two different children of another child node which results that the child node becomes BARRIER
        # instead of WORKER
        # so we copy the whole other children in another vector and when one of the children of the current node
        # does point to the other child node, we just adjust mwType and then we remove the node from the vector
        # Thus we prevent changing to BARRIER due of two dependencies pointing to two different children of
        # the other node

        # create the copy vector so that it only contains the other nodes
        other_nodes = find_subnodes(pet, main_node, 'child')
        other_nodes.remove(node)

        for other_node in other_nodes:
            if depends(pet, other_node, node):
                # print("\t" + pet.graph.vp.id[node] + "<--" + pet.graph.vp.id[other_node])
                if pet.graph.vp.mwType[other_node] == 'WORKER':
                    pet.graph.vp.mwType[other_node] = 'BARRIER'
                else:
                    pet.graph.vp.mwType[other_node] = 'WORKER'

    pairs = []
    # check for Barrier Worker pairs
    # if two barriers don't have any dependency to each other then they create a barrierWorker pair
    # so check every barrier pair that they don't have a dependency to each other -> barrierWorker
    direct_subnodes = find_subnodes(pet, main_node, 'child')
    for n1 in direct_subnodes:
        if pet.graph.vp.mwType[n1] == 'BARRIER':
            for n2 in direct_subnodes:
                if pet.graph.vp.mwType[n2] == 'BARRIER' and n1 != n2:
                    if n2 in [e.target() for e in n1.out_edges()] or n2 in [e.source() for e in n1.in_edges()]:
                        break
                    # so these two nodes are BarrierWorker, because there is no dependency between them
                    pairs.append((n1, n2))
                    pet.graph.vp.mwType[n1] = 'BARRIER_WORKER'
                    pet.graph.vp.mwType[n2] = 'BARRIER_WORKER'

    # return pairs


def __create_task_tree(pet: PETGraph, root: Vertex):
    """generates task tree data from root node

    :param pet: PET graph
    :param root: root node
    """
    root_task = Task(pet, root)
    __forks.add(root_task)
    __create_task_tree_helper(pet, root, root_task, [])


def __create_task_tree_helper(pet: PETGraph, current: Vertex, root: Task, visited_func: List[Vertex]):
    """generates task tree data recursively

    :param pet: PET graph
    :param current: current vertex to process
    :param root: root task for subtree
    :param visited_func: visited function nodes
    """
    if pet.graph.vp.type[current] == 'func':
        if current in visited_func:
            return
        else:
            visited_func.append(current)

    for child in find_subnodes(pet, current, 'child'):
        mw_type = pet.graph.vp.mwType[child]

        if mw_type in ['BARRIER', 'BARRIER_WORKER', 'WORKER']:
            task = Task(pet, child)
            root.child_tasks.append(task)
            __create_task_tree_helper(pet, child, task, visited_func)
        elif mw_type == 'FORK' and not pet.graph.vp.startsAtLine[child].endswith('16383'):
            task = Task(pet, child)
            __forks.add(task)
            __create_task_tree_helper(pet, child, task, visited_func)
        else:
            __create_task_tree_helper(pet, child, root, visited_func)
