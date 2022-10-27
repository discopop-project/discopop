import json
import os.path
from typing import List

import jsons
import pytermgui as ptg

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.add_configuration import show_add_configuration_screen
from discopop_wizard.screens.utils import submit, exit_program


def initialize_screen(config_dir: str):
    CONFIG = """
            config:
                InputField:
                    styles:
                        prompt: dim italic
                        cursor: '@72'
                Label:
                    styles:
                        value: dim bold

                Window:
                    styles:
                        border: '60'
                        corner: '60'

                Container:
                    styles:
                        border: '96'
                        corner: '96'
            """

    with ptg.YamlLoader() as loader:
        loader.load(CONFIG)

    with ptg.WindowManager() as manager:
        manager.layout = ptg.Layout()
        show_main_screen(manager, config_dir)


def show_main_screen(manager: ptg.WindowManager, config_dir: str):
    window = (
        ptg.Window(
            "",
            "Execution configurations",
            display_execution_configurations(manager, config_dir),
            ["Add Configuration", lambda *_: show_add_configuration_screen(manager, config_dir)],
            ["Exit", lambda *_: exit_program(manager)],
            width=120,
            height=24,
            box="DOUBLE",
        )
        .set_title("[210 bold]DiscoPoP execution wizard")
        .center()
    )
    manager.add(window)


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
