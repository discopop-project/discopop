# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Tests for ClangASTGraph.

All fixtures use real Clang AST JSON field names:
  * ``file`` is a plain string (only present when it changes from context)
  * column key is ``"col"`` (not ``"column"``)
  * ``line`` / ``file`` may be absent from child nodes (location inheritance)
  * ``spellingLoc`` / ``expansionLoc`` used for macro positions
"""

from __future__ import annotations

import pytest

from discopop_explorer.utilities.ASTUtils.ASTGraph import ClangASTGraph


def _make_builder() -> ClangASTGraph:
    return ClangASTGraph()


class TestClangASTGraph:
    def test_build_empty_ast(self) -> None:
        graph = _make_builder().build_from_ast({})
        assert len(graph.nodes) == 0
        assert len(graph.edges) == 0

    def test_build_single_node_ast(self) -> None:
        ast = {"kind": "TranslationUnitDecl", "inner": []}
        graph = _make_builder().build_from_ast(ast)
        assert len(graph.nodes) == 1
        assert len(graph.edges) == 0

    def test_build_tree_structure(self) -> None:
        ast = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {
                    "kind": "FunctionDecl",
                    "name": "foo",
                    "inner": [
                        {"kind": "VarDecl", "name": "x", "inner": []},
                        {"kind": "VarDecl", "name": "y", "inner": []},
                    ],
                }
            ],
        }
        graph = _make_builder().build_from_ast(ast)
        assert len(graph.nodes) == 4
        assert len(graph.edges) == 3

    def test_node_attributes_preserved(self) -> None:
        """Node kind / name / type are stored correctly."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "type": "int ()",
            # Real Clang format: file is a string, column key is "col"
            "loc": {"file": "test.cpp", "line": 1, "col": 1},
            "range": {
                "begin": {"col": 1},
                "end": {"line": 5, "col": 1},
            },
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        node_id = "0x1"
        assert graph.nodes[node_id]["kind"] == "FunctionDecl"
        assert graph.nodes[node_id]["name"] == "foo"
        assert graph.nodes[node_id]["type"] == "int ()"

    def test_inner_array_preserved(self) -> None:
        ast = {
            "kind": "FunctionDecl",
            "name": "foo",
            "inner": [{"kind": "VarDecl", "name": "x", "inner": []}],
        }
        graph = _make_builder().build_from_ast(ast)
        fn_node = next(n for n, a in graph.nodes(data=True) if a["kind"] == "FunctionDecl")
        assert isinstance(graph.nodes[fn_node]["inner"], list)
        assert len(graph.nodes[fn_node]["inner"]) == 1

    # --- real format: file as string, "col" key ---

    def test_loc_file_stored_as_string(self) -> None:
        """file is stored as plain string, not as a nested dict."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "loc": {"file": "test.cpp", "line": 1, "col": 5},
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        loc = graph.nodes["0x1"]["loc"]
        assert loc["file"] == "test.cpp"

    def test_loc_col_mapped_to_column_key(self) -> None:
        """Clang 'col' is stored under the 'column' key for API consistency."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "loc": {"file": "test.cpp", "line": 3, "col": 7},
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        loc = graph.nodes["0x1"]["loc"]
        assert loc["column"] == 7
        assert loc["line"] == 3

    def test_file_inheritance_from_parent(self) -> None:
        """Child node without explicit file inherits it from the parent."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "loc": {"file": "test.cpp", "line": 1, "col": 1},
            "inner": [
                {
                    "id": "0x2",
                    "kind": "VarDecl",
                    "name": "x",
                    "loc": {"line": 2, "col": 5},  # no "file" — inherited
                    "inner": [],
                }
            ],
        }
        graph = _make_builder().build_from_ast(ast)
        var_loc = graph.nodes["0x2"]["loc"]
        assert var_loc["file"] == "test.cpp", "file must be inherited from FunctionDecl"
        assert var_loc["line"] == 2
        assert var_loc["column"] == 5

    def test_range_col_mapped_to_begin_end_column(self) -> None:
        """Range endpoints use begin_column / end_column (mapped from 'col')."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "loc": {"file": "test.cpp", "line": 1, "col": 1},
            "range": {
                "begin": {"col": 1},
                "end": {"line": 5, "col": 2},
            },
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        r = graph.nodes["0x1"]["range"]
        assert r["begin_column"] == 1
        assert r["end_column"] == 2
        assert r["end_line"] == 5

    def test_range_line_fallback_to_loc_line(self) -> None:
        """Range begin without explicit line falls back to the node's loc line."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "foo",
            "loc": {"file": "test.cpp", "line": 4, "col": 1},
            "range": {
                "begin": {"col": 1},  # no line → should use loc line (4)
                "end": {"line": 10, "col": 1},
            },
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        r = graph.nodes["0x1"]["range"]
        assert r["begin_line"] == 4

    def test_spellingloc_unwrapped(self) -> None:
        """spellingLoc wrapper is unwrapped; its fields are used directly."""
        ast = {
            "id": "0x1",
            "kind": "FunctionDecl",
            "name": "macro_fn",
            "loc": {
                "spellingLoc": {
                    "file": "real.cpp",
                    "line": 10,
                    "col": 3,
                }
            },
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        loc = graph.nodes["0x1"]["loc"]
        assert loc["file"] == "real.cpp"
        assert loc["line"] == 10
        assert loc["column"] == 3

    def test_expansionloc_used_when_no_spellingloc(self) -> None:
        """expansionLoc is used when spellingLoc is absent."""
        ast = {
            "id": "0x1",
            "kind": "CallExpr",
            "loc": {
                "expansionLoc": {
                    "file": "macro.cpp",
                    "line": 20,
                    "col": 5,
                }
            },
            "inner": [],
        }
        graph = _make_builder().build_from_ast(ast)
        loc = graph.nodes["0x1"]["loc"]
        assert loc["file"] == "macro.cpp"
        assert loc["line"] == 20

    def test_node_id_from_clang_field(self) -> None:
        """Explicit 'id' from Clang JSON is used as the node ID."""
        ast = {"id": "0xABCD", "kind": "TranslationUnitDecl", "inner": []}
        graph = _make_builder().build_from_ast(ast)
        assert "0xABCD" in graph.nodes

    def test_node_id_autogenerated_when_absent(self) -> None:
        """Nodes without 'id' receive auto-generated IDs."""
        ast = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {"kind": "FunctionDecl", "name": "f", "inner": []},
                {"kind": "FunctionDecl", "name": "g", "inner": []},
            ],
        }
        graph = _make_builder().build_from_ast(ast)
        assert len(graph.nodes) == 3
        assert len(set(graph.nodes())) == 3  # all IDs distinct

    def test_multiple_builds_reset_state(self) -> None:
        """A second build on the same builder produces a clean graph."""
        builder = _make_builder()
        ast1 = {"kind": "TranslationUnitDecl", "inner": [{"kind": "FunctionDecl", "inner": []}]}
        ast2 = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {"kind": "FunctionDecl", "inner": []},
                {"kind": "FunctionDecl", "inner": []},
            ],
        }
        graph1 = builder.build_from_ast(ast1)
        assert len(graph1.nodes) == 2
        graph2 = builder.build_from_ast(ast2)
        assert len(graph2.nodes) == 3

    def test_parent_child_relationships(self) -> None:
        """Edges point from parent to child with relation='child'."""
        ast = {
            "kind": "FunctionDecl",
            "name": "foo",
            "inner": [
                {"kind": "VarDecl", "name": "x", "inner": []},
                {"kind": "VarDecl", "name": "y", "inner": []},
            ],
        }
        graph = _make_builder().build_from_ast(ast)
        assert len(graph.nodes) == 3
        for _, _, eattrs in graph.edges(data=True):
            assert eattrs.get("relation") == "child"

    def test_complex_nested_structure(self) -> None:
        ast = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {
                    "kind": "FunctionDecl",
                    "name": "main",
                    "inner": [
                        {
                            "kind": "CompoundStmt",
                            "inner": [
                                {"kind": "VarDecl", "name": "x", "inner": []},
                                {
                                    "kind": "ForStmt",
                                    "inner": [{"kind": "VarDecl", "name": "i", "inner": []}],
                                },
                            ],
                        }
                    ],
                }
            ],
        }
        graph = _make_builder().build_from_ast(ast)
        assert len(graph.nodes) == 6
        assert len(graph.edges) == 5
