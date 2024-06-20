import os
import pathlib
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.subprocess_wrapper.command_execution_wrapper import run_cmd
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation

from discopop_library.ConfigProvider.config_provider import run as run_config_provider
from discopop_library.ConfigProvider.ConfigProviderArguments import ConfigProviderArguments


class TestMethods(unittest.TestCase):
    def setUp(self):
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
        os.chdir(src_dir)

        # create FileMapping
        cmd = os.path.join(dp_build_dir, "scripts", "dp-fmap")
        run_cmd(cmd, src_dir, env_vars)

        # build
        env_vars["CC"] = os.path.join(dp_build_dir, "scripts", "CC_wrapper.sh")
        env_vars["CXX"] = os.path.join(dp_build_dir, "scripts", "CXX_wrapper.sh")
        cmd = "make"
        run_cmd(cmd, src_dir, env_vars)

        # execute instrumented program
        run_cmd("./prog", src_dir, env_vars)
        # execute DiscoPoP analysis

        cwd = os.path.join(src_dir, ".discopop")
        cmd = "discopop_explorer --enable-patterns doall,reduction"
        run_cmd(cmd, cwd, env_vars)

        self.src_dir = src_dir
        self.env_vars = env_vars

    def tearDown(self):
        run_cmd("make veryclean", self.src_dir, self.env_vars)

    def test(self):
        """Check that exactly one do-all is suggested"""
        test_output_file = os.path.join(self.src_dir, ".discopop", "explorer", "detection_result_dump.json")
        # load detection results
        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        test_output: DetectionResult = jsonpickle.decode(tmp_str)

        for pattern_type in test_output.patterns.__dict__:
            amount_of_identified_patterns = len(test_output.patterns.__dict__[pattern_type])
            if pattern_type == "do_all":
                self.assertEqual(amount_of_identified_patterns, 0)
            else:
                self.assertEqual(amount_of_identified_patterns, 0)
