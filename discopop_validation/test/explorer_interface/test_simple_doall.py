import unittest
import os
from pathlib import Path

from discopop.discopop_validation.interfaces.discopop_explorer import get_parallelization_suggestions
from discopop.discopop_validation.interfaces.behavior_extraction import get_relevant_sections_from_suggestions, execute_behavior_extraction


class MyTestCase(unittest.TestCase):
    def test_obtain_simple_suggestions(self):
        cu_xml = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/Data.xml")
        dep_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/simple_doall_dp_run_dep.txt")
        loop_counter_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/loop_counter_output.txt")
        reduction_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/reduction.txt")
        plugins = []
        file_mapping = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/FileMapping.txt")
        suggestions = get_parallelization_suggestions(cu_xml, dep_file, loop_counter_file, reduction_file, plugins, file_mapping=file_mapping)
        self.assertEqual(len(suggestions.do_all), 2)
        self.assertEqual(len(suggestions.geometric_decomposition), 2)
        self.assertEqual(["arr"], [s.name for s in suggestions.do_all[0].shared])
        return suggestions

    def test_relevant_sections_simple(self):
        suggestions = self.test_obtain_simple_suggestions()
        relevant_sections = get_relevant_sections_from_suggestions(suggestions)
        self.assertIn(("0", "1:7", "1:13", "arr"), relevant_sections)

    def test_execute_behavior_extraction(self):
        suggestions = self.test_obtain_simple_suggestions()
        file_mapping = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/FileMapping.txt")
        ll_file_path = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/simple_doall_dp.ll")
        execute_behavior_extraction(suggestions, file_mapping, ll_file_path)
