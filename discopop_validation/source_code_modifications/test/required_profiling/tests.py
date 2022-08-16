import os
import unittest

from discopop_validation.source_code_modifications.CodeDifferences import file_difference_checker


class TestSourceCodeModifications(unittest.TestCase):
    def test_yes_added_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "yes/added_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertTrue(profiling_required)


    def test_yes_removed_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "yes/removed_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertTrue(profiling_required)


    def test_yes_modified_line(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "yes/modified_line"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertTrue(profiling_required)

    def test_no_added_pragma(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/added_pragma"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)


    def test_no_removed_pragma(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/removed_pragma"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)


    def test_no_modified_pragma(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/modified_pragma"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)


    def test_no_added_braces(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/added_braces"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)


    def test_no_added_braced_pragma(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/added_braced_pragma"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)


    def test_no_removed_braced_pragma(self):
        path = os.path.dirname(os.path.abspath(__file__))
        dir_name = "no/removed_braced_pragma"
        original_file = path + "/" + dir_name + "/original.c"
        modified_file = path + "/" + dir_name + "/modified.c"
        line_mapping, profiling_required = file_difference_checker(original_file, modified_file)
        self.assertFalse(profiling_required)