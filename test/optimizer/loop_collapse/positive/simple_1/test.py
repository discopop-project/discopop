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
        env_vars["CC"] = os.path.join(dp_build_dir, "scripts", "CC_wrapper.sh")
        env_vars["CXX"] = os.path.join(dp_build_dir, "scripts", "CXX_wrapper.sh")
        cmd = "make "
        run_cmd(cmd, src_dir, env_vars)
        # execute instrumented program
        run_cmd("./prog", src_dir, env_vars)
        # execute DiscoPoP analysis
        cmd = "discopop_explorer --enable-patterns doall,reduction"
        cwd = os.path.join(src_dir, ".discopop")
        run_cmd(cmd, cwd, env_vars)
        cmd = "discopop_optimizer -o3"
        run_cmd(cmd, cwd, env_vars)
        # cleanup
        self.addCleanup(run_cmd, cmd, src_dir, env_vars)
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
        """Check that a 2-level collapse has been identified"""

        # load test output
        test_output_file = os.path.join(src_dir, ".discopop", "optimizer", "detection_result_dump.json")
        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        test_output: DetectionResult = jsonpickle.decode(tmp_str)

        # check identified DoAllInfo objects for collapse clauses > 1
        two_level_collapse_found = False
        for do_all_info in test_output.patterns.do_all:
            if do_all_info.collapse_level == 2:
                two_level_collapse_found = True

        self.assertTrue(two_level_collapse_found)
