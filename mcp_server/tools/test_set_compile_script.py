# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import tempfile
import unittest
from typing import Any

from mcp_server.tools import set_compile_script
from mcp_server.tools.helpers import ToolContext


class TestSetCompileScript(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp_dir = tempfile.TemporaryDirectory()
        self.project_path = self._tmp_dir.name
        self.configs_dir = os.path.join(self.project_path, ".discopop", "project", "configs")
        os.makedirs(self.configs_dir)
        os.makedirs(os.path.join(self.configs_dir, "default"))
        self.ctx = ToolContext(debug=False)

    def tearDown(self) -> None:
        self._tmp_dir.cleanup()

    def _handle(self, **kwargs: Any) -> Any:
        arguments = {"project_path": self.project_path, "script_body": "$CXX $CXXFLAGS main.cpp -o a.out\n"}
        arguments.update(kwargs)
        result = set_compile_script.handle(arguments, self.ctx)
        return json.loads(result[0].text)

    def test_omitted_config_name_writes_shared_script(self) -> None:
        data = self._handle()
        self.assertEqual(data["status"], "success")
        self.assertNotIn("config_name", data)
        shared_path = os.path.join(self.configs_dir, "compile.sh")
        self.assertEqual(data["path"], shared_path)
        self.assertTrue(os.path.exists(shared_path))
        self.assertFalse(os.path.exists(os.path.join(self.configs_dir, "default", "compile.sh")))

    def test_valid_config_name_writes_per_config_script_only(self) -> None:
        data = self._handle(config_name="default")
        self.assertEqual(data["status"], "success")
        self.assertEqual(data["config_name"], "default")
        per_config_path = os.path.join(self.configs_dir, "default", "compile.sh")
        self.assertEqual(data["path"], per_config_path)
        self.assertTrue(os.path.exists(per_config_path))
        self.assertFalse(os.path.exists(os.path.join(self.configs_dir, "compile.sh")))

    def test_nonexistent_config_name_errors_without_writing(self) -> None:
        data = self._handle(config_name="does_not_exist")
        self.assertEqual(data["status"], "error")
        self.assertFalse(os.path.exists(os.path.join(self.configs_dir, "does_not_exist")))
        self.assertFalse(os.path.exists(os.path.join(self.configs_dir, "compile.sh")))

    def test_uninitialized_project_errors(self) -> None:
        with tempfile.TemporaryDirectory() as empty_project:
            arguments = {"project_path": empty_project, "script_body": "exit 0\n"}
            result = set_compile_script.handle(arguments, self.ctx)
            data = json.loads(result[0].text)
            self.assertEqual(data["status"], "error")


if __name__ == "__main__":
    unittest.main()
