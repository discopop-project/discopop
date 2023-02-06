from typing import List


def get_contained_lines(start_line: str, end_line: str) -> List[str]:
    """Returns a list of line numbers inbetween start_line and end_line"""
    file_id = start_line.split(":")[0]
    if file_id != end_line.split(":")[0]:
        raise ValueError("File-ids not equal! ", start_line, end_line)
    line_numbers: List[int] = list(
        range(int(start_line.split(":")[1]), int(end_line.split(":")[1]) + 1)
    )
    result = [file_id + ":" + str(num) for num in line_numbers]
    return result
