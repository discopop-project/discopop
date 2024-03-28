import os
import pathlib
import subprocess
import unittest

import jsonpickle

from discopop_library.result_classes.DetectionResult import DetectionResult
from test.utils.validator_classes.DoAllInfoForValidation import DoAllInfoForValidation


class TestMethods(unittest.TestCase):
    def test(self):
        current_dir = pathlib.Path(__file__).parent.resolve()
        discopop_dir = os.path.join(current_dir, "..", "..", "..", "..")
        build_dir = os.path.join(discopop_dir, "build")

        src_dir = os.path.join(current_dir, "src")
        # create FileMapping
        subprocess.run(os.path.join(build_dir, "scripts", "dp-fmap"), cwd=src_dir, executable="/bin/bash", shell=True)

        # build
        # make_command = "DP_FM_PATH=" + os.path.join(src_dir, "FileMapping.txt") + " "
        make_command = ""
        make_command += "CC=" + os.path.join(build_dir, "scripts", "CC_wrapper.sh") + " "
        make_command += "CXX=" + os.path.join(build_dir, "scripts", "CXX_wrapper.sh") + " "
        # make_command += "LINKER=" + os.path.join(build_dir, "scripts", "LINKER_wrapper.sh") + " "
        make_command += "make "
        subprocess.run(make_command.split(" "), cwd=src_dir, executable="/bin/bash", shell=True)

        # execute instrumented program
        subprocess.run("./prog", cwd=src_dir, executable="/bin/bash", shell=True)

        # execute DiscoPoP analysis
        subprocess.run(
            ["discopop_explorer", "--enable-patterns doall,reduction"], cwd=src_dir, executable="/bin/bash", shell=True
        )
        # validate results
        self.validate_results(current_dir, src_dir)
        # clean environment
        subprocess.run(["make", "veryclean"], cwd=src_dir, executable="/bin/bash", shell=True)

    def validate_results(self, test_dir, src_dir):
        """Check that exactly one do-all is suggested"""
        test_output_file = os.path.join(src_dir, ".discopop", "explorer", "detection_result_dump.json")
        # load detection results
        with open(test_output_file, "r") as f:
            tmp_str = f.read()
        test_output: DetectionResult = jsonpickle.decode(tmp_str)

        for pattern_type in test_output.patterns.__dict__:
            print("Pattern type: ", pattern_type)
            amount_of_identified_patterns = len(test_output.patterns.__dict__[pattern_type])
            if pattern_type == "do_all":
                self.assertEqual(amount_of_identified_patterns, 1)
            else:
                self.assertEqual(amount_of_identified_patterns, 0)
