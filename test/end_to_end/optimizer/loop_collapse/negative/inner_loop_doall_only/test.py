# type: ignore
import os
import pathlib
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.subprocess_wrapper.command_execution_wrapper import run_cmd
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation
from discopop_library.ConfigProvider.config_provider import run as run_config_provider
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments
from discopop_library.DependencyComparator.DependencyComparatorArguments import DependencyComparatorArguments
from discopop_library.DependencyComparator.dependency_comparator import run as run_comparator


class TestMethods(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        current_dir = pathlib.Path(__file__).parent.resolve()
        dp_build_dir = run_config_provider(
            ConfigProviderArguments(
                return_dp_build_dir=True,
                return_dp_source_dir=False,
                return_llvm_bin_dir=False,
                return_version_string=False,
            )
        )

        env_vars = dict(os.environ)

        src_dir = os.path.join(current_dir, "src")

        # create FileMapping
        cmd = os.path.join(dp_build_dir, "scripts", "dp-fmap")
        run_cmd(cmd, src_dir, env_vars)

        # build
        env_vars["CC"] = os.path.join(dp_build_dir, "scripts", "CC_wrapper.sh")
        env_vars["CXX"] = os.path.join(dp_build_dir, "scripts", "CXX_wrapper.sh")
        env_vars["DP_PROJECT_ROOT_DIR"] = src_dir
        cmd = "make"
        run_cmd(cmd, src_dir, env_vars)
        # execute instrumented program
        cmd = "./prog"
        run_cmd(cmd, src_dir, env_vars)
        # execute DiscoPoP analysis
        cwd = os.path.join(src_dir, ".discopop")
        run_cmd("discopop_explorer", cwd, env_vars)
        run_cmd("discopop_optimizer -o3", cwd, env_vars)

        self.src_dir = src_dir
        self.env_vars = env_vars

        test_output_file = os.path.join(self.src_dir, ".discopop", "explorer", "detection_result_dump.json")
        # load detection results
        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        self.test_output: DetectionResult = jsonpickle.decode(tmp_str)

    @classmethod
    def tearDownClass(self):
        run_cmd("make veryclean", self.src_dir, self.env_vars)

    def test(self):
        """Check that not collapse has been identified"""
        # check identified DoAllInfo objects for collapse clauses > 1
        for do_all_info in self.test_output.patterns.do_all:
            self.assertTrue(do_all_info.collapse_level <= 1)

    def test_dynamic_deps(self) -> None:
        # compare detected dependencies to gold standard
        current_dir = pathlib.Path(__file__).parent.resolve()
        gold_standard_dir = os.path.join(current_dir, "gold_std")
        test_output_dir = os.path.join(self.src_dir, ".discopop", "profiler")
        dynamic_gold_std = os.path.join(gold_standard_dir, "dynamic_dependencies.txt")
        dynamic_test_result = os.path.join(test_output_dir, "dynamic_dependencies.txt")
        self.assertEqual(
            run_comparator(DependencyComparatorArguments(dynamic_gold_std, dynamic_test_result, "None", False)), 0
        )

    def test_static_deps(self) -> None:
        # compare detected dependencies to gold standard
        current_dir = pathlib.Path(__file__).parent.resolve()
        gold_standard_dir = os.path.join(current_dir, "gold_std")
        test_output_dir = os.path.join(self.src_dir, ".discopop", "profiler")
        static_gold_std = os.path.join(gold_standard_dir, "static_dependencies.txt")
        static_test_result = os.path.join(test_output_dir, "static_dependencies.txt")
        self.assertEqual(
            run_comparator(DependencyComparatorArguments(static_gold_std, static_test_result, "None", False)), 0
        )
