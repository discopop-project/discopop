# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List

from discopop_explorer.pattern_detectors.PatternBase import PatternBase
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.geometric_decomposition_detector import GDInfo
from discopop_explorer.pattern_detectors.pipeline_detector import PipelineInfo
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo


class PatternStorage(object):
    reduction: List[ReductionInfo]
    do_all: List[DoAllInfo]
    pipeline: List[PipelineInfo]
    geometric_decomposition: List[GDInfo]
    task: List[PatternInfo]
    simple_gpu: List[PatternInfo]
    combined_gpu: List[PatternInfo]
    optimizer_output: List[PatternBase]

    def __init__(self):
        self.optimizer_output = []
