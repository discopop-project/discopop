import unittest
import os
from pathlib import Path

from discopop.discopop_validation.explorer_interface.interface import get_parallelization_suggestions


class MyTestCase(unittest.TestCase):
    def test_obtain_suggestions(self):
        cu_xml = os.path.join(str(Path(__file__).resolve().parent), "/simple_doall/Data.xml")
        loop_counter_file = os.path.join(str(Path(__file__).resolve().parent), "/simple_doall/loop_counter_output.txt")
        reduction_file = os.path.join(str(Path(__file__).resolve().parent), "/simple_doall/reduction.txt")
        plugins = []
        suggestions = get_parallelization_suggestions(cu_xml, loop_counter_file, reduction_file, plugins)
        self.assertEqual(len(suggestions), 2)




