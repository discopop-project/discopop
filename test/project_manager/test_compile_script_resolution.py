# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import tempfile
import unittest

from discopop_library.ProjectManager.configurations.compile_script import (
    get_per_config_compile_script_path,
    get_shared_compile_script_path,
    resolve_compile_script_path,
)


class TestCompileScriptResolution(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp_dir = tempfile.TemporaryDirectory()
        self.project_config_dir = self._tmp_dir.name
        os.makedirs(os.path.join(self.project_config_dir, "foo"))

    def tearDown(self) -> None:
        self._tmp_dir.cleanup()

    def test_path_builder_helpers_join_correctly(self) -> None:
        self.assertEqual(
            get_shared_compile_script_path(self.project_config_dir),
            os.path.join(self.project_config_dir, "compile.sh"),
        )
        self.assertEqual(
            get_per_config_compile_script_path(self.project_config_dir, "foo"),
            os.path.join(self.project_config_dir, "foo", "compile.sh"),
        )

    def test_resolve_falls_back_to_shared_when_no_override(self) -> None:
        shared_path = get_shared_compile_script_path(self.project_config_dir)
        with open(shared_path, "w") as f:
            f.write("#!/bin/bash\nexit 0\n")

        self.assertEqual(
            resolve_compile_script_path(self.project_config_dir, "foo"),
            shared_path,
        )

    def test_resolve_prefers_per_config_when_present(self) -> None:
        shared_path = get_shared_compile_script_path(self.project_config_dir)
        with open(shared_path, "w") as f:
            f.write("#!/bin/bash\nexit 0\n")

        per_config_path = get_per_config_compile_script_path(self.project_config_dir, "foo")
        with open(per_config_path, "w") as f:
            f.write("#!/bin/bash\nexit 1\n")

        self.assertEqual(
            resolve_compile_script_path(self.project_config_dir, "foo"),
            per_config_path,
        )

    def test_resolve_handles_nonexistent_config_dir(self) -> None:
        # no "bar" subdirectory exists under project_config_dir
        self.assertEqual(
            resolve_compile_script_path(self.project_config_dir, "bar"),
            get_shared_compile_script_path(self.project_config_dir),
        )


if __name__ == "__main__":
    unittest.main()
