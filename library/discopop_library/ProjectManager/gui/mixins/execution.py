# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
import json
import logging
import os
import threading
import tkinter as tk


from discopop_library.ProjectManager.configurations.copying import copy_configuration
from discopop_library.ProjectManager.configurations.deletion import delete_configuration
from discopop_library.ProjectManager.configurations.execution import execute_configuration
from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase
from discopop_library.ProjectManager.gui.mixins.helpers import show_warning
from typing import Optional
from tkinter import ttk


class ExecutionMixin(ConfigManagerMixinBase):
    _execution_stop_event: threading.Event = threading.Event()
    stop_execution_button: Optional[ttk.Button] = None

    def _validate_execution_inputs(self) -> bool:
        cpu_count = os.cpu_count() or 4
        try:
            thread_count = self.thread_var.get()
            if thread_count < 1:
                self._set_status("Error: Thread count must be >= 1", fg="red", reset_delay=3000)
                return False
            if thread_count > cpu_count:
                self._set_status(
                    f"Warning: Thread count ({thread_count}) exceeds CPU count ({cpu_count})",
                    fg="orange",
                    reset_delay=3000,
                )
        except (ValueError, tk.TclError):
            self._set_status("Error: Thread count must be a valid integer", fg="red", reset_delay=3000)
            return False

        try:
            timeout_exec = self.timeout_execution_var.get()
            if timeout_exec < 0:
                self._set_status("Error: Execution timeout cannot be negative", fg="red", reset_delay=3000)
                return False
        except (ValueError, tk.TclError):
            self._set_status("Error: Execution timeout must be a valid integer", fg="red", reset_delay=3000)
            return False

        try:
            timeout_comp = self.timeout_compilation_var.get()
            if timeout_comp < 0:
                self._set_status("Error: Compilation timeout cannot be negative", fg="red", reset_delay=3000)
                return False
        except (ValueError, tk.TclError):
            self._set_status("Error: Compilation timeout must be a valid integer", fg="red", reset_delay=3000)
            return False

        return True

    def _run_execution(self) -> None:
        if not self._validate_execution_inputs():
            return

        selected_modes = [mode for mode, var in self.mode_vars.items() if var.get()]
        if not selected_modes:
            show_warning(self, "No mode selected", "Please select at least one execution mode.")
            return

        inplace = self.inplace_var.get()
        suggestions_mode = self.suggestions_mode_var.get()
        if inplace and suggestions_mode != "none":
            from discopop_library.ProjectManager.gui.mixins.helpers import ask_yes_no

            if not ask_yes_no(
                self,
                "Dangerous Configuration",
                "Warning: You have selected inplace execution with suggestion application.\n\n"
                "This will directly modify your project directory and may overwrite existing files.\n\n"
                "Do you want to proceed?",
            ):
                return

        self._execution_stop_event.clear()
        if self.stop_execution_button is not None:
            self.stop_execution_button.config(state="normal")

        self.run_button.config(state="disabled", text="⟳ Running...")
        self.generate_report_button.config(state="disabled")
        self.view_report_button.config(state="disabled")

        self.status_label.config(text="⏳ Execution in progress...", foreground="#FF6B6B")

        self.output_text.config(state=tk.NORMAL)
        self.output_text.delete("1.0", tk.END)
        self.output_text.config(state="disabled")

        def append_output(text: str) -> None:
            self.output_text.config(state=tk.NORMAL)
            self.output_text.insert(tk.END, text)
            self.output_text.see(tk.END)
            self.output_text.config(state="disabled")

        inplace = self.inplace_var.get()
        skip_cleanup = self.skip_cleanup_var.get()
        thread_count = self.thread_var.get()
        label_prefix = self.label_prefix_var.get()
        timeout_execution = self.timeout_execution_var.get()
        timeout_compilation = self.timeout_compilation_var.get()
        log_level = self.log_level_var.get()
        suggestions_mode = self.suggestions_mode_var.get()
        assert self.current_config is not None
        current_config = self.current_config
        config_path = os.path.join(self.config_dir, current_config)
        args_copy = copy.copy(self.arguments)
        args_copy.execute_inplace = inplace
        args_copy.skip_cleanup = skip_cleanup
        args_copy.label_prefix = label_prefix
        args_copy.timeout_execution = timeout_execution
        args_copy.timeout_compilation = timeout_compilation
        args_copy.log_level = log_level

        combined_ids: list[str] = []

        if suggestions_mode == "manual":
            selection_path = os.path.join(args_copy.dot_dp, "project", "manager", "selected_suggestions.json")
            try:
                with open(selection_path, "r") as f:
                    selection_data = json.load(f)
                combined_ids += [sid for sid, patches in selection_data.get("selected", {}).items() if patches]
            except (json.JSONDecodeError, IOError):
                pass

        if suggestions_mode == "autotuner":
            results_path = os.path.join(args_copy.dot_dp, "auto_tuner", "results.json")
            try:
                with open(results_path, "r") as f:
                    results_data = json.load(f)
                autotuner_ids = [str(s) for s in results_data.get(current_config, {}).get("applied_suggestions", [])]
                combined_ids += [sid for sid in autotuner_ids if sid not in combined_ids]
            except (json.JSONDecodeError, IOError):
                pass

        args_copy.apply_suggestions = ",".join(combined_ids) if combined_ids else None

        logging.basicConfig(level=log_level, force=True)
        root_logger = logging.getLogger()
        root_logger.setLevel(log_level)

        for handler in root_logger.handlers[:]:
            root_logger.removeHandler(handler)

        from discopop_library.ProjectManager.gui.mixins.helpers import TextAreaHandler

        text_handler = TextAreaHandler(self.output_text)
        text_handler.setLevel(log_level)
        formatter = logging.Formatter("[%(name)s] %(levelname)s: %(message)s")
        text_handler.setFormatter(formatter)
        root_logger.addHandler(text_handler)

        logger = logging.getLogger("Execute")
        logger.info(f"Starting execution of configuration: {current_config}")

        def thread_func() -> None:
            if inplace and args_copy.apply_suggestions:
                self.after(  # type: ignore
                    0,
                    lambda: append_output("Note: Apply suggestions is ignored in inplace mode.\n"),
                )

            shared_compile_sh = os.path.join(self.arguments.project_config_dir, "compile.sh")
            shared_seq_settings = os.path.join(self.arguments.project_config_dir, "seq_settings.json")
            shared_dp_settings = os.path.join(self.arguments.project_config_dir, "dp_settings.json")
            shared_hd_settings = os.path.join(self.arguments.project_config_dir, "hd_settings.json")
            shared_par_settings = os.path.join(self.arguments.project_config_dir, "par_settings.json")

            for mode in selected_modes:
                if self._execution_stop_event.is_set():
                    self.after(0, lambda: append_output("Execution stopped by user.\n"))  # type: ignore
                    break

                self.after(0, lambda m=mode: append_output(f"\n=== {m.upper()} mode ===\n"))  # type: ignore

                settings_file = f"{mode}_settings.json"
                if mode == "seq":
                    settings_path = shared_seq_settings
                elif mode == "dp":
                    settings_path = shared_dp_settings
                elif mode == "hd":
                    settings_path = shared_hd_settings
                elif mode == "par":
                    settings_path = shared_par_settings
                else:
                    continue

                if inplace:
                    project_copy_path = self.arguments.project_root
                else:
                    self.after(0, lambda: append_output("Copying project...\n"))  # type: ignore
                    try:
                        project_copy_path = copy_configuration(args_copy, config_path, settings_path)
                    except Exception as e:
                        self.after(0, lambda e_msg=str(e): append_output(f"Error copying project: {e_msg}\n"))  # type: ignore
                        continue

                self.after(0, lambda: self.status_label.config(text="⏳ Compiling...", foreground="#FF6B6B"))  # type: ignore
                self.after(0, lambda: append_output("Compiling...\n"))  # type: ignore
                compile_result = execute_configuration(
                    args_copy,
                    project_copy_path,
                    config_path,
                    settings_path,
                    shared_compile_sh,
                    1 if mode == "seq" else thread_count,
                    args_copy.timeout_compilation,
                )

                if compile_result is None or compile_result[0] != 0:
                    ret_code = compile_result[0] if compile_result else "None"
                    self.after(0, lambda rc=ret_code: append_output(f"Compilation failed (return code: {rc})\n"))  # type: ignore
                    if not inplace and not skip_cleanup:
                        try:
                            delete_configuration(args_copy, project_copy_path)
                        except Exception:
                            pass
                    continue

                ret_code, elapsed, stdout, stderr = compile_result
                self.after(0, lambda e=elapsed: append_output(f"Compilation succeeded ({e:.2f}s)\n"))  # type: ignore
                if stdout:
                    self.after(0, lambda o=stdout: append_output(f"stdout: {o}\n"))  # type: ignore
                if stderr:
                    self.after(0, lambda e=stderr: append_output(f"stderr: {e}\n"))  # type: ignore

                if self._execution_stop_event.is_set():
                    self.after(0, lambda: append_output("Execution stopped by user.\n"))  # type: ignore
                    break

                self.after(0, lambda: self.status_label.config(text="⏳ Executing...", foreground="#FF6B6B"))  # type: ignore
                self.after(0, lambda: append_output("Executing...\n"))  # type: ignore
                execute_result = execute_configuration(
                    args_copy,
                    project_copy_path,
                    config_path,
                    settings_path,
                    os.path.join(config_path, "execute.sh"),
                    1 if mode == "seq" else thread_count,
                    args_copy.timeout_execution,
                )

                if execute_result is None or execute_result[0] != 0:
                    ret_code = execute_result[0] if execute_result else "None"
                    self.after(0, lambda rc=ret_code: append_output(f"Execution failed (return code: {rc})\n"))  # type: ignore
                else:
                    ret_code, elapsed, stdout, stderr = execute_result
                    self.after(0, lambda e=elapsed: append_output(f"Execution succeeded ({e:.2f}s)\n"))  # type: ignore
                    if stdout:
                        self.after(0, lambda o=stdout: append_output(f"stdout: {o}\n"))  # type: ignore
                    if stderr:
                        self.after(0, lambda e=stderr: append_output(f"stderr: {e}\n"))  # type: ignore

                if not inplace and not skip_cleanup:
                    try:
                        delete_configuration(args_copy, project_copy_path)
                    except Exception:
                        pass

            self.after(0, lambda: append_output("\n=== Execution complete ===\n"))  # type: ignore
            self.after(0, lambda: self.run_button.config(state=tk.NORMAL, text="Run"))  # type: ignore
            self.after(0, lambda: self.stop_execution_button.config(state="disabled") if self.stop_execution_button else None)  # type: ignore
            self.after(0, lambda: self.generate_report_button.config(state=tk.NORMAL))  # type: ignore
            self.after(0, lambda: self.inplace_var.set(False))  # type: ignore
            self.after(0, lambda: self.status_label.config(text="Ready", foreground="gray"))  # type: ignore
            self.after(0, lambda: self._refresh_config_list())  # type: ignore
            self.after(0, lambda: self._update_report_display())  # type: ignore
            self.after(0, lambda: self._update_pattern_detection_ui())  # type: ignore

        threading.Thread(target=thread_func, daemon=True).start()

    def _prepare_pattern_detection(self) -> None:
        if not self.current_config:
            show_warning(self, "No Configuration Selected", "Please select a configuration first.")
            return

        self._execution_stop_event.clear()
        if self.stop_execution_button is not None:
            self.stop_execution_button.config(state="normal")

        self.prepare_pattern_detection_button.config(state="disabled", text="⟳ Preparing...")
        self.run_button.config(state="disabled")
        self.generate_report_button.config(state="disabled")
        self.view_report_button.config(state="disabled")

        self.status_label.config(text="⏳ Preparing pattern detection...", foreground="#FF6B6B")

        self.output_text.config(state=tk.NORMAL)
        self.output_text.delete("1.0", tk.END)
        self.output_text.config(state="disabled")

        def append_output(text: str) -> None:
            self.output_text.config(state=tk.NORMAL)
            self.output_text.insert(tk.END, text)
            self.output_text.see(tk.END)
            self.output_text.config(state="disabled")

        args_copy = copy.copy(self.arguments)
        args_copy.execute_inplace = True
        args_copy.skip_cleanup = False
        args_copy.label_prefix = ""
        args_copy.timeout_execution = self.timeout_execution_var.get()
        args_copy.timeout_compilation = self.timeout_compilation_var.get()
        args_copy.log_level = "INFO"
        args_copy.apply_suggestions = None

        current_config = self.current_config
        config_path = os.path.join(self.config_dir, current_config)

        import logging

        logging.basicConfig(level="INFO", force=True)
        root_logger = logging.getLogger()
        root_logger.setLevel("INFO")

        for handler in root_logger.handlers[:]:
            root_logger.removeHandler(handler)

        from discopop_library.ProjectManager.gui.mixins.helpers import TextAreaHandler

        text_handler = TextAreaHandler(self.output_text)
        text_handler.setLevel("INFO")
        formatter = logging.Formatter("[%(name)s] %(levelname)s: %(message)s")
        text_handler.setFormatter(formatter)
        root_logger.addHandler(text_handler)

        logger = logging.getLogger("Prepare Pattern Detection")

        def thread_func() -> None:
            logger.info(f"Starting pattern detection preparation for: {current_config}")
            self.after(0, lambda: append_output("Compiling in 'dp' mode with inplace execution...\n\n"))  # type: ignore

            shared_compile_sh = os.path.join(self.arguments.project_config_dir, "compile.sh")
            shared_dp_settings = os.path.join(self.arguments.project_config_dir, "dp_settings.json")

            self.after(0, lambda: self.status_label.config(text="⏳ Compiling...", foreground="#FF6B6B"))  # type: ignore
            self.after(0, lambda: append_output("Compiling...\n"))  # type: ignore

            compile_result = execute_configuration(
                args_copy,
                self.arguments.project_root,
                config_path,
                shared_dp_settings,
                shared_compile_sh,
                1,
                args_copy.timeout_compilation,
            )

            if compile_result is None or compile_result[0] != 0:
                ret_code = compile_result[0] if compile_result else "None"
                self.after(0, lambda rc=ret_code: append_output(f"Compilation failed (return code: {rc})\n"))  # type: ignore
                self.after(0, lambda: self.status_label.config(text="Pattern detection preparation failed", foreground="red"))  # type: ignore
            else:
                ret_code, elapsed, stdout, stderr = compile_result
                self.after(0, lambda e=elapsed: append_output(f"Compilation succeeded ({e:.2f}s)\n"))  # type: ignore
                if stdout:
                    self.after(0, lambda o=stdout: append_output(f"stdout: {o}\n"))  # type: ignore
                if stderr:
                    self.after(0, lambda e=stderr: append_output(f"stderr: {e}\n"))  # type: ignore

                if self._execution_stop_event.is_set():
                    self.after(0, lambda: append_output("Pattern detection preparation stopped by user.\n"))  # type: ignore
                else:
                    self.after(0, lambda: self.status_label.config(text="⏳ Executing...", foreground="#FF6B6B"))  # type: ignore
                    self.after(0, lambda: append_output("Executing...\n"))  # type: ignore

                    execute_result = execute_configuration(
                        args_copy,
                        self.arguments.project_root,
                        config_path,
                        shared_dp_settings,
                        os.path.join(config_path, "execute.sh"),
                        1,
                        args_copy.timeout_execution,
                    )

                if execute_result is None or execute_result[0] != 0:
                    ret_code = execute_result[0] if execute_result else "None"
                    self.after(0, lambda rc=ret_code: append_output(f"Execution failed (return code: {rc})\n"))  # type: ignore
                    self.after(0, lambda: self.status_label.config(text="Pattern detection preparation failed", foreground="red"))  # type: ignore
                else:
                    ret_code, elapsed, stdout, stderr = execute_result
                    self.after(0, lambda e=elapsed: append_output(f"Execution succeeded ({e:.2f}s)\n"))  # type: ignore
                    if stdout:
                        self.after(0, lambda o=stdout: append_output(f"stdout: {o}\n"))  # type: ignore
                    if stderr:
                        self.after(0, lambda e=stderr: append_output(f"stderr: {e}\n"))  # type: ignore

            self.after(0, lambda: append_output("\n=== Pattern detection preparation complete ===\n"))  # type: ignore
            self.after(0, lambda: self.prepare_pattern_detection_button.config(state=tk.NORMAL, text="Prepare Pattern Detection"))  # type: ignore
            self.after(0, lambda: self.stop_execution_button.config(state="disabled") if self.stop_execution_button else None)  # type: ignore
            self.after(0, lambda: self.run_button.config(state=tk.NORMAL))  # type: ignore
            self.after(0, lambda: self.generate_report_button.config(state=tk.NORMAL))  # type: ignore
            self.after(0, lambda: self.status_label.config(text="Ready", foreground="gray"))  # type: ignore
            self.after(0, lambda: self._update_report_display())  # type: ignore
            self.after(0, lambda: self._update_pattern_detection_ui())  # type: ignore

        threading.Thread(target=thread_func, daemon=True).start()

    def _stop_execution(self) -> None:
        self._execution_stop_event.set()
        if self.stop_execution_button is not None:
            self.stop_execution_button.config(state="disabled")
        self.status_label.config(text="Stopping execution...", foreground="orange")
