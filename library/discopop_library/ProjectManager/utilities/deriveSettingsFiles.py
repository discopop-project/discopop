# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os
import json
import copy
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
import logging

logger = logging.getLogger("ConfigurationManager")


def derive_settings_files(arguments: ProjectManagerArguments) -> None:
    """Derives dp_settings.json, hd_settings.json, and par_settings.json from the shared seq_settings.json"""
    # load shared seq_settings.json
    shared_settings_path = os.path.join(arguments.project_config_dir, "seq_settings.json")
    if not os.path.exists(shared_settings_path):
        raise FileNotFoundError(shared_settings_path)

    with open(shared_settings_path, "r") as f:
        settings = json.load(f)

    # Derive and create shared settings files (overwrite if they exist)
    shared_dp_settings = os.path.join(arguments.project_config_dir, "dp_settings.json")
    dp_settings = copy.deepcopy(settings)
    dp_settings["CC"] = "discopop_cc"
    dp_settings["CXX"] = "discopop_cxx"
    with open(shared_dp_settings, "w") as f:
        json.dump(dp_settings, f, indent=2)
    logger.debug("Created derived settings file: " + shared_dp_settings)

    shared_hd_settings = os.path.join(arguments.project_config_dir, "hd_settings.json")
    hd_settings = copy.deepcopy(settings)
    hd_settings["CC"] = "discopop_hotspot_cc"
    hd_settings["CXX"] = "discopop_hotspot_cxx"
    hd_settings["CFLAGS"] += " -fopenmp" if len(hd_settings["CFLAGS"]) != 0 else "-fopenmp"
    hd_settings["CXXFLAGS"] += " -fopenmp" if len(hd_settings["CXXFLAGS"]) != 0 else "-fopenmp"
    with open(shared_hd_settings, "w") as f:
        json.dump(hd_settings, f, indent=2)
    logger.debug("Created derived settings file: " + shared_hd_settings)

    shared_par_settings = os.path.join(arguments.project_config_dir, "par_settings.json")
    parallel_settings = copy.deepcopy(settings)
    parallel_settings["CFLAGS"] += " -fopenmp" if len(parallel_settings["CFLAGS"]) != 0 else "-fopenmp"
    parallel_settings["CXXFLAGS"] += " -fopenmp" if len(parallel_settings["CXXFLAGS"]) != 0 else "-fopenmp"
    with open(shared_par_settings, "w") as f:
        json.dump(parallel_settings, f, indent=2)
    logger.debug("Created derived settings file: " + shared_par_settings)
