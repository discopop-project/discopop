import logging
import os
from typing import Optional

import jsonpickle
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.utils import get_applicable_suggestion_ids
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.HotspotType import HotspotType
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
    # for all hotspot types in descending importance:
    for hotspot_type in [HotspotType.YES, HotspotType.MAYBE, HotspotType.NO]:
        if hotspot_type not in hotspot_information:
            continue
        # for all loops in descending order by average execution time
        loop_tuples = hotspot_information[hotspot_type]
        sorted_loop_tuples = sorted(loop_tuples, key=lambda x: x[4], reverse=True)
        for loop_tuple in sorted_loop_tuples:
            # identify all applicable suggestions for this loop
            logger.debug(str(hotspot_type) + " loop: " + str(loop_tuple))
            # create code and execute for all applicable suggestions
            applicable_suggestions = get_applicable_suggestion_ids(loop_tuple[0], loop_tuple[1], detection_result)
            logger.debug("--> applicable suggestions: " + str(applicable_suggestions))

            # select the best option and save it in the current best_configuration
            # continue with the next loop



    # TODO return the best configuration
    return reference_configuration
