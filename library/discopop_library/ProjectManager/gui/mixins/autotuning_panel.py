# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import subprocess
import sys
import threading
import tkinter as tk
from tkinter import scrolledtext, ttk
from typing import Any, Callable, Dict, Optional

from discopop_library.ProjectManager.gui.mixins.helpers import show_error, Tooltip, clean_ansi_output
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui import widgets
from discopop_library.ProjectManager.gui.widgets import (
    create_styled_output_console,
    heading_label,
    caption_label,
    primary_button,
)

logger_name = "AutotuningPanel"


class AutotuningPanelMixin(ConfigManagerMixinBase):
    autotuning_running = False
    autotuning_output_text: Optional[scrolledtext.ScrolledText] = None
    autotuning_run_button: Optional[ttk.Button] = None
    autotuning_stop_button: Optional[ttk.Button] = None
    autotuning_config_label: Optional[ttk.Label] = None
    autotuning_threads_var: Optional[tk.StringVar] = None
    autotuning_hotspot_types_vars: Optional[Dict[str, tk.BooleanVar]] = None
    autotuning_algorithm_var: Optional[tk.StringVar] = None
    autotuning_algorithm_map: Dict[str, str] = {}
    autotuning_log_level_var: Optional[tk.StringVar] = None
    autotuning_suggestions_label: Optional[ttk.Label] = None
    _autotuning_tab_tooltip: Optional[Any] = None
    _autotuning_tab_tooltip_timer: Optional[str] = None
    _autotuning_tab_tooltip_active_tab: Optional[int] = None
    _autotuning_process: Optional["subprocess.Popen[str]"] = None

    def _build_autotuning_panel(self, parent: tk.Widget) -> None:
        main_paned = tk.PanedWindow(parent, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        main_paned.pack(fill=tk.BOTH, expand=True, padx=0, pady=0)

        # Left panel - settings
        left_frame = ttk.Frame(main_paned)
        main_paned.add(left_frame, minsize=650, width=650)

        settings_frame = ttk.LabelFrame(left_frame, text="Settings", padding=5)
        settings_frame.pack(fill=tk.X, padx=5, pady=5)

        # Configuration display
        config_row = ttk.Frame(settings_frame)
        config_row.pack(fill=tk.X, pady=3)
        heading_label(config_row, "Configuration:").pack(side=tk.LEFT, padx=5)
        self.autotuning_config_label = caption_label(config_row, "(none selected)")
        self.autotuning_config_label.pack(side=tk.LEFT, padx=5)

        # Threads selection
        threads_row = ttk.Frame(settings_frame)
        threads_row.pack(fill=tk.X, pady=5)
        ttk.Label(threads_row, text="Threads:", font=widgets.FONT_BODY).pack(side=tk.LEFT, padx=5)
        self.autotuning_threads_var = tk.StringVar(value="auto")
        threads_combo = ttk.Combobox(
            threads_row,
            textvariable=self.autotuning_threads_var,
            values=widgets.THREAD_VALUES,
            width=10,
            state="readonly",
        )
        threads_combo.pack(side=tk.LEFT, padx=5)
        caption_label(threads_row, "(auto = CPU count / 2)").pack(side=tk.LEFT, padx=5)

        # Hotspot types
        hotspot_frame = ttk.Frame(settings_frame)
        hotspot_frame.pack(fill=tk.X, pady=5)
        heading_label(hotspot_frame, "Hotspot Types:").pack(anchor=tk.W, padx=5)

        self.autotuning_hotspot_types_vars = {}
        for htype in ["yes", "no", "maybe"]:
            var = tk.BooleanVar(value=htype in ["yes", "no"])
            self.autotuning_hotspot_types_vars[htype] = var
            cb = ttk.Checkbutton(hotspot_frame, text=htype.upper(), variable=var)
            cb.pack(side=tk.LEFT, padx=20)

        # Algorithm selection
        algo_frame = ttk.Frame(settings_frame)
        algo_frame.pack(fill=tk.X, pady=5)
        heading_label(algo_frame, "Algorithm:").pack(anchor=tk.W, padx=5)
        self.autotuning_algorithm_var = tk.StringVar(value="Evolutionary combination")
        algo_options = [
            ("0", "No combination (measure only)"),
            ("1", "Linear combination"),
            ("3", "Evolutionary combination"),
            ("4", "Greedy combination"),
            ("5", "Coordinate descent combination"),
        ]
        self.autotuning_algorithm_map = {opt[1]: opt[0] for opt in algo_options}
        algo_combo = ttk.Combobox(algo_frame, textvariable=self.autotuning_algorithm_var, state="readonly", width=40)
        algo_combo["values"] = [opt[1] for opt in algo_options]
        algo_combo.pack(side=tk.LEFT, padx=5, fill=tk.X, expand=True)

        # Log level
        loglevel_frame = ttk.Frame(settings_frame)
        loglevel_frame.pack(fill=tk.X, pady=5)
        ttk.Label(loglevel_frame, text="Log Level:", font=widgets.FONT_BODY).pack(side=tk.LEFT, padx=5)
        self.autotuning_log_level_var = tk.StringVar(value="WARNING")
        loglevel_combo = ttk.Combobox(
            loglevel_frame,
            textvariable=self.autotuning_log_level_var,
            values=widgets.LOG_LEVEL_VALUES,
            state="readonly",
            width=10,
        )
        loglevel_combo.pack(side=tk.LEFT, padx=5)

        # Run button
        button_frame = ttk.Frame(left_frame)
        button_frame.pack(fill=tk.X, padx=0, pady=0)

        self.autotuning_run_button = primary_button(
            button_frame, text="Run Autotuning", command=self._run_autotuning, state="disabled"
        )
        self.autotuning_run_button.pack(side=tk.LEFT, padx=5, pady=5)

        self.autotuning_stop_button = ttk.Button(
            button_frame, text="Stop", command=self._stop_autotuning, state="disabled"
        )
        self.autotuning_stop_button.pack(side=tk.LEFT, padx=5, pady=5)

        # Selected suggestions display
        suggestions_frame = ttk.LabelFrame(left_frame, text="Selected Suggestion IDs", padding=5)
        suggestions_frame.pack(fill=tk.X, padx=5, pady=5)

        self.autotuning_suggestions_label = caption_label(suggestions_frame, "(none)", justify=tk.LEFT)
        self.autotuning_suggestions_label.pack(anchor=tk.W)

        # Right panel - output
        right_frame = ttk.Frame(main_paned)
        main_paned.add(right_frame)

        output_frame = ttk.LabelFrame(right_frame, text="Output")
        output_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

        self.autotuning_output_text = create_styled_output_console(output_frame)
        self.autotuning_output_text.pack(fill=tk.BOTH, expand=True)

        self._update_autotuning_ui()
        self._setup_autotuning_tab_tooltip()

    def _update_autotuning_ui(self) -> None:
        if self.autotuning_run_button is not None:
            self.autotuning_run_button.config(state="normal")

        self._refresh_autotuning_suggestions_display()

    def _setup_autotuning_tab_tooltip(self) -> None:
        tooltip_text = "Prerequisites not met:\n" "Pattern Detection needs to be executed first."
        self._autotuning_tab_tooltip = Tooltip(self.right_tabs, tooltip_text)

        def on_motion(event: Any) -> None:
            try:
                result = self.right_tabs.tk.call(str(self.right_tabs), "identify", "tab", event.x, event.y)
                tab_under_cursor: Optional[int] = int(result) if result != "" else None
            except Exception:
                tab_under_cursor = None

            if tab_under_cursor == self._autotuning_tab_tooltip_active_tab:
                return

            _hide_tooltip()

            if tab_under_cursor == self.autotuning_tab_index:
                ready = self._check_explorer_prerequisites() if hasattr(self, "_check_explorer_prerequisites") else True
                browse_ready = (
                    self._check_browse_suggestions_available()
                    if hasattr(self, "_check_browse_suggestions_available")
                    else True
                )
                if not (ready and browse_ready):
                    self._autotuning_tab_tooltip_active_tab = tab_under_cursor
                    assert self._autotuning_tab_tooltip is not None
                    self._autotuning_tab_tooltip_timer = self.after(  # type: ignore
                        500, self._autotuning_tab_tooltip.showtip, event.x_root, event.y_root + 20
                    )

        def _hide_tooltip() -> None:
            if self._autotuning_tab_tooltip_timer:
                self.after_cancel(self._autotuning_tab_tooltip_timer)  # type: ignore
                self._autotuning_tab_tooltip_timer = None
            if self._autotuning_tab_tooltip is not None:
                self._autotuning_tab_tooltip.hidetip()
            self._autotuning_tab_tooltip_active_tab = None

        def on_leave(event: Any) -> None:
            _hide_tooltip()

        self.right_tabs.bind("<Motion>", on_motion, add="+")
        self.right_tabs.bind("<Leave>", on_leave, add="+")

    def _refresh_autotuning_suggestions_display(self) -> None:
        """Read autotuning results and update the display label."""
        if not hasattr(self, "autotuning_suggestions_label") or self.autotuning_suggestions_label is None:
            return

        results_path = os.path.join(self.arguments.dot_dp, "auto_tuner", "results.json")
        suggested_ids = []
        autotuner_executed = os.path.exists(results_path)

        if autotuner_executed:
            try:
                with open(results_path, "r") as f:
                    results_data = json.load(f)
                config_key = getattr(self, "current_config", None) or ""
                config_results = results_data.get(config_key, {})
                suggested_ids = sorted(
                    [str(sid) for sid in config_results.get("applied_suggestions", [])],
                    key=lambda x: int(x) if x.isdigit() else x,
                )
            except (json.JSONDecodeError, IOError):
                pass

        if suggested_ids:
            self.autotuning_suggestions_label.config(text=", ".join(suggested_ids), foreground="black")
        elif autotuner_executed:
            self.autotuning_suggestions_label.config(text="No suggestions selected", foreground="gray")
        else:
            self.autotuning_suggestions_label.config(text="Autotuner not yet executed", foreground="gray")

    def _update_autotuning_config_display(self) -> None:
        """Update the configuration display label."""
        if not hasattr(self, "autotuning_config_label") or self.autotuning_config_label is None:
            return

        if self.current_config:
            self.autotuning_config_label.config(text=self.current_config, foreground="black")
        else:
            self.autotuning_config_label.config(text="(none selected)", foreground="gray")

    def _run_autotuning(self) -> None:
        if self.autotuning_running:
            show_error(self, "Already Running", "Autotuning is already running.")
            return

        if not self.current_config:
            show_error(self, "No Configuration Selected", "Please select a configuration first.")
            return

        self.autotuning_running = True
        if self.autotuning_run_button is not None:
            self.autotuning_run_button.config(state="disabled", text="⟳ Running...")

        if self.autotuning_stop_button is not None:
            self.autotuning_stop_button.config(state="normal")

        self.status_label.config(text="⏳ Autotuning in progress...", foreground=widgets.STATUS_BUSY)

        if self.autotuning_output_text is not None:
            self.autotuning_output_text.config(state=tk.NORMAL)
            self.autotuning_output_text.delete("1.0", tk.END)
            self.autotuning_output_text.config(state="disabled")

        def append_output(text: str) -> None:
            if self.autotuning_output_text is not None:
                self.autotuning_output_text.config(state=tk.NORMAL)
                self.autotuning_output_text.insert(tk.END, text)
                self.autotuning_output_text.see(tk.END)
                self.autotuning_output_text.config(state="disabled")

        def thread_safe_append(text: str) -> None:
            self.after(0, lambda: append_output(text))  # type: ignore

        def thread_func() -> None:
            try:
                thread_safe_append("Starting autotuning...\n")
                self._invoke_autotuner(thread_safe_append)
                self.after(0, lambda: self._on_autotuning_complete())  # type: ignore
            except Exception as e:
                thread_safe_append(f"\nError: {str(e)}\n")
                self.after(0, lambda: self._on_autotuning_complete(error=True))  # type: ignore

        thread = threading.Thread(target=thread_func, daemon=True)
        thread.start()

    def _invoke_autotuner(self, output_callback: Callable[[str], None]) -> None:
        assert self.autotuning_threads_var is not None
        assert self.autotuning_hotspot_types_vars is not None
        assert self.autotuning_algorithm_var is not None
        assert self.autotuning_log_level_var is not None

        dot_discopop = self.arguments.dot_dp

        selected_hotspot_types = [htype for htype, var in self.autotuning_hotspot_types_vars.items() if var.get()]
        hotspot_types = ",".join(selected_hotspot_types) if selected_hotspot_types else "yes,no,maybe"

        threads_value = self.autotuning_threads_var.get()
        algorithm_description = self.autotuning_algorithm_var.get()
        algorithm_value = self.autotuning_algorithm_map.get(algorithm_description, "0")
        log_level = self.autotuning_log_level_var.get()

        output_callback("Configuration:\n")
        output_callback(f"  Configuration: {self.current_config}\n")
        output_callback(f"  Hotspot Types: {hotspot_types}\n")
        output_callback(f"  Threads: {threads_value}\n")
        output_callback(f"  Algorithm: {algorithm_value}\n")
        output_callback(f"  Log Level: {log_level}\n\n")

        cmd = [
            sys.executable,
            "-m",
            "discopop_library.EmpiricalAutotuning",
            "--dot-dp-path",
            dot_discopop,
            "-c",
            self.current_config or "tiny",
            "-ht",
            hotspot_types,
            "-A",
            algorithm_value,
            "--log",
            log_level,
        ]

        if threads_value != "auto":
            cmd.extend(["-t", threads_value])

        output_callback("Running autotuner...\n\n")

        self._autotuning_process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            cwd=dot_discopop,
        )

        assert self._autotuning_process.stdout is not None
        for line in self._autotuning_process.stdout:
            cleaned = clean_ansi_output(line.rstrip("\n"))
            if cleaned:
                output_callback(cleaned + "\n")

        self._autotuning_process.wait()

        if self._autotuning_process.returncode != 0:
            raise RuntimeError(f"Autotuner exited with return code {self._autotuning_process.returncode}")

        output_callback("\nAutotuning completed.\n")
        self._autotuning_process = None

    def _on_autotuning_complete(self, error: bool = False) -> None:
        self.autotuning_running = False

        if self.autotuning_run_button is not None:
            self.autotuning_run_button.config(state="normal", text="Run Autotuning")

        if self.autotuning_stop_button is not None:
            self.autotuning_stop_button.config(state="disabled")

        if not error:
            self._refresh_autotuning_suggestions_display()
            if hasattr(self, "_refresh_suggestion_selection_display"):
                self._refresh_suggestion_selection_display()
            if hasattr(self, "_update_report_display"):
                self._update_report_display()
            self.status_label.config(text="Autotuning completed successfully", foreground=widgets.STATUS_OK)
            self.after(3000, lambda: self.status_label.config(text="Ready", foreground=widgets.STATUS_IDLE))  # type: ignore
        else:
            self.status_label.config(text="Autotuning failed", foreground=widgets.STATUS_FAIL)
            self.after(3000, lambda: self.status_label.config(text="Ready", foreground=widgets.STATUS_IDLE))  # type: ignore

    def _stop_autotuning(self) -> None:
        if self._autotuning_process is not None:
            self._autotuning_process.terminate()
        if self.autotuning_stop_button is not None:
            self.autotuning_stop_button.config(state="disabled")
        if hasattr(self, "_update_report_display"):
            self._update_report_display()
        self.status_label.config(text="Stopping autotuning...", foreground=widgets.STATUS_STOP)
