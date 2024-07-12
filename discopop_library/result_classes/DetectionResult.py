# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from ast import Dict
from typing import List, cast

import jsonpickle  # type: ignore

from discopop_explorer.PEGraphX import PEGraphX
from discopop_explorer.pattern_detectors.PatternBase import PatternBase
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo
from discopop_explorer.pattern_detectors.geometric_decomposition_detector import GDInfo
from discopop_explorer.pattern_detectors.pipeline_detector import PipelineInfo
from discopop_explorer.pattern_detectors.reduction_detector import ReductionInfo
from discopop_library.global_data.version.utils import get_version
from discopop_library.result_classes.PatternStorage import PatternStorage


class DetectionResult(object):
    version: str
    pet: PEGraphX
    patterns: PatternStorage

    def __init__(self, pet: PEGraphX):
        self.version = get_version()  # discopop version
        self.pet = pet
        self.patterns = PatternStorage()
        pass

    def __str__(self) -> str:
        result_str = ""
        for v in self.__dict__.values():
            if type(v) == PEGraphX:
                continue
            value_str = "\n\n\n"
            for entry in v:
                try:
                    value_str += str(entry) + "\n\n"
                except NotImplementedError:
                    value_str += entry.to_string(self.pet) + "\n\n"
            result_str += value_str
        return result_str

    def dump_to_pickled_json(self) -> str:
        """Encodes and returns the entire Object into a pickled json string.
        The encoded string can be reconstructed into an object by using:
        jsonpickle.decode(json_str)

        :return: encoded string
        """
        return cast(str, jsonpickle.encode(self))
