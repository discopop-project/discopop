from typing import List

from discopop_explorer.pattern_detectors.do_all_detector import DoAllInfo


def check_do_all_equivalence(do_alls_1: List[DoAllInfo], do_alls_2: List[DoAllInfo]) -> bool:
    # check both ways to ensure exactly the correct patterns have been identified
    for gold_pattern in do_alls_1:
        found = False
        for pattern in do_alls_2:
            if (
                gold_pattern.start_line == pattern.start_line
                and gold_pattern.end_line == pattern.end_line
                and gold_pattern.reduction == pattern.reduction
                and gold_pattern.shared == pattern.shared
                and gold_pattern.private == pattern.private
                and gold_pattern.first_private == pattern.first_private
                and gold_pattern.last_private == pattern.last_private
            ):
                found = True
                break
        if not found:
            return False
    for pattern in do_alls_2:
        found = False
        for gold_pattern in do_alls_1:
            if (
                gold_pattern.start_line == pattern.start_line
                and gold_pattern.end_line == pattern.end_line
                and gold_pattern.reduction == pattern.reduction
                and gold_pattern.shared == pattern.shared
                and gold_pattern.private == pattern.private
                and gold_pattern.first_private == pattern.first_private
                and gold_pattern.last_private == pattern.last_private
            ):
                found = True
                break
        if not found:
            return False
    return True
