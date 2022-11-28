# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
import os
import tkinter as tk
from tkinter import ttk
from typing import List

import jsons

from discopop_wizard.classes.Suggestion import Suggestion
from discopop_wizard.screens.utils import create_tool_tip


def show_suggestions_overview_screen(wizard, details_frame: tk.Frame, execution_configuration_obj):
    # close elements on details_frame
    for c in details_frame.winfo_children():
        c.destroy()
    # load suggestions from execution
    suggestions = get_suggestion_objects(execution_configuration_obj)

    # create horizontally split frames (scrollable list of suggestions + code preview)
    horizontal_paned_window = ttk.PanedWindow(details_frame, orient="horizontal")
    horizontal_paned_window.pack(fill=tk.BOTH, expand=True)
    scrollable_list_frame = tk.Frame(horizontal_paned_window)
    horizontal_paned_window.add(scrollable_list_frame, weight=1)
    code_preview_frame = tk.Frame(horizontal_paned_window)
    horizontal_paned_window.add(code_preview_frame, weight=5)

    # create scrollable list of suggestions
    canvas = tk.Canvas(scrollable_list_frame)
    scrollbar = tk.Scrollbar(scrollable_list_frame, orient="vertical", command=canvas.yview)
    scrollable_frame = tk.Frame(canvas)
    scrollable_frame.bind(
        "<Configure>",
        lambda e: canvas.configure(
            scrollregion=canvas.bbox("all")
        )
    )
    canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
    canvas.configure(yscrollcommand=scrollbar.set)
    for row, suggestion in enumerate(suggestions):
        # create button to load code preview
        button = suggestion.get_as_button(canvas, code_preview_frame, execution_configuration_obj)

        button.grid(row=row)
        # register hover message (suggestion details)
        create_tool_tip(button, text=suggestion.get_details())

    # add label of execution configuration for overview purposes
    tk.Label(scrollable_list_frame, text=execution_configuration_obj.label,
             font=wizard.style_font_bold).pack(side="top", pady=10)

    canvas.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")


def get_suggestion_objects(execution_configuration_obj) -> List[Suggestion]:
    suggestions_path = os.path.join(execution_configuration_obj.project_path, "patterns.json")

    suggestions_list: List[Suggestion] = []
    with open(suggestions_path, "r") as f:
        suggestions_dict = json.load(f)
    for suggestion_type in suggestions_dict:
        for suggestion_values in suggestions_dict[suggestion_type]:
            suggestions_list.append(Suggestion(suggestion_type, suggestion_values))

    return suggestions_list

    # todo load json or python objects instead
    suggestions: List[str] = []
    current_suggestion: str = ""
    with open(suggestions_path, "r") as f:
        for line in f.readlines():
            if line.startswith("Pipeline at:") or line.startswith("Reduction at:") or \
                    line.startswith("Do-all at:") or line.startswith("Geometric decomposition at:"):
                suggestions.append(current_suggestion)
                current_suggestion = ""
            current_suggestion += line
    suggestions.append(current_suggestion)
    suggestions = [s for s in suggestions if len(s) > 0]

    suggestion_objects = []
    for idx, suggestion in enumerate(suggestions):
        suggestion_objects.append(Suggestion(idx, suggestion))

    return suggestion_objects
