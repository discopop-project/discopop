# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Tuple

from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.classes.system.devices.DeviceTypeEnum import DeviceTypeEnum


class GPU(Device):
    def __init__(self, frequency, thread_count, openmp_device_id, device_specific_compiler_flags, speedup: float):
        super().__init__(frequency, thread_count, openmp_device_id, device_specific_compiler_flags, speedup)

    def get_device_specific_pattern_info(
        self, suggestion: PatternInfo, suggestion_type: str
    ) -> Tuple[PatternInfo, str]:
        return suggestion, "gpu_" + suggestion_type

    def get_device_type(self) -> DeviceTypeEnum:
        return DeviceTypeEnum.GPU
