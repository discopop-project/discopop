from typing import Tuple

from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_explorer.pattern_detectors.PatternInfo import PatternInfo


class GPU(Device):
    def __init__(self, compute_capability, thread_count):
        super().__init__(compute_capability, thread_count)

    def get_device_specific_pattern_info(
        self, suggestion: PatternInfo, suggestion_type: str
    ) -> Tuple[PatternInfo, str]:
        return suggestion, "gpu_" + suggestion_type
