# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import json
from typing import Any, Dict, List
from discopop_explorer.PEGraphX import Node
from discopop_explorer.pattern_detectors.PatternBase import PatternBase

from discopop_library.PatternIdManagement.unique_pattern_id import get_unique_pattern_id
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.Update import Update, construct_update_from_dict
from discopop_library.discopop_optimizer.classes.system.devices.DeviceTypeEnum import DeviceTypeEnum
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


class MergedPattern(OptimizerOutputPattern):
    def __init__(self, node: Node, decisions: List[int], host_device_id: int, experiment: Experiment):
        OptimizerOutputPattern.__init__(self, node, decisions, host_device_id, experiment)
