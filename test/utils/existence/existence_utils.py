from typing import Any, List


def check_patterns_for_FP(test_cls, pattern_type: str, expected_lines: List[str], patterns: List[Any]):
    """check if only expected patterns are found."""
    for pattern in patterns:
        msg = "Found unexpected " + pattern_type + " at line " + pattern.start_line
        #test_cls.assertTrue(pattern.start_line in expected_lines, msg)
        if pattern.start_line not in expected_lines:
            return False, msg
    return True, ""


def check_patterns_for_FN(test_cls, pattern_type: str, expected_lines: List[str], patterns: List[Any]):
    """check if expected patterns are overlooked."""
    for pattern in patterns:
        if pattern.start_line in expected_lines:
            expected_lines.remove(pattern.start_line)
    msg = "Overlooked expected " + pattern_type + " patterns at lines " + str(expected_lines)
    #test_cls.assertTrue(len(expected_lines) == 0 , msg)
    if len(expected_lines) == 0:
        return True, ""
    return False, msg

        
