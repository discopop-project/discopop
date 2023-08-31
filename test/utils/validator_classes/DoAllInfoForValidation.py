from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo


class DoAllInfoForValidation(object):
    dai: DoAllInfo

    def __init__(self, do_all_info: DoAllInfo):
        self.dai = do_all_info

    def __eq__(self, other):
        if (
            self.dai.start_line == other.dai.start_line
            and self.dai.end_line == other.dai.end_line
            and self.dai.reduction == other.dai.reduction
            and self.dai.shared == other.dai.shared
            and self.dai.private == other.dai.private
            and self.dai.first_private == other.dai.first_private
            and self.dai.last_private == other.dai.last_private
        ):
            return True
        return False
