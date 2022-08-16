import os
import unittest

from discopop_validation.source_code_modifications.CodeDifferences import file_difference_checker


class TestSourceCodeModifications(unittest.TestCase):
    def test_add_line_before(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "add/line_before"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            1: 2
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_add_line_after(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "add/line_after"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: 3
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_add_line_after_last_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "add/line_after_last_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_add_two_lines(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "add/two_lines"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: 4
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_add_two_lines_distributed(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "add/two_lines_distributed"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: 3,
            3: 5
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_remove_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "remove/line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: -1,
            3: 2
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)

    def test_remove_last_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "remove/last_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: -1
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_remove_two_lines(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "remove/two_lines"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: -1,
            3: -1,
            4: 2
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_remove_two_lines_distributed(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "remove/two_lines_distributed"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {
            2: -1,
            3: 2,
            4: -1,
            5: 3
        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_modify_single_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "modify/single_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {

        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)

    def test_modify_two_lines(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "modify/two_lines"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {

        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)


    def test_modify_two_lines_distributed(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "modify/two_lines_distributed"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        expected_line_mapping = {

        }
        self.assertEqual(line_mapping, expected_line_mapping)
        self.assertTrue(profiling_required)