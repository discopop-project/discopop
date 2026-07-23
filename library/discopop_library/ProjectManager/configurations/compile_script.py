# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os

PATH = str


def get_shared_compile_script_path(project_config_dir: PATH) -> PATH:
    return os.path.join(project_config_dir, "compile.sh")


def get_per_config_compile_script_path(project_config_dir: PATH, config_name: str) -> PATH:
    return os.path.join(project_config_dir, config_name, "compile.sh")


def resolve_compile_script_path(project_config_dir: PATH, config_name: str) -> PATH:
    """Returns the per-configuration compile.sh if it exists, otherwise the shared project-level one."""
    per_config_path = get_per_config_compile_script_path(project_config_dir, config_name)
    if os.path.exists(per_config_path):
        return per_config_path
    return get_shared_compile_script_path(project_config_dir)
