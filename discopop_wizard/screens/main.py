# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import functools
import os.path
import tkinter as tk
from tkinter import ttk
from typing import List

from discopop_wizard.classes.ExecutionConfiguration import ExecutionConfiguration
from discopop_wizard.screens.settings import show_settings_screen


class MainScreen(object):
    configuration_frame: tk.Frame
    notebook: ttk.Notebook
    details_frame: tk.Frame
    results_frame: tk.Frame

    def __init__(self, wizard, window_frame: tk.Frame):
        self.wizard = wizard
        self.push_main_screen(wizard, window_frame)

    def push_main_screen(self, wizard, window_frame: tk.Frame):
        frame = tk.Frame(window_frame)
        frame.grid(row=1, column=1, sticky="nsew")

        # create horizontally split frames (configurations + details frame)
        horizontal_paned_window = ttk.PanedWindow(frame, orient="horizontal")
        horizontal_paned_window.pack(fill=tk.BOTH, expand=True)
        self.configuration_frame = tk.Frame(horizontal_paned_window)
        horizontal_paned_window.add(self.configuration_frame, weight=1)
        self.notebook = ttk.Notebook(horizontal_paned_window)
        horizontal_paned_window.add(self.notebook, weight=5)

        self.details_frame = tk.Frame(self.notebook)
        self.results_frame = tk.Frame(self.notebook)
        self.notebook.add(self.details_frame, text="Details")
        self.notebook.add(self.results_frame, text="Results")

        self.build_configurations_frame(wizard)

        # build menu bar
        optionsmenu = tk.Menu(wizard.menubar)
        wizard.menubar.add_cascade(label="Options", menu=optionsmenu)
        optionsmenu.add_command(label="Settings", command=lambda: show_settings_screen(wizard))

    def build_configurations_frame(self, wizard):
        # clear previous contents if existent
        for c in self.configuration_frame.winfo_children():
            c.destroy()
        # build configuration frame
        self.__display_execution_configurations(wizard)

    def __create_new_execution_configuration(self, wizard):
        execution_config = ExecutionConfiguration(wizard)
        execution_config.show_details_screen(wizard, self)


    def __display_execution_configurations(self, wizard):
        # based on https://blog.teclado.com/tkinter-scrollable-frames/
        # load configuration options
        configs: List[ExecutionConfiguration] = self.load_execution_configurations(wizard.config_dir)
        frame = tk.Frame(self.configuration_frame)
        frame.pack(fill=tk.BOTH, expand=True)
        tk.Label(frame, text="Configurations", font=wizard.style_font_bold, pady=10).pack()
        # add New.. Button
        tk.Button(frame, text="New..",
                  command=lambda: self.__create_new_execution_configuration(wizard)).pack()

        tmp_frame = tk.Frame(frame)
        tmp_frame.pack(fill=tk.BOTH, expand=True)

        # create scrollable list of suggestions
        canvas = tk.Canvas(tmp_frame)
        scrollbar = tk.Scrollbar(tmp_frame, orient="vertical", command=canvas.yview)
        scrollable_frame = tk.Frame(canvas)
        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(
                scrollregion=canvas.bbox("all")
            )
        )
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        all_buttons: List[tk.Button] = []  # used to manage highlights when a different configuration is selected
        for row, config in enumerate(configs):
            button = config.get_as_button(wizard, self, scrollable_frame, all_buttons)
            button.pack(fill=tk.BOTH, expand=True)
            all_buttons.append(button)

        # add support for mouse wheel scrolling (on linux systems)
        def _on_mousewheel(event, scroll):
            canvas.yview_scroll(int(scroll), "units")

        def _bind_to_mousewheel(event):
            canvas.bind_all("<Button-4>", functools.partial(_on_mousewheel, scroll=-1))
            canvas.bind_all("<Button-5>", functools.partial(_on_mousewheel, scroll=1))

        def _unbind_from_mousewheel(event):
            canvas.unbind_all("<Button-4>")
            canvas.unbind_all("<Button-5>")

        canvas.bind('<Enter>', _bind_to_mousewheel)
        canvas.bind('<Leave>', _unbind_from_mousewheel)

        # add label
        tk.Label(tmp_frame, text="Suggestions", font=wizard.style_font_bold).pack(side="top", pady=10)

        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")



    def load_execution_configurations(self, config_dir: str) -> List[ExecutionConfiguration]:
        execution_configs: List[ExecutionConfiguration] = []
        for filename in os.listdir(os.path.join(config_dir, "execution_configurations")):
            if not filename.endswith(".json"):
                continue
            with open(os.path.join(os.path.join(config_dir, "execution_configurations"), filename), 'r') as json_file:
                config = ExecutionConfiguration(self.wizard)
                config.init_from_json(json_file)
                execution_configs.append(config)
        return execution_configs
