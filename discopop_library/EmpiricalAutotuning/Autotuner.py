import logging
from typing import Optional
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.CodeConfiguration import CodeConfiguration
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult

logger = logging.getLogger("Autotuner")

def run(arguments: AutotunerArguments) -> Optional[CodeConfiguration]:
    logger.info("Starting discopop autotuner.")

    # get untuned reference result
    reference_configuration = CodeConfiguration(arguments.project_path)
    reference_configuration.execute()
    



    return None
