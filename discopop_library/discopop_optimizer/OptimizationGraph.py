# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, cast, List, Tuple, Set

import jsonpickle  # type: ignore
import networkx as nx  # type: ignore
import sympy  # type: ignore
from spb import plot3d, MB  # type: ignore
from sympy import Integer, Expr, Symbol, lambdify, plot, Float, init_printing, simplify, diff  # type: ignore

from discopop_library.discopop_optimizer.PETParser.PETParser import PETParser
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment


class OptimizationGraph(object):
    next_free_node_id: int
    experiment: Experiment
    pet_parser: PETParser

    def __init__(self, project_folder_path, experiment: Experiment):
        # construct optimization graph from PET Graph

        # save reference to experiment
        self.experiment = experiment

        # construct PETParser
        self.pet_parser = PETParser(experiment.detection_result.pet, experiment)

        # save graph in experiment
        self.experiment.optimization_graph, self.next_free_node_id = self.pet_parser.parse()

    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer

    def show(self):
        show(self.experiment.optimization_graph)
