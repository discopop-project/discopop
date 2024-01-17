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

    # identify sequential suggestions
    # copy available decisions and convert function nodes to node ids
    sequential_suggestions = dict()
    for key in available_decisions:
        sequential_suggestions[key.node_id] = []
        for entry in available_decisions[key]:
            sequential_suggestions[key.node_id].append(copy.deepcopy(entry))

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
    
    # copy sequential decisions
    made_decisions = dict()
    for key in sequential_suggestions:
        made_decisions[key] = []
        for entry in sequential_suggestions[key]:
            made_decisions[key].append(copy.deepcopy(entry))
    

    for idx, function in enumerate(available_decisions):
        print("Greedy searching function: ", function.name, idx, "/", len(available_decisions))
        for dcsi, decision_set in enumerate(available_decisions[function]):
            local_results: List[Tuple[Dict[Any, Any], int]] = []
            
            # prepare arguments for parallel cost calculation
            param_list = []
            for decision in decision_set:
                # copy made decisions
                local_decision_set = dict()
                for key in made_decisions:
                    local_decision_set[key] = []
                    for entry in made_decisions[key]:
                        local_decision_set[key].append(copy.deepcopy(entry))
                
                local_decision_set[function.node_id][dcsi] = [decision]
                param_list.append(local_decision_set)

            # calculate costs in parallel
            with Pool(initializer=__initialize_cost_caluclation_worker, initargs=(experiment, arguments)) as pool:
                tmp_result = list(tqdm.tqdm(pool.imap_unordered(__get_score, param_list), total=len(param_list), disable=True))
            for local_result in tmp_result:
                # remove invalid elements
                if local_result[1] == -1:
                    continue                
                local_results.append(local_result)

            
            # identify best option and update made_decisions
            best_option: Tuple[Dict[Any, Any], int] = None
            for k, e in local_results:
                if best_option is None:
                    best_option = (k, e)
                    continue
                if e < best_option[1]:
                    best_option = (k, e)
            
            made_decisions = best_option[0]
            
#            made_decisions = sorted(local_results, key=lambda x: x[1])[0][0]
            print("Selection: ", __get_dicision_list(made_decisions), "costs:", best_option[1])
            

    import sys
    sys.exit(0)

def __get_dicision_list(decisions_dict):
    """Converts a dictionary based description of a configuration into a list of integers"""
    res_list = []
    for function in decisions_dict:
        for decision_set in decisions_dict[function]:
            res_list.append(decision_set[0])
    return res_list


def __initialize_cost_caluclation_worker(
    experiment: Experiment,
    arguments: OptimizerArguments,
):
    global global_experiment
    global global_arguments
    global_experiment = experiment
    global_arguments = arguments


def __get_score(param_tuple) -> Tuple[List[int], int, ContextObject]:
    global global_experiment
    global global_arguments
    configuration = param_tuple
    try:
        _, score_expr, _ = evaluate_configuration(
            cast(Experiment, global_experiment),
            __get_dicision_list(configuration),
            cast(OptimizerArguments, global_arguments),
        )
        result = int(float(str(score_expr.evalf())))
    except ValueError:
        result = -1

    return configuration, result