# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from typing import Dict, List, Optional
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
import logging
from tabulate import tabulate  # type: ignore

from discopop_library.ProjectManager.configurations.compile_script import resolve_compile_script_path
from discopop_library.ProjectManager.configurations.copying import copy_configuration
from discopop_library.ProjectManager.configurations.deletion import delete_configuration
from discopop_library.ProjectManager.configurations.execution import execute_configuration

logger = logging.getLogger("ConfigurationManager")

PATH = str
NAME = str  # todo rename


def __get_legend() -> str:
    return """Legend:
(C):  Compatibility: required scripts and settings exist and validated via execution.
(TC): Theoretical Compatibility: required scripts and settings exist but not validated.
(F):  Failure: executing the script resulted in a non-zero return code.
(M):  Missing: file does not exist
(NV):  Not validated
"""


def show_configurations_without_execution(arguments: ProjectManagerArguments) -> None:
    logger.info("listing available configurations without execution ...")

    # collect configurations
    configurations = [f.path for f in os.scandir(arguments.project_config_dir) if f.is_dir()]

    compatibility: Dict[PATH, Dict[NAME, bool]] = dict()
    table = [["Configuration", "(TC) Autotuner"]]
    # collect compatibility information
    for config in configurations:
        # autotuner: dp settings & hd settings
        dp_settings = os.path.join(config, "dp_settings.json")
        hd_settings = os.path.join(config, "hd_settings.json")
        dp_settings_exist = os.path.exists(dp_settings)
        hd_settings_exist = os.path.exists(hd_settings)
        if not config in compatibility:
            compatibility[config] = dict()
        compatibility[config]["autotuner"] = dp_settings_exist and hd_settings_exist

        # prepare display
        # --> autotuner
        if compatibility[config]["autotuner"]:
            autotuner_cell_contents = "PASS"
        else:
            autotuner_cell_contents = ""
            autotuner_cell_contents += "(M) dp - settings\n" if not dp_settings_exist else ""
            autotuner_cell_contents += "(M) hd - settings\n" if not hd_settings_exist else ""

        table.append([os.path.basename(config), autotuner_cell_contents])

    # display
    print(__get_legend())
    print(tabulate(table, tablefmt="grid"))


