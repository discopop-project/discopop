import json
import os
import unittest
from pathlib import Path

from discopop_explorer import run
from discopop_explorer.json_serializer import PatternInfoSerializer


class GraphAnalyzerTest(unittest.TestCase):
    def test_analyzer_end_to_end(self):
        """Analyzer end-to-end test"""
        # TODO upload test data?
        path = Path(__file__).parent.parent.parent / 'test'
        for file in [f.name for f in os.scandir(path) if f.name.endswith('.json')]:
            with self.subTest(file=file):
                cu_xml = os.path.join(path, file[:-5], 'data', 'Data.xml')
                dep_file = os.path.join(path, file[:-5], 'data', 'dp_run_dep.txt')
                loop_counter_file = os.path.join(path, file[:-5], 'data', 'loop_counter_output.txt')
                reduction_file = os.path.join(path, file[:-5], 'data', 'reduction.txt')
                res = run(cu_xml, dep_file, loop_counter_file, reduction_file, [])

                with open(os.path.join(path, file)) as f:
                    expected = ordered(json.load(f))
                actual = ordered(json.loads(json.dumps(res, cls=PatternInfoSerializer)))
                equal = expected == actual
                if not equal:
                    print('##expected##')
                    print(json.dumps(expected, indent=2))
                    print('##actual##')
                    print(json.dumps(actual, indent=2))
                    print('##end##')
                self.assertTrue(equal, 'Expected and actual detection result are not equal')


def ordered(obj):
    if isinstance(obj, dict):
        return sorted((k, ordered(v)) for k, v in obj.items())
    if isinstance(obj, list):
        return sorted(ordered(x) for x in obj)
    else:
        return obj
