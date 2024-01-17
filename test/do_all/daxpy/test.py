import os
import pathlib
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation


class TestMethods(unittest.TestCase):
    def test(self):
        current_dir = pathlib.Path(__file__).parent.resolve()
        discopop_dir = os.path.join(current_dir, "..", "..", "..")
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
        os.chdir("..")
        # validate results
        self.validate_results(current_dir, src_dir)
        # clean environment
        os.system("make veryclean")

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
