# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import json
import os
import subprocess
import tkinter as tk
from tkinter import ttk
from typing import Any, Optional

from discopop_library.ProjectManager.gui.mixins.helpers import (
    Tooltip,
    show_warning,
    show_error,
    enable_text_context_menu,
)
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase

BASE_FILES = ["compile.sh", "execute.sh", "seq_settings.json"]
DERIVED_FILES = ["dp_settings.json", "hd_settings.json", "par_settings.json"]

TAB_TOOLTIPS = {
    "compile.sh": "Compilation instructions",
    "execute.sh": "Execution instructions",
    "seq_settings.json": "Settings for sequential execution",
    "dp_settings.json": "Settings for DiscoPoP instrumented execution",
    "hd_settings.json": "Settings for DiscoPoP hotspot detection instrumented execution",
    "par_settings.json": "Settings for the execution of the parallelized source code",
}


class CompilationEditorMixin(ConfigManagerMixinBase):
    def _check_compilation_modification(self, filename: str) -> None:
        if filename not in self.compilation_text_areas:
            return

        text_area = self.compilation_text_areas[filename]
        is_modified = text_area.edit_modified()

        if is_modified and not self.compilation_modified_files[filename]:
            self.compilation_modified_files[filename] = True
            if self.compilation_notebook and filename in self.compilation_tabs:
                tab_index = self.compilation_tabs[filename]
                self.compilation_notebook.tab(tab_index, text=f"{filename} *")
            self._update_derive_button_state()
        elif not is_modified and self.compilation_modified_files[filename]:
            self.compilation_modified_files[filename] = False
            if self.compilation_notebook and filename in self.compilation_tabs:
                tab_index = self.compilation_tabs[filename]
                self.compilation_notebook.tab(tab_index, text=filename)
            self._update_derive_button_state()

    def _derive_current_config(self) -> None:
        if not self.current_config:
            self.status_label.config(text="No configuration selected", fg="red")
            return

        has_unsaved = any(self.modified_files.get(filename, False) for filename in ["execute.sh"])
        if has_unsaved:
            show_warning(self, "Unsaved Changes", "Please save your changes before deriving configuration files.")
            return

        config_path = os.path.join(self.config_dir, self.current_config)
        settings_path = os.path.join(config_path, "seq_settings.json")

        if not os.path.exists(settings_path):
            show_error(self, "Missing file", "seq_settings.json not found in configuration")
            return

        try:
            with open(settings_path, "r") as f:
                settings = json.load(f)
        except Exception as e:
            show_error(self, "Error", f"Failed to load seq_settings.json: {e}")
            return

        try:
            dp_path = os.path.join(config_path, "dp_settings.json")
            if not os.path.exists(dp_path):
                dp = copy.deepcopy(settings)
                dp["CC"] = "discopop_cc"
                dp["CXX"] = "discopop_cxx"
                with open(dp_path, "w") as f:
                    json.dump(dp, f, indent=2)

            hd_path = os.path.join(config_path, "hd_settings.json")
            if not os.path.exists(hd_path):
                hd = copy.deepcopy(settings)
                hd["CC"] = "discopop_hotspot_cc"
                hd["CXX"] = "discopop_hotspot_cxx"
                hd["CFLAGS"] += " -fopenmp" if hd["CFLAGS"] else "-fopenmp"
                hd["CXXFLAGS"] += " -fopenmp" if hd["CXXFLAGS"] else "-fopenmp"
                with open(hd_path, "w") as f:
                    json.dump(hd, f, indent=2)

            par_path = os.path.join(config_path, "par_settings.json")
            if not os.path.exists(par_path):
                par = copy.deepcopy(settings)
                par["CFLAGS"] += " -fopenmp" if par["CFLAGS"] else "-fopenmp"
                par["CXXFLAGS"] += " -fopenmp" if par["CXXFLAGS"] else "-fopenmp"
                with open(par_path, "w") as f:
                    json.dump(par, f, indent=2)

            self._load_config()
            self.status_label.config(text="Derived configuration files created", fg="green")
            self.after(2000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        except Exception as e:
            show_error(self, "Error", f"Failed to derive settings: {e}")
            self.status_label.config(text="Error deriving config", fg="red")

    def _open_compilation_editor(self) -> None:
        if self.compilation_editor_open:
            return

        self.compilation_editor_open = True
        self.compilation_text_areas = {}
        self.compilation_modified_files = {}
        self.compilation_tabs = {}
        self.compilation_tab_tooltips = {}
        self.compilation_tooltip_timer = None

        comp_window = tk.Toplevel(self)  # type: ignore
        comp_window.title("Compilation Editor")
        comp_window.geometry("1050x700")
        comp_window.minsize(800, 500)

        def on_close_window() -> None:
            comp_window.destroy()
            self.compilation_editor_open = False
            self.compilation_text_areas = {}
            self.compilation_modified_files = {}
            self.compilation_notebook = None
            self.compilation_tabs = {}
            self._hide_compilation_tooltips()
            self.compilation_tab_tooltips = {}
            if self.derive_button_tooltip_timer:
                self.after_cancel(self.derive_button_tooltip_timer)  # type: ignore
                self.derive_button_tooltip_timer = None
            if self.derive_button_tooltip:
                self.derive_button_tooltip.hidetip()

        comp_window.protocol("WM_DELETE_WINDOW", on_close_window)

        bottom_comp_frame = tk.Frame(comp_window)
        bottom_comp_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=5)

        comp_content_frame = tk.Frame(comp_window)
        comp_content_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=(5, 0))

        self.compilation_notebook = ttk.Notebook(comp_content_frame)

        style = ttk.Style()
        style.configure("TNotebook.Tab", padding=[10, 2], font=("TkDefaultFont", 9))

        compilation_files = [
            "compile.sh",
            "seq_settings.json",
            "dp_settings.json",
            "hd_settings.json",
            "par_settings.json",
        ]

        for filename in compilation_files:
            frame = tk.Frame(self.compilation_notebook)
            self.compilation_notebook.add(frame, text=filename)
            self.compilation_tabs[filename] = self.compilation_notebook.index(frame)

            tooltip_text = TAB_TOOLTIPS.get(filename, "")
            if filename in DERIVED_FILES:
                file_path = os.path.join(self.arguments.project_config_dir, filename)
                if not os.path.exists(file_path):
                    tooltip_text += "\n\nUse 'Derive Settings' to generate this file from seq_settings.json"

            if tooltip_text:
                tab_index = self.compilation_tabs[filename]
                tooltip = Tooltip(self.compilation_notebook, tooltip_text)
                self.compilation_tab_tooltips[tab_index] = (filename, tooltip)

            header_frame = tk.Frame(frame)
            header_frame.pack(fill=tk.X, padx=5, pady=5)

            help_label = tk.Label(header_frame, text=filename, font=("TkDefaultFont", 9, "bold"))
            help_label.pack(side=tk.LEFT)

            help_command = self._get_help_command(filename)
            if help_command:
                help_button = tk.Button(header_frame, text="Help", command=help_command)
                help_button.pack(side=tk.RIGHT, padx=5)

            text_frame = tk.Frame(frame)
            text_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

            scrollbar = tk.Scrollbar(text_frame)
            scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

            text_area = tk.Text(text_frame, yscrollcommand=scrollbar.set, wrap=tk.WORD)
            text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
            scrollbar.config(command=text_area.yview)
            enable_text_context_menu(text_area)

            self.compilation_text_areas[filename] = text_area
            self.compilation_modified_files[filename] = False

        self._load_compilation_files()

        comp_dir = self.arguments.project_config_dir
        for filename in DERIVED_FILES:
            file_path = os.path.join(comp_dir, filename)
            if not os.path.exists(file_path):
                tab_index = self.compilation_tabs[filename]
                self.compilation_notebook.tab(tab_index, state="disabled")

        self.compilation_notebook.pack(fill=tk.BOTH, expand=True)

        self.compilation_notebook.bind("<<NotebookTabChanged>>", self._on_compilation_tab_changed)

        self.compilation_notebook.bind("<Motion>", self._on_compilation_tab_motion)
        self.compilation_notebook.bind("<Leave>", self._on_compilation_tab_leave)

        save_button = tk.Button(bottom_comp_frame, text="Save (Ctrl+S)", command=self._save_compilation_files)
        save_button.pack(side=tk.LEFT, padx=5)

        self.test_compilation_button = tk.Button(
            bottom_comp_frame, text="Test Compilation", command=self._test_compilation_from_editor, state="disabled"
        )
        self.test_compilation_button.pack(side=tk.LEFT, padx=5)

        self.derive_compilation_button = tk.Button(
            bottom_comp_frame, text="Derive", command=self._derive_compilation_settings, state="disabled"
        )
        self.derive_compilation_button.pack(side=tk.LEFT, padx=5)

        self.derive_button_tooltip = Tooltip(
            self.derive_compilation_button, "Save all changes before deriving settings"
        )

        def on_derive_enter(event: Any) -> None:
            if self.derive_compilation_button.cget("state") == "disabled" and self.derive_button_tooltip:
                if self.derive_button_tooltip_timer:
                    self.after_cancel(self.derive_button_tooltip_timer)  # type: ignore
                self.derive_button_tooltip_timer = self.after(  # type: ignore
                    500, self.derive_button_tooltip.showtip, event.x_root + 5, event.y_root + 5
                )

        def on_derive_leave(event: Any) -> None:
            if self.derive_button_tooltip_timer:
                self.after_cancel(self.derive_button_tooltip_timer)  # type: ignore
                self.derive_button_tooltip_timer = None
            if self.derive_button_tooltip:
                self.derive_button_tooltip.hidetip()

        self.derive_compilation_button.bind("<Enter>", on_derive_enter)
        self.derive_compilation_button.bind("<Leave>", on_derive_leave)

        self._update_derive_button_state()
        self._on_compilation_tab_changed(None)  # type: ignore

    def _load_compilation_files(self) -> None:
        comp_dir = self.arguments.project_config_dir
        for filename in self.compilation_text_areas:
            file_path = os.path.join(comp_dir, filename)
            text_area = self.compilation_text_areas[filename]
            text_area.delete("1.0", tk.END)

            if os.path.exists(file_path):
                try:
                    with open(file_path, "r") as f:
                        content = f.read()
                        if filename.endswith(".json"):
                            content = self._format_json_content(content)
                        text_area.insert("1.0", content)
                except Exception as e:
                    text_area.insert("1.0", f"Error loading file: {e}")
            else:
                text_area.insert("1.0", f"File not found: {file_path}")

            self.compilation_modified_files[filename] = False
            text_area.edit_modified(False)

    def _save_compilation_files(self) -> None:
        comp_dir = self.arguments.project_config_dir
        os.makedirs(comp_dir, exist_ok=True)

        saved_files = []
        for filename in self.compilation_text_areas:
            if not self.compilation_modified_files[filename]:
                continue

            file_path = os.path.join(comp_dir, filename)
            content = self.compilation_text_areas[filename].get("1.0", tk.END).rstrip()

            if filename.endswith(".json"):
                formatted_content = self._format_json_content(content)
            else:
                formatted_content = content

            try:
                with open(file_path, "w") as f:
                    f.write(formatted_content)

                if filename.endswith(".sh"):
                    subprocess.run(
                        f"chmod +x {file_path}",
                        executable="/bin/bash",
                        shell=True,
                        capture_output=True,
                    )

                self.compilation_modified_files[filename] = False
                self.compilation_text_areas[filename].edit_modified(False)
                if self.compilation_notebook and filename in self.compilation_tabs:
                    tab_index = self.compilation_tabs[filename]
                    self.compilation_notebook.tab(tab_index, text=filename)
                saved_files.append(filename)
            except Exception as e:
                self.status_label.config(text=f"Error saving file {filename}: {e}", fg="red")
                return

        if saved_files:
            self.status_label.config(text=f"Saved {', '.join(saved_files)}", fg="green")
            self._update_derive_button_state()
            self.after(2000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        else:
            self.status_label.config(text="No changes to save", fg="gray")

    def _on_compilation_tab_changed(self, event: Any) -> None:
        """Show/hide Derive and Test buttons based on active compilation tab"""
        notebook = self.compilation_notebook
        if not notebook:
            return
        current_tab = notebook.select()
        if current_tab:
            tab_text = notebook.tab(current_tab, "text").rstrip("*")
            if tab_text == "compile.sh":
                self.test_compilation_button.pack(side=tk.LEFT, padx=5)
                compile_sh_path = os.path.join(self.arguments.project_config_dir, "compile.sh")
                seq_settings_path = os.path.join(self.arguments.project_config_dir, "seq_settings.json")
                can_test = os.path.exists(compile_sh_path) and os.path.exists(seq_settings_path)
                self.test_compilation_button.config(state="normal" if can_test else "disabled")
            else:
                self.test_compilation_button.pack_forget()
            if tab_text == "seq_settings.json":
                self.derive_compilation_button.pack(side=tk.LEFT, padx=5)
            else:
                self.derive_compilation_button.pack_forget()

    def _update_derive_button_state(self) -> None:
        """Update Derive button enabled/disabled state based on unsaved changes"""
        if self.compilation_notebook is None:
            return

        has_unsaved_changes = any(self.compilation_modified_files.values())

        if has_unsaved_changes:
            self.derive_compilation_button.config(state="disabled")
        else:
            self.derive_compilation_button.config(state="normal")

    def _on_compilation_tab_motion(self, event: Any) -> None:
        """Show tooltip for whichever compilation tab is under the cursor."""
        if not self.compilation_notebook:
            return

        try:
            result = self.compilation_notebook.tk.call(
                str(self.compilation_notebook), "identify", "tab", event.x, event.y
            )
            tab_under_cursor: Optional[int] = int(result) if result != "" else None
        except Exception:
            tab_under_cursor = None

        if tab_under_cursor == self.current_tooltip_tab:
            return

        self._hide_compilation_tooltips()

        if tab_under_cursor is not None and tab_under_cursor in self.compilation_tab_tooltips:
            self.current_tooltip_tab = tab_under_cursor
            _, tooltip = self.compilation_tab_tooltips[tab_under_cursor]
            self.compilation_tooltip_timer = self.after(500, tooltip.showtip, event.x_root, event.y_root)  # type: ignore

    def _on_compilation_tab_leave(self, event: Any) -> None:
        """Hide tooltip when the mouse leaves the compilation notebook."""
        self._hide_compilation_tooltips()

    def _hide_compilation_tooltips(self) -> None:
        if self.compilation_tooltip_timer:
            self.after_cancel(self.compilation_tooltip_timer)  # type: ignore
            self.compilation_tooltip_timer = None
        for _, tooltip in self.compilation_tab_tooltips.values():
            tooltip.hidetip()
        self.current_tooltip_tab = None

    def _test_compilation_from_editor(self) -> None:
        """Test compilation using current compile.sh and seq_settings.json"""
        import threading

        if self.compilation_modified_files.get("compile.sh", False) or self.compilation_modified_files.get(
            "seq_settings.json", False
        ):
            self._save_compilation_files()

        compile_sh_path = os.path.join(self.arguments.project_config_dir, "compile.sh")
        seq_settings_path = os.path.join(self.arguments.project_config_dir, "seq_settings.json")

        if not os.path.exists(compile_sh_path):
            show_error(self, "Missing File", "compile.sh not found")
            return

        if not os.path.exists(seq_settings_path):
            show_error(self, "Missing File", "seq_settings.json not found")
            return

        self.test_compilation_button.config(state="disabled", text="⟳ Testing...")
        self.status_label.config(text="Running compilation test...", fg="#FF6B6B")

        def thread_func() -> None:
            from discopop_library.ProjectManager.configurations.execution import execute_configuration

            result = execute_configuration(
                copy.copy(self.arguments),
                self.arguments.project_root,
                self.arguments.project_config_dir,
                seq_settings_path,
                compile_sh_path,
                1,
                self.arguments.timeout_compilation,
            )

            if result is None:
                self.after(0, lambda: self.status_label.config(text="✗ Compilation test failed: settings not found", fg="red"))  # type: ignore
            else:
                ret_code, elapsed, stdout, stderr = result
                if ret_code == 0:
                    self.after(0, lambda e=elapsed: self.status_label.config(text=f"✓ Compilation successful ({e:.2f}s)", fg="green"))  # type: ignore
                else:
                    self.after(0, lambda rc=ret_code, e=elapsed: self.status_label.config(text=f"✗ Compilation failed (exit code: {rc}, {e:.2f}s)", fg="red"))  # type: ignore

                output_msg = f"Compilation test output:\n\n"
                if ret_code == 0:
                    output_msg += f"Success ({elapsed:.2f}s)\n"
                else:
                    output_msg += f"Failed with exit code {ret_code} ({elapsed:.2f}s)\n"
                if stdout:
                    output_msg += f"\nstdout:\n{stdout}\n"
                if stderr:
                    output_msg += f"\nstderr:\n{stderr}\n"

                self.after(0, lambda msg=output_msg, rc=ret_code: self._show_test_compilation_result(msg, rc))  # type: ignore

            self.after(0, lambda: self.test_compilation_button.config(state="normal", text="Test Compilation"))  # type: ignore

        threading.Thread(target=thread_func, daemon=True).start()

    def _show_test_compilation_result(self, output: str, return_code: int) -> None:
        """Show test compilation result in a dialog"""
        from tkinter import simpledialog

        dialog = tk.Toplevel(self)  # type: ignore
        dialog.title("Compilation Test Result")
        dialog.geometry("700x500")
        dialog.minsize(400, 300)

        status_color = "green" if return_code == 0 else "red"
        status_text = "✓ Success" if return_code == 0 else "✗ Failed"

        status_label = tk.Label(dialog, text=status_text, fg=status_color, font=("TkDefaultFont", 12, "bold"))
        status_label.pack(pady=10)

        text_frame = tk.Frame(dialog)
        text_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

        scrollbar = tk.Scrollbar(text_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        output_text = tk.Text(text_frame, yscrollcommand=scrollbar.set, wrap=tk.WORD)
        output_text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.config(command=output_text.yview)

        output_text.insert(1.0, output)
        output_text.config(state=tk.DISABLED)

        close_button = tk.Button(dialog, text="Close", command=dialog.destroy)
        close_button.pack(pady=10)

        pw = self.winfo_width()  # type: ignore
        ph = self.winfo_height()  # type: ignore
        px = self.winfo_rootx()  # type: ignore
        py = self.winfo_rooty()  # type: ignore
        w, h = 700, 500
        dialog.geometry(f"{w}x{h}+{px + (pw - w) // 2}+{py + (ph - h) // 2}")

    def _derive_compilation_settings(self) -> None:
        """Derive dp, hd, and par settings from seq_settings.json"""
        try:
            from discopop_library.ProjectManager.utilities.deriveSettingsFiles import derive_settings_files

            derive_settings_files(self.arguments)
            self.status_label.config(text="Derived settings created successfully", fg="green")

            if self.compilation_notebook is not None:
                for filename in DERIVED_FILES:
                    tab_index = self.compilation_tabs[filename]
                    self.compilation_notebook.tab(tab_index, state="normal")

            self._load_compilation_files()

            self._update_derive_button_state()

            self.after(2000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        except Exception as e:
            self.status_label.config(text=f"Error deriving settings: {e}", fg="red")
            self.after(3000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
