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


from discopop_library.ProjectManager.configurations.compile_script import (
    get_per_config_compile_script_path,
    get_shared_compile_script_path,
)
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no, show_warning
from discopop_library.ProjectManager.utilities.scriptFiles import write_script_file


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
            self._set_sub_tab_modified(filename, False)

        self._load_compile_override()
        self._load_validate_script()
        self.right_tabs.tab(self.editor_tab_index, text="Editor")
        self._update_execute_modes()
        self._update_report_display()

    def _set_sub_tab_modified(self, filename: str, modified: bool) -> None:
        tab_index = self.editor_sub_tab_index.get(filename)
        if tab_index is None:
            return
        base_label = self.editor_sub_tab_labels[filename]
        self.editor_notebook.tab(tab_index, text=f"{base_label} *" if modified else base_label)

    def _load_compile_override(self) -> None:
        if not self.current_config:
            return

        compile_path = get_per_config_compile_script_path(self.arguments.project_config_dir, self.current_config)
        text_area = self.text_areas["compile.sh"]

        text_area.config(state=tk.NORMAL)
        text_area.delete("1.0", tk.END)

        has_override = os.path.exists(compile_path)
        if has_override:
            try:
                with open(compile_path, "r") as f:
                    text_area.insert("1.0", f.read())
            except Exception as e:
                text_area.insert("1.0", f"Error loading file: {e}")
        else:
            text_area.insert(
                "1.0",
                "# This configuration has no compile.sh override.\n"
                "# The shared compile.sh is used to compile it instead.\n"
                "# Click 'Add Override' above to create one for this configuration only.\n",
            )
            text_area.config(state=tk.DISABLED)

        self.modified_files["compile.sh"] = False
        text_area.edit_modified(False)
        self._set_sub_tab_modified("compile.sh", False)
        self.compile_override_button.config(text="Remove Override" if has_override else "Add Override")

    def _toggle_compile_override(self) -> None:
        if not self.current_config:
            return

        compile_path = get_per_config_compile_script_path(self.arguments.project_config_dir, self.current_config)
        if os.path.exists(compile_path):
            self._remove_compile_override(compile_path)
        else:
            self._add_compile_override(compile_path)

    def _add_compile_override(self, compile_path: str) -> None:
        shared_path = get_shared_compile_script_path(self.arguments.project_config_dir)
        seed_content = ""
        if os.path.exists(shared_path):
            with open(shared_path, "r") as f:
                seed_content = f.read()

        write_script_file(compile_path, seed_content)
        self._load_compile_override()
        self._update_execute_modes()
        self._set_status("Added compile.sh override for this configuration", fg="green", reset_delay=2000)

    def _remove_compile_override(self, compile_path: str) -> None:
        if not ask_yes_no(
            self,
            "Remove Override",
            "Remove the compile.sh override for this configuration?\n\n"
            "The configuration will use the shared compile.sh instead.",
        ):
            return

        os.remove(compile_path)
        self._load_compile_override()
        self._update_execute_modes()
        self._set_status("Removed compile.sh override for this configuration", fg="green", reset_delay=2000)

    def _get_validate_script_path(self) -> str:
        assert self.current_config is not None
        return os.path.join(self.config_dir, self.current_config, "validate.sh")

    def _load_validate_script(self) -> None:
        if not self.current_config:
            return

        validate_path = self._get_validate_script_path()
        text_area = self.text_areas["validate.sh"]

        text_area.config(state=tk.NORMAL)
        text_area.delete("1.0", tk.END)

        has_validate = os.path.exists(validate_path)
        if has_validate:
            try:
                with open(validate_path, "r") as f:
                    text_area.insert("1.0", f.read())
            except Exception as e:
                text_area.insert("1.0", f"Error loading file: {e}")
        else:
            text_area.insert(
                "1.0",
                "# This configuration has no validate.sh.\n"
                "# execute.sh alone determines correctness (its exit code).\n"
                "# Click 'Add validate.sh' above to separate output validation from\n"
                "# the timed execute.sh run: validate.sh re-runs the code and validates\n"
                "# its output; a run then counts as correct only if BOTH execute.sh and\n"
                "# validate.sh exit 0.\n",
            )
            text_area.config(state=tk.DISABLED)

        self.modified_files["validate.sh"] = False
        text_area.edit_modified(False)
        self._set_sub_tab_modified("validate.sh", False)
        self.validate_script_button.config(text="Remove validate.sh" if has_validate else "Add validate.sh")

    def _toggle_validate_script(self) -> None:
        if not self.current_config:
            return

        validate_path = self._get_validate_script_path()
        if os.path.exists(validate_path):
            self._remove_validate_script(validate_path)
        else:
            self._add_validate_script(validate_path)

    def _add_validate_script(self, validate_path: str) -> None:
        assert self.current_config is not None
        seed_content = ""
        execute_path = os.path.join(self.config_dir, self.current_config, "execute.sh")
        if os.path.exists(execute_path):
            with open(execute_path, "r") as f:
                seed_content = f.read()

        write_script_file(validate_path, seed_content)
        self._load_validate_script()
        self._set_status("Added validate.sh for this configuration", fg="green", reset_delay=2000)

    def _remove_validate_script(self, validate_path: str) -> None:
        if not ask_yes_no(
            self,
            "Remove validate.sh",
            "Remove validate.sh for this configuration?\n\n" "Correctness will then be determined by execute.sh alone.",
        ):
            return

        os.remove(validate_path)
        self._load_validate_script()
        self._set_status("Removed validate.sh for this configuration", fg="green", reset_delay=2000)

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
            self._set_status(f"Error validating compile.sh: {e}", fg="red")

    def _save_config(self) -> None:
        if not self.current_config:
            self._set_status("No configuration selected", fg="red")
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
                self._set_sub_tab_modified(filename, False)
                saved_files.append(filename)
            except Exception as e:
                self._set_status(f"Error saving file {filename}: {e}", fg="red")
                return

        if not any(self.modified_files.values()):
            self.right_tabs.tab(self.editor_tab_index, text="Editor")

        if saved_files:
            self._set_status(f"Saved {', '.join(saved_files)}", fg="green", reset_delay=2000)

            if "compile.sh" in saved_files:
                compile_path = os.path.join(config_path, "compile.sh")
                self._validate_compile_script(compile_path)
        else:
            self._set_status("No changes to save")

    def _check_modification(self, filename: str) -> None:
        if filename not in self.text_areas:
            return

        text_area = self.text_areas[filename]
        is_modified = text_area.edit_modified()

        if is_modified and not self.modified_files[filename]:
            self.modified_files[filename] = True
            self._set_sub_tab_modified(filename, True)
            self.right_tabs.tab(self.editor_tab_index, text="Editor *")
        elif not is_modified and self.modified_files[filename]:
            self.modified_files[filename] = False
            self._set_sub_tab_modified(filename, False)
            if not any(self.modified_files.values()):
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
