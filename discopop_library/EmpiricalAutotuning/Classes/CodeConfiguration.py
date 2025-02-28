# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
import json
import logging
import os
from pathlib import Path
import shutil
import subprocess
import time
from typing import Callable, Dict, List, Optional
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.EmpiricalAutotuning.Classes.ExecutionResult import ExecutionResult
from discopop_library.EmpiricalAutotuning.Statistics.StatisticsGraph import NodeColor
from discopop_library.EmpiricalAutotuning.Types import SUGGESTION_ID
from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments
from discopop_library.PatchApplicator.patch_applicator import run as apply_patches
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
from discopop_library.ProjectManager.configurations.copying import copy_configuration
from discopop_library.ProjectManager.configurations.execution import execute_configuration

logger = logging.getLogger("CodeConfiguration")


class CodeConfiguration(object):
    root_path: str
    config_dot_dp_path: str
    settings_name: str
    execution_result: Optional[ExecutionResult]

    def __init__(self, root_path: str, config_dot_dp_path: str, settings_name: str):

        self.root_path = root_path
        self.settings_name = settings_name
        if self.root_path.endswith("/"):
            self.root_path = self.root_path[:-1]
        self.config_dot_dp_path = config_dot_dp_path
        if self.config_dot_dp_path.endswith("/"):
            self.config_dot_dp_path = self.config_dot_dp_path[:-1]
        self.execution_result = None
        logger.debug("Created configuration: " + root_path)

    def __str__(self) -> str:
        return self.root_path

    def execute(
        self, arguments: AutotunerArguments, timeout: Optional[float], thread_count: int, is_initial: bool = False
    ) -> None:

        cm_args = ProjectManagerArguments(
            log_level=arguments.log_level,
            write_log=arguments.write_log,
            project_root=arguments.project_path,
            full_execute=False,
            list=False,
            execute_configurations=arguments.configuration,
            execute_inplace=False,
            skip_cleanup=arguments.skip_cleanup,
            generate_report=False,
            show_report=False,
            initialize_directory=False,
            apply_suggestions=None,
            reset=False,
            reset_execution_results=False,
            label_prefix="",
        )

        compilation_successful = True
        ret = execute_configuration(
            cm_args,
            self.root_path,
            os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration),
            os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration, self.settings_name),
            os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration, "compile.sh"),
            thread_count,
            timeout,
        )

        if ret is None or ret[0] != 0:
            print("Error during compilation!\n" + "" if ret is None else ("STDERR: " + ret[3]))
            self.execution_result = ExecutionResult(0.1, 1, False, False)
            compilation_successful = False

        if compilation_successful:
            ret = execute_configuration(
                cm_args,
                self.root_path,
                os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration),
                os.path.join(
                    self.config_dot_dp_path, "project", "configs", arguments.configuration, self.settings_name
                ),
                os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration, "execute.sh"),
                thread_count,
                timeout,
            )
        else:
            ret = None
        if ret is None:
            result_returncode = 1
            required_time = 1.0
        else:
            result_returncode, required_time, out, err = ret

        # DUMMY VALUES
        result_valid = result_returncode == 0
        thread_sanitizer_valid = True

        # reporting
        logger.debug("Execution took " + str(round(required_time, 4)) + " s")
        logger.debug("Execution return code: " + str(result_returncode))
        logger.debug("Execution result valid: " + str(result_valid))
        logger.debug("ThreadSanitizer valid: " + str(thread_sanitizer_valid))

        self.execution_result = ExecutionResult(required_time, result_returncode, result_valid, thread_sanitizer_valid)

    def create_copy(
        self, arguments: AutotunerArguments, settings_name: str, get_new_configuration_id: Callable[[], int]
    ) -> CodeConfiguration:
        # create a copy of the project folder
        cm_args = ProjectManagerArguments(
            log_level=arguments.log_level,
            write_log=arguments.write_log,
            project_root=arguments.project_path,
            full_execute=False,
            list=False,
            execute_configurations=arguments.configuration,
            execute_inplace=False,
            skip_cleanup=arguments.skip_cleanup,
            generate_report=False,
            show_report=False,
            initialize_directory=False,
            apply_suggestions=None,
            reset=False,
            reset_execution_results=False,
            label_prefix="",
        )
        dest_path = copy_configuration(
            cm_args,
            arguments.configuration,
            os.path.join(self.config_dot_dp_path, "project", "configs", arguments.configuration, settings_name),
            get_new_configuration_id(),
        )
        new_dot_discopop_path = os.path.join(dest_path, ".discopop")

        # create a new CodeConfiguration object
        return CodeConfiguration(dest_path, new_dot_discopop_path, settings_name)

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
                    "WARNING", arguments.write_log, False, suggestion_ids_str, [], False, False, False
                )
            )
            sub_logger.debug("Patch applicator return code: " + str(ret_val))
            os.chdir(save_dir)
        except Exception as ex:
            sub_logger.debug("Got Exception during call to patch applicator.")
            os.chdir(save_dir)
            raise ex

    def get_statistics_graph_label(self) -> str:
        res_str = "" + self.root_path + "\n"
        if self.execution_result is None:
            res_str += "Not executed."
        else:
            res_str += str(round(self.execution_result.runtime, 3)) + "s"

        return res_str

    def get_statistics_graph_color(self) -> NodeColor:
        if self.execution_result is None:
            return NodeColor.ORANGE
        if self.execution_result.result_valid and self.execution_result.return_code == 0:
            return NodeColor.GREEN
        if self.execution_result.return_code == 0 and not self.execution_result.result_valid:
            return NodeColor.ORANGE
        return NodeColor.RED
