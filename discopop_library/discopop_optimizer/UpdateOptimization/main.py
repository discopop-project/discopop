import os
from discopop_library.ParallelConfiguration.ParallelConfiguration import ParallelConfiguration
from discopop_library.discopop_optimizer.UpdateOptimization.LoopInitializationUpdates import (
    fix_loop_initialization_updates,
)
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.utilities.visualization.update_graph import show_update_graph


def optimize_updates(experiment: Experiment, best_configuration: ParallelConfiguration):
    # plot raw update graph
    # show_update_graph(experiment.optimization_graph, best_configuration, experiment)

    # optimize updates
    best_configuration = fix_loop_initialization_updates(experiment, best_configuration)

    # plt optimized update graph
    # show_update_graph(experiment.optimization_graph, best_configuration, experiment)

    # export the updated configuration to the disk
    updated_configuration_path = os.path.join("optimizer", "updated_configuration.json")
    best_configuration.dump_to_file(updated_configuration_path)