def show_configurations_with_execution(
    arguments: ProjectManagerArguments, restricted_configurations: Optional[List[str]] = None
) -> None:
    logger.info("listing configurations with validating execution ...")
    # prepare restrictions
    config_restrictions: Dict[NAME, List[str]] = dict()
    config_thread_counts: Dict[NAME, Dict[str, int]] = dict()

    if restricted_configurations is not None:
        for entry in restricted_configurations:
            if ":" in entry:
                config_name = entry.split(":")[0]
                config_mode = entry.split(":")[1]
                config_thread_count = int(entry.split(":")[2]) if entry.count(":") > 1 else __get_default_thread_count()
            else:
                config_name = entry
                config_mode = ""
                config_thread_count = 1 if config_name == "seq" else __get_default_thread_count()
            if config_name not in config_restrictions:
                config_restrictions[config_name] = []
            if len(config_mode) > 0:
                config_restrictions[config_name].append(config_mode)
            if config_name not in config_thread_counts:
                config_thread_counts[config_name] = dict()
            non_null_cfc = 1
            if config_thread_count is not None:
                non_null_cfc = config_thread_count
            config_thread_counts[config_name][config_mode] = non_null_cfc

    # collect and restrict configurations if required
    configurations = [f.path for f in os.scandir(arguments.project_config_dir) if f.is_dir()]
    if len(config_restrictions) != 0:
        logger.debug("restricting tested configurations to: " + str(config_restrictions))
        configurations = [config for config in configurations if os.path.basename(config) in config_restrictions]

    compatibility: Dict[PATH, Dict[NAME, bool]] = dict()
    table = [["Configuration", "Overview", "(C) Autotuner"]]
    # execute configurations and collect compatibility information
    for config in configurations:
        # declare values
        dp_settings_exist = False
        dp_compile_successful = False
        dp_execute_successful = False
        hd_settings_exist = False
        hd_compile_successful = False
        hd_execute_successful = False
        seq_settings_exist = False
        seq_compile_successful = False
        seq_execute_successful = False
        seq_validate_successful = False
        par_settings_exist = False
        par_compile_successful = False
        par_execute_successful = False
        par_validate_successful = False
        # validate.sh is an optional, per-config script that re-runs the code and
        # validates its output, separated from the timed execute.sh run. It is only
        # applied to the "real" runs (seq/par); dp/hd are profiling modes where
        # re-running the instrumented binary would regenerate profiling data.
        validate_sh = os.path.join(config, "validate.sh")
        validate_sh_exists = os.path.exists(validate_sh)

        # collect overview information
        compile_sh = resolve_compile_script_path(arguments.project_config_dir, os.path.basename(config))
        shared_dp_settings = os.path.join(arguments.project_config_dir, "dp_settings.json")
        shared_hd_settings = os.path.join(arguments.project_config_dir, "hd_settings.json")
        shared_seq_settings = os.path.join(arguments.project_config_dir, "seq_settings.json")
        shared_par_settings = os.path.join(arguments.project_config_dir, "par_settings.json")

        # --> dp
        dp_settings_exist = os.path.exists(shared_dp_settings)
        if __is_selected(config_restrictions, config, "dp"):
            dp_project_path = (
                arguments.project_root
                if arguments.execute_inplace
                else copy_configuration(arguments, config, shared_dp_settings)
            )

            ret = execute_configuration(
                arguments,
                dp_project_path,
                config,
                shared_dp_settings,
                compile_sh,
                __get_thread_count(config, "dp", config_thread_counts),
                arguments.timeout_compilation,
            )
            dp_compile_successful = ret is not None and ret[0] == 0

            if dp_compile_successful:
                ret = execute_configuration(
                    arguments,
                    dp_project_path,
                    config,
                    shared_dp_settings,
                    os.path.join(config, "execute.sh"),
                    __get_thread_count(config, "dp", config_thread_counts),
                    arguments.timeout_execution,
                )
                dp_execute_successful = ret is not None and ret[0] == 0
            if not (arguments.skip_cleanup or arguments.execute_inplace):
                delete_configuration(arguments, dp_project_path)
        # --> hd
        hd_settings_exist = os.path.exists(shared_hd_settings)
        if __is_selected(config_restrictions, config, "hd"):
            hd_project_path = (
                arguments.project_root
                if arguments.execute_inplace
                else copy_configuration(arguments, config, shared_hd_settings)
            )

            ret = execute_configuration(
                arguments,
                hd_project_path,
                config,
                shared_hd_settings,
                compile_sh,
                __get_thread_count(config, "hd", config_thread_counts),
                arguments.timeout_compilation,
            )
            hd_compile_successful = ret is not None and ret[0] == 0

            if hd_compile_successful:
                ret = execute_configuration(
                    arguments,
                    hd_project_path,
                    config,
                    shared_hd_settings,
                    os.path.join(config, "execute.sh"),
                    __get_thread_count(config, "hd", config_thread_counts),
                    arguments.timeout_execution,
                )
                hd_execute_successful = ret is not None and ret[0] == 0
            if not (arguments.skip_cleanup or arguments.execute_inplace):
                delete_configuration(arguments, hd_project_path)
        # --> seq
        seq_settings_exist = os.path.exists(shared_seq_settings)
        if __is_selected(config_restrictions, config, "seq"):
            seq_project_path = (
                arguments.project_root
                if arguments.execute_inplace
                else copy_configuration(arguments, config, shared_seq_settings)
            )
            ret = execute_configuration(
                arguments,
                seq_project_path,
                config,
                shared_seq_settings,
                compile_sh,
                __get_thread_count(config, "seq", config_thread_counts),
                arguments.timeout_compilation,
            )
            seq_compile_successful = ret is not None and ret[0] == 0

            if seq_compile_successful:
                ret = execute_configuration(
                    arguments,
                    seq_project_path,
                    config,
                    shared_seq_settings,
                    os.path.join(config, "execute.sh"),
                    __get_thread_count(config, "seq", config_thread_counts),
                    arguments.timeout_execution,
                )
                seq_execute_successful = ret is not None and ret[0] == 0

                # optional output validation (auto-run when validate.sh exists)
                if seq_execute_successful and validate_sh_exists:
                    ret = execute_configuration(
                        arguments,
                        seq_project_path,
                        config,
                        shared_seq_settings,
                        validate_sh,
                        __get_thread_count(config, "seq", config_thread_counts),
                        arguments.timeout_validation,
                    )
                    seq_validate_successful = ret is not None and ret[0] == 0
                else:
                    # no validate.sh => execute.sh alone decides correctness
                    seq_validate_successful = seq_execute_successful
            if not (arguments.skip_cleanup or arguments.execute_inplace):
                delete_configuration(arguments, seq_project_path)
        # --> par
        par_settings_exist = os.path.exists(shared_par_settings)
        if __is_selected(config_restrictions, config, "par"):
            par_project_path = (
                arguments.project_root
                if arguments.execute_inplace
                else copy_configuration(arguments, config, shared_par_settings)
            )
            ret = execute_configuration(
                arguments,
                par_project_path,
                config,
                shared_par_settings,
                compile_sh,
                __get_thread_count(config, "par", config_thread_counts),
                arguments.timeout_compilation,
            )
            par_compile_successful = ret is not None and ret[0] == 0

            if par_compile_successful:
                ret = execute_configuration(
                    arguments,
                    par_project_path,
                    config,
                    shared_par_settings,
                    os.path.join(config, "execute.sh"),
                    __get_thread_count(config, "par", config_thread_counts),
                    arguments.timeout_execution,
                )
                par_execute_successful = ret is not None and ret[0] == 0

                # optional output validation (auto-run when validate.sh exists)
                if par_execute_successful and validate_sh_exists:
                    ret = execute_configuration(
                        arguments,
                        par_project_path,
                        config,
                        shared_par_settings,
                        validate_sh,
                        __get_thread_count(config, "par", config_thread_counts),
                        arguments.timeout_validation,
                    )
                    par_validate_successful = ret is not None and ret[0] == 0
                else:
                    # no validate.sh => execute.sh alone decides correctness
                    par_validate_successful = par_execute_successful
            if not (arguments.skip_cleanup or arguments.execute_inplace):
                delete_configuration(arguments, par_project_path)

        # collect information: autotuner
        if not config in compatibility:
            compatibility[config] = dict()
        compatibility[config]["autotuner"] = (
            dp_settings_exist
            and hd_settings_exist
            and dp_compile_successful
            and dp_execute_successful
            and hd_compile_successful
            and hd_execute_successful
        )

        # prepare display
        # --> overview
        overview_cell_contents = ""
        if __is_selected(config_restrictions, config, "dp"):
            overview_cell_contents += "(PASS) dp - settings\n" if dp_settings_exist else "(M) dp - settings\n"
            overview_cell_contents += "(PASS) dp - compile\n" if dp_compile_successful else "(F) dp - compile\n"
            overview_cell_contents += "(PASS) dp - execute\n" if dp_execute_successful else "(F) dp - execute\n"
        if __is_selected(config_restrictions, config, "hd"):
            overview_cell_contents += "(PASS) hd - settings\n" if hd_settings_exist else "(M) hd - settings\n"
            overview_cell_contents += "(PASS) hd - compile\n" if hd_compile_successful else "(F) hd - compile\n"
            overview_cell_contents += "(PASS) hd - execute\n" if hd_execute_successful else "(F) hd - execute\n"
        if __is_selected(config_restrictions, config, "seq"):
            overview_cell_contents += "(PASS) seq - settings\n" if seq_settings_exist else "(M) seq - settings\n"
            overview_cell_contents += "(PASS) seq - compile\n" if seq_compile_successful else "(F) seq - compile\n"
            overview_cell_contents += "(PASS) seq - execute\n" if seq_execute_successful else "(F) seq - execute\n"
            if validate_sh_exists:
                overview_cell_contents += (
                    "(PASS) seq - validate\n" if seq_validate_successful else "(F) seq - validate\n"
                )
        if __is_selected(config_restrictions, config, "par"):
            overview_cell_contents += "(PASS) par - settings\n" if par_settings_exist else "(M) par - settings\n"
            overview_cell_contents += "(PASS) par - compile\n" if par_compile_successful else "(F) par - compile\n"
            overview_cell_contents += "(PASS) par - execute\n" if par_execute_successful else "(F) par - execute\n"
            if validate_sh_exists:
                overview_cell_contents += (
                    "(PASS) par - validate\n" if par_validate_successful else "(F) par - validate\n"
                )
        # --> autotuner
        if compatibility[config]["autotuner"]:
            autotuner_cell_contents = "PASS "
        else:
            autotuner_dp_failure_marker = (
                "(NV)"
                if (
                    os.path.basename(config) in config_restrictions
                    and "dp" not in config_restrictions[os.path.basename(config)]
                )
                else "(F)"
            )
            autotuner_hd_failure_marker = (
                "(NV)"
                if (
                    os.path.basename(config) in config_restrictions
                    and "hd" not in config_restrictions[os.path.basename(config)]
                )
                else "(F)"
            )
            autotuner_cell_contents = ""
            autotuner_cell_contents += "(M) dp - settings\n" if not dp_settings_exist else ""
            autotuner_cell_contents += (
                autotuner_dp_failure_marker + " dp - compile\n" if not dp_compile_successful else ""
            )
            autotuner_cell_contents += (
                autotuner_dp_failure_marker + " dp - execute\n" if not dp_execute_successful else ""
            )
            autotuner_cell_contents += "(M) hd - settings\n" if not hd_settings_exist else ""
            autotuner_cell_contents += (
                autotuner_hd_failure_marker + " hd - compile\n" if not hd_compile_successful else ""
            )
            autotuner_cell_contents += (
                autotuner_hd_failure_marker + " hd - execute\n" if not hd_execute_successful else ""
            )

        table.append([os.path.basename(config), overview_cell_contents, autotuner_cell_contents])

    # display
    print(__get_legend())
    print(tabulate(table, tablefmt="grid"))


def __is_selected(config_restrictions: Dict[NAME, List[str]], config: str, mode: str) -> bool:
    return len(config_restrictions) == 0 or (
        os.path.basename(config) in config_restrictions
        and (
            len(config_restrictions[os.path.basename(config)]) == 0
            or mode in config_restrictions[os.path.basename(config)]
        )
    )


def __get_thread_count(config: str, mode: str, config_thread_counts: dict[NAME, Dict[str, int]]) -> int:
    config_name = os.path.basename(config)
    if mode == "seq":
        return 1
    if config_name in config_thread_counts:
        if mode in config_thread_counts[config_name]:
            return config_thread_counts[config_name][mode]

    return __get_default_thread_count()


def __get_default_thread_count() -> int:
    cpu_count = os.cpu_count()
    if cpu_count is None:
        return 4  # default if no value could be determined

    return int(cpu_count / 2)  # account of hyperthreading typically encountered as a default
