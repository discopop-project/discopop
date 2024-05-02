from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo


class DoAllInfoForValidation(object):
    dai: DoAllInfo

    def __init__(self, do_all_info: DoAllInfo):
        self.dai = do_all_info

    def __eq__(self, other):
        print("CHECK ")
        print(self)
        print("  against ")
        print(other)
        
        if (
            self.dai.start_line == other.dai.start_line
            and self.dai.end_line == other.dai.end_line
            and self.dai.reduction == other.dai.reduction
            and self.dai.shared == other.dai.shared
            and self.dai.private == other.dai.private
            and self.dai.first_private == other.dai.first_private
            and self.dai.last_private == other.dai.last_private
        ):
            print("  TRUE")
            print()
            return True
        print("  FALSE")
        print()
        return False

    def __str__(self):
        return_str = ""
        return_str += "start " + self.dai.start_line + "\n"
        return_str += "end " + self.dai.end_line + "\n"
        return_str += "r  " + str([r.name for r in self.dai.reduction]) + "\n"
        return_str += "s " + str([s.name for s in self.dai.shared]) + "\n"
        return_str += "p " + str([p.name for p in self.dai.private]) + "\n"
        return_str += "fp " + str([fp.name for fp in self.dai.first_private]) + "\n"
        return_str += "lp " + str([lp.name for lp in self.dai.last_private]) + "\n"

        return return_str