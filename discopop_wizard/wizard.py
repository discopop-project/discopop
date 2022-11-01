import os
from enum import IntEnum
from os.path import dirname
from typing import List, Tuple

import pytermgui as ptg

from discopop_wizard.screens.main import push_main_screen
# todo add command line option to list available run configurations
# todo add command line option to execute run configuration (by name)
from discopop_wizard.screens.utils import exit_program


def main():
    print("starting DiscoPoP Wizard...\n")
    discopop_dir = dirname(dirname(os.path.abspath(__file__)))
    config_dir = os.path.join(discopop_dir, ".config")

    # check if config exists, if not, initialize config folder and files
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)
    if not os.path.exists(os.path.join(config_dir, "run_configurations.txt")):
        # create run_configurations.txt
        with open(os.path.join(config_dir, "run_configurations.txt"), "w+"):
            pass

    wizard = DiscoPoPWizard(config_dir)
    print()

class ConsoleStyles(IntEnum):
    NORMAL = 1
    WARNING = 2
    ERROR = 3


class DiscoPoPWizard(object):
    body_window_stack: List[ptg.Window] = []
    body_button_stack: List[ptg.Window] = []
    console_log: List[Tuple[str, ConsoleStyles]] = [("Welcome to the DiscoPoP execution Wizard.", ConsoleStyles.NORMAL)]
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
            manager.layout.add_slot("Body")
            # A slot in the same row as body, using the full non-occupied height and
            # 20% of the terminal's height.
            manager.layout.add_slot("body_buttons", width=0.2, height=0.7)
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
        # get heigt from slot
        for slot in manager.layout.slots:
            if slot.name == "console":
                container.height = slot.height.value.real - 2
                break
        manager.add(window, assign="console")
        self.console_window = window

    def push_body_window(self, window: ptg.Window):
        self.body_window_stack.append(window)

    def push_body_buttons(self, window: ptg.Window):
        self.body_button_stack.append(window)

    def clear_window_stacks(self):
        self.body_window_stack = []
        self.body_button_stack = []

    def action_back(self, manager: ptg.WindowManager):
        """Pops one element from the window and button stack of the body.
        If the stack contains only a single element, close the application"""
        if len(self.body_window_stack) > 1:
            self.body_window_stack[-1].close()
            self.body_button_stack[-1].close()
            self.__show_output_console(manager)
        else:
            exit_program(manager)

    def __fill_console(self, container: ptg.Container):
        for line, style in self.console_log:
            if style == ConsoleStyles.NORMAL:
                container.lazy_add(ptg.Label(line))
            elif style == ConsoleStyles.WARNING:
                container.lazy_add(ptg.Label("[orange]"+line))
            elif style == ConsoleStyles.ERROR:
                container.lazy_add(ptg.Label("[red bold]"+line))
            container.get_lines()
            container.scroll(1)

    def print_to_console(self, manager: ptg.WindowManager, output: str, style=ConsoleStyles.NORMAL):
        self.console_log.append((output, style))
        self.__show_output_console(manager)




