# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import textwrap
import tkinter as tk
from tkinter import ttk
from typing import Any

from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no
from discopop_library.ProjectManager.gui import widgets
from discopop_library.ProjectManager.gui.widgets import danger_button, primary_button


class ReportPanelMixin(ConfigManagerMixinBase):
    def _build_report_panel(self, parent: tk.Widget) -> None:
        button_frame = ttk.Frame(parent)
        button_frame.pack(side=tk.TOP, fill=tk.X, padx=5, pady=5)

        def on_reset_execution_results() -> None:
            if ask_yes_no(
                self,
                "Confirm Reset",
                "Are you sure you want to reset execution results?\nThis will delete all execution data and reports.",
            ):
                self._reset_execution_results()

        def on_reset_project() -> None:
            if ask_yes_no(
                self,
                "Confirm Reset",
                "Are you sure you want to reset the entire project?\nThis will delete all data except the configuration files.",
            ):
                self._reset_project_data()

        reset_results_button = danger_button(
            button_frame,
            text="Reset Execution Results",
            command=on_reset_execution_results,
        )
        reset_results_button.pack(side=tk.LEFT, padx=5)

        reset_project_button = danger_button(
            button_frame,
            text="Reset Project",
            command=on_reset_project,
        )
        reset_project_button.pack(side=tk.LEFT, padx=5)

        def on_generate_report() -> None:
            self._generate_report()

        def on_view_report() -> None:
            self._view_report()

        self.generate_report_button = primary_button(
            button_frame,
            text="Generate PDF Report",
            state="disabled",
            command=on_generate_report,
        )
        self.generate_report_button.pack(side=tk.LEFT, padx=5)

        self.view_report_button = ttk.Button(
            button_frame,
            text="View Report PDF",
            state="disabled",
            command=on_view_report,
        )
        self.view_report_button.pack(side=tk.LEFT, padx=5)

        tree_frame = ttk.Frame(parent)
        tree_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        vsb = ttk.Scrollbar(tree_frame, orient=tk.VERTICAL)
        vsb.pack(side=tk.RIGHT, fill=tk.Y)

        hsb = ttk.Scrollbar(tree_frame, orient=tk.HORIZONTAL)
        hsb.pack(side=tk.BOTTOM, fill=tk.X)

        columns = (
            "Config",
            "Script",
            "Setting",
            "Label",
            "Applied Suggestions",
            "Threads",
            "Code",
            "Time",
            "Speedup",
            "Efficiency",
        )
        self.report_tree = ttk.Treeview(
            tree_frame,
            columns=columns,
            show="headings",
            yscrollcommand=vsb.set,
            xscrollcommand=hsb.set,
        )

        column_widths = {
            "Config": 90,
            "Script": 100,
            "Setting": 70,
            "Label": 85,
            "Applied Suggestions": 90,
            "Threads": 65,
            "Code": 55,
            "Time": 65,
            "Speedup": 75,
            "Efficiency": 75,
        }

        for col in columns:
            self.report_tree.heading(col, text=col)
            self.report_tree.column(col, width=column_widths.get(col, 100), anchor="w", stretch=True)

        self.report_tree.tag_configure("evenrow", background=widgets.TREE_EVEN_ROW)
        self.report_tree.tag_configure("oddrow", background=widgets.TREE_ODD_ROW)

        self.report_tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        vsb.config(command=self.report_tree.yview)
        hsb.config(command=self.report_tree.xview)

        def _on_tree_mousewheel(event: Any) -> object:
            self.report_tree.yview_scroll(int(-1 * (event.delta / 120)), "units")
            return "break"

        self.report_tree.bind("<MouseWheel>", _on_tree_mousewheel)
        self.report_tree.bind("<Button-4>", lambda e: self.report_tree.yview_scroll(-1, "units"))
        self.report_tree.bind("<Button-5>", lambda e: self.report_tree.yview_scroll(1, "units"))

    def _update_report_display(self) -> None:
        for item in self.report_tree.get_children():
            self.report_tree.delete(item)

        execution_results_path = os.path.join(self.arguments.project_dir, "execution_results.json")
        if not os.path.exists(execution_results_path):
            return

        try:
            with open(execution_results_path, "r") as f:
                execution_results = json.load(f)
        except Exception:
            return

        for configuration in sorted(execution_results.keys()):
            configuration_first_occurrence = True
            for script in sorted(execution_results[configuration].keys()):
                script_first_occurrence = True
                for setting in sorted(execution_results[configuration][script].keys()):
                    setting_first_occurrence = True

                    seq_runtime: float = -1.0
                    if "seq_settings.json" in execution_results[configuration][script]:
                        for execution in execution_results[configuration][script]["seq_settings.json"]:
                            if execution["code"] == 0:
                                seq_runtime = execution["time"]

                    setting_row_index = len(self.report_tree.get_children())
                    tags = ("evenrow",) if setting_row_index % 2 == 0 else ("oddrow",)

                    for execution in execution_results[configuration][script][setting]:
                        config_str = configuration if configuration_first_occurrence else ""
                        script_str = script if script_first_occurrence else ""
                        setting_str = setting.replace("_settings.json", "") if setting_first_occurrence else ""

                        configuration_first_occurrence = False
                        script_first_occurrence = False
                        setting_first_occurrence = False

                        speedup = seq_runtime / execution["time"] if seq_runtime > 0 else -1
                        efficiency = speedup / execution["thread_count"] if speedup > 0 else -1

                        self.report_tree.insert(
                            "",
                            "end",
                            values=(
                                config_str,
                                script_str,
                                setting_str,
                                execution.get("label", ""),
                                textwrap.shorten(str(execution["applied_suggestions"]), width=20, placeholder="...]"),
                                str(execution["thread_count"]),
                                str(execution["code"]),
                                str(execution["time"]),
                                str(round(speedup, 3)),
                                str(round(efficiency, 3)),
                            ),
                            tags=tags,
                        )
