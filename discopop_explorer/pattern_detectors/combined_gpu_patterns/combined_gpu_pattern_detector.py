from typing import List, cast

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.combined_gpu_patterns.CombinedGPURegions import (
    find_combined_gpu_regions,
)


def run_detection(pet: PETGraphX, res) -> List[PatternInfo]:
    """Search for combined gpu patterns

    :param pet: PET graph
    :param res: DetectionResult object
    :return: List of detected pattern info
    """

    # construct Combined GPU Regions
    combined_gpu_regions = find_combined_gpu_regions(pet, res.simple_gpu)

    return cast(List[PatternInfo], combined_gpu_regions)
