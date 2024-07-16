import logging
from typing import Optional
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration

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
    # !DEBUG

    return reference_configuration
