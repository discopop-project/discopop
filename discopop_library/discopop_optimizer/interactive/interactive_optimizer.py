# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import os
from typing import List, Set
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.Variables.ExperimentUtils import restore_session
from discopop_library.discopop_optimizer.utilities.MOGUtilities import show

logger = logging.getLogger("InteractiveOptimizer")

def run_interactive_optimizer(arguments: OptimizerArguments):
    logger.info("Starting..")
    # check prerequisites
    if not os.path.exists(os.path.join("optimizer", "last_experiment.pickle")):
        raise FileNotFoundError("" + os.path.join("optimizer", "last_experiment.pickle") + ": please execute the non-interactice optimizer in advance.")
    
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
        pattern_ids: List[int] = []
        for s in split_input:
            try:
                id = int(s)
                pattern_ids.append(id)
            except:
                pass
        logger.info("Adding ids: " + str(pattern_ids))
        applied_suggestions.update(pattern_ids)
    elif input.startswith("rm "):
        split_input = input.split(" ")
        pattern_ids: List[int] = []
        for s in split_input:
            try:
                id = int(s)
                pattern_ids.append(id)
            except:
                pass
        logger.info("Removing ids: " + str(pattern_ids))
        for i in pattern_ids:
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
    

def show_configuration_diff(experiment: Experiment, applied_suggestions: List[int]):
    logger.info("Creating and showing the diff for the current configuration..")
    logger.info("Not yet implemented")

def export_configuration(experiment: Experiment, applied_suggestions: List[int]):
    logger.info("Exporting the current configuration..")
    logger.warning("Not yet implemented!")
