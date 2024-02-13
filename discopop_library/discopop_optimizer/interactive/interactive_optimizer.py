# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import os
from typing import List, Optional, Set, cast
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.Variables.ExperimentUtils import restore_session
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern

logger = logging.getLogger("InteractiveOptimizer")


def run_interactive_optimizer(arguments: OptimizerArguments):
    logger.info("Starting..")
    # check prerequisites
    if not os.path.exists(os.path.join("optimizer", "last_experiment.pickle")):
        raise FileNotFoundError(
            ""
            + os.path.join("optimizer", "last_experiment.pickle")
            + ": please execute the non-interactice optimizer in advance."
        )

    experiment = restore_session(os.path.join("optimizer", "last_experiment.pickle"))
    logger.info("Restored experiment.")

    applied_suggestions: Set[int] = set()

    # mainloop
    got_continue = True
    while got_continue:
        print()
        print("Options: list, add [<int>]+, rm [<int>]+, exit, export, showdiff, clear")
        input1 = input()
        logger.debug("Got input: ", input1)
        got_continue = parse_input(input1, experiment, applied_suggestions)
    logger.info("Closing interactive optimizer..")


def parse_input(input: str, experiment: Experiment, applied_suggestions: Set[int]):
    """Return True if the interactive session should be kept alive.
    Return False if the main loop should be exited."""
    if input.startswith("list"):
        print("Selected suggestions:")
        print(applied_suggestions)
    elif input.startswith("add "):
        split_input = input.split(" ")
        pattern_ids1: List[int] = []
        for s in split_input:
            try:
                id = int(s)
                pattern_ids1.append(id)
            except:
                pass
        logger.info("Adding ids: " + str(pattern_ids1))
        applied_suggestions.update(pattern_ids1)
    elif input.startswith("rm "):
        split_input = input.split(" ")
        pattern_ids2: List[int] = []
        for s in split_input:
            try:
                id = int(s)
                pattern_ids2.append(id)
            except:
                pass
        logger.info("Removing ids: " + str(pattern_ids2))
        for i in pattern_ids2:
            if i in applied_suggestions:
                applied_suggestions.remove(i)
    elif input.startswith("clear"):
        applied_suggestions.clear()
    elif input.startswith("exit"):
        return False
    elif input.startswith("export"):
        export_configuration(experiment, applied_suggestions)
    elif input.startswith("showdiff"):
        show_configuration_diff(experiment, applied_suggestions)
    else:
        logger.info("Unknown command ignored: " + input)
    return True


def show_configuration_diff(experiment: Experiment, applied_suggestions: Set[int]):
    logger.info("Creating and showing the diff for the current configuration..")
    logger.info("Not yet implemented")


def export_configuration(experiment: Experiment, applied_suggestions: Set[int]):
    logger.info("Exporting the current configuration..")
    logger.warning("Not yet implemented!")


#    __create_optimizer_output_pattern(experiment, applied_suggestions)

# def __create_optimizer_output_pattern(experiment: Experiment, applied_suggestions: List[int]) -> Optional[OptimizerOutputPattern]:
#    if len(applied_suggestions) == 0:
#        return None
#    output_pattern: Optional[OptimizerOutputPattern] = None
#
#    for suggestion_id in applied_suggestions:
#        if output_pattern is None:
#            # get suggestion object
#            first_suggestion = experiment.detection_result.patterns.get_pattern_from_id(suggestion_id)
#
#            output_pattern = OptimizerOutputPattern(first_suggestion._node, experiment.suggestion_to_node_ids_dict[first_suggestion.pattern_id], experiment.get_system().get_host_device_id())
#            logger.info("Initialized OptimizerOutputPattern based on " + str(suggestion_id))
#        else:
#            pattern_obj = experiment.detection_result.patterns.get_pattern_from_id(suggestion_id)
#            if type(pattern_obj) == OptimizerOutputPattern:
#                target_device_id = cast(OptimizerOutputPattern, pattern_obj).
#            else:
#                experiment.get_system().get_host_device_id()
#
#            output_pattern.add_pattern(suggestion_id, target_device_id, experiment.get_system().get_device(target_device_id).get_device_type())
#            logger.info("Added pattern : " + str(suggestion_id))
#    return output_pattern
