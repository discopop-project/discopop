# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import re
import os
from collections import defaultdict

from lxml import objectify  # type:ignore

# Map to record which line belongs to read set of nodes. LID -> NodeIds
readlineToCUIdMap = defaultdict(set)  # type: ignore
# Map to record which line belongs to write set of nodes. LID -> NodeIds
writelineToCUIdMap = defaultdict(set)  # type: ignore
# Map to record which line belongs to set of nodes. LID -> NodeIds
lineToCUIdMap = defaultdict(set)  # type: ignore


class DependenceItem(object):
    def __init__(self, sink, source, type, var_name):
        self.sink = sink
        self.source = source
        self.type = type
        self.var_name = var_name


def __parse_xml_input(xml_fd):
    xml_content = ""
    for line in xml_fd.readlines():
        if not (line.rstrip().endswith("</Nodes>") or line.rstrip().endswith("<Nodes>")):
            xml_content = xml_content + line

    xml_content = "<Nodes>{0}</Nodes>".format(xml_content)

    parsed_cu = objectify.fromstring(xml_content)
    cu_dict = dict()
    for node in parsed_cu.Node:
        node.childrenNodes = str(node.childrenNodes).split(",") if node.childrenNodes else []
        if node.get("type") == "0":
            for instruction_id in str(node.writePhaseLines).split(","):
                writelineToCUIdMap[instruction_id].add(node.get("id"))
            for instruction_id in str(node.readPhaseLines).split(","):
                readlineToCUIdMap[instruction_id].add(node.get("id"))

        cu_dict[node.get("id")] = node

    return cu_dict


def __map_dummy_nodes(cu_dict):
    dummy_node_args_to_id_map = defaultdict(list)
    func_node_args_to_id_map = dict()
    dummy_to_func_ids_map = dict()
    for node_id, node in cu_dict.items():
        if node.get("type") == "3" or node.get("type") == "1":
            key = node.get("name")
            if "arg" in dir(node.funcArguments):
                for i in node.funcArguments.arg:
                    key = key + i.get("type")
                if node.get("type") == "3":
                    dummy_node_args_to_id_map[key].append(node_id)
                else:
                    func_node_args_to_id_map[key] = node_id

    # iterate over all real functions
    for func in func_node_args_to_id_map:
        if func in dummy_node_args_to_id_map:
            for dummyID in dummy_node_args_to_id_map[func]:
                dummy_to_func_ids_map[dummyID] = func_node_args_to_id_map[func]
                cu_dict.pop(dummyID)

    # now go through all the nodes and update the mapped dummies to real funcs
    for node_id, node in cu_dict.items():
        # check dummy in all the children nodes
        if "childrenNodes" in dir(node):
            for child_idx, child in enumerate(node.childrenNodes):
                if child in dummy_to_func_ids_map:
                    cu_dict[node_id].childrenNodes[child_idx] = dummy_to_func_ids_map[child]

            # Also do the same in callLineToFunctionMap
            if "callsNode" in dir(node):
                for idx, i in enumerate(node.callsNode.nodeCalled):
                    if i in dummy_to_func_ids_map:
                        cu_dict[node_id].callsNode.nodeCalled[idx] = dummy_to_func_ids_map[i]
    return cu_dict


def __parse_dep_file(dep_fd):
    dependencies_list = []
    for line in dep_fd.readlines():
        dep_fields = line.split()
        if len(dep_fields) < 4 or dep_fields[1] != "NOM":
            continue
        sink = dep_fields[0]
        # pairwise iteration over dependencies source
        for dep_pair in list(zip(dep_fields[2:], dep_fields[3:]))[::2]:
            type = dep_pair[0]
            source_fields = dep_pair[1].split("|")
            var_str = "" if len(source_fields) == 1 else source_fields[1]
            dependencies_list.append(DependenceItem(sink, source_fields[0], type, var_str))

    return dependencies_list


