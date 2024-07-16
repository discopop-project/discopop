import logging
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments


def run(arguments: AutotunerArguments) -> None:
    logger = logging.getLogger("Autotuner")
    logger.info("Starting discopop autotuner.")
    
    pass