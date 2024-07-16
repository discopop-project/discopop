import logging
import os
import subprocess
import time
from typing import Optional
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult

logger = logging.getLogger("CodeConfiguration")

class CodeConfiguration(object):
    root_path: str
    execution_result: Optional[ExecutionResult]

    def __init__(self, root_path: str):
        self.root_path = root_path
        self.execution_result = None
        logger.debug("Created configuration: " + root_path)

    def __str__(self)->str:
        return self.root_path

    def execute(self)->None:
        # compile code
        logger.info("Compiling configuration: " + str(self))
        subprocess.run("./DP_COMPILE.sh", cwd=self.root_path, executable="/bin/bash", shell=True)
        # execute code
        logger.info("Executing configuration: " + str(self))
        start_time = time.time()
        result = subprocess.run("./DP_EXECUTE.sh", cwd=self.root_path, executable="/bin/bash", shell=True)
        end_time = time.time()
        required_time = end_time - start_time

        # check for result validity
        result_valid = True
        if os.path.exists(os.path.join(self.root_path, "DP_VALIDATE.sh")):
            logger.info("Checking result validity: " + str(self))
            validity_check_result = subprocess.run("./DP_VALIDATE.sh", cwd=self.root_path, executable="/bin/bash", shell=True)
            if validity_check_result.returncode != 0:
                result_valid = False

        # reporting
        logger.info("Execution took " + str(required_time) + " s")
        logger.info("Execution return code: " + str(result.returncode))
        logger.info("Execution result valid: " + str(result_valid))

        self.execution_result = ExecutionResult(required_time, result.returncode, result_valid)


        # retrieve 
        
#        subprocess.run(
#            cmd,
#            cwd=cwd,
#            executable="/bin/bash",
#            shell=True,
#            env=env,
#            stdout=subprocess.DEVNULL,
#            stderr=subprocess.DEVNULL,
#            )