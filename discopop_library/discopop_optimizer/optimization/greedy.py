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

    print("AVAIL:")
    print(available_decisions)

    # identify sequential suggestions
    # copy available decisions
    sequential_suggestions = dict()
    for key in available_decisions:
        sequential_suggestions[key] = []
        for entry in available_decisions[key]:
            sequential_suggestions[key].append(copy.deepcopy(entry))

    print("SEQ")
    print(sequential_suggestions)

    for function in sequential_suggestions:
        for decision_set in sequential_suggestions[function]:
            to_be_removed = []
            print("DECSET", decision_set)
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
    # copy sequential decisions
    made_decisions = dict()
    for key in sequential_suggestions:
        made_decisions[key] = []
        for entry in sequential_suggestions[key]:
            made_decisions[key].append(copy.deepcopy(entry))
    
    def get_dicision_list(decisions_dict):
        res_list = []
        for function in decisions_dict:
            for decision_set in decisions_dict[function]:
                res_list.append(decision_set[0])
        return res_list

    for function in available_decisions:
        print(function.name)
        for dcsi, decision_set in enumerate(available_decisions[function]):
            print("\t", decision_set)
            for decision in decision_set:
                # copy made decisions
                local_decision_set = dict()
                for key in made_decisions:
                    local_decision_set[key] = []
                    for entry in made_decisions[key]:
                        local_decision_set[key].append(copy.deepcopy(entry))


                local_decision_set = copy.deepcopy(made_decisions)
                print("LocalKeys: ")
                for key in local_decision_set:
                    print(key)
                local_decision_set[function][dcsi] = decision

                print("\t\tlocal: ", get_dicision_list(local_decision_set))
                #_, score_expr, context = evaluate_configuration(
                #    cast(Experiment, global_experiment),
                #    local_decision_set,
                #    cast(OptimizerArguments, global_arguments),
                #)
                #print("\t\t\t", score_expr)


    import sys
    sys.exit(0)