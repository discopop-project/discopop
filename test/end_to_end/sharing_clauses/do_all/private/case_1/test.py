import copy
import os
import pathlib
import subprocess
from typing import Dict, List
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.sharing_clauses.clauses_utils import check_clauses_for_FN, check_clauses_for_FP
from test.utils.subprocess_wrapper.command_execution_wrapper import run_cmd
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation
from subprocess import DEVNULL
from discopop_library.ConfigProvider.config_provider import run as run_config_provider
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments


class TestMethods(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        current_dir = pathlib.Path(__file__).parent.resolve()
        dp_build_dir = run_config_provider(
            ConfigProviderArguments(
                return_dp_build_dir=True,
                return_dp_source_dir=False,
                return_llvm_bin_dir=False,
                return_full_config=False,
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
        run_cmd("./prog", src_dir, env_vars)

        # execute DiscoPoP analysis
        cmd = "discopop_explorer --enable-patterns doall,reduction"
        run_cmd(cmd, os.path.join(src_dir, ".discopop"), env_vars)

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
        self.assertIn("do_all", self.test_output.patterns.__dict__)
        doall_patterns = self.test_output.patterns.__dict__["do_all"]
        self.assertEqual(len(doall_patterns), 1)
        do_all_pattern = doall_patterns[0]

        expected_clauses: Dict[str, List[str]] = {"shared": ["y"], "private": ["z"]}

        with self.subTest("check pattern for FP data sharing clauses"):
            res, msg = check_clauses_for_FP(self, expected_clauses, do_all_pattern)
            self.assertTrue(res, msg)
        with self.subTest("check pattern for FN data sharing clauses"):
            res, msg = check_clauses_for_FN(self, expected_clauses, do_all_pattern)
            self.assertTrue(res, msg)


