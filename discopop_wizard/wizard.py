# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import pathlib
import tkinter as tk
import warnings
from tkinter import ttk
from enum import IntEnum
from os.path import dirname
from typing import Optional

from discopop_wizard.classes.Arguments import Arguments
from discopop_wizard.classes.Console import Console
from discopop_wizard.classes.ProfilingContainer import ProfilingContainer
from discopop_wizard.classes.Settings import Settings, load_from_config_file
from discopop_wizard.screens.main import MainScreen
# todo add command line option to list available run configurations
# todo add command line option to execute run configuration (by name)
from discopop_wizard.screens.settings import show_settings_screen, save_settings


def main(arguments: Arguments):
    print("starting DiscoPoP Wizard...\n")
    source_dir = dirname(os.path.abspath(__file__))  # source_dir: discopop/discopop_wizard
    config_dir = os.path.join(source_dir, ".config")

    # check if config exists, if not, initialize config folder and files
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)
    if not os.path.exists(os.path.join(config_dir, "execution_configurations")):
        os.mkdir(os.path.join(config_dir, "execution_configurations"))

    # check if SETTINGS file exists. if not, create it.
    if not os.path.exists(os.path.join(config_dir, "SETTINGS.txt")):
        with open(os.path.join(config_dir, "SETTINGS.txt"), "w+"):
            pass

    wizard = DiscoPoPConfigurationWizard(config_dir, arguments)
    print()


class ConsoleStyles(IntEnum):
    NORMAL = 1
    WARNING = 2
    ERROR = 3


class DiscoPoPConfigurationWizard(object):
    arguments: Arguments
    settings: Optional[Settings]
    window: tk.Tk
    window_frame: tk.Frame
    config_dir: str
    menubar: tk.Menu
    profiling_container: Optional[ProfilingContainer] = None

    ## font styles
    style_font_bold: str = "Helvetica 12 bold"
    style_font_bold_small: str = "Helvetica 10 bold"

    def __init__(self, config_dir: str, arguments: Arguments):
        self.arguments = arguments
        self.config_dir = config_dir
        # check if settings exist
        if os.stat(os.path.join(config_dir, "SETTINGS.txt")).st_size == 0:
            # no settings exist
            prompt_result = tk.messagebox.askyesno("DiscoPoP Wizard",
                                                   "Do you want to make use of a docker container for the profiling?")
            if not prompt_result:
                # ask user for path to discopop_build and go/bin directory
                discopop_build_dir = tk.filedialog.askdirectory(title="Select DiscoPoP build folder")
                go_bin_dir = tk.filedialog.askdirectory(title="Select go/bin folder (Go installation)")
            else:
                discopop_build_dir = ""
                go_bin_dir = ""
            self.settings = Settings(use_docker_container=prompt_result, discopop_build_dir=discopop_build_dir,
                                     go_bin_dir=go_bin_dir)
        else:
            # load settings
            self.settings = load_from_config_file(config_dir)

        self.initialize_screen(config_dir)

    def initialize_screen(self, config_dir: str):

        self.window = tk.Tk()
        self.window.title("DiscoPoP Wizard")

        try:
            photo = tk.PhotoImage(
                file=os.path.join(str(pathlib.Path(__file__).parent.resolve()), "assets", "icons", "discoPoP_128x128.png"))
            self.window.iconphoto(False, photo)
        except tk.TclError:
            warnings.warn("Loading the window icon was not successful.")

        # set window to full screen
        self.window.attributes('-zoomed', True)
        self.window.columnconfigure(1, weight=1)
        self.window.rowconfigure(1, weight=1)
        paned_window = ttk.PanedWindow(self.window, orient=tk.VERTICAL)
        paned_window.pack(fill=tk.BOTH, expand=True)

        # create content frame
        self.window_frame = tk.Frame(paned_window)
        paned_window.add(self.window_frame, weight=5)
        self.window_frame.columnconfigure(1, weight=1)
        self.window_frame.rowconfigure(1, weight=1)

        # create menu bar
        self.menubar = tk.Menu(self.window)
        self.window.config(menu=self.menubar)

        # create console frame
        self.console_frame = tk.Frame(paned_window)
        paned_window.add(self.console_frame, weight=0)
        self.console_frame.columnconfigure(1, weight=1)
        self.console_frame.rowconfigure(1, weight=1)
        self.console = Console(self.console_frame)

        MainScreen(self, self.window_frame)

        # show settings screen if first start
        if not self.settings.initialized:
            show_settings_screen(self)
        else:
            # save settings
            self.settings.save_to_file(self.config_dir)

        self.window.mainloop()

        # close DiscoPoP profiling profiling_container before exiting the application
        if self.profiling_container is not None:
            self.profiling_container.stop()


    def close_frame_contents(self):
        # close current frame contents
        for c in self.window_frame.winfo_children():
            c.destroy()
        # create empty menu bar
        self.menubar.destroy()
        self.menubar = tk.Menu(self.window)
        self.window.config(menu=self.menubar)

    def show_main_screen(self):
        self.close_frame_contents()
        MainScreen(self, self.window_frame)
