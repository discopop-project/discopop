import os
import pathlib
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation


class TestMethods(unittest.TestCase):
    def test(self):
        current_dir = pathlib.Path(__file__).parent.resolve()
        discopop_dir = os.path.join(current_dir, "..", "..", "..", "..", "..")
        build_dir = os.path.join(discopop_dir, "build")

        src_dir = os.path.join(current_dir, "src")
        os.chdir(src_dir)

        # create FileMapping
        os.system("" + os.path.join(build_dir, "scripts", "dp-fmap"))

        # build
        # make_command = "DP_FM_PATH=" + os.path.join(src_dir, "FileMapping.txt") + " "
        make_command = ""
        make_command += "CC=" + os.path.join(build_dir, "scripts", "CC_wrapper.sh") + " "
        make_command += "CXX=" + os.path.join(build_dir, "scripts", "CXX_wrapper.sh") + " "
        # make_command += "LINKER=" + os.path.join(build_dir, "scripts", "LINKER_wrapper.sh") + " "
        make_command += "make "
        os.system(make_command)
        # execute instrumented program
        os.system("./prog")
        # execute DiscoPoP analysis
        os.chdir(".discopop")
        os.system("discopop_explorer")
        os.system("discopop_optimizer -x")
        os.chdir("..")
        # validate results
        self.validate_results(current_dir, src_dir)
        # clean environment
        os.system("make veryclean")

    def validate_results(self, test_dir, src_dir):
        """Check that not collapse has been identified"""
        
        # load test output
        test_output_file = os.path.join(src_dir, ".discopop", "optimizer", "detection_result_dump.json")
        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        test_output: DetectionResult = jsonpickle.decode(tmp_str)

        # check identified DoAllInfo objects for collapse clauses > 1
        for do_all_info in test_output.do_all:
            self.assertTrue(do_all_info.collapse_level <= 1)


