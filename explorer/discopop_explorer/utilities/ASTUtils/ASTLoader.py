# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
from pathlib import Path
from typing import Any, Optional


class ClangASTLoader:
    """Loads and parses Clang AST JSON dump"""

    @staticmethod
    def load_ast(ast_dump_path: str) -> dict[str, Any]:
        """Load JSON-formatted Clang AST from file

        Args:
            ast_dump_path: Path to the ast_dump.json file

        Returns:
            Dictionary containing the AST root node

        Raises:
            FileNotFoundError: If the AST dump file does not exist
            json.JSONDecodeError: If the JSON is malformed
        """
        path = Path(ast_dump_path)

        if not path.exists():
            raise FileNotFoundError(f"AST dump file not found: {ast_dump_path}")

        if not path.is_file():
            raise ValueError(f"AST dump path is not a file: {ast_dump_path}")

        try:
            with open(path, "r") as f:
                return dict(json.load(f))  # type: ignore[return-value]
        except json.JSONDecodeError as e:
            raise json.JSONDecodeError(
                f"Failed to parse AST JSON from {ast_dump_path}: {e.msg}",
                e.doc,
                e.pos,
            ) from e

    @staticmethod
    def load_ast_from_project(project_path: str) -> Optional[dict[str, Any]]:
        """Load AST dump from standard DiscoPoP project location

        Args:
            project_path: Root path of the DiscoPoP project

        Returns:
            Dictionary containing the AST root node, or None if file doesn't exist
        """
        ast_dump_path = Path(project_path) / "profiler" / "ast_dump.json"

        if not ast_dump_path.exists():
            return None

        return ClangASTLoader.load_ast(str(ast_dump_path))
