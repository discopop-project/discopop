# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Integration utilities for AST analysis in pattern detection"""

from __future__ import annotations

import sys
import traceback
from pathlib import Path
from typing import Any, Dict, Optional

import networkx as nx

from discopop_explorer.utilities.ASTUtils.ASTLoader import ClangASTLoader
from discopop_explorer.utilities.ASTUtils.ASTGraph import ClangASTGraph
from discopop_explorer.utilities.ASTUtils.ASTQueries import (
    ASTQueries,
    ASTVariableAndTypeQueries,
)
from discopop_explorer.utilities.ASTUtils.ASTVisualization import ASTVisualization
from discopop_library.PathManagement.PathManagement import load_file_mapping


class ASTPatternDetectionHelper:
    """Helper class for AST analysis during pattern detection

    Provides convenient methods for pattern detectors to query AST information.
    """

    def __init__(self) -> None:
        """Initialize helper with no AST loaded"""
        self.ast_graph: Optional[nx.DiGraph[str]] = None
        self.file_mapping: Dict[int, Path] = {}

    def load_ast_from_project(self, project_path: str) -> None:
        """Load and build AST graph from project.

        Also loads ``FileMapping.txt`` so that callers can pass integer file IDs
        (as used throughout the rest of the DiscoPoP pipeline) instead of raw
        filenames.  After building the graph, file paths stored in node ``loc``
        dicts are normalised against ``FileMapping.txt`` so lookups by file ID
        resolve correctly.

        Args:
            project_path: Root path of the DiscoPoP project (.discopop directory)
        """
        file_mapping_path = str(Path(project_path) / "FileMapping.txt")

        # Load FileMapping.txt so file-ID lookups work later
        try:
            self.file_mapping = load_file_mapping(file_mapping_path)
        except (ValueError, OSError):
            self.file_mapping = {}

        ast_dict = ClangASTLoader.load_ast_from_project(project_path)
        if ast_dict is None:
            print(
                f"[ASTUtils] ast_dump.json not found under {project_path}/profiler/",
                file=sys.stderr,
            )
            return
        try:
            self.ast_graph = ClangASTGraph().build_from_ast(ast_dict)
        except Exception:
            print("[ASTUtils] Failed to build AST graph:", file=sys.stderr)
            traceback.print_exc(file=sys.stderr)
            self.ast_graph = None
            return

        # Normalise file paths to match FileMapping.txt entries
        ast_file_paths: set[str] = {
            attrs["loc"]["file"]
            for _, attrs in self.ast_graph.nodes(data=True)
            if isinstance(attrs.get("loc"), dict) and attrs["loc"].get("file")
        }
        path_mapping = ClangASTLoader.build_path_mapping(file_mapping_path, ast_file_paths)
        if path_mapping:
            ClangASTGraph.normalize_file_paths(self.ast_graph, path_mapping)

    def get_variables_at_location(self, file_id: int, line: int, column: int) -> list[tuple[str, Optional[str]]]:
        """Get variables visible at a specific source location, identified by file ID.

        Args:
            file_id: Integer file identifier as defined in ``FileMapping.txt``
            line: Line number
            column: Column number

        Returns:
            List of (var_name, var_type) tuples, or empty list when the file ID
            is unknown or the AST has not been loaded.
        """
        if not self.ast_graph:
            return []

        file_path = self.file_mapping.get(file_id)
        if file_path is None:
            return []

        return ASTVariableAndTypeQueries.find_all_variables_in_scope(self.ast_graph, str(file_path), line, column)

    def get_variable_declarations_in_scope(self, scope_name: str) -> list[tuple[str, Optional[str]]]:
        """Get variables declared in a scope by function/loop name

        Args:
            scope_name: Name of the function or loop

        Returns:
            List of (var_name, var_type) tuples
        """
        if not self.ast_graph:
            return []

        for node_id, attrs in self.ast_graph.nodes(data=True):
            if attrs.get("name") == scope_name:
                kind = attrs.get("kind")
                if kind in {"FunctionDecl", "ForStmt", "WhileStmt"}:
                    return ASTVariableAndTypeQueries.get_variables_in_scope(self.ast_graph, node_id)

        return []

    def get_ast_statistics(self) -> Optional[dict[str, Any]]:
        """Get statistics about the loaded AST

        Returns:
            Dictionary with graph statistics or None if no AST loaded
        """
        if not self.ast_graph:
            return None

        return ASTVisualization.get_statistics(self.ast_graph)

    def get_ast_visualization(self) -> Optional[str]:
        """Get GraphViz DOT format representation of AST

        Returns:
            DOT format string or None if no AST loaded
        """
        if not self.ast_graph:
            return None

        return ASTVisualization.get_graphviz_format(self.ast_graph)

    def print_ast_structure(self, max_depth: Optional[int] = None) -> None:
        """Print ASCII representation of AST structure

        Args:
            max_depth: Maximum depth to print (None = unlimited)
        """
        if not self.ast_graph:
            print("No AST loaded")
            return

        ASTVisualization.print_tree_structure(self.ast_graph, max_depth=max_depth)

    def get_ast_graph(self) -> Optional[nx.DiGraph[str]]:
        """Get the underlying AST graph for direct querying

        Returns:
            AST graph or None if not loaded
        """
        return self.ast_graph

    def is_ast_loaded(self) -> bool:
        """Check if AST is available

        Returns:
            True if AST is loaded, False otherwise
        """
        return self.ast_graph is not None
