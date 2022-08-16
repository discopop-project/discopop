"""Source code differences

Usage:
    detect_file_modifications [--original_file <path>] [--modified_file <path>]

Options:
    --original_file=<path>               Path to original file
    --modified_file=<path>               Path to potentially modified file
    -h --help                   Show this screen
"""
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
    #line_mapping = get_line_mapping(original_file, modified_file)
    # new line mapping
    line_mapping = get_new_line_mapping(original_file, modified_file)

    profiling_required = get_profiling_necessity(original_file, modified_file)

    return line_mapping, profiling_required


def get_profiling_necessity(original_file: str, modified_file: str) -> bool:
    original = open(original_file, "r")
    original_file_line_numbers = range(1, len(original.readlines()) + 1)
    original.close()
    original = open(original_file, "r")
    original_path = os.path.realpath(original.name)
    modified = open(modified_file, "r")
    modified_path = os.path.realpath(modified.name)
    diff_lines = unified_diff(original.readlines(), modified.readlines(), fromfile=original_path, tofile=modified_path,
                              n=0)
    original.close()
    modified.close()

    modification_scopes: List[Tuple[str, str]] = []
    added_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_line_distance = -1
    added_line_distance = -1

    # read raw modifications from diff

    for line in diff_lines:
        line = line.replace("\n", "")
        if line.startswith("@@"):
            # get line numbers
            split_line = line.split(" ")
            start_line_original = split_line[1].replace("-", "")
            start_line_modified = split_line[2].replace("+", "")
            # ignore column numbers
            if "," in start_line_original:
                start_line_original = start_line_original[:start_line_original.index(",")]
            if "," in start_line_modified:
                start_line_modified = start_line_modified[:start_line_modified.index(",")]
            start_line_original = int(start_line_original)
            start_line_modified = int(start_line_modified)
            modification_scopes.append((start_line_original, start_line_modified))
            removed_lines_dict[(start_line_original, start_line_modified)] = []
            added_lines_dict[(start_line_original, start_line_modified)] = []
            removed_line_distance = -1
            added_line_distance = -1

        if line.startswith("-") and not line.startswith("---"):
            # line removed from original file
            removed_line_distance += 1
            removed_line_number = int(modification_scopes[-1][0]) + removed_line_distance
            removed_lines_dict[modification_scopes[-1]].append((removed_line_number, line[1:]))
        if line.startswith("+") and not line.startswith("+++"):
            # line added to original file
            added_line_distance += 1
            added_line_number = int(modification_scopes[-1][1]) + added_line_distance
            added_lines_dict[modification_scopes[-1]].append((added_line_number, line[1:]))

    # check whether all modifications targeted openmp pragmas
    # if not, profiling the code again is required

    profiling_required = False
    for dict_obj in [added_lines_dict, removed_lines_dict]:
        for key in dict_obj:
            ignore_next_entry = False
            for line_num, modification in dict_obj[key]:
                cleaned_modification = modification.replace(" ", "").replace("\t", "")
                if len(cleaned_modification) == 0:
                    ignore_next_entry = False
                    continue
                if "#pragma omp " in modification:
                    if modification.endswith("\\"):
                        ignore_next_entry = True
                    continue
                if ignore_next_entry:
                    if modification.endswith("\\"):
                        ignore_next_entry = True
                    else:
                        ignore_next_entry = False
                    continue
                if cleaned_modification in ["{", "}", "{}"]:
                    ignore_next_entry = False
                    continue
                profiling_required = True
                break

    # clean up line mapping
#    to_be_removed = []
#    for line in line_mapping:
#        if line_mapping[line] == line:
#            to_be_removed.append(line)
#    for line in to_be_removed:
#        del line_mapping[line]

    return profiling_required


