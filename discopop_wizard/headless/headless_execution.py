# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from typing import List, Tuple

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.classes.Settings import load_from_config_file, Settings
from discopop_wizard.screens.execution import ExecutionView
from discopop_wizard.wizard import DiscoPoPConfigurationWizard


def execute_all_stored_configurations(args: Arguments, source_dir: str):
    wizard, settings, execution_configs = __load_data(args, source_dir)
    # execute all configurations
    execution_views: List[ExecutionView] = []
    for config in execution_configs:
        execution_views.append(ExecutionView(config, wizard, None, headless_mode=True))


def execute_tag_filtered_configurations(args: Arguments, source_dir: str):
    wizard, settings, execution_configs = __load_data(args, source_dir)
    # filter configurations by tags
    filtered_execution_configs: List[ExecutionConfiguration] = []
    for config in execution_configs:
        # get tags from config
        # get tags from arguments
        # if an overlap exists, the configurations shall be executed
        overlapping_tags = [tag for tag in config.get_tags() if tag in args.execute_configurations_with_tag]
        if len(overlapping_tags) > 0:
            filtered_execution_configs.append(config)

    # execute the filtered configurations
    execution_views: List[ExecutionView] = []
    for config in filtered_execution_configs:
        execution_views.append(ExecutionView(config, wizard, None, headless_mode=True))


def __load_data(
    args: Arguments, source_dir: str
) -> Tuple[DiscoPoPConfigurationWizard, Settings, List[ExecutionConfiguration]]:
    """Loads and returns a DiscoPoPConfigurationWizard, Settings, and a list of ExecutionConfigurations."""
    config_dir = os.path.join(source_dir, ".config")
    # load settings
    settings = load_from_config_file(config_dir)
    # create DiscoPoPWizard
    wizard = DiscoPoPConfigurationWizard(config_dir, args, headless_mode=True)

    # load execution configurations
    execution_configs: List[ExecutionConfiguration] = []
    for filename in os.listdir(os.path.join(config_dir, "execution_configurations")):
        if not filename.endswith(".json"):
            continue
        with open(os.path.join(os.path.join(config_dir, "execution_configurations"), filename), "r") as json_file:
            config = ExecutionConfiguration(wizard)
            config.init_from_json(json_file)
            execution_configs.append(config)

    return wizard, settings, execution_configs
