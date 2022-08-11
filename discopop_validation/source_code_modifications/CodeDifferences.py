"""Source code differences

Usage:
    detect_file_modifications [--original_file <path>] [--modified_file <path>]

Options:
    --original_file=<path>               Path to original file
    --modified_file=<path>               Path to potentially modified file
    -h --help                   Show this screen
"""
import os
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


    original = open(original_file, "r")
    original_file_line_numbers = range(1, len(open(original_file, "r").readlines()) + 1)
    print("line numbers: ", original_file_line_numbers)
    original_path = os.path.realpath(original.name)
    print("Last profiled file: ", original_path)
    modified = open(modified_file, "r")
    modified_path = os.path.realpath(modified.name)
    print("Modified file: ", modified_path)
    print()
    diff_lines = unified_diff(original.readlines(), modified.readlines(), fromfile=original_path, tofile=modified_path, n=0)

    modification_scopes: List[Tuple[str, str]] = []
    added_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    removed_line_distance = -1
    added_line_distance = -1

    # read raw modifications from diff

    for line in diff_lines:
        line = line.replace("\n", "")
        print(line)
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

    print()
    print("mod_scopes: ", modification_scopes)
    print("removed: ", removed_lines_dict)
    print("added:", added_lines_dict)
    print()
    # get clean lists of added, removed and modified lines and their contents
    clean_removed_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    clean_added_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str]]] = dict()
    clean_modified_lines_dict: Dict[Tuple[str, str], List[Tuple[int, str, str]]] = dict()

    # todo implement more efficiently

    # get clean modified
    if False:
        for key in added_lines_dict:
            remove_from_added_lines = []
            remove_from_removed_lines = []
            for added_line, added_pragma in added_lines_dict[key]:
                if key in removed_lines_dict:
                    for removed_line, removed_pragma in removed_lines_dict[key]:
                        if added_line == removed_line:
                            if key not in clean_modified_lines_dict:
                                clean_modified_lines_dict[key] = []
                            clean_modified_lines_dict[key].append((added_line, removed_pragma, added_pragma))
                            remove_from_added_lines.append((added_line, added_pragma))
                            remove_from_removed_lines.append((added_line, removed_pragma))
            for entry in remove_from_added_lines:
                added_lines_dict[key].remove(entry)
            for entry in remove_from_removed_lines:
                removed_lines_dict[key].remove(entry)

    # get clean removed
    for key in removed_lines_dict:
        for removed_line, pragma in removed_lines_dict[key]:
            if key not in added_lines_dict:
                if key not in clean_removed_lines_dict:
                    clean_removed_lines_dict[key] = []
                clean_removed_lines_dict[key].append((removed_line, pragma))
            else:
                added_lines = [added_line for added_line, added_pragma in added_lines_dict[key]]
                if removed_line not in added_lines:
                    if key not in clean_removed_lines_dict:
                        clean_removed_lines_dict[key] = []
                    clean_removed_lines_dict[key].append((removed_line, pragma))

    # get clean added
    for key in added_lines_dict:
        for added_line, pragma in added_lines_dict[key]:
            if key not in removed_lines_dict:
                if key not in clean_added_lines_dict:
                    clean_added_lines_dict = []
                clean_added_lines_dict[key].append((added_line, pragma))
            else:
                removed_lines = [removed_line for removed_line, removed_pragma in removed_lines_dict[key]]
                if added_line not in removed_lines:
                    if key not in clean_added_lines_dict:
                        clean_added_lines_dict[key] = []
                    clean_added_lines_dict[key].append((added_line, pragma))


    print("clean removed: ", clean_removed_lines_dict)
    print("clean added: ", clean_added_lines_dict)
    print("clean modified: ", clean_modified_lines_dict)
    print()

    # create line mapping and extract line mapping rules
    line_mapping: Dict[int, int] = dict()
    line_mapping_rules: List[Tuple[int, int]] = []  # (boundary line, difference )
    #line_mapping_rules: dict[int, int]  # [boundary_line: difference]

    # create line mapping rules based on cleaned information
    for key in added_lines_dict:
        for entry in added_lines_dict[key]:
            line_mapping_rules.append((entry[0], 1))  # add one line
    for key in removed_lines_dict:
        for entry in removed_lines_dict[key]:
            line_mapping_rules.append((entry[0], -1))  # remove one line

    print()

    # add lines of original file to line mapping
    for line_num in original_file_line_numbers:
        line_mapping[line_num] = line_num

#    # add modification scopes to line mapping
#    for mod_scope in modification_scopes:
#        # line_mapping[mod_scope[0]] = mod_scope[1]
#        line_mapping_rules.append((mod_scope[0]+1, mod_scope[1] - mod_scope[0]))

    print("Line Mapping Rules:")
    print(line_mapping_rules)
    print()

    # apply line mapping rules:
    for rule_boundary_line, rule_line_difference in line_mapping_rules:
        print("RULE: ", rule_boundary_line, rule_line_difference)
        for line_num in line_mapping:
            # apply rule
            if rule_line_difference > 0:
                if line_mapping[line_num] >= rule_boundary_line:
                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference
            else:
                if line_mapping[line_num] >= rule_boundary_line:
                    line_mapping[line_num] = line_mapping[line_num] + rule_line_difference

        # print out line mapping
        for line_num in line_mapping:
            if line_num != line_mapping[line_num]:
                print("\t" + colored(str(line_num) + "  ->  " + str(line_mapping[line_num]), 'green', attrs=["bold"]))


    print()
    # add removed and added lines to line mapping

    # print out line mapping
    print("Line Mapping:")
    for line_num in line_mapping:
        if line_num != line_mapping[line_num]:
            print(colored(str(line_num) + "  ->  " + str(line_mapping[line_num]), 'green', attrs=["bold"]))
        #else:
        #    print(line_num, " -> ", line_mapping[line_num])


    # convert raw modifications into a "transition dictionary" for line numbers
    # modification_scopes give an implicit mapping between line numbers as "anchor points"
    # found modifications are to be treated in relation to the modifications_scopes

if __name__ == "__main__":
    main()


