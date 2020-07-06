import unittest
import os
import json
from graph_analyzer import run
from json_serializer import PatternInfoSerializer


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

                with open(os.path.join(path, file)) as f:
                    expected = json.load(f)
                actual = json.loads(json.dumps(res, cls=PatternInfoSerializer))
                equal = ordered(expected) == ordered(actual)
                if not equal:
                    print(expected)
                    print(actual)
                self.assertTrue(equal)


def ordered(obj):
    if isinstance(obj, dict):
        return sorted((k, ordered(v)) for k, v in obj.items())
    if isinstance(obj, list):
        return sorted(ordered(x) for x in obj)
    else:
        return obj


if __name__ == '__main__':
    unittest.main()
