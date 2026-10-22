# type: ignore
"""A function that calls itself from inside one of its loops: the states of the recursion levels and the loop
accounting of the profiler.

The call paths of the profiler used to be cut at a recursive call, so every recursion level shared the states of the
first one. Two things followed from it:
- a dependence between an iteration of the caller (a write) and an iteration of the callee (a read) looked like a
  dependence between iterations of one loop execution, because both ends lie in the same state of the same function
  with different iteration buckets. The explorer rejected such loops as not parallel (uts of the omp-tasks tests),
- the loop stack of the runtime compared the loop only by its id, so the entry of a recursive instance of a loop
  counted as one more iteration of the loop of the caller (wrong iteration counts, and the explorer saw "fewer than
  two iterations").
The recursion depth is now part of the call path: three levels, then the states of the first level are used again.
Known failures are marked with unittest.expectedFailure; the tests that cover the fix remove the mark."""

import json
import os
import unittest
import pathlib
import re

from test.end_to_end.pipeline import PipelineTestCase

SRC = pathlib.Path(__file__).parent / "src" / "code.cpp"
# the number of recursion levels the states distinguish; deeper levels use the states of the first one again
RECURSION_DEPTH_BUCKETS = 3


def loop_lines():
    """{name: line of the loop marked "// LOOP:<name>" in code.cpp}"""
    lines = dict()
    for number, text in enumerate(SRC.read_text().splitlines(), start=1):
        marker = re.search(r"// LOOP:(\w+)", text)
        if marker:
            lines[marker.group(1)] = number
    return lines


class TestRecursionStates(PipelineTestCase):
    SRC_DIR = SRC.parent
    ENABLE_PATTERNS = "doall,reduction"

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        # callpath per state id, from the prefix tree "<state_id> <parent_state_id> <label>"
        tree = dict()
        with open(os.path.join(cls.profiler_dir, "stateID_to_callpath_mapping.txt")) as f:
            for line in f:
                fields = line.split()
                if len(fields) >= 3 and not line.startswith("#"):
                    tree[fields[0]] = (fields[1], fields[2])

        def callpath(state_id):
            labels = []
            while state_id in tree and tree[state_id][0] != state_id and len(labels) < 1000:
                labels.append(tree[state_id][1])
                state_id = tree[state_id][0]
            return list(reversed(labels))

        cls.callpath = staticmethod(callpath)
        with open(os.path.join(cls.profiler_dir, "dynamic_dependencies.txt")) as f:
            text = f.read()
        cls.used_states = set(re.findall(r"@(\d+)", text))
        # {line: (total iterations, executions, average, maximum)} of the loop records of the run
        cls.loop_records = {
            int(line): tuple(int(v) for v in values)
            for _, line, *values in re.findall(r"(\d+):(\d+) BGN loop (\d+) (\d+) (\d+) (\d+)", text)
        }

    # --- the call paths -------------------------------------------------------------------------------------------

    def occurrences_of(self, function, state):
        """how often the function occurs on the call path of the state"""
        return len(
            [
                label
                for label in self.callpath(state)
                if function in label and not label.startswith("call_") and "_loopstate" not in label
            ]
        )

    @unittest.expectedFailure  # the states of a recursive call are those of the caller: one occurrence at most
    def test_the_recursion_levels_have_states_of_their_own(self):
        levels = {self.occurrences_of("walk_uniform", state) for state in self.used_states}
        self.assertTrue({1, 2, 3} <= levels, f"occurrences of walk_uniform on the call paths: {levels}")

    @unittest.expectedFailure  # see above
    def test_deeper_levels_reuse_the_states_of_the_first_level(self):
        levels = {self.occurrences_of("walk_uniform", state) for state in self.used_states}
        self.assertEqual(max(levels), RECURSION_DEPTH_BUCKETS, f"occurrences: {levels}")

    # --- the loop accounting of the runtime -----------------------------------------------------------------------

    @unittest.expectedFailure  # the maximum of iterations per execution counts the entries of the recursive instances
    def test_a_recursive_loop_is_counted_like_a_plain_loop_with_the_same_executions(self):
        lines = loop_lines()
        for recursive, plain in [("walk_uniform", "plain_uniform"), ("walk_zero", "plain_zero")]:
            with self.subTest(loop=recursive):
                self.assertIn(lines[plain], self.loop_records)
                self.assertEqual(self.loop_records.get(lines[recursive]), self.loop_records[lines[plain]])

    # --- the decision of the explorer -----------------------------------------------------------------------------

    @unittest.expectedFailure  # a RAW between the caller's iteration and the callee's read is reported as carried
    def test_a_loop_is_not_rejected_for_the_reads_of_its_recursive_callee(self):
        fill_line = loop_lines()["fill"]
        with open(os.path.join(self.dot_discopop, "explorer", "pattern_decisions.json")) as f:
            decisions = json.load(f)["decisions"]
        reasons = [
            reason["kind"]
            for decision in decisions
            if decision["region"]["start_line"] == fill_line
            for reason in decision["reasons"]
        ]
        self.assertNotIn("loop_carried_dependency", reasons)
