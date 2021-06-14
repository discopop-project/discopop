from typing import List, Tuple, Dict

from ..interfaces.BBGraph import BBNode
from ..vc_data_race_detector.schedule import Schedule


def create_schedules(sections_to_path_combinations_dict: Dict[int, List[List[List[BBNode]]]]) -> Dict[int, List[Schedule]]:
    """creates a mapping from sections to list of schedules to be checked based on the extracted behavior."""
    pass