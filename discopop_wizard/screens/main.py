# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os.path
from typing import List

import pytermgui as ptg

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.add_configuration import push_add_configuration_screen
from discopop_wizard.screens.settings import push_settings_screen
from discopop_wizard.screens.utils import exit_program


def push_main_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    body = (
        ptg.Window(
            "",
            "Execution configurations",
            display_execution_configurations(manager, config_dir, wizard),
            box="DOUBLE",
        )
        .set_title("[210 bold]DiscoPoP Configuration Wizard")
    )
    body.overflow = ptg.Overflow.SCROLL
    #manager.add(body, assign="body_left")

    buttons = (ptg.Window(
        ["Add Configuration", lambda *_: push_add_configuration_screen(manager, config_dir, wizard)],
        "",
        "",
        ["Settings", lambda *_: push_settings_screen(manager, config_dir, wizard)],
        )
        .set_title("[210 bold]Screen specific options")
    )

    wizard.show_body_windows(manager, [(body, 0.75), (buttons, 0.2)])


def display_execution_configurations(manager: ptg.WindowManager, config_dir: str, wizard) -> ptg.Container:
    # load configuration options
    configs: List[ExecutionConfiguration] = load_execution_configurations(config_dir)
    container = ptg.Container()
    for config in configs:
        container.lazy_add(config.get_as_widget(manager, config_dir, wizard))
    return container


def load_execution_configurations(config_dir: str) -> List[ExecutionConfiguration]:
    execution_configs: List[ExecutionConfiguration] = []
    for filename in os.listdir(os.path.join(config_dir, "execution_configurations")):
        with open(os.path.join(os.path.join(config_dir, "execution_configurations"), filename), 'r') as script:
            config = ExecutionConfiguration()
            config.init_from_script(script)
            execution_configs.append(config)
    return execution_configs
