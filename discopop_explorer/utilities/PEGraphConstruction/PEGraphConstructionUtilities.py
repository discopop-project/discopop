# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations

from typing import Union

from lxml.objectify import ObjectifiedElement  # type: ignore

from discopop_explorer.classes.PEGraph.CUNode import CUNode

from discopop_explorer.classes.Dependency import Dependency
from discopop_explorer.classes.DummyNode import DummyNode
from discopop_explorer.classes.FunctionNode import FunctionNode
from discopop_explorer.classes.LoopNode import LoopNode
from discopop_explorer.classes.Node import Node
from discopop_explorer.enums.DepType import DepType
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.utilities.PEGraphConstruction.classes.DependenceItem import DependenceItem
from discopop_explorer.classes.variable import Variable
from discopop_explorer.utilities.PEGraphConstruction.ParserUtilities import parse_id


def parse_dependency(dep: DependenceItem) -> Dependency:
    d = Dependency(EdgeType.DATA)
    d.source_line = dep.source
    d.sink_line = dep.sink
    # check for intra-iteration dependencies
    if "_II_" in dep.type:
        d.intra_iteration = True
        # get intra_iteration_level
        d.intra_iteration_level = int(dep.type[dep.type.rindex("_") + 1 :])
        d.dtype = DepType[dep.type[: dep.type.index("_")]]  # remove _II_x tag
    else:
        d.dtype = DepType[dep.type]
    d.var_name = dep.var_name
    d.memory_region = dep.memory_region
    # parse metadata
    if len(dep.metadata) > 0:
        for md in dep.metadata.split(" "):
            if len(md) == 0:
                continue
            # unpack metadata
            md_type = md[: md.index("[")]
            md_raw_values = md[md.index("[") + 1 : -1]
            md_values = [tmp for tmp in md_raw_values.split(",") if len(tmp) > 0]
            # store metadata
            if md_type == "IAI":
                d.metadata_intra_iteration_dep += md_values
            elif md_type == "IEI":
                d.metadata_inter_iteration_dep += md_values
            elif md_type == "IAC":
                d.metadata_intra_call_dep += md_values
            elif md_type == "IEC":
                d.metadata_inter_call_dep += md_values
            elif md_type == "SINK_ANC":
                d.metadata_sink_ancestors += md_values
            elif md_type == "SOURCE_ANC":
                d.metadata_source_ancestors += md_values
            else:
                raise ValueError("Unknown metadata type: ", md_type)
    return d


def parse_cu(node: ObjectifiedElement) -> Node:
    node_id = node.get("id")
    node_type = NodeType(int(node.get("type")))

    n: Node
    # CU Node
    if node_type == NodeType.CU:
        n = CUNode(node_id)
        if hasattr(node.localVariables, "local"):
            n.local_vars = [
                Variable(
                    v.get("type"),
                    v.text,
                    v.get("defLine"),
                    v.get("accessMode"),
                    int(v.get("sizeInByte")) if v.get("sizeInByte") is not None else 0,
                )
                for v in node.localVariables.local
            ]
        if hasattr(node.globalVariables, "global"):
            n.global_vars = [
                Variable(
                    v.get("type"),
                    v.text,
                    v.get("defLine"),
                    v.get("accessMode"),
                    int(v.get("sizeInByte")) if v.get("sizeInByte") is not None else 0,
                )
                for v in getattr(node.globalVariables, "global")
            ]
        if hasattr(node, "BasicBlockID"):
            n.basic_block_id = getattr(node, "BasicBlockID").text
        if hasattr(node, "returnInstructions"):
            n.return_instructions_count = int(getattr(node, "returnInstructions").get("count"))
        if hasattr(node.callsNode, "nodeCalled"):
            n.node_calls = [
                {"cuid": v.text, "atLine": v.get("atLine")}
                for v in getattr(node.callsNode, "nodeCalled")
                if v.get("atLine") is not None
            ]
        if hasattr(node, "callsNode") and hasattr(node.callsNode, "recursiveFunctionCall"):
            n.recursive_function_calls = [n.text for n in node.callsNode.recursiveFunctionCall]
        if hasattr(node, "performsFileIO"):
            n.performs_file_io = True if int(getattr(node, "performsFileIO")) == 1 else False
        n.instructions_count = int(getattr(node, "instructionsCount"))

    # FUNC or DUMMY NODE
    elif node_type == NodeType.DUMMY or node_type == NodeType.FUNC:
        dummy_or_func: Union[DummyNode, FunctionNode]
        if node_type == NodeType.DUMMY:
            dummy_or_func = DummyNode(node_id)
        else:
            dummy_or_func = FunctionNode(node_id)
        if hasattr(node, "funcArguments") and hasattr(node.funcArguments, "arg"):
            dummy_or_func.args = [
                Variable(
                    v.get("type"),
                    v.text,
                    v.get("defLine"),
                    sizeInByte=int(v.get("sizeInByte")) if v.get("sizeInByte") is not None else 0,
                )
                for v in node.funcArguments.arg
            ]
        n = dummy_or_func

    # LOOP Node
    elif node_type == NodeType.LOOP:
        n = LoopNode(node_id)
    else:
        assert False, "invalid NodeType"

    _, n.start_line = parse_id(node.get("startsAtLine"))
    _, n.end_line = parse_id(node.get("endsAtLine"))
    n.name = node.get("name")

    return n
