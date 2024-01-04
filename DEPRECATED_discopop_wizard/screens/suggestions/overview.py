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

from DEPRECATED_discopop_wizard.classes.Suggestion import Suggestion
from DEPRECATED_discopop_wizard.screens.utils import create_tool_tip
from DEPRECATED_discopop_wizard.screens.widgets.ScrollableText import ScrollableTextWidget
from DEPRECATED_discopop_wizard.utils import support_scrolling


def show_suggestions_overview_screen(wizard, details_frame: tk.Frame, execution_configuration_obj):
    # close elements on details_frame
    for c in details_frame.winfo_children():
        c.destroy()
    # load suggestions from execution
    suggestions = get_suggestion_objects(wizard, execution_configuration_obj)

    # create horizontally split frames (scrollable list of suggestions + code preview)
    horizontal_paned_window = ttk.PanedWindow(details_frame, orient="horizontal")
    horizontal_paned_window.pack(fill=tk.BOTH, expand=True)
    scrollable_list_frame = tk.Frame(horizontal_paned_window)
    horizontal_paned_window.add(scrollable_list_frame, weight=1)
    code_preview_frame = tk.Frame(horizontal_paned_window)
    horizontal_paned_window.add(code_preview_frame, weight=5)

    tmp_frame = tk.Frame(scrollable_list_frame)
    tmp_frame.pack(fill=tk.BOTH, expand=True)

    # define notebook widget to show generated CUs and dependencies
    separator = ttk.Separator(scrollable_list_frame, orient="horizontal")
    separator.pack(fill=tk.X)
    result_browser_frame = tk.Frame(scrollable_list_frame)
    result_browser_frame.pack(fill=tk.BOTH, expand=True)
    result_notebook = ttk.Notebook(result_browser_frame)
    result_notebook.pack(fill=tk.BOTH, expand=True)
    # add CU preview
    cu_display_widget = ScrollableTextWidget(result_notebook)
    with open(execution_configuration_obj.value_dict["working_copy_path"] + "/Data.xml", "r") as f:
        cu_display_widget.set_text(f.read())
    result_notebook.add(cu_display_widget.frame, text="CU's")
    # add dynamic dependency preview
    dynamic_dep_display_widget = ScrollableTextWidget(result_notebook)
    with open(
        execution_configuration_obj.value_dict["working_copy_path"]
        + "/"
        + execution_configuration_obj.value_dict["executable_name"]
        + "_dp_dep.txt",
        "r",
    ) as f:
        dynamic_dep_display_widget.set_text(f.read())
    result_notebook.add(dynamic_dep_display_widget.frame, text="Dynamic DEP's")
    # add static dependency preview
    static_dep_display_widget = ScrollableTextWidget(result_notebook)
    if os.path.exists(execution_configuration_obj.value_dict["working_copy_path"] + "/static_dependencies.txt"):
        with open(
            execution_configuration_obj.value_dict["working_copy_path"] + "/static_dependencies.txt",
            "r",
        ) as f:
            static_dep_display_widget.set_text(f.read())
    else:
        static_dep_display_widget.set_text(
            execution_configuration_obj.value_dict["working_copy_path"] + "/static_dependencies.txt" + " NOT FOUND."
        )
    result_notebook.add(static_dep_display_widget.frame, text="Static DEP's")
    # add instrumented LLVM IR preview
    instrumented_llvm_ir_display_widget = ScrollableTextWidget(result_notebook)
    if os.path.exists(
        execution_configuration_obj.value_dict["working_copy_path"]
        + "/"
        + execution_configuration_obj.value_dict["executable_name"]
        + "_dp.ll"
    ):
        with open(
            execution_configuration_obj.value_dict["working_copy_path"]
            + "/"
            + execution_configuration_obj.value_dict["executable_name"]
            + "_dp.ll",
            "r",
        ) as f:
            instrumented_llvm_ir_display_widget.set_text(f.read())
    else:
        instrumented_llvm_ir_display_widget.set_text(
            execution_configuration_obj.value_dict["working_copy_path"]
            + "/"
            + execution_configuration_obj.value_dict["executable_name"]
            + "_dp.ll"
            + " NOT FOUND."
        )
    result_notebook.add(instrumented_llvm_ir_display_widget.frame, text="LLVM IR")
    # add patterns.json preview
    patterns_json_display_widget = ScrollableTextWidget(result_notebook)
    with open(execution_configuration_obj.value_dict["working_copy_path"] + "/" + "patterns.json", "r") as f:
        patterns_json_display_widget.set_text(f.read())
    result_notebook.add(patterns_json_display_widget.frame, text="patterns.json")

    # create scrollable list of suggestions
    canvas = tk.Canvas(tmp_frame)
    scrollbar = tk.Scrollbar(tmp_frame, orient="vertical", command=canvas.yview)
    scrollable_frame = tk.Frame(canvas)
    scrollable_frame.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
    canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
    canvas.configure(yscrollcommand=scrollbar.set)
    for row, suggestion in enumerate(suggestions):
        # create button to load code preview
        button = suggestion.get_as_button(scrollable_frame, code_preview_frame, execution_configuration_obj)
        button.pack(fill=tk.BOTH, expand=True)

        # register hover message (suggestion details)
        create_tool_tip(button, text=suggestion.get_details())

    # add support for mouse wheel scrolling
    support_scrolling(canvas)

    # add label
    tk.Label(tmp_frame, text="Suggestions", font=wizard.style_font_bold).pack(side="top", pady=10)

    canvas.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")


def get_suggestion_objects(wizard, execution_configuration_obj) -> List[Suggestion]:
    suggestions_path = os.path.join(execution_configuration_obj.value_dict["working_copy_path"], "patterns.json")

    suggestions_list: List[Suggestion] = []
    with open(suggestions_path, "r") as f:
        suggestions_dict = json.load(f)
    for suggestion_type in suggestions_dict:
        for suggestion_values in suggestions_dict[suggestion_type]:
            suggestions_list.append(Suggestion(wizard, suggestion_type, suggestion_values))

    return suggestions_list
