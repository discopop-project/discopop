# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations

from typing import Any, Optional

import networkx as nx


class ClangASTGraph:
    """Converts Clang AST JSON to networkx DiGraph.

    Handles the real Clang AST JSON format produced by
    ``clang -Xclang -ast-dump=json``, including:

    * ``file`` / ``line`` location inheritance — Clang omits these keys when
      they are the same as the enclosing context, so we track them during
      traversal and propagate them downward.
    * Column key is ``"col"`` (not ``"column"``) in Clang JSON.
    * Macro-expanded locations represented as ``spellingLoc`` / ``expansionLoc``
      — we prefer ``spellingLoc`` (the actual source position).
    """

    def __init__(self) -> None:
        self.graph: nx.DiGraph[str] = nx.DiGraph()
        self.node_counter: int = 0

    def build_from_ast(self, ast_root: dict[str, Any]) -> nx.DiGraph[str]:
        """Recursively traverse AST and build graph.

        Args:
            ast_root: Root node dictionary from Clang AST JSON

        Returns:
            NetworkX directed graph representation of the AST
        """
        self.graph.clear()
        self.node_counter = 0

        if ast_root:
            self._traverse_iterative(ast_root)

        return self.graph

    def _traverse_iterative(self, ast_root: dict[str, Any]) -> None:
        """Iterative DFS traversal of the AST — avoids Python recursion limits.

        Each stack frame carries the node dict, its parent ID, and the
        inherited file/line context from the nearest ancestor that provided
        explicit values for those fields.

        Args:
            ast_root: Root node of the AST
        """
        # Stack items: (node, parent_id, current_file, current_line)
        stack: list[tuple[dict[str, Any], Optional[str], Optional[str], Optional[int]]] = [(ast_root, None, None, None)]

        while stack:
            node, parent_id, inh_file, inh_line = stack.pop()

            node_id = self._extract_id(node)
            loc, resolved_file, resolved_line = self._extract_location(node.get("loc", {}), inh_file, inh_line)
            range_info = self._extract_range(node.get("range", {}), resolved_file, resolved_line)

            attrs = {
                "kind": node.get("kind"),
                "name": node.get("name"),
                "type": self._extract_type(node.get("type")),
                "loc": loc,
                "range": range_info,
                "inner": node.get("inner", []),
            }

            self.graph.add_node(node_id, **attrs)

            if parent_id is not None:
                self.graph.add_edge(parent_id, node_id, relation="child")

            # Push children in reverse order so the first child is processed first
            for child in reversed(node.get("inner", [])):
                stack.append((child, node_id, resolved_file, resolved_line))

    def _extract_id(self, node: dict[str, Any]) -> str:
        """Extract or generate unique node ID.

        Clang AST JSON nodes have an ``id`` field (hex string like
        ``"0x5555..."``) when serialised by modern Clang.  Fall back to
        an auto-incremented counter when absent.

        Args:
            node: AST node dictionary

        Returns:
            Unique node identifier
        """
        node_id: Any = node.get("id")
        if node_id is not None:
            return str(node_id)

        generated_id = f"node_{self.node_counter}"
        self.node_counter += 1
        return generated_id

    @staticmethod
    def _resolve_macro_loc(loc: dict[str, Any]) -> dict[str, Any]:
        """Unwrap macro spelling / expansion locations.

        Clang represents macro-expanded positions as::

            {"spellingLoc": {...}, "expansionLoc": {...}}

        We prefer ``spellingLoc`` (the actual source text position).

        Args:
            loc: Raw location or range-endpoint dictionary

        Returns:
            Resolved location dictionary (may be the same object)
        """
        if "spellingLoc" in loc:
            return dict(loc["spellingLoc"])
        if "expansionLoc" in loc:
            return dict(loc["expansionLoc"])
        return loc

    @staticmethod
    def _extract_type(type_field: Any) -> Optional[str]:
        """Normalise the ``type`` field to a plain string.

        Clang AST JSON represents types as objects::

            {"qualType": "int", "desugaredQualType": "int"}

        We extract ``qualType`` (the canonical type string).  A bare string
        is returned as-is for forward compatibility; None is returned for
        absent types.

        Args:
            type_field: Raw ``type`` value from a Clang AST node

        Returns:
            Type string or None
        """
        if type_field is None:
            return None
        if isinstance(type_field, str):
            return type_field
        if isinstance(type_field, dict):
            return type_field.get("qualType")
        return str(type_field)

    def _extract_location(
        self,
        loc: dict[str, Any],
        inherited_file: Optional[str],
        inherited_line: Optional[int],
    ) -> tuple[dict[str, Any], Optional[str], Optional[int]]:
        """Extract file, line, column from a Clang ``loc`` object.

        Clang omits ``file`` when it is unchanged from the enclosing context
        and omits ``line`` when the node is on the same line as the previous
        sibling.  We therefore inherit both from the caller's context and
        update them only when the JSON provides a new value.

        Column key in Clang JSON is ``"col"``, not ``"column"``.

        Args:
            loc: ``loc`` dict from a Clang AST node
            inherited_file: File name propagated from ancestor traversal
            inherited_line: Line number propagated from ancestor traversal

        Returns:
            Tuple of (extracted loc dict, updated_file, updated_line)
        """
        resolved = self._resolve_macro_loc(loc)

        # file: string when present and changed, otherwise use inherited value
        file_name: Optional[str] = resolved.get("file", inherited_file)

        # line: integer when present and changed, otherwise use inherited value
        line: Optional[int] = resolved.get("line", inherited_line)

        # Clang uses "col", not "column"
        col: Optional[int] = resolved.get("col")

        extracted = {
            "file": file_name,
            "line": line,
            "column": col,  # stored as "column" for API consistency
        }
        return extracted, file_name, line

    @staticmethod
    def normalize_file_paths(graph: nx.DiGraph[str], path_mapping: dict[str, str]) -> None:
        """Replace non-canonical file paths in every node's ``loc`` with their canonical counterparts.

        Uses the mapping produced by :meth:`ClangASTLoader.build_path_mapping`.
        Only the ``loc["file"]`` field is updated; ``range`` endpoints do not carry
        independent file information.

        Args:
            graph: AST graph (modified in place)
            path_mapping: Dict mapping raw AST paths to canonical absolute paths
        """
        if not path_mapping:
            return

        for node_id in graph.nodes():
            loc = graph.nodes[node_id].get("loc")
            if isinstance(loc, dict):
                raw = loc.get("file")
                if raw in path_mapping:
                    loc["file"] = path_mapping[raw]

    def _extract_range(
        self,
        range_info: dict[str, Any],
        current_file: Optional[str],
        current_line: Optional[int],
    ) -> dict[str, Any]:
        """Extract source range from a Clang ``range`` object.

        Range endpoints follow the same inheritance rules as ``loc``: ``line``
        and ``file`` may be absent when unchanged.  We use the node's own
        ``current_line`` as fallback for endpoints that omit it.

        Args:
            range_info: ``range`` dict from a Clang AST node
            current_file: Resolved file for this node (used as fallback)
            current_line: Resolved line for this node (used as fallback)

        Returns:
            Dictionary with begin/end line and column information
        """
        begin_raw = self._resolve_macro_loc(range_info.get("begin", {}))
        end_raw = self._resolve_macro_loc(range_info.get("end", {}))

        return {
            "begin_line": begin_raw.get("line", current_line),
            "begin_column": begin_raw.get("col"),
            "end_line": end_raw.get("line", current_line),
            "end_column": end_raw.get("col"),
        }