def get_line_mapping(original_file: str, modified_file: str) -> Dict[int, int]:
    original = open(original_file, "r")
    original_file_line_numbers = range(1, len(original.readlines()) + 1)
    original.close()
    original = open(original_file, "r")
    original_path = os.path.realpath(original.name)
    modified = open(modified_file, "r")
    modified_path = os.path.realpath(modified.name)
    diff_lines = unified_diff(original.readlines(), modified.readlines(), fromfile=original_path, tofile=modified_path,
                              n=0)
    original.close()
    modified.close()

    modification_scopes: List[Tuple[str, str]] = []
    added_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_line_distance = -1
    added_line_distance = -1

    # read raw modifications from diff

    for line in diff_lines:
        line = line.replace("\n", "")
        if line.startswith("@@"):
            # get line numbers
            split_line = line.split(" ")
            start_line_original = split_line[1].replace("-", "")
            start_line_modified = split_line[2].replace("+", "")
            # ignore column numbers
            if "," in start_line_original:
                start_line_original = start_line_original[:start_line_original.index(",")]
            if "," in start_line_modified:
                start_line_modified = start_line_modified[:start_line_modified.index(",")]
            start_line_original = int(start_line_original)
            start_line_modified = int(start_line_modified)
            modification_scopes.append((start_line_original, start_line_modified))
            removed_lines_dict[(start_line_original, start_line_modified)] = []
            added_lines_dict[(start_line_original, start_line_modified)] = []
            removed_line_distance = -1
            added_line_distance = -1

        if line.startswith("-") and not line.startswith("---"):
            # line removed from original file
            removed_line_distance += 1
            removed_line_number = int(modification_scopes[-1][0]) + removed_line_distance
            removed_lines_dict[modification_scopes[-1]].append((removed_line_number, line[1:]))
        if line.startswith("+") and not line.startswith("+++"):
            # line added to original file
            added_line_distance += 1
            added_line_number = int(modification_scopes[-1][1]) + added_line_distance
            added_lines_dict[modification_scopes[-1]].append((added_line_number, line[1:]))

    # create line mapping and extract line mapping rules
    line_mapping: Dict[int, int] = dict()
    line_mapping_rules: List[Tuple[int, int]] = []  # (boundary line, difference )

    # gather add and removed lines information
    added_lines_after_dict = dict()
    for key in added_lines_dict:
        for entry in added_lines_dict[key]:
            if key[0] not in added_lines_after_dict:
                added_lines_after_dict[key[0]] = 0
            added_lines_after_dict[key[0]] += 1
    removed_lines_after_dict = dict()
    for key in removed_lines_dict:
        for entry in removed_lines_dict[key]:
            if key[0] - 1 not in removed_lines_after_dict:
                removed_lines_after_dict[key[0] - 1] = 0
            removed_lines_after_dict[key[0] - 1] -= 1

    # create line mapping rules based on added_lines_after_dict
    for line_num in sorted(added_lines_after_dict, reverse=True):
        line_mapping_rules.append((line_num, added_lines_after_dict[line_num]))
    # create line mapping rules based on removed_lines_after_dict
    for line_num in sorted(removed_lines_after_dict, reverse=True):
        line_mapping_rules.append((line_num, removed_lines_after_dict[line_num]))

    print("Line Mapping Rules")
    print(line_mapping_rules)

    # create line mapping rules based on cleaned information
    #    for key in added_lines_dict:
    #        for entry in added_lines_dict[key]:
    #            line_mapping_rules.append((entry[0], 1))  # add one line
    #    for key in removed_lines_dict:
    #        for entry in removed_lines_dict[key]:
    #            line_mapping_rules.append((entry[0], -1))  # remove one line

    # add lines of original file to line mapping
    for line_num in original_file_line_numbers:
        line_mapping[line_num] = line_num

    #    # add modification scopes to line mapping
    #    for mod_scope in modification_scopes:
    #        # line_mapping[mod_scope[0]] = mod_scope[1]
    #        line_mapping_rules.append((mod_scope[0]+1, mod_scope[1] - mod_scope[0]))

    # apply line mapping rules:
    for rule_boundary_line, rule_line_difference in line_mapping_rules:
        for line_num in line_mapping:
            # apply rule
            if rule_line_difference > 0:
                if line_num > rule_boundary_line:
                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference
            else:
                if line_num > rule_boundary_line:
                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference


# old implementation
#    for rule_boundary_line, rule_line_difference in line_mapping_rules:
#        for line_num in line_mapping:
#            # apply rule
#            if rule_line_difference > 0:
#                if line_mapping[line_num] > rule_boundary_line:
#                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference
#            else:
#                if line_mapping[line_num] > rule_boundary_line:
#                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference

# add removed and added lines to line mapping
    return line_mapping


def get_new_line_mapping(original_file: str, modified_file: str) -> Dict[int, int]:
    import os
    stream = os.popen("diff --old-line-format='-$$$ %L\n' --new-line-format='+$$$ %L\n' --unchanged-line-format='|$$$ %L\n' " + original_file + " " + modified_file)
    # $$$ used to identify the amount of operations per line
    output_lines = stream.readlines()

    line_mapping: Dict[int, int] = dict()
    original_line_num = 1
    current_offset = 0

    for line in output_lines:
        line = line.replace("\n", "")
        if len(line) == 0:  # empty lines required to split old and new line in case of modifications
            continue
        print(original_line_num, "\t", current_offset, "\t", line)
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

    # clean up line mapping
    to_be_removed = []
    for line in line_mapping:
        if line_mapping[line] == line:
            to_be_removed.append(line)
    for line in to_be_removed:
        del line_mapping[line]

    return line_mapping


if __name__ == "__main__":
    main()


