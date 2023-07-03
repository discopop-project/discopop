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

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.CostModels.DataTransfer.DataTransferCosts import (
    add_data_transfer_costs,
)
from discopop_library.discopop_optimizer.CostModels.utilities import (
    get_performance_models_for_functions,
)
from discopop_library.discopop_optimizer.DataTransfers.DataTransfers import calculate_data_transfers
from discopop_library.discopop_optimizer.PETParser.PETParser import PETParser
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.Variables.ExperimentUtils import (
    show_function_models,
    export_to_json,
    perform_headless_execution,
)
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.queries.ValueTableQuery import (
    query_user_for_symbol_values,
)
from discopop_library.discopop_optimizer.suggestions.importers.base import import_suggestions
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show
from discopop_library.discopop_optimizer.utilities.optimization.LocalOptimization.TopDown import (
    get_locally_optimized_models,
)


class OptimizationGraph(object):
    next_free_node_id: int

    def __init__(self, project_folder_path, experiment: Experiment, arguments: Dict):
        # construct optimization graph from PET Graph
        # save graph in experiment
        experiment.optimization_graph, self.next_free_node_id = PETParser(
            experiment.detection_result.pet, experiment
        ).parse()

        # get performance models for sequential execution
        sequential_function_performance_models = get_performance_models_for_functions(
            experiment, experiment.optimization_graph
        )
        sequential_function_performance_models_with_transfers = calculate_data_transfers(
            experiment.optimization_graph, sequential_function_performance_models
        )
        sequential_complete_performance_models = add_data_transfer_costs(
            experiment.optimization_graph,
            sequential_function_performance_models_with_transfers,
            experiment,
        )

        for function_root in sequential_complete_performance_models:
            print("Function: ", function_root.name)
            print("\tfunction_model: ")
            function_root.performance_model.print()

            for model, ctx in sequential_complete_performance_models[function_root]:
                print("\n\tmodel: ")
                model.print()

        # import parallelization suggestions
        experiment.optimization_graph = import_suggestions(
            experiment.detection_result,
            experiment.optimization_graph,
            self.get_next_free_node_id,
            experiment,
        )

        # perform an exhaustive search if requested
        if arguments["--exhaustive-search"]:
            # calculate performance models without data transfers
            function_performance_models = get_performance_models_for_functions(
                experiment, experiment.optimization_graph
            )

            # calculate and append necessary data transfers to the models
            function_performance_models_with_transfers = calculate_data_transfers(
                experiment.optimization_graph, function_performance_models
            )

            # calculate and append costs of data transfers to the performance models
            exhaustive_performance_models = add_data_transfer_costs(
                experiment.optimization_graph,
                function_performance_models_with_transfers,
                experiment,
            )
        else:
            exhaustive_performance_models = dict()

        # define variable substitutions
        substitutions: Dict[Symbol, Expr] = dict()

        # collect free symbols
        #        free_symbols: Set[Symbol] = set()
        free_symbol_ranges: Dict[Symbol, Tuple[float, float]] = dict()
        free_symbol_distributions: Dict[Symbol, FreeSymbolDistribution] = dict()

        #        for function in complete_performance_models:
        #            for pair in complete_performance_models[function]:
        #                model, context = pair
        #                free_symbols.update(cast(List[Symbol], model.parallelizable_costs.free_symbols))
        #                free_symbols.update(cast(List[Symbol], model.sequential_costs.free_symbols))
        #                suggested_values = suggested_values | model.symbol_value_suggestions
        sorted_free_symbols = sorted(list(experiment.free_symbols), key=lambda x: x.name)

        # query user for values for free symbols
        query_results = query_user_for_symbol_values(
            sorted_free_symbols, experiment.suggested_values, arguments
        )
        for symbol, value, start_value, end_value, symbol_distribution in query_results:
            if value is not None:
                substitutions[symbol] = Float(value)
            else:
                free_symbol_ranges[symbol] = (cast(float, start_value), cast(float, end_value))
                free_symbol_distributions[symbol] = cast(
                    FreeSymbolDistribution, symbol_distribution
                )

        # add function symbols to list of substitutions
        # TODO NOTE THIS IS JUST A DUMMY!!!
        #  collect substitutions
        for function in sequential_complete_performance_models:
            # register substitution
            substitutions[
                cast(Symbol, function.sequential_costs)
            ] = sequential_complete_performance_models[function][0][0].sequential_costs
            substitutions[
                cast(Symbol, function.parallelizable_costs)
            ] = sequential_complete_performance_models[function][0][0].parallelizable_costs

        print("FUNCTION SUBSTITUTIONS", substitutions)
        # todo MAY NOT STAY AS IS! MUST BE DYNAMIC

        # perform iterative substitutions
        modification_found = True
        while modification_found and False:
            print("SUBSTITUTION LOOP")
            modification_found = False
            for idx, function in enumerate(sequential_complete_performance_models):
                for midx, model in enumerate(sequential_complete_performance_models[function]):
                    # apply substitution to parallelizable costs
                    tmp_model = model.parallelizable_costs.subs(substitutions)
                    if tmp_model != model.parallelizable_costs:
                        modification_found = True
                    model.parallelizable_costs = tmp_model

                    # apply substitutions to sequential costs
                    tmp_model = model.sequential_costs.subs(substitutions)
                    if tmp_model != model.sequential_costs:
                        modification_found = True
                    model.sequential_costs = model.sequential_costs.subs(substitutions)

        # TODO END OF DUMMY

        # apply substitutions and un-mark substituted free symbols
        #        for idx, function in enumerate(complete_performance_models):
        #            for midx, pair in enumerate(complete_performance_models[function]):
        #                model, context = pair
        #                model.parallelizable_costs = model.parallelizable_costs.subs(substitutions)
        #                model.sequential_costs = model.sequential_costs.subs(substitutions)

        # perform iterative substitutions
        modification_found = True
        while modification_found:
            modification_found = False
            for idx, function in enumerate(sequential_complete_performance_models):
                for midx, pair in enumerate(sequential_complete_performance_models[function]):
                    model, context = pair
                    # apply substitution to parallelizable costs
                    tmp_model = model.parallelizable_costs.subs(substitutions)
                    if tmp_model != model.parallelizable_costs:
                        modification_found = True
                    model.parallelizable_costs = tmp_model
                    # apply substitutions to sequential costs
                    tmp_model = model.sequential_costs.subs(substitutions)
                    if tmp_model != model.sequential_costs:
                        modification_found = True
                    model.sequential_costs = tmp_model

        for symbol in substitutions:
            if symbol in experiment.free_symbols:
                experiment.free_symbols.remove(symbol)
            if symbol in free_symbol_ranges:
                del free_symbol_ranges[symbol]
            if symbol in sorted_free_symbols:
                sorted_free_symbols.remove(symbol)

        # set free symbol ranges and distributions for comparisons
        #        for idx, function in enumerate(complete_performance_models):
        #            for pair in complete_performance_models[function]:
        #                model, context = pair
        #                model.free_symbol_ranges = free_symbol_ranges
        #                model.free_symbol_distributions = free_symbol_distributions

        # save substitutions, sorted_free_symbols, free_symbol_ranges and free_symbol_distributions in experiment
        experiment.substitutions = substitutions
        experiment.sorted_free_symbols = sorted_free_symbols
        experiment.free_symbol_ranges = free_symbol_ranges
        experiment.free_symbol_distributions = free_symbol_distributions

        # create locally optimized model
        locally_optimized_models = get_locally_optimized_models(
            experiment,
            experiment.optimization_graph,
            substitutions,
            experiment,
            free_symbol_ranges,
            free_symbol_distributions,
        )
        # perform iterative substitutions
        modification_found = True
        while modification_found:
            modification_found = False
            print("SUBSTITUTION LOOP")
            for idx, function in enumerate(locally_optimized_models):
                for midx, pair in enumerate(locally_optimized_models[function]):
                    model, context = pair
                    # apply substitution to parallelizable costs
                    tmp_model = model.parallelizable_costs.subs(substitutions)
                    if tmp_model != model.parallelizable_costs:
                        modification_found = True
                    model.parallelizable_costs = tmp_model
                    # apply substitutions to sequential costs
                    tmp_model = model.sequential_costs.subs(substitutions)
                    if tmp_model != model.sequential_costs:
                        modification_found = True
                    model.sequential_costs = tmp_model

        # set free symbol ranges and distributions for comparisons
        for idx, function in enumerate(locally_optimized_models):
            for pair in locally_optimized_models[function]:
                model, context = pair
                model.free_symbol_ranges = free_symbol_ranges
                model.free_symbol_distributions = free_symbol_distributions

        # perform iterative substitutions
        modification_found = True
        while modification_found:
            modification_found = False
            for idx, function in enumerate(exhaustive_performance_models):
                for midx, pair in enumerate(exhaustive_performance_models[function]):
                    model, context = pair
                    # apply substitution to parallelizable costs
                    tmp_model = model.parallelizable_costs.subs(substitutions)
                    if tmp_model != model.parallelizable_costs:
                        modification_found = True
                    model.parallelizable_costs = tmp_model
                    # apply substitutions to sequential costs
                    tmp_model = model.sequential_costs.subs(substitutions)
                    if tmp_model != model.sequential_costs:
                        modification_found = True
                    model.sequential_costs = tmp_model
        # set free symbol ranges and distributions for comparisons
        for idx, function in enumerate(exhaustive_performance_models):
            for pair in exhaustive_performance_models[function]:
                model, context = pair
                model.free_symbol_ranges = free_symbol_ranges
                model.free_symbol_distributions = free_symbol_distributions

        # find the minimum of the exhaustive list of models
        exhaustive_minima: Dict[FunctionRoot, List[Tuple[CostModel, ContextObject]]] = dict()
        print("Sorting exhaustive models...")
        for function in exhaustive_performance_models:
            sorted_exhaustive_performance_models = sorted(
                exhaustive_performance_models[function], key=lambda x: x[0]
            )
            exhaustive_minima[function] = [sorted_exhaustive_performance_models[0]]
        print("\tDone.")

        for function in locally_optimized_models:
            # show table of options
            options: List[Tuple[CostModel, ContextObject, str]] = []
            # add exhaustive minima
            if function in exhaustive_minima:
                for model_tmp in exhaustive_minima[function]:
                    options.append((model_tmp[0], model_tmp[1], "Exhaustive Min"))

            options.append(
                (
                    sequential_complete_performance_models[function][0][0],
                    sequential_complete_performance_models[function][0][1],
                    "Sequential",
                )
            )
            options.append(
                (
                    locally_optimized_models[function][0][0],
                    locally_optimized_models[function][0][1],
                    "Locally Optimized",
                )
            )
            # save options to experiment
            experiment.function_models[function] = options

        # show function models
        if not arguments["--headless-mode"]:
            show_function_models(
                experiment,
            )
        else:
            # perform actions for headless mode
            perform_headless_execution(experiment)

        # save experiment to disk
        export_to_json(experiment)

    def get_next_free_node_id(self):
        buffer = self.next_free_node_id
        self.next_free_node_id += 1
        return buffer
