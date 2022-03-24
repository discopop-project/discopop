# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import os
from collections import defaultdict

from lxml import objectify  # type:ignore

readlineToCUIdMap = defaultdict(set)  # Map to record which line belongs to read set of nodes. LID -> NodeIds
writelineToCUIdMap = defaultdict(set)  # Map to record which line belongs to write set of nodes. LID -> NodeIds
lineToCUIdMap = defaultdict(set)  # Map to record which line belongs to set of nodes. LID -> NodeIds


class DependenceItem(object):
    def __init__(self, sink, source, type, var_name):
        self.sink = sink
        self.source = source
        self.type = type
        self.var_name = var_name


def __parse_xml_input(xml_fd):
    xml_content = ""
    for line in xml_fd.readlines():
        if not (line.rstrip().endswith('</Nodes>') or line.rstrip().endswith('<Nodes>')):
            xml_content = xml_content + line

    xml_content = "<Nodes>{0}</Nodes>".format(xml_content)

    parsed_cu = objectify.fromstring(xml_content)
    cu_dict = dict()
    for node in parsed_cu.Node:
        node.childrenNodes = str(node.childrenNodes).split(',') if node.childrenNodes else []
        if node.get('type') == '0':
            for instruction_id in str(node.instructionLines).split(','):
                lineToCUIdMap[instruction_id].add(node.get('id'))
            for instruction_id in str(node.writePhaseLines).split(','):
                writelineToCUIdMap[instruction_id].add(node.get('id'))
            for instruction_id in str(node.readPhaseLines).split(','):
                readlineToCUIdMap[instruction_id].add(node.get('id'))

        cu_dict[node.get('id')] = node

    return cu_dict


def __map_dummy_nodes(cu_dict):
    dummy_node_args_to_id_map = defaultdict(list)
    func_node_args_to_id_map = dict()
    dummy_to_func_ids_map = dict()
    for node_id, node in cu_dict.items():
        if node.get('type') == '3' or node.get('type') == '1':
            key = node.get('name')
            if 'arg' in dir(node.funcArguments):
                for i in node.funcArguments.arg:
                    key = key + i.get('type')
                if node.get('type') == '3':
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
        if 'childrenNodes' in dir(node):
            for child_idx, child in enumerate(node.childrenNodes):
                if child in dummy_to_func_ids_map:
                    cu_dict[node_id].childrenNodes[child_idx] = dummy_to_func_ids_map[child]

            # Also do the same in callLineToFunctionMap
            if 'callsNode' in dir(node):
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
        for dep_pair in list(zip(dep_fields[2:], dep_fields[3:]))[::2]:  # pairwise iteration over dependencies source
            type = dep_pair[0]
            source_fields = dep_pair[1].split('|')
            var_str = "" if len(source_fields) == 1 else source_fields[1]
            dependencies_list.append(DependenceItem(sink, source_fields[0], type, var_str))

    return dependencies_list


def parse_inputs(cu_file, dependencies, loop_counter, reduction_file):
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
            s = line.split(' ')
            # line = FileId + LineNr
            loop_data[s[0] + ':' + s[1]] = int(s[2])
    else:
        loop_data = None

    if os.path.exists(reduction_file):
        reduction_vars = []

        # parse reduction variables
        with open(reduction_file) as f:
            content = f.readlines()

        for line in content:
            line = line.replace("\n", "")
            s = line.split(' ')
            # line = FileId + LineNr
            var = {
                'loop_line': f'{s[3]}:{s[8]}',
                'name': s[17],
                'reduction_line': f'{s[3]}:{s[13]}',
                'operation': s[21]
            }
            reduction_vars.append(var)
    else:
        reduction_vars = None

    return cu_dict, dependencies, loop_data, reduction_vars
