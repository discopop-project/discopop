# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import unittest

import networkx as nx  # type:ignore

from discopop_explorer.PETGraphX import CUNode, DepType, Dependency, EdgeType, NodeType, PETGraphX
from discopop_explorer.pattern_detectors.do_all_detector import run_detection as detect_do_all
from discopop_explorer.pattern_detectors.pipeline_detector import run_detection as detect_pipeline
from discopop_explorer.pattern_detectors.reduction_detector import run_detection as detect_reduction
from discopop_explorer.variable import Variable


def loop_with_reduction():
    g = nx.MultiDiGraph()
    loop_node = CUNode.from_kwargs(
        node_id="0:0",
        type=NodeType.LOOP,
        name="main",
        source_file=0,
        start_line=0,
        end_line=0,
        loop_iterations=1,
    )
    g.add_node(loop_node.id, data=loop_node)
    var_node = CUNode.from_kwargs(
        node_id="0:1",
        source_file=0,
        start_line=1,
        end_line=1,
        type=NodeType.CU,
        name="var",
        local_vars=[Variable("int", "x")],
    )
    g.add_node(var_node.id, data=var_node)
    g.add_edge(loop_node.id, var_node.id, data=Dependency(EdgeType.CHILD))
    reduction_vars = [
        {
            "loop_line": f"{loop_node.source_file}:{loop_node.start_line}",
            "name": var_node.local_vars[0].name,
            "operation": "+"
        }
    ]
    return g, reduction_vars, loop_node, var_node


class ReductionDetectorTest(unittest.TestCase):
    def run_detection(self, g, reduction_vars, expected_node_ids):
        patterns = detect_reduction(PETGraphX(g, reduction_vars, {}))
        self.assertListEqual([pattern.node_id for pattern in patterns], expected_node_ids)

    def test_reduction_pattern(self):
        """Reduction detection on loop with a reduction on a variable"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        self.run_detection(g, reduction_vars, [loop_node.id])

    def test_nonloop_reduction(self):
        """Reduction detection on loop with zero iterations"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        loop_node.loop_iterations = 0
        self.run_detection(g, reduction_vars, [])

    def test_no_reduction_vars(self):
        """Reduction detection on loop without reduction variables"""
        g, _, loop_node, *_ = loop_with_reduction()
        self.run_detection(g, [], [])


class DoAllDetectorTest(unittest.TestCase):
    def run_detection(self, g, reduction_vars, expected_node_ids):
        detect_reduction(PETGraphX(g, reduction_vars, {}))  # reduction before do_all
        patterns = detect_do_all(PETGraphX(g, reduction_vars, {}))
        self.assertListEqual([pattern.node_id for pattern in patterns], expected_node_ids)

    def test_reduction_pattern(self):
        """Do All detection on a reduction pattern"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        reduction_vars[0]["name"] += "_"
        self.run_detection(g, reduction_vars, [loop_node.id])

    def test_omit_reduction_loop(self):
        """Do All detection on loop with a reduction on a variable"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        self.run_detection(g, reduction_vars, [])

    def test_nonloop_reduction(self):
        """Do All detection on loop with zero iterations"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        loop_node.loop_iterations = 0
        self.run_detection(g, reduction_vars, [])

    def test_loop_with_raw_dependency(self):
        """Do All detection on reduction loop with additional RAW dependency"""
        g, reduction_vars, loop_node, var_node = loop_with_reduction()
        raw_node = CUNode.from_kwargs(node_id="0:2", type=NodeType.CU, name="raw")
        g.add_node(raw_node.id, data=raw_node)
        g.add_edge(var_node.id, raw_node.id, data=Dependency(EdgeType.CHILD))
        raw_dependency = Dependency(EdgeType.DATA)
        raw_dependency.dtype = DepType.RAW
        g.add_edge(raw_node.id, var_node.id, data=raw_dependency)
        self.run_detection(g, reduction_vars, [])


class PipelineDetector(unittest.TestCase):
    def run_detection(self, g, reduction_vars, expected_node_ids):
        patterns = detect_pipeline(PETGraphX(g, reduction_vars, {}))
        self.assertListEqual([pattern.node_id for pattern in patterns], expected_node_ids)

    def test_reduction_pattern(self):
        """Pipeline detection on loop with a reduction on a variable"""
        g, reduction_vars, loop_node, *_ = loop_with_reduction()
        self.run_detection(g, reduction_vars, [])
        self.assertEqual(loop_node.pipeline, 0.0)

    def test_raw_dependency_chain(self):
        """Pipeline detection on loop with a RAW dependency chain"""
        g, reduction_vars, loop_node, var_node = loop_with_reduction()
        var_node2 = CUNode.from_kwargs(
            node_id="0:2",
            source_file=0,
            start_line=2,
            end_line=2,
            type=NodeType.CU,
            name="var2",
            local_vars=[Variable("int", "y")],
        )
        g.add_node(var_node2.id, data=var_node2)
        g.add_edge(loop_node.id, var_node2.id, data=Dependency(EdgeType.CHILD))
        raw_dependency = Dependency(EdgeType.DATA)
        raw_dependency.dtype = DepType.RAW
        g.add_edge(var_node.id, var_node2.id, data=raw_dependency)
        var_node3 = CUNode.from_kwargs(
            node_id="0:3",
            source_file=0,
            start_line=3,
            end_line=3,
            type=NodeType.CU,
            name="var3",
            local_vars=[Variable("int", "z")],
        )
        g.add_node(var_node3.id, data=var_node3)
        g.add_edge(loop_node.id, var_node3.id, data=Dependency(EdgeType.CHILD))
        g.add_edge(var_node2.id, var_node3.id, data=raw_dependency)
        self.run_detection(g, reduction_vars, [])
        self.assertGreater(loop_node.pipeline, 0.0)