def parse_inputs(cu_file, dependencies, loop_counter, reduction_file, file_mapping):
    with open(cu_file) as f:
        cu_dict = __parse_xml_input(f)
    cu_dict = __map_dummy_nodes(cu_dict)

    with open(dependencies) as f:
        dependencies = __parse_dep_file(f)

    if os.path.exists(loop_counter):
        loop_data = {}
        with open(loop_counter) as f:
            content = f.readlines()
        for line in content:
            s = line.split(" ")
            loop_data[s[0] + ":" + s[1]] = int(s[2])
    else:
        loop_data = None

    fmap_file = open(file_mapping)
    fmap_lines = fmap_file.read().splitlines()
    fmap_file.close()

    if os.path.exists(reduction_file):
        reduction_vars = []

        # parse reduction variables
        with open(reduction_file) as f:
            content = f.readlines()
        for line in content:
            if is_reduction(line, fmap_lines, file_mapping):
                line = line.replace("\n", "")
                s = line.split(" ")
                var = {
                    "loop_line": f"{s[3]}:{s[8]}",
                    "name": s[17],
                    "reduction_line": f"{s[3]}:{s[13]}",
                    "operation": s[21],
                }
                reduction_vars.append(var)
    else:
        reduction_vars = None

    return cu_dict, dependencies, loop_data, reduction_vars


def is_reduction(reduction_line, fmap_lines, file_mapping):
    rex = re.compile(
        "FileID : ([0-9]*) Loop Line Number : [0-9]* Reduction Line Number : ([0-9]*) "
    )
    if not rex:
        return False
    res = rex.search(reduction_line)
    file_id = int(res.group(1))
    file_line = int(res.group(2))

    filepath = get_filepath(file_id, fmap_lines, file_mapping)
    src_file = open(filepath)
    src_lines = src_file.read().splitlines()
    src_file.close()

    return possible_reduction(file_line, src_lines)


def possible_reduction(line, src_lines):
    assert line > 0 and line <= len(src_lines), "invalid src line"
    src_line = src_lines[line - 1]
    while not ";" in src_line:
        line = line + 1
        if line > len(src_lines):
            return False
        src_line = src_line + " " + src_lines[line - 1]

    pos = src_line.find("=")
    if pos == -1:
        return True

    bracket_a = src_line[0:pos].find("[")
    if bracket_a == -1:
        return True
    bracket_b = src_line[0:pos].rfind("]")
    assert bracket_b != -1

    rex_search_res = re.search("([A-Za-z0-9_]+)\[", src_line[0 : (bracket_a + 1)])
    if not rex_search_res:
        return True

    array_name = rex_search_res[1]
    array_index = src_line[(bracket_a + 1) : bracket_b]

    array_indices = find_array_indices(array_name, src_line[pos : len(src_line)])
    for index in array_indices:
        if index == array_index:
            return False

    return True


def get_filepath(file_id, fmap_lines, file_mapping):
    assert file_id > 0 and file_id <= len(fmap_lines), "invalid file id"
    line = fmap_lines[file_id - 1]
    tokens = line.split(sep="\t")
    if tokens[1].startswith(".."):
        return os.path.dirname(file_mapping) + "/" + tokens[1]
    else:
        return tokens[1]


def get_enclosed_str(data):
    num_open_brackets = 1
    for i in range(0, len(data)):
        if data[i] == "[":
            num_open_brackets = num_open_brackets + 1
        elif data[i] == "]":
            num_open_brackets = num_open_brackets - 1
            if num_open_brackets == 0:
                return data[0:i]


def find_array_indices(array_name, src_line):
    indices = []
    uses = list(re.finditer(array_name, src_line))
    for use in uses:
        if src_line[use.end()] == "[":
            indices.append(get_enclosed_str(src_line[(use.end() + 1) : len(src_line)]))
        else:
            indices.append("")

    return indices
