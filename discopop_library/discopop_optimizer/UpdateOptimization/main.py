import os
from discopop_library.ParallelConfiguration.ParallelConfiguration import ParallelConfiguration
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.UpdateOptimization.LoopInitializationUpdates import (
    fix_loop_initialization_updates,
)
from discopop_library.discopop_optimizer.UpdateOptimization.RemoveDuplicatedUpdates import remove_duplicated_updates
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.utilities.visualization.update_graph import show_update_graph


def optimize_updates(experiment: Experiment, best_configuration: ParallelConfiguration, arguments: OptimizerArguments):
    # plot raw update graph
    # show_update_graph(experiment.optimization_graph, best_configuration, experiment)

    # print original updates
    if arguments.verbose:
        print("Original updates")
        for update in best_configuration.data_movement:
            print("# ", update)
        print()

    # optimize updates
    best_configuration = fix_loop_initialization_updates(experiment, best_configuration, arguments)

    # remove duplicated updates
    best_configuration = remove_duplicated_updates(best_configuration, arguments)

    # plt optimized update graph
    # show_update_graph(experiment.optimization_graph, best_configuration, experiment)

    # print optimized updates
    if arguments.verbose:
        print("Optimized updates")
        for update in best_configuration.data_movement:
            print("# ", update)
        print()

    # export the updated configuration to the disk
    updated_configuration_path = os.path.join("optimizer", "updated_configuration.json")
    best_configuration.dump_to_file(updated_configuration_path)
