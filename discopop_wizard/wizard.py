# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
from enum import IntEnum
from os.path import dirname
from typing import List, Tuple, cast, Optional

import pytermgui as ptg
from pytermgui.window_manager.layouts import Relative, Static, Auto, Slot

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.screens.main import push_main_screen
# todo add command line option to list available run configurations
# todo add command line option to execute run configuration (by name)
from discopop_wizard.screens.utils import exit_program


def main(arguments: Arguments):
    print("starting DiscoPoP Wizard...\n")
    source_dir = dirname(os.path.abspath(__file__))  # source_dir: discopop/discopop_wizard
    config_dir = os.path.join(source_dir, ".config")

    # check if config exists, if not, initialize config folder and files
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)

    wizard = DiscoPoPConfigurationWizard(config_dir)
    print()


class ConsoleStyles(IntEnum):
    NORMAL = 1
    WARNING = 2
    ERROR = 3


class DiscoPoPConfigurationWizard(object):
    body_window_stack: List[List[Tuple[ptg.WindowManager, float]]] = []
    body_width_stack: List[Tuple[float, float]] = []  # (body_left width, body_right width)
    console_log: List[Tuple[str, ConsoleStyles]] = [("Welcome to the DiscoPoP Configuration Wizard.", ConsoleStyles.NORMAL)]
    console_window = None

    def __init__(self, config_dir: str):
        self.initialize_screen(config_dir)

    def initialize_screen(self, config_dir: str):
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
            manager.layout.add_slot("Header", height=1)
            manager.layout.add_break()
            # A body slot that will fill the entire width, and the height is remaining
            # width of body slots can be resized by each view
            manager.layout.add_slot("body_0", width=0.0, height=0.7)
            manager.layout.add_slot("body_1", width=0.0, height=0.7)
            manager.layout.add_slot("body_2", width=0.0, height=0.7)
            manager.layout.add_slot("body_3", width=0.0, height=0.7)
            manager.layout.add_slot("body_4", width=0.0, height=0.7)
            # A slot in the same row as body, using the full non-occupied height and
            # 20% of the terminal's height.
            manager.layout.add_slot("body_5", width=0.2, height=0.7)
            manager.layout.add_break()
            manager.layout.add_slot("console", height=0.2)
            manager.layout.add_break()
            # A footer with a static height of 10%
            manager.layout.add_slot("footer_left", height=3)
            manager.layout.add_slot("footer_right", height=3)

            self.__show_footer_buttons(manager)
            self.__show_output_console(manager)
            push_main_screen(manager, config_dir, self)

    def __show_footer_buttons(self, manager: ptg.WindowManager):
        window = ptg.Window(
            ["Back", lambda *_: self.action_back(manager)]
        )
        manager.add(window, assign="footer_left")
        window = ptg.Window(
            ["Exit", lambda *_: exit_program(manager)]
        )
        manager.add(window, assign="footer_right")

    def __show_output_console(self, manager: ptg.WindowManager):
        if self.console_window is not None:
            self.console_window.close()
        window = (ptg.Window(
        )
                  .set_title("[210 bold]Output console")
                  )
        container = ptg.Container()

        container.overflow = ptg.Overflow.SCROLL
        self.__fill_console(container)
        window.lazy_add(container)
        # get height from slot
        for slot in manager.layout.slots:
            if slot.name == "console":
                container.height = slot.height.value.real - 2
                break
        manager.add(window, assign="console")
        self.console_window = window

    def show_body_windows(self, manager: ptg.WindowManager, windows: List[Tuple[ptg.WindowManager, float]],
                          push_to_stack=True):  # [(window, width)]
        if len(windows) > 5:
            raise ValueError("Maximum of 5 windows can be displayed in Body!")
        while len(windows) < 5:
            windows.append((ptg.Window(), 0.0))
        # close old windows
        for slot in manager.layout.slots:
            if slot.name in ["body_0", "body_1", "body_2", "body_3", "body_4", "body_5"]:
                if type(slot.content) == ptg.Window:
                    slot.content.close()

        # resize slots according to windows
        for idx, (window, width) in enumerate(windows):
            for slot in manager.layout.slots:
                if slot.name == "body_" + str(idx):
                    slot = cast(Slot, slot)
                    if not isinstance(slot.width, Relative):
                        raise ValueError("Width must be relative!")
                    cast(Relative, slot.width).scale = width

        # add windows to manager
        for idx, (window, width) in enumerate(windows):
            window.width = width
            manager.add(window, assign="body_" + str(idx))

        # add windows to stack
        if push_to_stack:
            self.body_window_stack.append(windows)

    def clear_window_stacks(self):
        self.body_window_stack = []
        self.body_width_stack = []

    def action_back(self, manager: ptg.WindowManager):
        """Pops one element from the window and button stack of the body.
        If the stack contains only a single element, close the application"""
        if len(self.body_window_stack) > 1:
            self.body_window_stack.pop()
            self.show_body_windows(manager, self.body_window_stack[-1], push_to_stack=False)
            self.__show_output_console(manager)
        else:
            exit_program(manager)

    def __fill_console(self, container: ptg.Container):
        for line, style in self.console_log:
            if style == ConsoleStyles.NORMAL:
                container.lazy_add(ptg.Label(line))
            elif style == ConsoleStyles.WARNING:
                container.lazy_add(ptg.Label("[orange]" + line))
            elif style == ConsoleStyles.ERROR:
                container.lazy_add(ptg.Label("[red bold]" + line))
            container.get_lines()
            container.scroll(1 + line.count("\n"))

    def print_to_console(self, manager: ptg.WindowManager, output: str, style=ConsoleStyles.NORMAL):
        self.console_log.append((output, style))
        self.__show_output_console(manager)
