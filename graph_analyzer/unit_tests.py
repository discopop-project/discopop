import unittest
import os


class GraphAnalyzerTest(unittest.TestCase):
    def test_analyzer_end_to_end(self):
        path = './../../unittests/data'
        for file in [f.name for f in os.scandir(path) if f.name.endswith('.json')]:
            with self.subTest(file=file):
                pass


if __name__ == '__main__':
    unittest.main()
