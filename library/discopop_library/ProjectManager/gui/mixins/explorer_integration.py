# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import os
import subprocess
import sys
import threading
import tkinter as tk
from tkinter import scrolledtext
from typing import Any, Callable, Dict, Optional

from discopop_library.ProjectManager.gui.mixins.helpers import Tooltip, show_error, clean_ansi_output
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.widgets import create_styled_output_console

logger = logging.getLogger("ExplorerIntegration")


class ExplorerIntegrationMixin(ConfigManagerMixinBase):
    explorer_running = False
    explorer_output_text: Optional[scrolledtext.ScrolledText] = None
    explorer_run_button: Optional[tk.Button] = None
    browse_suggestions_button: Optional[tk.Button] = None
    no_suggestions_label: Optional[tk.Label] = None
    prerequisite_info_label: Optional[tk.Label] = None
    pattern_types_vars: Optional[Dict[str, tk.BooleanVar]] = None
    jobs_var: Optional[tk.StringVar] = None
    collect_stats_var: Optional[tk.BooleanVar] = None
    _pattern_detection_tab_tooltip: Optional[Tooltip] = None
    _pattern_detection_tab_tooltip_timer: Optional[str] = None
    _pattern_detection_tab_tooltip_active_tab: Optional[int] = None

    def _build_pattern_detection_panel(self, parent: tk.Frame) -> None:
        import tkinter.ttk as ttk

        main_paned = tk.PanedWindow(parent, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        main_paned.pack(fill=tk.BOTH, expand=True, padx=0, pady=0)

        # Left panel - settings
        left_frame = tk.Frame(main_paned)
        main_paned.add(left_frame, minsize=650, width=650)

        # Settings frame
        settings_frame = tk.LabelFrame(left_frame, text="Settings", padx=5, pady=5)
        settings_frame.pack(fill=tk.X, padx=5, pady=5)

        # Pattern types selection
        patterns_frame = tk.Frame(settings_frame)
        patterns_frame.pack(fill=tk.X, pady=5)

        tk.Label(patterns_frame, text="Pattern Types:", font=("Arial", 9, "bold")).pack(side=tk.LEFT, padx=5)

        self.pattern_types_vars = {}
        for pattern in ["reduction", "doall", "task"]:
            var = tk.BooleanVar(value=pattern in ["reduction", "doall"])
            self.pattern_types_vars[pattern] = var
            cb = tk.Checkbutton(patterns_frame, text=pattern, variable=var)
            cb.pack(side=tk.LEFT, padx=5)

        # Jobs selection
        jobs_frame = tk.Frame(settings_frame)
        jobs_frame.pack(fill=tk.X, pady=5)

        tk.Label(jobs_frame, text="Threads:", font=("Arial", 9)).pack(side=tk.LEFT, padx=5)
        self.jobs_var = tk.StringVar(value="auto")
        jobs_combo = ttk.Combobox(
            jobs_frame,
            textvariable=self.jobs_var,
            values=["auto", "1", "2", "4", "8", "16"],
            width=10,
            state="readonly",
        )
        jobs_combo.pack(side=tk.LEFT, padx=5)
        tk.Label(jobs_frame, text="(auto = unlimited)", font=("Arial", 8)).pack(side=tk.LEFT, padx=5)

        # Buttons frame
        button_frame = tk.Frame(left_frame)
        button_frame.pack(fill=tk.X, padx=0, pady=0)

        self.explorer_run_button = tk.Button(
            button_frame, text="Run Pattern Detection", command=self._run_pattern_detection, state="disabled"
        )
        self.explorer_run_button.pack(side=tk.LEFT, padx=5, pady=5)

        self.browse_suggestions_button = tk.Button(
            button_frame, text="Browse Suggestions", command=self._open_suggestion_browser, state="disabled"
        )
        self.browse_suggestions_button.pack(side=tk.LEFT, padx=5, pady=5)

        # No suggestions notification label
        self.no_suggestions_label = tk.Label(left_frame, text="No patterns found.", fg="#f38ba8", font=("Arial", 9))
        self.no_suggestions_label.pack(anchor=tk.W, padx=5, pady=(5, 0))

        # Right panel - output
        right_frame = tk.Frame(main_paned)
        main_paned.add(right_frame)

        output_frame = tk.LabelFrame(right_frame, text="Output")
        output_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

        self.explorer_output_text = create_styled_output_console(output_frame)
        self.explorer_output_text.pack(fill=tk.BOTH, expand=True)

        self._update_pattern_detection_ui()
        self._setup_pattern_detection_tab_tooltip()

    def _setup_pattern_detection_tab_tooltip(self) -> None:
        tooltip_text = (
            "Prerequisites not met:\n"
            "Profiling data not found.\n"
            "Execute a configuration in 'dp' mode with 'inplace' enabled first."
        )
        self._pattern_detection_tab_tooltip = Tooltip(self.right_tabs, tooltip_text)

        def on_motion(event: Any) -> None:
            try:
                result = self.right_tabs.tk.call(str(self.right_tabs), "identify", "tab", event.x, event.y)
                tab_under_cursor: Optional[int] = int(result) if result != "" else None
            except Exception:
                tab_under_cursor = None

            if tab_under_cursor == self._pattern_detection_tab_tooltip_active_tab:
                return

            _hide_tooltip()

            if tab_under_cursor == self.pattern_detection_tab_index:
                if not self._check_explorer_prerequisites():
                    self._pattern_detection_tab_tooltip_active_tab = tab_under_cursor
                    assert self._pattern_detection_tab_tooltip is not None
                    self._pattern_detection_tab_tooltip_timer = self.after(  # type: ignore
                        500, self._pattern_detection_tab_tooltip.showtip, event.x_root, event.y_root + 20
                    )

        def _hide_tooltip() -> None:
            if self._pattern_detection_tab_tooltip_timer:
                self.after_cancel(self._pattern_detection_tab_tooltip_timer)  # type: ignore
                self._pattern_detection_tab_tooltip_timer = None
            if self._pattern_detection_tab_tooltip is not None:
                self._pattern_detection_tab_tooltip.hidetip()
            self._pattern_detection_tab_tooltip_active_tab = None

        def on_leave(event: Any) -> None:
            _hide_tooltip()

        self.right_tabs.bind("<Motion>", on_motion, add="+")
        self.right_tabs.bind("<Leave>", on_leave, add="+")

    def _update_pattern_detection_ui(self) -> None:
        ready = self._check_explorer_prerequisites()

        if self.explorer_run_button is not None:
            self.explorer_run_button.config(state="normal" if ready else "disabled")

        # Count suggestions the same way as in execute_panel.py for consistency
        patch_gen_dir = os.path.join(self.arguments.dot_dp, "patch_generator")
        total_suggestions = 0
        if os.path.isdir(patch_gen_dir):
            for sid in os.listdir(patch_gen_dir):
                sid_dir = os.path.join(patch_gen_dir, sid)
                if os.path.isdir(sid_dir):
                    total_suggestions += sum(1 for f in os.listdir(sid_dir) if f.endswith(".patch"))

        browse_ready = total_suggestions > 0
        if self.browse_suggestions_button is not None:
            self.browse_suggestions_button.config(state="normal" if browse_ready else "disabled")

        detection_executed = self._check_pattern_detection_executed()
        patterns_found = self._check_patterns_found()
        if self.no_suggestions_label is not None:
            if detection_executed and not patterns_found:
                self.no_suggestions_label.pack(anchor=tk.W, padx=5, pady=(5, 0))
            else:
                self.no_suggestions_label.pack_forget()

        self._update_pattern_detection_tab_state(ready)
        self._update_autotuning_tab_state(ready and browse_ready)
        if hasattr(self, "_update_autotuning_ui"):
            self._update_autotuning_ui()

    def _check_browse_suggestions_available(self) -> bool:
        patch_gen_dir = os.path.join(self.arguments.dot_dp, "patch_generator")
        if not os.path.isdir(patch_gen_dir):
            return False
        for entry in os.listdir(patch_gen_dir):
            sid_dir = os.path.join(patch_gen_dir, entry)
            if os.path.isdir(sid_dir):
                patch_count = sum(1 for f in os.listdir(sid_dir) if f.endswith(".patch"))
                if patch_count > 0:
                    return True
        return False

    def _open_suggestion_browser(self) -> None:
        from discopop_library.ProjectManager.gui.suggestion_browser import SuggestionBrowserDialog

        SuggestionBrowserDialog(
            self,
            self.arguments.dot_dp,
            on_selection_changed=self._refresh_suggestion_selection_display,
        )

    def _check_explorer_prerequisites(self) -> bool:
        profiler_dir = os.path.join(self.arguments.dot_dp, "profiler")
        return os.path.isdir(profiler_dir)

    def _check_patterns_found(self) -> bool:
        import json

        patterns_file = os.path.join(self.arguments.dot_dp, "explorer", "patterns.json")
        if not os.path.exists(patterns_file):
            return False
        try:
            with open(patterns_file, "r") as f:
                data = json.load(f)
            patterns = data.get("patterns", {})
            return any(
                patterns.get(key, []) for key in ["optimizer_output", "merged_pattern", "task", "do_all", "reduction"]
            )
        except (json.JSONDecodeError, IOError):
            return False

    def _check_pattern_detection_executed(self) -> bool:
        explorer_dir = os.path.join(self.arguments.dot_dp, "explorer")
        return os.path.isdir(explorer_dir)

    def _run_pattern_detection(self) -> None:
        if not self._check_explorer_prerequisites():
            show_error(
                self,
                "Prerequisites Not Met",
                "Profiling data not found.\nPlease execute a configuration in 'dp' mode with 'inplace' enabled first.",
            )
            return

        if self.explorer_running:
            show_error(self, "Already Running", "Pattern detection is already running.")
            return

        self.explorer_running = True
        if self.explorer_run_button is not None:
            self.explorer_run_button.config(state="disabled", text="⟳ Running...")

        if self.no_suggestions_label is not None:
            self.no_suggestions_label.pack_forget()

        self.status_label.config(text="⏳ Pattern detection in progress...", fg="#FF6B6B")

        if self.explorer_output_text is not None:
            self.explorer_output_text.config(state=tk.NORMAL)
            self.explorer_output_text.delete("1.0", tk.END)
            self.explorer_output_text.config(state="disabled")

        def append_output(text: str) -> None:
            if self.explorer_output_text is not None:
                self.explorer_output_text.config(state=tk.NORMAL)
                self.explorer_output_text.insert(tk.END, text)
                self.explorer_output_text.see(tk.END)
                self.explorer_output_text.config(state="disabled")

        def thread_safe_append(text: str) -> None:
            self.after(0, lambda: append_output(text))  # type: ignore

        def thread_func() -> None:
            try:
                thread_safe_append("Starting pattern detection...\n")
                self._invoke_explorer(thread_safe_append)
                self.after(0, lambda: self._on_pattern_detection_complete())  # type: ignore
            except Exception as e:
                thread_safe_append(f"\nError: {str(e)}\n")
                self.after(0, lambda: self._on_pattern_detection_complete(error=True))  # type: ignore

        thread = threading.Thread(target=thread_func, daemon=True)
        thread.start()

    def _invoke_explorer(self, output_callback: Callable[[str], None]) -> None:
        dot_discopop = self.arguments.dot_dp
        project_path = dot_discopop

        output_callback("Loading explorer configuration...\n")

        required_files = [
            os.path.join(project_path, "profiler", "Data.xml"),
            os.path.join(project_path, "profiler", "dynamic_dependencies.txt"),
            os.path.join(project_path, "profiler", "loop_counter_output.txt"),
            os.path.join(project_path, "profiler", "reduction.txt"),
            os.path.join(project_path, "FileMapping.txt"),
        ]
        missing_files = [f for f in required_files if not os.path.exists(f)]
        if missing_files:
            output_callback("\nMissing required files:\n")
            for file_path in missing_files:
                output_callback(f"  - {file_path}\n")
            raise RuntimeError("Missing required profiling data files")

        assert self.pattern_types_vars is not None
        assert self.jobs_var is not None

        selected_patterns = [pattern for pattern, var in self.pattern_types_vars.items() if var.get()]
        enable_patterns = ",".join(selected_patterns) if selected_patterns else "reduction,doall"
        jobs_value = self.jobs_var.get()

        output_callback("Configuration:\n")
        output_callback(f"  Patterns: {enable_patterns}\n")
        output_callback(f"  Threads: {jobs_value}\n\n")

        cmd = [
            sys.executable,
            "-m",
            "discopop_explorer",
            "--path",
            project_path,
            "--enable-patterns",
            enable_patterns,
            "--log",
            "WARNING",
        ]

        if jobs_value != "auto":
            cmd.extend(["-j", jobs_value])

        output_callback("Running pattern detection...\n\n")

        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
        )

        assert process.stdout is not None
        for line in process.stdout:
            cleaned = clean_ansi_output(line.rstrip("\n"))
            if cleaned:
                output_callback(cleaned + "\n")

        process.wait()

        if process.returncode != 0:
            raise RuntimeError(f"Explorer exited with return code {process.returncode}")

        output_callback("\nPattern detection completed.\n")

    def _update_pattern_detection_tab_state(self, enabled: bool) -> None:
        try:
            if enabled:
                self.right_tabs.tab(self.pattern_detection_tab_index, state="normal")
            else:
                self.right_tabs.tab(self.pattern_detection_tab_index, state="disabled")
        except tk.TclError:
            pass

    def _update_autotuning_tab_state(self, enabled: bool) -> None:
        try:
            if not hasattr(self, "autotuning_tab_index"):
                return
            if enabled:
                self.right_tabs.tab(self.autotuning_tab_index, state="normal")
            else:
                self.right_tabs.tab(self.autotuning_tab_index, state="disabled")
        except tk.TclError:
            pass

    def _on_pattern_detection_complete(self, error: bool = False) -> None:
        self.explorer_running = False

        if self.explorer_run_button is not None:
            self.explorer_run_button.config(state="normal", text="Run Pattern Detection")

        self._update_pattern_detection_ui()
        self._refresh_suggestion_selection_display()

        if not error:
            self.status_label.config(text="Pattern detection completed successfully", fg="green")
            self.after(3000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        else:
            self.status_label.config(text="Pattern detection failed", fg="red")
            self.after(3000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
