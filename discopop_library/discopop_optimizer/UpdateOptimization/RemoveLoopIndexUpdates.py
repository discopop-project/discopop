# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.Update import Update
from discopop_library.discopop_optimizer.classes.nodes.Loop import Loop
from discopop_library.discopop_optimizer.utilities.simple_utilities import data_at
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


def remove_loop_index_updates(experiment: Experiment, best_configuration: OptimizerOutputPattern, arguments: OptimizerArguments
) -> OptimizerOutputPattern:
    to_be_removed: List[Update] = []
    for update in best_configuration.data_movement:
        # check for loop nodes as update targets
        if type(data_at(experiment.optimization_graph, update.target_node_id)) == Loop:
            # get loop indices from PEGraph
            loop_cu_id = data_at(experiment.optimization_graph, update.target_node_id).original_cu_id
            if loop_cu_id is None:
                continue
            loop_indices = experiment.detection_result.pet.node_at(loop_cu_id).loop_indices
            # check for loop indices as targeted varbiables
            if update.write_data_access.var_name in loop_indices:
                # found update to loop index
                if arguments.verbose:
                    print("ignoring update: ", str(update), " , since it targets a loop index.")
                to_be_removed.append(update)
    # remove identified loop index updates
    for tbr in to_be_removed:
        if tbr in best_configuration.data_movement:
            best_configuration.data_movement.remove(tbr)

    # ensure correct formatting
    if arguments.verbose:
        if len(to_be_removed) > 0:
            print()



    if arguments.verbose:
        print("Removed loop index updates")
        for update in best_configuration.data_movement:
            print("# ", update)
        print()

    return best_configuration