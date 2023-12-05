# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, cast

from discopop_explorer.PEGraphX import PEGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.combined_gpu_patterns.CombinedGPURegions import (
    find_combined_gpu_regions,
)


def run_detection(pet: PEGraphX, res, project_folder_path: str) -> List[PatternInfo]:
    """Search for combined gpu patterns

    :param pet: PET graph
    :param res: DetectionResult object
    :return: List of detected pattern info
    """

    # construct Combined GPU Regions
    combined_gpu_regions = find_combined_gpu_regions(pet, res.simple_gpu, project_folder_path)

    return cast(List[PatternInfo], combined_gpu_regions)
