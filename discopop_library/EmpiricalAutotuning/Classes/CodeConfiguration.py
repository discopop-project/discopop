import logging
import subprocess
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
        subprocess.run("./DP_EXECUTE.sh", cwd=self.root_path, executable="/bin/bash", shell=True)

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