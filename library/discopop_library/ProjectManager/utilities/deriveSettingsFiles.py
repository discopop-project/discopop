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
    configurations = [f.path for f in os.scandir(arguments.project_config_dir) if f.is_dir()]
    for config in configurations:
        # load original settings
        settings_path = os.path.join(config, "seq_settings.json")
        if not os.path.exists(settings_path):
            raise FileNotFoundError(settings_path)

        with open(settings_path, "r") as f:
            settings = json.load(f)

        # create dp_settings.json
        dp_settings_path = os.path.join(config, "dp_settings.json")
        if not os.path.exists(dp_settings_path):
            dp_settings = copy.deepcopy(settings)
            dp_settings["CC"] = "discopop_cc"
            dp_settings["CXX"] = "discopop_cxx"
            with open(dp_settings_path, "w+") as f:
                json.dump(dp_settings, f)
            logger.debug("Created derived settings file: " + dp_settings_path)
        # create hd_settings.json
        hd_settings_path = os.path.join(config, "hd_settings.json")
        if not os.path.exists(hd_settings_path):
            hd_settings = copy.deepcopy(settings)
            hd_settings["CC"] = "discopop_hotspot_cc"
            hd_settings["CXX"] = "discopop_hotspot_cxx"
            hd_settings["CFLAGS"] += " -fopenmp" if len(hd_settings["CFLAGS"]) != 0 else "-fopenmp"
            hd_settings["CXXFLAGS"] += " -fopenmp" if len(hd_settings["CXXFLAGS"]) != 0 else "-fopenmp"
            with open(hd_settings_path, "w+") as f:
                json.dump(hd_settings, f)
            logger.debug("Created derived settings file: " + hd_settings_path)
        # create par_settings.json
        parallel_settings_path = os.path.join(config, "par_settings.json")
        if not os.path.exists(parallel_settings_path):
            parallel_settings = copy.deepcopy(settings)
            parallel_settings["CFLAGS"] += " -fopenmp" if len(parallel_settings["CFLAGS"]) != 0 else "-fopenmp"
            parallel_settings["CXXFLAGS"] += " -fopenmp" if len(parallel_settings["CXXFLAGS"]) != 0 else "-fopenmp"
            with open(parallel_settings_path, "w+") as f:
                json.dump(parallel_settings, f)
            logger.debug("Created derived settings file: " + parallel_settings_path)
