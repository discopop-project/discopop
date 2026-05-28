# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Tests for ASTQueries and ASTVariableAndTypeQueries.

Fixtures use real Clang AST JSON format:
  * ``"col"`` (not ``"column"``) for column info
  * ``file`` is a plain string, absent on child nodes that inherit it
"""

from __future__ import annotations

import pytest
import networkx as nx

from discopop_explorer.utilities.ASTUtils.ASTGraph import ClangASTGraph
from discopop_explorer.utilities.ASTUtils.ASTQueries import (
    ASTQueries,
    ASTVariableAndTypeQueries,
    _file_matches,
)


@pytest.fixture  # type: ignore[misc]
def sample_graph() -> nx.DiGraph[str]:
    """AST graph for a single function 'main' with variables x, y and a loop."""
    ast = {
        "kind": "TranslationUnitDecl",
        "inner": [
            {
                "id": "fn_main",
                "kind": "FunctionDecl",
                "name": "main",
                "type": "int ()",
                # file present here (first occurrence)
                "loc": {"file": "test.cpp", "line": 1, "col": 1},
                "range": {"begin": {"col": 1}, "end": {"line": 10, "col": 1}},
                "inner": [
                    {
                        "id": "var_x",
                        "kind": "VarDecl",
                        "name": "x",
                        "type": "int",
                        # file inherited from FunctionDecl
                        "loc": {"line": 2, "col": 5},
                        "range": {"begin": {"col": 5}, "end": {"col": 10}},
                        "inner": [],
                    },
                    {
                        "id": "var_y",
                        "kind": "VarDecl",
                        "name": "y",
                        "type": "double",
                        "loc": {"line": 3, "col": 5},
                        "range": {"begin": {"col": 5}, "end": {"col": 12}},
                        "inner": [],
                    },
                    {
                        "id": "for_stmt",
                        "kind": "ForStmt",
                        "loc": {"line": 5, "col": 5},
                        "range": {"begin": {"col": 5}, "end": {"line": 8, "col": 5}},
                        "inner": [
                            {
                                "id": "var_i",
                                "kind": "VarDecl",
                                "name": "i",
                                "type": "int",
                                "loc": {"line": 5, "col": 10},
                                "range": {"begin": {"col": 10}, "end": {"col": 15}},
                                "inner": [],
                            }
                        ],
                    },
                    {
                        "id": "ret_stmt",
                        "kind": "ReturnStmt",
                        "loc": {"line": 9, "col": 5},
                        "range": {"begin": {"col": 5}, "end": {"col": 15}},
                        "inner": [],
                    },
                ],
            }
        ],
    }
    return ClangASTGraph().build_from_ast(ast)


# ---------------------------------------------------------------------------
# ASTQueries tests
# ---------------------------------------------------------------------------


class TestASTQueries:
    def test_find_nodes_by_kind(self, sample_graph: nx.DiGraph[str]) -> None:
        var_decls = ASTQueries.find_nodes_by_kind(sample_graph, "VarDecl")
        assert len(var_decls) == 3
        assert all(sample_graph.nodes[n]["kind"] == "VarDecl" for n in var_decls)

    def test_find_functions(self, sample_graph: nx.DiGraph[str]) -> None:
        functions = ASTQueries.find_functions(sample_graph)
        assert len(functions) == 1
        assert sample_graph.nodes[functions[0]]["name"] == "main"

    def test_find_loops(self, sample_graph: nx.DiGraph[str]) -> None:
        loops = ASTQueries.find_loops(sample_graph)
        assert len(loops) == 1
        assert sample_graph.nodes[loops[0]]["kind"] == "ForStmt"

    def test_find_declarations(self, sample_graph: nx.DiGraph[str]) -> None:
        decls = ASTQueries.find_declarations(sample_graph)
        assert len(decls) == 3
        names = {sample_graph.nodes[d]["name"] for d in decls}
        assert names == {"x", "y", "i"}

    def test_get_parent(self, sample_graph: nx.DiGraph[str]) -> None:
        parent = ASTQueries.get_parent(sample_graph, "var_x")
        assert parent == "fn_main"

    def test_get_parent_of_root_is_none(self, sample_graph: nx.DiGraph[str]) -> None:
        roots = [n for n in sample_graph.nodes() if sample_graph.in_degree(n) == 0]
        assert ASTQueries.get_parent(sample_graph, roots[0]) is None

    def test_get_children(self, sample_graph: nx.DiGraph[str]) -> None:
        children = ASTQueries.get_children(sample_graph, "fn_main")
        assert len(children) == 4  # var_x, var_y, for_stmt, ret_stmt

    def test_find_enclosing_scope_function(self, sample_graph: nx.DiGraph[str]) -> None:
        """Variable x is directly inside main → scope is FunctionDecl."""
        scope = ASTQueries.find_enclosing_scope(sample_graph, "var_x")
        assert scope == "fn_main"

    def test_find_enclosing_scope_loop(self, sample_graph: nx.DiGraph[str]) -> None:
        """Variable i is inside ForStmt → nearest scope is ForStmt."""
        scope = ASTQueries.find_enclosing_scope(sample_graph, "var_i")
        assert scope == "for_stmt"

    def test_find_enclosing_scope_cycle_safe(self) -> None:
        """find_enclosing_scope must not loop forever on a cyclic graph."""
        g: nx.DiGraph[str] = nx.DiGraph()
        g.add_node("a", kind="VarDecl")
        g.add_node("b", kind="VarDecl")
        g.add_edge("a", "b")
        g.add_edge("b", "a")  # cycle
        # Should return None or one of the nodes, but not hang
        result = ASTQueries.find_enclosing_scope(g, "a")
        assert result is None  # neither is a scope kind

    def test_get_node_info(self, sample_graph: nx.DiGraph[str]) -> None:
        info = ASTQueries.get_node_info(sample_graph, "var_x")
        assert info["kind"] == "VarDecl"
        assert info["name"] == "x"
        assert info["type"] == "int"

    def test_find_nodes_in_file(self, sample_graph: nx.DiGraph[str]) -> None:
        """All user-code nodes should resolve to test.cpp via inheritance."""
        nodes = ASTQueries.find_nodes_in_file(sample_graph, "test.cpp")
        # fn_main, var_x, var_y, for_stmt, var_i, ret_stmt  (not TranslationUnitDecl)
        assert len(nodes) >= 5

    def test_find_nodes_in_file_basename(self, sample_graph: nx.DiGraph[str]) -> None:
        """_file_matches accepts basename even when full path is stored."""
        assert _file_matches("/home/user/project/main.cpp", "main.cpp")
        assert not _file_matches("/home/user/project/main.cpp", "other.cpp")
        assert not _file_matches(None, "main.cpp")

    def test_find_nodes_at_location(self, sample_graph: nx.DiGraph[str]) -> None:
        # Line 2, col 5 is where var_x is declared — range is line 2 col 5..10
        nodes = ASTQueries.find_nodes_at_location(sample_graph, "test.cpp", 2, 7)
        assert len(nodes) > 0
        kinds = {sample_graph.nodes[n]["kind"] for n in nodes}
        assert "VarDecl" in kinds

    def test_is_in_range_zero_column(self) -> None:
        """begin_column == 0 must not be treated as falsy."""
        r = {"begin_line": 1, "begin_column": 0, "end_line": 1, "end_column": 10}
        assert ASTQueries._is_in_range(1, 0, r)  # exactly at column 0
        assert ASTQueries._is_in_range(1, 5, r)
        assert not ASTQueries._is_in_range(1, 11, r)  # past end

    def test_is_in_range_missing_lines(self) -> None:
        assert not ASTQueries._is_in_range(1, 1, {})
        assert not ASTQueries._is_in_range(1, 1, {"begin_line": None, "end_line": 5})

    def test_is_in_range_none_column_ignores_column_bounds(self) -> None:
        """column=None matches any column on a line within the line range."""
        r = {"begin_line": 3, "begin_column": 10, "end_line": 7, "end_column": 5}
        assert ASTQueries._is_in_range(3, None, r)  # first line, before begin_col — still matches
        assert ASTQueries._is_in_range(5, None, r)  # middle line
        assert ASTQueries._is_in_range(7, None, r)  # last line, after end_col — still matches
        assert not ASTQueries._is_in_range(2, None, r)  # before range
        assert not ASTQueries._is_in_range(8, None, r)  # after range

    def test_find_nodes_at_location_none_column(self, sample_graph: nx.DiGraph[str]) -> None:
        """column=None returns nodes spanning the line regardless of column."""
        nodes_with_col = ASTQueries.find_nodes_at_location(sample_graph, "test.cpp", 2, 7)
        nodes_no_col = ASTQueries.find_nodes_at_location(sample_graph, "test.cpp", 2)
        # Without a column filter we get at least as many nodes
        assert set(nodes_with_col).issubset(set(nodes_no_col))


# ---------------------------------------------------------------------------
# ASTVariableAndTypeQueries tests
# ---------------------------------------------------------------------------


class TestASTVariableAndTypeQueries:
    def test_find_declarations_at_location(self, sample_graph: nx.DiGraph[str]) -> None:
        decls = ASTVariableAndTypeQueries.find_declarations_at_location(sample_graph, "test.cpp", 2, 7)
        assert any(d[0] == "x" for d in decls)

    def test_find_all_variables_in_scope(self, sample_graph: nx.DiGraph[str]) -> None:
        # Position inside the function body (line 6 is inside the for loop range)
        variables = ASTVariableAndTypeQueries.find_all_variables_in_scope(sample_graph, "test.cpp", 6, 5)
        var_names = [v[0] for v in variables]
        assert len(var_names) > 0
        assert any(name in var_names for name in ["x", "y", "i"])

    def test_find_all_variables_in_scope_none_column(self, sample_graph: nx.DiGraph[str]) -> None:
        """Omitting column returns the same or more variables than a specific column."""
        with_col = ASTVariableAndTypeQueries.find_all_variables_in_scope(sample_graph, "test.cpp", 6, 5)
        no_col = ASTVariableAndTypeQueries.find_all_variables_in_scope(sample_graph, "test.cpp", 6)
        assert set(with_col).issubset(set(no_col))

    def test_function_parameters_included(self) -> None:
        """ParmVarDecl nodes (function parameters) must be returned alongside VarDecl locals."""
        ast = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {
                    "id": "fn_dist",
                    "kind": "FunctionDecl",
                    "name": "dist",
                    "loc": {"file": "test.cpp", "line": 1, "col": 1},
                    "range": {"begin": {"col": 1}, "end": {"line": 20, "col": 1}},
                    "inner": [
                        {
                            "id": "parm_nd",
                            "kind": "ParmVarDecl",
                            "name": "nd",
                            "type": "int",
                            "loc": {"line": 1, "col": 10},
                            "range": {"begin": {"col": 10}, "end": {"col": 12}},
                            "inner": [],
                        },
                        {
                            "id": "parm_r1",
                            "kind": "ParmVarDecl",
                            "name": "r1",
                            "type": "double *",
                            "loc": {"line": 1, "col": 14},
                            "range": {"begin": {"col": 14}, "end": {"col": 16}},
                            "inner": [],
                        },
                        {
                            "id": "var_d",
                            "kind": "VarDecl",
                            "name": "d",
                            "type": "double",
                            "loc": {"line": 3, "col": 5},
                            "range": {"begin": {"col": 5}, "end": {"col": 6}},
                            "inner": [],
                        },
                    ],
                }
            ],
        }
        graph = ClangASTGraph().build_from_ast(ast)
        variables = ASTVariableAndTypeQueries.find_all_variables_in_scope(graph, "test.cpp", 10, 1)
        var_names = [v[0] for v in variables]
        assert "nd" in var_names
        assert "r1" in var_names
        assert "d" in var_names

    def test_get_variables_in_scope(self, sample_graph: nx.DiGraph[str]) -> None:
        variables = ASTVariableAndTypeQueries.get_variables_in_scope(sample_graph, "fn_main")
        var_names = [v[0] for v in variables]
        assert "x" in var_names
        assert "y" in var_names
        assert "i" in var_names

    def test_variable_types_preserved(self, sample_graph: nx.DiGraph[str]) -> None:
        variables = ASTVariableAndTypeQueries.get_variables_in_scope(sample_graph, "fn_main")
        var_dict = {name: typ for name, typ in variables}
        assert var_dict["x"] == "int"
        assert var_dict["y"] == "double"
        assert var_dict["i"] == "int"
