import unittest
import os


class GraphAnalyzerTest(unittest.TestCase):
    def test_analyzer_end_to_end(self):
        path = './../../unittests/data'

        for file in [f.name for f in os.scandir(path) if f.name.endswith('.json')]:
            print(file)
            with self.subTest(file=file):
                if file.endswith(".json"):
                    continue
                else:
                    continue


if __name__ == '__main__':
    unittest.main()
