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
            display_execution_configurations(manager, config_dir),
            box="DOUBLE",
        )
        .set_title("[210 bold]DiscoPoP execution wizard")
    )
    manager.add(body, assign="body")
    wizard.push_body_window(body)

    buttons = (ptg.Window(
        ["Add Configuration", lambda *_: push_add_configuration_screen(manager, config_dir, wizard)],
        )
        .set_title("[210 bold]Screen specific options")
    )

    manager.add(buttons, assign="body_buttons")
    wizard.push_body_buttons(buttons)


def display_execution_configurations(manager: ptg.WindowManager, config_dir: str) -> ptg.Container:
    # load configuration options
    configs: List[ExecutionConfiguration] = load_execution_configurations(config_dir)
    container = ptg.Container()
    for config in configs:
        container.lazy_add(config.get_as_widget(manager))
    return container


def load_execution_configurations(config_dir: str) -> List[ExecutionConfiguration]:
    execution_configs: List[ExecutionConfiguration] = []
    with open(os.path.join(config_dir, "run_configurations.txt"), "r") as f:
        file_contents = f.read()
    loaded_dicts: List[dict] = []
    if len(file_contents) > 0:
        loaded_dicts = jsons.loads(file_contents)
    for config in loaded_dicts:
        exec_config = ExecutionConfiguration()
        exec_config.init_from_dict(config)
        execution_configs.append(exec_config)
    return execution_configs

