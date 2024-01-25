# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import cast
from discopop_library.discopop_optimizer.CostModels.DataTransfer.DataTransferCosts import add_data_transfer_costs
from discopop_library.discopop_optimizer.CostModels.utilities import get_performance_models_for_functions
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.UpdateOptimization.main import optimize_updates
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


def calculate_data_movement(experiment: Experiment):
    """Calculate the necessary data movement for each suggestion created by the optimizer"""

    for suggestion in experiment.detection_result.patterns.optimizer_output:
        oo_suggestion = cast(OptimizerOutputPattern, suggestion)
        print("Calculating data movement for ", oo_suggestion.pattern_id, "decisions: ", oo_suggestion.decisions)
        # calculate necessary updates
        function_performance_models_without_context = get_performance_models_for_functions(
            experiment, experiment.optimization_graph, restrict_to_decisions=set(oo_suggestion.decisions)
        )
        function_performance_models = calculate_data_transfers(
            experiment.optimization_graph, function_performance_models_without_context, experiment
        )
        function_performance_models = add_data_transfer_costs(
            experiment.optimization_graph,
            function_performance_models,
            experiment,
        )

        # collect necessary updates
        for function in function_performance_models:
            for cost_model, context in function_performance_models[function]:
                print()
                print("CM: ", cost_model.path_decisions)
                print("CTX: ", context.necessary_updates)
                for update in context.necessary_updates:
                    oo_suggestion.add_data_movement(update)

        # optimize updates
        oo_suggestion = optimize_updates(experiment, oo_suggestion, experiment.arguments)
