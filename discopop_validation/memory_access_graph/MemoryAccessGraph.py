import os.path

import matplotlib.pyplot as plt  # type: ignore
import networkx as nx  # type: ignore
from graphviz import Source  # type: ignore
from networkx.drawing.nx_pydot import to_pydot  # type: ignore
from typing import List

from discopop_validation.data_race_prediction.task_graph.classes.TaskGraph import TaskGraph
from discopop_validation.memory_access_graph.ParallelFrame import ParallelFrame


class MemoryAccessGraph(object):
    graph: nx.MultiDiGraph
    next_free_parallel_frame_id: int

    def __init__(self, task_graph: TaskGraph):
        self.next_free_parallel_frame_id = 0
        self.graph = nx.MultiDiGraph()
        self.__construct_from_task_graph(task_graph)

    def __get_new_parallel_frame_id(self) -> int:
        buffer = self.next_free_parallel_frame_id
        self.next_free_parallel_frame_id += 1
        return buffer

    def plot_graph(self):
        dot_file_path = "/home/lukas/tmp.dot"
        if os.path.exists(dot_file_path):
            os.remove(dot_file_path)

        dot_g = to_pydot(self.graph)
        print(dot_g)
        dot_g.write_dot(dot_file_path)
        s = Source.from_file(dot_file_path)
        s.view()
        os.remove(dot_file_path)

    def __construct_from_task_graph(self, task_graph: TaskGraph):
        current_node = task_graph.graph.nodes[0]["data"]  # root node of task_graph
        task_graph.plot_graph()
        # self.plot_graph()

        # identify parallel frames
        parallel_frames = self.__identify_parallel_frames(task_graph)

    def __identify_parallel_frames(self, task_graph) -> List[ParallelFrame]:
        """identifies and returns a list of parallel frames."""
