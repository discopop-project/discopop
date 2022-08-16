"""Source code differences

Usage:
    detect_file_modifications [--original_file <path>] [--modified_file <path>]

Options:
    --original_file=<path>               Path to original file
    --modified_file=<path>               Path to potentially modified file
    -h --help                   Show this screen
"""
import copy
import os
import subprocess
import sys
from difflib import unified_diff
from typing import Tuple, List, Dict

from docopt import docopt
from schema import SchemaError, Schema, Use  # type: ignore
from termcolor import colored


docopt_schema = Schema({
    '--original_file': Use(str),
    '--modified_file': Use(str),
})


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Argument handling."""
    arguments = docopt(__doc__)
    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    original_file = arguments["--original_file"]
    modified_file = arguments["--modified_file"]

    mapping, profiling_required = file_difference_checker(original_file, modified_file)

    print("Line Mapping:")
    for line_num in mapping:
        if line_num != mapping[line_num]:
            print(colored(str(line_num) + "  ->  " + str(mapping[line_num]), 'green', attrs=["bold"]))
        else:
            print(str(line_num) + "  ->  " + str(mapping[line_num]))
    print("Profiling required:")
    print(profiling_required)


def file_difference_checker(original_file: str, modified_file: str) -> Tuple[Dict[int, int], bool]:
    import os
    stream = os.popen(
        "diff --old-line-format='-$$$ %L\n' --new-line-format='+$$$ %L\n' --unchanged-line-format='|$$$ %L\n' " + original_file + " " + modified_file)
    # $$$ used to identify the amount of operations per line
    output_lines = stream.readlines()

    line_mapping: Dict[int, int] = dict()
    original_line_num = 1
    current_offset = 0
    profiling_required = False
    ignore_next_entry = False

    for line in output_lines:
        line = line.replace("\n", "")
        if len(line) == 0:
            continue
        update_line_mapping(copy.deepcopy(line), original_line_num, current_offset, line_mapping)
        cur_result, ignore_next_entry = get_profiling_necessity(copy.deepcopy(line), ignore_next_entry)
        profiling_required = profiling_required or cur_result

    # clean up line mapping
    to_be_removed = []
    for line in line_mapping:
        if line_mapping[line] == line:
            to_be_removed.append(line)
    for line in to_be_removed:
        del line_mapping[line]

    return line_mapping, profiling_required


def get_profiling_necessity(line: str, ignore_next_entry: bool) -> Tuple[bool, bool]:
    # check whether all modifications targeted openmp pragmas
    # if not, profiling the code again is required
    # if no modification has been done, skip line
    if "|$$$" in line:
        ignore_next_entry = False
        return False, ignore_next_entry
    cleaned_line = line.replace(" ", "").replace("\t", "").replace("|$$$", "").replace("+$$$","").replace("-$$$","")
    if len(cleaned_line) == 0:
        ignore_next_entry = False
        return False, ignore_next_entry
    if "#pragma omp " in line:
        if line.endswith("\\"):
            ignore_next_entry = True
        return False, ignore_next_entry
    if ignore_next_entry:
        if line.endswith("\\"):
            ignore_next_entry = True
        else:
            ignore_next_entry = False
        return False, ignore_next_entry
    if cleaned_line in ["{", "}", "{}"]:
        ignore_next_entry = False
        return False, ignore_next_entry
    return True, ignore_next_entry



def update_line_mapping(line: str, original_line_num: int, current_offset: int, line_mapping: Dict[int, int]):
    if len(line) == 0:  # empty lines required to split old and new line in case of modifications
        return
    # always write to line_mapping prior to modifying original_line_num

    # if line has been added, original_line_num is not increased as it was not present in the original code
    if line.startswith("|"):
        line_mapping[original_line_num] = original_line_num + current_offset
        original_line_num += 1

    # if line has been removed, decrease the current offset by one
    if line.startswith("-"):
        line_mapping[original_line_num] = -1
        current_offset -= 1
        original_line_num += 1

    # if line has been added, increase current offset by one
    if line.startswith("+"):
        current_offset += 1
    return


if __name__ == "__main__":
    main()


