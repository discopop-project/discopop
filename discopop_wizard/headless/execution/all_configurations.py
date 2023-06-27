import os
from typing import List

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.classes.Settings import load_from_config_file
from discopop_wizard.screens.execution import ExecutionView
from discopop_wizard.wizard import DiscoPoPConfigurationWizard


def execute_all_stored_configurations(args: Arguments, source_dir: str):
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
        with open(os.path.join(os.path.join(config_dir, "execution_configurations"), filename), 'r') as json_file:
            config = ExecutionConfiguration(wizard)
            config.init_from_json(json_file)
            execution_configs.append(config)
    # create execution views
    execution_views: List[ExecutionView] = []
    for config in execution_configs:
        execution_views.append(ExecutionView(config, wizard, None, headless_mode=True))

