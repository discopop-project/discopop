# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
import logging
import os
import shutil
import subprocess
import time
from typing import Callable, List, Optional
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments
from discopop_library.PatchApplicator.patch_applicator import run as apply_patches

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

    def __str__(self) -> str:
        return self.root_path

    def execute(self, timeout: Optional[float] ) -> None:
        # create timeout string
        timeout_string = "" if timeout is None else "timeout " + str(timeout) + " "
        # compile code
        logger.info("Compiling configuration: " + str(self))
        compile_result = subprocess.run(
            "./DP_COMPILE.sh", cwd=self.root_path, executable="/bin/bash", shell=True, capture_output=True
        )
        logger.getChild("compilationOutput").debug(str(compile_result.stdout.decode("utf-8")))
        # execute code
        logger.info("Executing configuration: " + str(self) + " with " + timeout_string)
        start_time = time.time()
        result = subprocess.run(
            timeout_string + "./DP_EXECUTE.sh", cwd=self.root_path, executable="/bin/bash", shell=True, capture_output=True
        )
        logger.getChild("executionOutput").debug(str(result.stdout.decode("utf-8")))
        end_time = time.time()
        required_time = end_time - start_time

        # check for result validity
        result_valid = True
        if os.path.exists(os.path.join(self.root_path, "DP_VALIDATE.sh")):
            logger.info("Checking result validity: " + str(self))
            validity_check_result = subprocess.run(
                "./DP_VALIDATE.sh", cwd=self.root_path, executable="/bin/bash", shell=True, capture_output=True
            )
            logger.getChild("validationOutput").debug(str(validity_check_result.stdout.decode("utf-8")))
            if validity_check_result.returncode != 0:
                result_valid = False

        # reporting
        logger.debug("Execution took " + str(round(required_time, 4)) + " s")
        logger.debug("Execution return code: " + str(result.returncode))
        logger.debug("Execution result valid: " + str(result_valid))

        self.execution_result = ExecutionResult(required_time, result.returncode, result_valid)

    def create_copy(self, get_new_configuration_id: Callable[[], int]) -> CodeConfiguration:
        # create a copy of the project folder
        dest_path = self.root_path + "_dpautotune_" + str(get_new_configuration_id())
        if os.path.exists(dest_path):
            shutil.rmtree(dest_path)
        shutil.copytree(self.root_path, dest_path)
        # get updated .discopop folder location
        new_dot_discopop_path = self.config_dot_dp_path.replace(self.root_path, dest_path)
        logger.debug("Copied folder: " + self.root_path + " to " + dest_path)
        logger.debug("Set " + self.config_dot_dp_path + " to " + new_dot_discopop_path)
        # update FileMapping.txt in new .discopop folder
        with open(os.path.join(new_dot_discopop_path, "NewFileMapping.txt"), "w+") as o:
            with open(os.path.join(new_dot_discopop_path, "FileMapping.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace(self.root_path, dest_path)
                    o.write(line)
        shutil.move(
            os.path.join(new_dot_discopop_path, "NewFileMapping.txt"),
            os.path.join(new_dot_discopop_path, "FileMapping.txt"),
        )
        logger.debug("Updated " + os.path.join(new_dot_discopop_path, "FileMapping.txt"))

        # create a new CodeConfiguration object
        return CodeConfiguration(dest_path, new_dot_discopop_path)
    
    def deleteFolder(self) -> None:
        # delete the root folder. 
        if not os.path.exists(self.root_path):
            raise FileNotFoundError(self.root_path)
        shutil.rmtree(self.root_path)
        logger.debug("Deleted " + self.root_path)


    def apply_suggestions(self, arguments: AutotunerArguments, suggestion_ids: List[SUGGESTION_ID]) -> None:
        """Applies the given suggestion to the code configuration via discopop_patch_applicator"""
        sub_logger = logger.getChild("apply_suggestions")

        sub_logger.debug("Applying patch applicator for: " + str(suggestion_ids))
        suggestion_ids_str = [str(id) for id in suggestion_ids]

        save_dir = os.getcwd()
        os.chdir(self.config_dot_dp_path)
        try:
            ret_val = apply_patches(
                PatchApplicatorArguments(
                    arguments.log_level, arguments.write_log, False, suggestion_ids_str, [], False, False, False
                )
            )
            sub_logger.debug("Patch applicator return code: " + str(ret_val))
            os.chdir(save_dir)
        except Exception as ex:
            sub_logger.debug("Got Exception during call to patch applicator.")
            os.chdir(save_dir)
            raise ex
