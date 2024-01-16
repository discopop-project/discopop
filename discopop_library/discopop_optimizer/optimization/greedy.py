# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import copy
import json
from multiprocessing import Pool
import os
from typing import Dict, List, Optional, Set, Tuple, cast

from sympy import Expr
import tqdm  # type: ignore
from discopop_explorer.PEGraphX import NodeID  # type: ignore

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.optimization.evaluate import evaluate_configuration
from itertools import product
from discopop_library.discopop_optimizer.optimization.validation import check_configuration_validity

from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


global_experiment = None
global_arguments = None


def greedy_search(
    experiment: Experiment,
    available_decisions: Dict[FunctionRoot, List[List[int]]],
    arguments: OptimizerArguments,
    optimizer_dir: str,
) -> Optional[OptimizerOutputPattern]:
    """find a good combination of suggestions via greedy search"""
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments

    made_decisions: List[int] = []

    # identify sequential suggestions
    sequential_suggestions = copy.deepcopy(available_decisions)
    for function in sequential_suggestions:
        for decision_set in sequential_suggestions[function]:
            to_be_removed = []
            for decision in decision_set:
                if not data_at(experiment.optimization_graph, decision).represents_sequential_version():
                    to_be_removed.append(decision)
            for entry in to_be_removed:
                decision_set.remove(entry)
            
            # remove all but the original version
            while len(decision_set) > 1:
                tbr = sorted(decision_set, reverse=True)[0]
                decision_set.remove(tbr)

    print("SEQUENTIAL:")
    for function in sequential_suggestions:
        print(function.name)
        for decision_set in sequential_suggestions[function]:
            print(decision_set)
    
    print("AVAILABLE:")
    for function in available_decisions:
        print(function.name)
        for decision_set in available_decisions[function]:
            print("\t", decision_set)
            for decision in decision_set:
                local_decision_set = made_decisions + [decision]
                print("\t\tlocal: ", local_decision_set)
                _, score_expr, context = evaluate_configuration(
                    cast(Experiment, global_experiment),
                    local_decision_set,
                    cast(OptimizerArguments, global_arguments),
                )
                print("\t\t\t", score_expr)


    import sys
    sys.exit(0)