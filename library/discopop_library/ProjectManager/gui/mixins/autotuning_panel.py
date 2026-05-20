# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
import re
import subprocess
import sys
import threading
import tkinter as tk
from tkinter import scrolledtext, ttk
from typing import Any, Callable, Dict, Optional

from discopop_library.ProjectManager.gui.mixins.helpers import show_error, Tooltip
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.widgets import create_styled_output_console

logger_name = "AutotuningPanel"


def _clean_ansi_output(text: str) -> str:
    """Remove ANSI escape codes and clean up carriage returns for display."""
    ansi_escape = re.compile(r"\x1b\[[0-9;]*m|\x1b\[[A-Z]")
    text = ansi_escape.sub("", text)
    lines = text.split("\n")
    cleaned_lines = []
    for line in lines:
        if "\r" in line:
            parts = line.split("\r")
            line = parts[-1] if parts[-1] else parts[-2] if len(parts) > 1 else ""
        if line.strip():
            cleaned_lines.append(line)
    return "\n".join(cleaned_lines)


class AutotuningPanelMixin(ConfigManagerMixinBase):
    autotuning_running = False
    autotuning_output_text: Optional[scrolledtext.ScrolledText] = None
    autotuning_run_button: Optional[tk.Button] = None
    autotuning_config_label: Optional[tk.Label] = None
    autotuning_threads_var: Optional[tk.StringVar] = None
    autotuning_hotspot_types_vars: Optional[Dict[str, tk.BooleanVar]] = None
    autotuning_algorithm_var: Optional[tk.StringVar] = None
    autotuning_algorithm_map: Dict[str, str] = {}
    autotuning_log_level_var: Optional[tk.StringVar] = None
    autotuning_suggestions_label: Optional[tk.Label] = None
    _autotuning_tab_tooltip: Optional[Any] = None
    _autotuning_tab_tooltip_timer: Optional[str] = None
    _autotuning_tab_tooltip_active_tab: Optional[int] = None

    def _build_autotuning_panel(self, parent: tk.Frame) -> None:
        import tkinter.ttk as ttk

        main_paned = tk.PanedWindow(parent, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        main_paned.pack(fill=tk.BOTH, expand=True, padx=0, pady=0)

        # Left panel - settings
        left_frame = tk.Frame(main_paned)
        main_paned.add(left_frame, minsize=650, width=650)

        settings_frame = tk.LabelFrame(left_frame, text="Settings", padx=5, pady=5)
        settings_frame.pack(fill=tk.X, padx=5, pady=5)

        # Configuration display
        config_row = tk.Frame(settings_frame)
        config_row.pack(fill=tk.X, pady=3)
        tk.Label(config_row, text="Configuration:", font=("Arial", 9, "bold")).pack(side=tk.LEFT, padx=5)
        self.autotuning_config_label = tk.Label(config_row, text="(none selected)", fg="gray")
        self.autotuning_config_label.pack(side=tk.LEFT, padx=5)

        # Threads selection
        threads_row = tk.Frame(settings_frame)
        threads_row.pack(fill=tk.X, pady=5)
        tk.Label(threads_row, text="Threads:", font=("Arial", 9)).pack(side=tk.LEFT, padx=5)
        self.autotuning_threads_var = tk.StringVar(value="auto")
        threads_combo = ttk.Combobox(
            threads_row,
            textvariable=self.autotuning_threads_var,
            values=["auto", "1", "2", "4", "8", "16"],
            width=10,
            state="readonly",
        )
        threads_combo.pack(side=tk.LEFT, padx=5)
        tk.Label(threads_row, text="(auto = CPU count / 2)", font=("Arial", 8)).pack(side=tk.LEFT, padx=5)

        # Hotspot types
        hotspot_frame = tk.Frame(settings_frame)
        hotspot_frame.pack(fill=tk.X, pady=5)
        tk.Label(hotspot_frame, text="Hotspot Types:", font=("Arial", 9, "bold")).pack(anchor=tk.W, padx=5)

        self.autotuning_hotspot_types_vars = {}
        for htype in ["yes", "no", "maybe"]:
            var = tk.BooleanVar(value=htype in ["yes", "no"])
            self.autotuning_hotspot_types_vars[htype] = var
            cb = tk.Checkbutton(hotspot_frame, text=htype.upper(), variable=var)
            cb.pack(side=tk.LEFT, padx=20)

        # Algorithm selection
        algo_frame = tk.Frame(settings_frame)
        algo_frame.pack(fill=tk.X, pady=5)
        tk.Label(algo_frame, text="Algorithm:", font=("Arial", 9, "bold")).pack(anchor=tk.W, padx=5)
        self.autotuning_algorithm_var = tk.StringVar(value="Evolutionary combination")
        algo_options = [
            ("0", "No combination (measure only)"),
            ("1", "Linear combination"),
            ("2", "Linear combination with refinement"),
            ("3", "Evolutionary combination"),
        ]
        self.autotuning_algorithm_map = {opt[1]: opt[0] for opt in algo_options}
        algo_combo = ttk.Combobox(algo_frame, textvariable=self.autotuning_algorithm_var, state="readonly", width=40)
        algo_combo["values"] = [opt[1] for opt in algo_options]
        algo_combo.pack(side=tk.LEFT, padx=5, fill=tk.X, expand=True)

        # Log level
        loglevel_frame = tk.Frame(settings_frame)
        loglevel_frame.pack(fill=tk.X, pady=5)
        tk.Label(loglevel_frame, text="Log Level:", font=("Arial", 9)).pack(side=tk.LEFT, padx=5)
        self.autotuning_log_level_var = tk.StringVar(value="WARNING")
        loglevel_combo = ttk.Combobox(
            loglevel_frame,
            textvariable=self.autotuning_log_level_var,
            values=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
            state="readonly",
            width=10,
        )
        loglevel_combo.pack(side=tk.LEFT, padx=5)

        # Run button
        button_frame = tk.Frame(left_frame)
        button_frame.pack(fill=tk.X, padx=0, pady=0)

        self.autotuning_run_button = tk.Button(
            button_frame, text="Run Autotuning", command=self._run_autotuning, state="disabled"
        )
        self.autotuning_run_button.pack(side=tk.LEFT, padx=5, pady=5)

        # Selected suggestions display
        suggestions_frame = tk.LabelFrame(left_frame, text="Selected Suggestions", padx=5, pady=5)
        suggestions_frame.pack(fill=tk.X, padx=5, pady=5)

        self.autotuning_suggestions_label = tk.Label(
            suggestions_frame, text="(none)", fg="gray", font=("Arial", 8), justify=tk.LEFT
        )
        self.autotuning_suggestions_label.pack(anchor=tk.W)

        # Right panel - output
        right_frame = tk.Frame(main_paned)
        main_paned.add(right_frame)

        output_frame = tk.LabelFrame(right_frame, text="Output")
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
            self.autotuning_suggestions_label.config(text=", ".join(suggested_ids), fg="black")
        elif autotuner_executed:
            self.autotuning_suggestions_label.config(text="No suggestions selected", fg="gray")
        else:
            self.autotuning_suggestions_label.config(text="Autotuner not yet executed", fg="gray")

    def _update_autotuning_config_display(self) -> None:
        """Update the configuration display label."""
        if not hasattr(self, "autotuning_config_label") or self.autotuning_config_label is None:
            return

        if self.current_config:
            self.autotuning_config_label.config(text=self.current_config, fg="black")
        else:
            self.autotuning_config_label.config(text="(none selected)", fg="gray")

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

        self.status_label.config(text="⏳ Autotuning in progress...", fg="#FF6B6B")

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

        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            cwd=dot_discopop,
        )

        assert process.stdout is not None
        for line in process.stdout:
            cleaned = _clean_ansi_output(line.rstrip("\n"))
            if cleaned:
                output_callback(cleaned + "\n")

        process.wait()

        if process.returncode != 0:
            raise RuntimeError(f"Autotuner exited with return code {process.returncode}")

        output_callback("\nAutotuning completed.\n")

    def _on_autotuning_complete(self, error: bool = False) -> None:
        self.autotuning_running = False

        if self.autotuning_run_button is not None:
            self.autotuning_run_button.config(state="normal", text="Run Autotuning")

        if not error:
            self._refresh_autotuning_suggestions_display()
            if hasattr(self, "_refresh_suggestion_selection_display"):
                self._refresh_suggestion_selection_display()
            self.status_label.config(text="Autotuning completed successfully", fg="green")
            self.after(3000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        else:
            self.status_label.config(text="Autotuning failed", fg="red")
            self.after(3000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
