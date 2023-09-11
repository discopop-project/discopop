# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import List

import jsonpickle  # type: ignore
from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.geometric_decomposition_detector import GDInfo
from discopop_explorer.pattern_detectors.pipeline_detector import PipelineInfo
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo


class DetectionResult(object):
    pet: PETGraphX
    reduction: List[ReductionInfo]
    do_all: List[DoAllInfo]
    pipeline: List[PipelineInfo]
    geometric_decomposition: List[GDInfo]
    task: List[PatternInfo]
    simple_gpu: List[PatternInfo]
    combined_gpu: List[PatternInfo]

    def __init__(self, pet: PETGraphX):
        self.pet = pet
        pass

    def __str__(self):
        result_str = ""
        for v in self.__dict__.values():
            if type(v) == PETGraphX:
                continue
            value_str = "\n\n\n"
            for entry in v:
                try:
                    value_str += str(entry) + "\n\n"
                except NotImplementedError:
                    value_str += entry.to_string(self.pet) + "\n\n"
            result_str += value_str
        return result_str

    def dump_to_pickled_json(self):
        """Encodes and returns the entire Object into a pickled json string.
        The encoded string can be reconstructed into an object by using:
        jsonpickle.decode(json_str)

        :return: encoded string
        """
        return jsonpickle.encode(self)
