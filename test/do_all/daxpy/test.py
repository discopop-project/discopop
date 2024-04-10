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
    def test(self):
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
        # make_command = "DP_FM_PATH=" + os.path.join(src_dir, "FileMapping.txt") + " "
        env_vars["CC"] = os.path.join(dp_build_dir, "scripts", "CC_wrapper.sh")
        env_vars["CXX"] = os.path.join(dp_build_dir, "scripts", "CXX_wrapper.sh")
        cmd = "make"
        run_cmd(cmd, src_dir, env_vars)

        # execute instrumented program
        cmd = "./prog"
        run_cmd(cmd, src_dir, env_vars)
        # execute DiscoPoP analysis
        cwd = os.path.join(src_dir, ".discopop")
        cmd = "discopop_explorer"
        run_cmd(cmd, cwd, env_vars)
        # validate results
        try:
            self.validate_results(current_dir, src_dir)
            # clean environment
            run_cmd("make veryclean", src_dir, env_vars)
        except Exception as ex:
            # clean environment
            run_cmd("make veryclean", src_dir, env_vars)
            raise ex

    def validate_results(self, test_dir, src_dir):
        """compare results to gold standard"""
        gold_standard_file = os.path.join(test_dir, "detection_result_dump.json")
        test_output_file = os.path.join(src_dir, ".discopop", "explorer", "detection_result_dump.json")
        # load both detection results
        with open(gold_standard_file, "r") as f:
            tmp_str = f.read()
        gold_standard: DetectionResult = jsonpickle.decode(tmp_str)

        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        test_output: DetectionResult = jsonpickle.decode(tmp_str)

        # convert DoAllInfo objects to DoAllInfoForValidation objects to make use of custom __eq__
        converted_gold_standard = [DoAllInfoForValidation(elem) for elem in gold_standard.do_all]
        converted_test_output = [DoAllInfoForValidation(elem) for elem in test_output.patterns.do_all]

        # sort the lists
        converted_gold_standard = sorted(
            converted_gold_standard, key=lambda x: (x.dai.node_id, x.dai.start_line, x.dai.end_line)
        )
        converted_test_output = sorted(
            converted_test_output, key=lambda x: (x.dai.node_id, x.dai.start_line, x.dai.end_line)
        )
        # compare doall list elements
        self.assertListEqual(converted_gold_standard, converted_test_output)
