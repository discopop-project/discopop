# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import shutil
import subprocess
from typing import Dict
import warnings
from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
import logging

logger = logging.getLogger("ConfigurationManager")

initial_settings_content: Dict[str, str] = {"CC": "clang", "CXX": "clang++", "CFLAGS": "", "CXXFLAGS": ""}

initial_script_content = """echo "Please set the contents of the script according to the wiki: https://discopop-project.github.io/discopop/"
echo "The scripts need to make use of CC / CXX and the according flags CFLAGS / CXXFLAGS and return 0 upon successful execution."
echo "Document: $(realpath $0)"
exit 1
"""


def initialize_configuration_files(arguments: ProjectManagerArguments) -> None:
    """adds the missing files for stored configurations, for example after initialization of the directories"""
    for configuration_path in [f.path for f in os.scandir(arguments.project_config_dir) if f.is_dir()]:
        file_list = [
            os.path.join(configuration_path, "seq_settings.json"),
            os.path.join(configuration_path, "compile.sh"),
            os.path.join(configuration_path, "execute.sh"),
        ]

        for file in file_list:
            if not os.path.exists(file):
                if file.endswith("settings.json"):
                    with open(file, "w+") as f:
                        json.dump(initial_settings_content, f)
                        logger.info("Created configuration file: " + str(file))

                else:
                    with open(file, "w+") as f:
                        f.write(initial_script_content)
                        logger.info("Created configuration file: " + str(file))
                    # make executable
                    cmd = "chmod +x " + file
                    result = subprocess.run(
                        cmd,
                        executable="/bin/bash",
                        shell=True,
                        capture_output=True,
                    )
                    if result.returncode != 0:
                        warnings.warn(
                            "Created script "
                            + str(file)
                            + " could not be marked as executable via \n"
                            + cmd
                            + "\nPlease fix this manually.\nstderr: \n->"
                            + str(result.stderr.decode("utf-8"))
                        )
