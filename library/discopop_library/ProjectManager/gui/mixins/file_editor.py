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


from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.mixins.helpers import show_warning


class FileEditorMixin(ConfigManagerMixinBase):
    def _format_json_content(self, content: str) -> str:
        try:
            parsed = json.loads(content)
            return json.dumps(parsed, indent=2)
        except (json.JSONDecodeError, ValueError):
            return content

    def _load_config(self) -> None:
        if not self.current_config:
            return

        config_path = os.path.join(self.config_dir, self.current_config)

        for filename in ["execute.sh"]:
            file_path = os.path.join(config_path, filename)
            text_area = self.text_areas[filename]
            text_area.delete("1.0", tk.END)

            if os.path.exists(file_path):
                try:
                    with open(file_path, "r") as f:
                        content = f.read()
                        text_area.insert("1.0", content)
                except Exception as e:
                    text_area.insert("1.0", f"Error loading file: {e}")
            else:
                text_area.insert("1.0", f"File not found: {file_path}")

            self.modified_files[filename] = False
            text_area.edit_modified(False)

        self._update_execute_modes()
        self._update_report_display()

    def _validate_compile_script(self, file_path: str) -> None:
        try:
            with open(file_path, "r") as f:
                content = f.read()

            if "CC" not in content and "CXX" not in content:
                show_warning(
                    self,
                    "Compilation Script Warning",
                    "The compilation script does not use CC or CXX environment variables.\n\n"
                    "The compilation script should make use of CC or CXX for compatibility "
                    "with the DiscoPoP framework.",
                )
        except Exception as e:
            self.status_label.config(text=f"Error validating compile.sh: {e}", fg="red")

    def _save_config(self) -> None:
        if not self.current_config:
            self.status_label.config(text="No configuration selected", fg="red")
            return

        config_path = os.path.join(self.config_dir, self.current_config)
        saved_files = []

        for filename in self.text_areas:
            if not self.modified_files[filename]:
                continue

            file_path = os.path.join(config_path, filename)
            content = self.text_areas[filename].get("1.0", tk.END).rstrip()

            if filename.endswith(".json"):
                formatted_content = self._format_json_content(content)
            else:
                formatted_content = content

            try:
                with open(file_path, "w") as f:
                    f.write(formatted_content)
                self.modified_files[filename] = False
                self.text_areas[filename].edit_modified(False)
                self.right_tabs.tab(self.editor_tab_index, text="Editor")
                saved_files.append(filename)
            except Exception as e:
                self.status_label.config(text=f"Error saving file {filename}: {e}", fg="red")
                return

        if saved_files:
            self.status_label.config(text=f"Saved {', '.join(saved_files)}", fg="green")

            if "compile.sh" in saved_files:
                compile_path = os.path.join(config_path, "compile.sh")
                self._validate_compile_script(compile_path)

            self.after(2000, lambda: self.status_label.config(text="Ready", fg="gray"))  # type: ignore
        else:
            self.status_label.config(text="No changes to save", fg="gray")

    def _check_modification(self, filename: str) -> None:
        if filename not in self.text_areas:
            return

        text_area = self.text_areas[filename]
        is_modified = text_area.edit_modified()

        if is_modified and not self.modified_files[filename]:
            self.modified_files[filename] = True
            self.right_tabs.tab(self.editor_tab_index, text="Editor *")
        elif not is_modified and self.modified_files[filename]:
            self.modified_files[filename] = False
            self.right_tabs.tab(self.editor_tab_index, text="Editor")

    def _start_modification_polling(self) -> None:
        for filename in self.text_areas:
            self._check_modification(filename)
        for filename in self.compilation_text_areas:
            self._check_compilation_modification(filename)
        self.after(500, self._start_modification_polling)  # type: ignore

    def _handle_save_shortcut(self) -> None:
        try:
            selected_tab_index = self.right_tabs.index(self.right_tabs.select())
            if selected_tab_index == 0:
                self._save_config()
            elif selected_tab_index == 1:
                pass
            elif selected_tab_index == 2:
                pass
            elif self.right_tabs.tab(selected_tab_index, option="text") == "Compilation":
                self._save_compilation_files()
        except Exception:
            pass
