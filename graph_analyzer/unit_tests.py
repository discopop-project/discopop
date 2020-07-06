import unittest
import os
from graph_analyzer import run


class GraphAnalyzerTest(unittest.TestCase):
    def test_analyzer_end_to_end(self):
        # TODO upload test data?
        path = './../../unittests/data'
        for file in [f.name for f in os.scandir(path) if f.name.endswith('.json')]:
            with self.subTest(file=file):
                cu_xml = os.path.join(path, file[:-5], 'MINI_DATASET', 'Data.xml')
                dep_file = os.path.join(path, file[:-5], 'MINI_DATASET', 'dp_run_dep.txt')
                loop_counter_file = os.path.join(path, file[:-5], 'MINI_DATASET', 'loop_counter_output.txt')
                reduction_file = os.path.join(path, file[:-5], 'MINI_DATASET', 'reduction.txt')
                res = run(cu_xml, dep_file, loop_counter_file, reduction_file, [])
                print(res)


if __name__ == '__main__':
    unittest.main()
