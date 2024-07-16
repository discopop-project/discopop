from __future__ import annotations
import logging
import os
import shutil
import subprocess
import time
from typing import Callable, Optional
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult

logger = logging.getLogger("CodeConfiguration")

class CodeConfiguration(object):
    root_path: str
    config_dot_dp_path: str
    execution_result: Optional[ExecutionResult]

    def __init__(self, root_path: str, config_dot_dp_path: str):
        self.root_path = root_path
        if self.root_path.endswith("/"):
            self.root_path = self.root_path[:-1]
        self.config_dot_dp_path = config_dot_dp_path
        if self.config_dot_dp_path.endswith("/"):
            self.config_dot_dp_path = self.config_dot_dp_path[:-1]
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
        logger.info("Execution took " + str(round(required_time, 4)) + " s")
        logger.info("Execution return code: " + str(result.returncode))
        logger.info("Execution result valid: " + str(result_valid))

        self.execution_result = ExecutionResult(required_time, result.returncode, result_valid)

    def create_copy(self, get_new_configuration_id: Callable[[], int])->CodeConfiguration:
        # create a copy of the project folder 
        dest_path = self.root_path + "_dpautotune_"+str(get_new_configuration_id())
        if os.path.exists(dest_path):
            shutil.rmtree(dest_path)
        shutil.copytree(self.root_path, dest_path)
        # get updated .discopop folder location
        new_dot_discopop_path = self.config_dot_dp_path.replace(self.root_path, dest_path)
        logger.debug("Copied folder: " + self.root_path + " to " + dest_path)
        logger.debug("Set "+ self.config_dot_dp_path + " to " + new_dot_discopop_path)
        # update FileMapping.txt in new .discopop folder
        with open(os.path.join(new_dot_discopop_path, "NewFileMapping.txt"), "w+") as o:
            with open(os.path.join(new_dot_discopop_path, "FileMapping.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace(self.root_path, dest_path)
                    o.write(line)
        shutil.move(os.path.join(new_dot_discopop_path, "NewFileMapping.txt"), os.path.join(new_dot_discopop_path, "FileMapping.txt"))
        logger.debug("Updated " + os.path.join(new_dot_discopop_path, "FileMapping.txt"))

        
        # create a new CodeConfiguration object
        return CodeConfiguration(dest_path, new_dot_discopop_path)


