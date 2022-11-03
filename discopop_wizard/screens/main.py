import os.path
from typing import List

import jsons
import pytermgui as ptg

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.add_configuration import push_add_configuration_screen
from discopop_wizard.screens.utils import exit_program


def push_main_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    body = (
        ptg.Window(
            "",
            "Execution configurations",
            display_execution_configurations(manager, config_dir, wizard),
            box="DOUBLE",
        )
        .set_title("[210 bold]DiscoPoP execution wizard")
    )
    #manager.add(body, assign="body_left")

    buttons = (ptg.Window(
        ["Add Configuration", lambda *_: push_add_configuration_screen(manager, config_dir, wizard)]
        )
        .set_title("[210 bold]Screen specific options")
    )

    wizard.show_body_windows(manager, [(body, 0.8), (buttons, 0.2)])


def display_execution_configurations(manager: ptg.WindowManager, config_dir: str, wizard) -> ptg.Container:
    # load configuration options
    configs: List[ExecutionConfiguration] = load_execution_configurations(config_dir)
    container = ptg.Container()
    for config in configs:
        container.lazy_add(config.get_as_widget(manager, config_dir, wizard))
    return container


def load_execution_configurations(config_dir: str) -> List[ExecutionConfiguration]:
    execution_configs: List[ExecutionConfiguration] = []
    for filename in os.listdir(config_dir):
        with open(os.path.join(config_dir, filename), 'r') as script:
            config = ExecutionConfiguration()
            config.init_from_script(script)
            execution_configs.append(config)
    return execution_configs
