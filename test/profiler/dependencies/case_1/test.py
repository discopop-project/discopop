# type: ignore
import copy
import os
import pathlib
import subprocess
import unittest

import jsonpickle

from test.utils.subprocess_wrapper.command_execution_wrapper import run_cmd
from discopop_library.ConfigProvider.config_provider import run as run_config_provider
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.DependencyComparator.dependency_comparator import run as run_comparator
from discopop_library.DependencyComparator.DependencyComparatorArguments import DependencyComparatorArguments
from subprocess import DEVNULL


class TestMethods(unittest.TestCase):
    @classmethod
    def setUpClass(self) -> None:
        self.current_dir = pathlib.Path(__file__).parent.resolve()
        dp_build_dir = run_config_provider(
            ConfigProviderArguments(
                return_dp_build_dir=True,
                return_dp_source_dir=False,
                return_llvm_bin_dir=False,
                return_full_config=False,
                return_version_string=False,
            )
        )
        self.env_vars = dict(os.environ)

        self.src_dir = os.path.join(self.current_dir, "src")

        # create FileMapping
        cmd = os.path.join(dp_build_dir, "scripts", "dp-fmap")
        run_cmd(cmd, self.src_dir, self.env_vars)

        # build
        self.env_vars["CC"] = os.path.join(dp_build_dir, "scripts", "CC_wrapper.sh")
        self.env_vars["CXX"] = os.path.join(dp_build_dir, "scripts", "CXX_wrapper.sh")
        self.env_vars["DP_PROJECT_ROOT_DIR"] = self.src_dir
        cmd = "make"
        run_cmd(cmd, self.src_dir, self.env_vars)
        # execute instrumented program
        cmd = "./prog"
        run_cmd(cmd, self.src_dir, self.env_vars)

        self.gold_standard_dir = os.path.join(self.current_dir, "gold_std")
        self.test_output_dir = os.path.join(self.src_dir, ".discopop", "profiler")

    @classmethod
    def tearDownClass(self):
        run_cmd("make veryclean", self.src_dir, self.env_vars)

    def test_dynamic_deps(self) -> None:
        # compare detected dependencies to gold standard
        gold_standard_dir = os.path.join(self.current_dir, "gold_std")
        test_output_dir = os.path.join(self.src_dir, ".discopop", "profiler")
        dynamic_gold_std = os.path.join(gold_standard_dir, "dynamic_dependencies.txt")
        dynamic_test_result = os.path.join(test_output_dir, "dynamic_dependencies.txt")
        self.assertEqual(
            run_comparator(DependencyComparatorArguments(dynamic_gold_std, dynamic_test_result, "None", False)), 0
        )

    def test_static_deps(self) -> None:
        # compare detected dependencies to gold standard
        gold_standard_dir = os.path.join(self.current_dir, "gold_std")
        test_output_dir = os.path.join(self.src_dir, ".discopop", "profiler")
        static_gold_std = os.path.join(gold_standard_dir, "static_dependencies.txt")
        static_test_result = os.path.join(test_output_dir, "static_dependencies.txt")
        self.assertEqual(
            run_comparator(DependencyComparatorArguments(static_gold_std, static_test_result, "None", False)), 0
        )
