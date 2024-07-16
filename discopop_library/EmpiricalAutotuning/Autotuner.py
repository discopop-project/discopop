import logging
import os
from typing import Optional

import jsonpickle
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.hostpot_loader import run as load_hotspots
from discopop_library.result_classes.DetectionResult import DetectionResult

logger = logging.getLogger("Autotuner")

configuration_counter = 1

def get_unique_configuration_id()->int:
    global configuration_counter
    buffer = configuration_counter
    configuration_counter += 1
    return buffer

def run(arguments: AutotunerArguments) -> Optional[CodeConfiguration]:
    logger.info("Starting discopop autotuner.")

    # get untuned reference result
    reference_configuration = CodeConfiguration(arguments.project_path, arguments.dot_dp_path)
    reference_configuration.execute()


    # DEBUG
    # create a copied configuration
    copied_configuration_1 = reference_configuration.create_copy(get_unique_configuration_id)
    copied_configuration_1.execute()
    # !DEBUG

    # load hotspots
    hsl_arguments = HotspotLoaderArguments(arguments.log_level, arguments.write_log, False, arguments.dot_dp_path, True, False, True, True, True)
    hotspot_information = load_hotspots(hsl_arguments)
    logger.debug("loaded hotspots")
    # load suggestions
    with open(os.path.join(arguments.dot_dp_path, "explorer", "detection_result_dump.json"), "r") as f:
        tmp_str = f.read()
    detection_result: DetectionResult = jsonpickle.decode(tmp_str)
    logger.debug("loaded suggestions")

    # greedy search for best configuration:
    # for all loops in descending order by hotspot rating:
        # create code and execute for all applicable suggestions
        # select the best option and save it in the current best_configuration
        # continue with the next loop



    # TODO return the best configuration
    return reference_configuration
