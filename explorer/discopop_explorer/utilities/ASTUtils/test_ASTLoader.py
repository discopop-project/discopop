# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import tempfile
from pathlib import Path

import pytest

from discopop_explorer.utilities.ASTUtils.ASTLoader import ClangASTLoader


class TestClangASTLoader:
    """Tests for ClangASTLoader"""

    def test_load_ast_from_valid_file(self) -> None:
        """Test loading AST from a valid JSON file"""
        test_ast = {
            "kind": "TranslationUnitDecl",
            "name": "test.cpp",
            "inner": [],
        }

        with tempfile.TemporaryDirectory() as tmpdir:
            ast_file = Path(tmpdir) / "ast_dump.json"
            with open(ast_file, "w") as f:
                json.dump(test_ast, f)

            result = ClangASTLoader.load_ast(str(ast_file))
            assert result["kind"] == "TranslationUnitDecl"
            assert result["name"] == "test.cpp"

    def test_load_ast_file_not_found(self) -> None:
        """Test loading AST from nonexistent file raises FileNotFoundError"""
        with pytest.raises(FileNotFoundError):
            ClangASTLoader.load_ast("/nonexistent/path/ast_dump.json")

    def test_load_ast_invalid_json(self) -> None:
        """Test loading invalid JSON raises JSONDecodeError"""
        with tempfile.TemporaryDirectory() as tmpdir:
            ast_file = Path(tmpdir) / "ast_dump.json"
            with open(ast_file, "w") as f:
                f.write("invalid json {")

            with pytest.raises(json.JSONDecodeError):
                ClangASTLoader.load_ast(str(ast_file))

    def test_load_ast_is_directory(self) -> None:
        """Test loading AST from directory raises ValueError"""
        with tempfile.TemporaryDirectory() as tmpdir:
            with pytest.raises(ValueError, match="is not a file"):
                ClangASTLoader.load_ast(tmpdir)

    def test_load_ast_from_project_existing(self) -> None:
        """Test loading AST from project with existing ast_dump.json"""
        test_ast = {"kind": "TranslationUnitDecl", "inner": []}

        with tempfile.TemporaryDirectory() as tmpdir:
            project_path = Path(tmpdir)
            ast_dir = project_path / "profiler"
            ast_dir.mkdir(parents=True)

            ast_file = ast_dir / "ast_dump.json"
            with open(ast_file, "w") as f:
                json.dump(test_ast, f)

            result = ClangASTLoader.load_ast_from_project(str(project_path))
            assert result is not None
            assert result["kind"] == "TranslationUnitDecl"

    def test_load_ast_from_project_nonexistent(self) -> None:
        """Test loading AST from project without ast_dump.json returns None"""
        with tempfile.TemporaryDirectory() as tmpdir:
            result = ClangASTLoader.load_ast_from_project(tmpdir)
            assert result is None

    def test_load_ast_with_nested_structure(self) -> None:
        """Test loading complex AST with nested nodes"""
        test_ast = {
            "kind": "TranslationUnitDecl",
            "inner": [
                {
                    "kind": "FunctionDecl",
                    "name": "foo",
                    "type": "int ()",
                    "inner": [
                        {
                            "kind": "VarDecl",
                            "name": "x",
                            "type": "int",
                            "inner": [],
                        }
                    ],
                }
            ],
        }

        with tempfile.TemporaryDirectory() as tmpdir:
            ast_file = Path(tmpdir) / "ast_dump.json"
            with open(ast_file, "w") as f:
                json.dump(test_ast, f)

            result = ClangASTLoader.load_ast(str(ast_file))
            assert len(result["inner"]) == 1
            assert result["inner"][0]["kind"] == "FunctionDecl"
            assert len(result["inner"][0]["inner"]) == 1
