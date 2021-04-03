from typing import List, Optional

from discopop_explorer.PETGraphX import CUNode, MWType, PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.utils import total_instructions_count, calculate_workload


class Task(object):
    """This class represents task in task parallelism pattern
    """
    nodes: List[CUNode]
    child_tasks: List['Task']
    start_line: str
    end_line: str

    def __init__(self, pet: PETGraphX, node: CUNode):
        self.node_id = node.id
        self.nodes = [node]
        self.start_line = node.start_position()
        if ":" in self.start_line:
            self.region_start_line = self.start_line[self.start_line.index(":") + 1:]
        else:
            self.region_start_line = self.start_line
        self.region_end_line = None
        self.end_line = node.end_position()
        self.mw_type = node.mw_type
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
        self.mw_type = MWType.BARRIER_WORKER if other.mw_type == MWType.BARRIER_WORKER else MWType.WORKER


class TaskParallelismInfo(PatternInfo):
    """Class, that contains task parallelism detection result
    """

    def __init__(self, node: CUNode, pragma, pragma_line, first_private, private, shared):
        """
        :param node: node, where task parallelism was detected
        :param pragma: pragma to be used (task / taskwait)
        :param pragma_line: line prior to which the pragma shall be inserted
        :param first_private: list of varNames
        :param private: list of varNames
        :param shared: list of varNames
        """
        PatternInfo.__init__(self, node)
        self.pragma = pragma
        self.pragma_line = pragma_line
        if ":" in self.pragma_line:
            self.region_start_line = self.pragma_line[self.pragma_line.index(":") + 1:]
        else:
            self.region_start_line = self.pragma_line
        self.region_end_line: Optional[str] = None
        self.first_private = first_private
        self.private = private
        self.shared = shared
        self.in_dep: List[str] = []
        self.out_dep: List[str] = []
        self.in_out_dep: List[str] = []
        self.critical_sections: List[str] = []
        self.atomic_sections: List[str] = []
        self.task_group: List[int] = []

    def __str__(self):
        return f'Task parallelism at CU: {self.node_id}\n' \
               f'CU Start line: {self.start_line}\n' \
               f'CU End line: {self.end_line}\n' \
               f'pragma at line: {self.pragma_line}\n' \
               f'pragma region start line: {self.region_start_line}\n' \
               f'pragma region end line: {self.region_end_line}\n' \
               f'pragma: "#pragma omp {" ".join(self.pragma)}"\n' \
               f'first_private: {" ".join(self.first_private)}\n' \
               f'private: {" ".join(self.private)}\n' \
               f'shared: {" ".join(self.shared)}\n' \
               f'in_dep: {" ".join(self.in_dep)}\n' \
               f'out_dep: {" ".join(self.out_dep)}\n' \
               f'in_out_dep: {" ".join(self.in_out_dep)}\n' \
               f'critical_sections: {" ".join(self.critical_sections)}\n' \
               f'atomic_sections: {" ".join(self.atomic_sections)}\n' \
               f'task_group: {" ".join([str(e) for e in self.task_group])}\n'


class ParallelRegionInfo(PatternInfo):
    """Class, that contains parallel region info.
    """

    def __init__(self, node: CUNode,
                 region_start_line, region_end_line):
        PatternInfo.__init__(self, node)
        self.region_start_line = region_start_line
        self.region_end_line = region_end_line
        self.pragma = "#pragma omp parallel\n\t#pragma omp single"

    def __str__(self):
        return f'Task Parallel Region at CU: {self.node_id}\n' \
               f'CU Start line: {self.start_line}\n' \
               f'CU End line: {self.end_line}\n' \
               f'pragma: \n\t{self.pragma}\n' \
               f'Parallel Region Start line: {self.region_start_line}\n' \
               f'Parallel Region End line {self.region_end_line}\n'


class OmittableCuInfo(PatternInfo):
    """Class, that contains information on omittable CUs (such that can be
    combined with a suggested task).
    Objects of this type are only intermediate and will not show up in the
    final suggestions.
    """

    def __init__(self, node: CUNode, combine_with_node: CUNode):
        PatternInfo.__init__(self, node)
        self.combine_with_node = combine_with_node
        # only for printing
        self.cwn_id = combine_with_node.id
        self.in_dep: List[Optional[str]] = []
        self.out_dep: List[Optional[str]] = []
        self.in_out_dep: List[Optional[str]] = []

    def __str__(self):
        return f'Omittable CU: {self.node_id}\n' \
               f'CU Start line: {self.start_line}\n' \
               f'CU End line: {self.end_line}\n' \
               f'Combinable with: {self.cwn_id}\n' \
               f'in_dep: {" ".join(self.in_dep)}\n' \
               f'out_dep: {" ".join(self.out_dep)}\n' \
               f'in_out_dep: {" ".join(self.in_out_dep)}\n'