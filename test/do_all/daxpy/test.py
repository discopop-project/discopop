import os
import unittest
import pathlib
import jsonpickle

from discopop_explorer.test.utils.validators import check_do_all_equivalence
from discopop_library.result_classes.DetectionResult import DetectionResult


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
        make_command = "DP_FM_PATH=" + os.path.join(src_dir, "FileMapping.txt") + " "
        make_command += "CC=" + os.path.join(build_dir, "scripts", "CC_wrapper.sh") + " "
        make_command += "CXX=" + os.path.join(build_dir, "scripts", "CXX_wrapper.sh") + " "
        make_command += "LINKER=" + os.path.join(build_dir, "scripts", "LINKER_wrapper.sh") + " "
        make_command += "make "
        os.system(make_command)
        # execute instrumented program
        os.system("./prog")
        # execute DiscoPoP analysis
        os.system("discopop_explorer --dep-file=prog_dep.txt")
        # validate results
        validation_result = validate_results(current_dir, src_dir)
        # clean environment
        os.system("make veryclean")

        self.assertTrue(validation_result)


def validate_results(test_dir, src_dir) -> bool:
    """compare results to gold standard"""
    gold_standard_file = os.path.join(test_dir, "detection_result_dump.json")
    test_output_file = os.path.join(src_dir, "detection_result_dump.json")
    # load both detection results
    tmp_str = ""
    with open(gold_standard_file, "r") as f:
        tmp_str = f.read()
    gold_standard: DetectionResult = jsonpickle.decode(tmp_str)

    tmp_str = ""
    with open(test_output_file, "r") as f:
        tmp_str = f.read()
    test_output: DetectionResult = jsonpickle.decode(tmp_str)

    # check both ways to ensure exactly the correct patterns have been identified
    return check_do_all_equivalence(gold_standard.do_all, test_output.do_all)
