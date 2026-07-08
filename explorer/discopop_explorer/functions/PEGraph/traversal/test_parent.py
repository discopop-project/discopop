# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations

from typing import Callable, Tuple

from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.enums.EdgeType import EdgeType
from discopop_explorer.enums.NodeType import NodeType
from discopop_explorer.functions.PEGraph.traversal.parent import (
    get_all_parent_functions,
    get_all_parents_until_function,
    get_parent_function,
)

MakeNode = Callable[..., Node]
BuildPetGraph = Callable[..., PEGraphX]


def _nested_pet(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> Tuple[PEGraphX, Node, Node, Node, Node, Node]:
    """main(FUNC) -> loop(LOOP) -> cu(CU), plus a second function 'helper' called from cu."""
    main = make_node("1:1", NodeType.FUNC, name="main")
    loop = make_node("1:2", NodeType.LOOP, name="loop")
    cu = make_node("1:3", NodeType.CU, name="cu")
    helper = make_node("2:1", NodeType.FUNC, name="helper")
    helper_cu = make_node("2:2", NodeType.CU, name="helper_cu")
    pet = build_pet_graph(
        [main, loop, cu, helper, helper_cu],
        [
            (main.id, loop.id, EdgeType.CHILD),
            (loop.id, cu.id, EdgeType.CHILD),
            (cu.id, helper.id, EdgeType.CALLSNODE),
            (helper.id, helper_cu.id, EdgeType.CHILD),
        ],
    )
    return pet, main, loop, cu, helper, helper_cu


def test_get_parent_function_returns_self_for_function_node(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    assert get_parent_function(pet, main) is main


def test_get_parent_function_climbs_through_loop(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    assert get_parent_function(pet, cu) is main


def test_get_parent_function_caches_result_on_node(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    assert cu.parent_function_id is None
    get_parent_function(pet, cu)
    assert cu.parent_function_id == main.id


def test_get_all_parent_functions_follows_calls_node_edges(make_node: MakeNode, build_pet_graph: BuildPetGraph) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    parents = get_all_parent_functions(pet, helper_cu)
    assert set(parents) == {helper, main}


def test_get_all_parents_until_function_collects_loops_and_stops_at_function(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    parents = get_all_parents_until_function(pet, cu)
    assert set(parents) == {loop, main}


def test_get_all_parents_until_function_empty_for_top_level_function(
    make_node: MakeNode, build_pet_graph: BuildPetGraph
) -> None:
    pet, main, loop, cu, helper, helper_cu = _nested_pet(make_node, build_pet_graph)
    assert get_all_parents_until_function(pet, main) == [main]
