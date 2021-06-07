import unittest
import os
from pathlib import Path, PurePath

from discopop.discopop_validation.interfaces.discopop_explorer import get_parallelization_suggestions, get_relevant_sections


class MyTestCase(unittest.TestCase):
    def test_obtain_simple_suggestions(self):
        cu_xml = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/Data.xml")
        dep_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/simple_doall_dp_run_dep.txt")
        loop_counter_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/loop_counter_output.txt")
        reduction_file = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/reduction.txt")
        plugins = []
        file_mapping = os.path.join(str(Path(__file__).resolve().parent.parent), "simple_doall/FileMapping.txt")
        suggestions = get_parallelization_suggestions(cu_xml, dep_file, loop_counter_file, reduction_file, plugins, file_mapping=file_mapping)
        self.assertEqual(len(suggestions.do_all), 1)
        self.assertEqual(len(suggestions.geometric_decomposition), 1)
        self.assertEqual(["arr"], [s.name for s in suggestions.do_all[0].shared])
        return suggestions

    def test_relevant_sections_simple(self):
        suggestions = self.test_obtain_simple_suggestions()
        relevant_sections = get_relevant_sections(suggestions)
        self.assertEqual([("1:6", "1:8", "arr")], relevant_sections)
