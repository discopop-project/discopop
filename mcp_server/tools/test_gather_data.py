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
from typing import Any, Callable, List, Optional, Tuple
from unittest import mock

from mcp_server.tools import gather_data
from mcp_server.tools.helpers import ToolContext

CONFIG_NAME = "default"


class TestGatherDataCompileScriptResolution(unittest.TestCase):
    """The instrumentation steps must honour a per-configuration compile.sh override."""

    def setUp(self) -> None:
        self._tmp_dir = tempfile.TemporaryDirectory()
        self.project_path = self._tmp_dir.name
        self.configs_dir = os.path.join(self.project_path, ".discopop", "project", "configs")
        os.makedirs(os.path.join(self.configs_dir, CONFIG_NAME))
        self.ctx = ToolContext(debug=False)

        for filename in ["compile.sh", "hd_settings.json", "dp_settings.json"]:
            self.__write(filename)

        self.script_paths: List[str] = []
        # _instrument_project treats a build that produced no Data.xml as a failure
        data_xml = os.path.join(self.project_path, ".discopop", "profiler", "Data.xml")

        def fake_execute_configuration(**kwargs: Any) -> Tuple[int, float, str, str]:
            self.script_paths.append(kwargs["script_path"])
            os.makedirs(os.path.dirname(data_xml), exist_ok=True)
            with open(data_xml, "w") as f:
                f.write("<Nodes></Nodes>\n")
            return (0, 1.0, "", "")

        patcher = mock.patch.object(gather_data, "execute_configuration", side_effect=fake_execute_configuration)
        patcher.start()
        self.addCleanup(patcher.stop)

    def tearDown(self) -> None:
        self._tmp_dir.cleanup()

    def __write(self, *parts: str) -> str:
        path = os.path.join(self.configs_dir, *parts)
        with open(path, "w") as f:
            f.write("{}\n" if path.endswith(".json") else "#!/bin/bash\nexit 0\n")
        return path

    def __steps(self) -> List[Tuple[str, Callable[..., dict[str, Any]]]]:
        return [
            ("hotspot", gather_data._hotspot_instrument),
            ("instrument", gather_data._instrument_project),
        ]

    def __run(self, step: Callable[..., dict[str, Any]], config_name: str = CONFIG_NAME) -> dict[str, Any]:
        self.script_paths.clear()
        return step(self.project_path, config_name, 60, True, self.ctx, None)

    def test_shared_script_is_used_without_an_override(self) -> None:
        for name, step in self.__steps():
            with self.subTest(step=name):
                result = self.__run(step)
                self.assertEqual(result["status"], "success")
                self.assertEqual(self.script_paths, [os.path.join(self.configs_dir, "compile.sh")])

    def test_per_config_override_is_used_when_present(self) -> None:
        override = self.__write(CONFIG_NAME, "compile.sh")
        for name, step in self.__steps():
            with self.subTest(step=name):
                result = self.__run(step)
                self.assertEqual(result["status"], "success")
                self.assertEqual(self.script_paths, [override])

    def test_missing_configuration_errors_before_compiling(self) -> None:
        for name, step in self.__steps():
            with self.subTest(step=name):
                result = self.__run(step, config_name="does_not_exist")
                self.assertEqual(result["status"], "error")
                self.assertIn("does_not_exist", result["message"])
                self.assertEqual(self.script_paths, [])

    def test_missing_shared_script_errors_when_no_override_exists(self) -> None:
        os.remove(os.path.join(self.configs_dir, "compile.sh"))
        for name, step in self.__steps():
            with self.subTest(step=name):
                result = self.__run(step)
                self.assertEqual(result["status"], "error")
                self.assertIn("compile.sh not found", result["message"])
                self.assertEqual(self.script_paths, [])

    def test_override_satisfies_the_check_without_a_shared_script(self) -> None:
        os.remove(os.path.join(self.configs_dir, "compile.sh"))
        override = self.__write(CONFIG_NAME, "compile.sh")
        for name, step in self.__steps():
            with self.subTest(step=name):
                result = self.__run(step)
                self.assertEqual(result["status"], "success")
                self.assertEqual(self.script_paths, [override])


if __name__ == "__main__":
    unittest.main()
