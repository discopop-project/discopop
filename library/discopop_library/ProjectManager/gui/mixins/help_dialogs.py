# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from tkinter import ttk
from typing import Callable, Optional

from discopop_library.ProjectManager.gui.mixins.mixin_base import ConfigManagerMixinBase


class HelpDialogsMixin(ConfigManagerMixinBase):
    def _show_help_dialog(self, title: str, content: str) -> None:
        help_window = tk.Toplevel(self)  # type: ignore[arg-type]
        help_window.withdraw()
        help_window.title(title)
        help_window.geometry("900x650")
        help_window.minsize(850, 600)
        help_window.resizable(True, True)

        button_frame = ttk.Frame(help_window)
        button_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=10, pady=(0, 10))

        ok_button = ttk.Button(button_frame, text="OK", command=help_window.destroy)
        ok_button.pack(side=tk.LEFT)

        main_frame = ttk.Frame(help_window)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        scrollbar = ttk.Scrollbar(main_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        text = tk.Text(main_frame, wrap=tk.WORD, yscrollcommand=scrollbar.set, font=("TkDefaultFont", 11))
        text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.config(command=text.yview)

        text.insert(1.0, content)
        text.config(state=tk.DISABLED)

        help_window.update_idletasks()
        w = 900
        h = 650
        px = self.winfo_rootx()  # type: ignore[attr-defined]
        py = self.winfo_rooty()  # type: ignore[attr-defined]
        pw = self.winfo_width()  # type: ignore[attr-defined]
        ph = self.winfo_height()  # type: ignore[attr-defined]
        x = px + (pw - w) // 2
        y = py + (ph - h) // 2
        help_window.geometry(f"{w}x{h}+{x}+{y}")
        help_window.deiconify()

    def _get_help_command(self, filename: str) -> Optional[Callable[[], None]]:
        """Get the help command for a given file"""
        help_commands: dict[str, Callable[[], None]] = {
            "compile.sh": self._show_compile_sh_help,
            "execute.sh": self._show_execute_sh_help,
            "seq_settings.json": self._show_seq_settings_help,
            "dp_settings.json": self._show_dp_settings_help,
            "hd_settings.json": self._show_hd_settings_help,
            "par_settings.json": self._show_par_settings_help,
        }
        return help_commands.get(filename)

    def _show_compile_sh_help(self) -> None:
        help_text = (
            "Compilation Script (compile.sh)\n\n"
            "Purpose:\n"
            "The compile.sh script is responsible for building your application using configurable\n"
            "compilers and flags.\n\n"
            "Requirements:\n"
            "  • Must use $CC for C compilation\n"
            "  • Must use $CXX for C++ compilation\n"
            "  • Must respect $CFLAGS and $CXXFLAGS environment variables\n"
            "  • Must return exit code 0 on success\n"
            "  • Must be executable from the project root directory\n\n"
            "Example:\n"
            "#!/bin/bash\n"
            "$CXX $CXXFLAGS -o program main.cpp\n\n"
            "Notes:\n"
            "The DiscoPoP framework will set the compiler variables to appropriate values\n"
            "during the instrumentation process.\n\n"
            "Per-configuration override:\n"
            "Each configuration may define its own compile.sh (via the 'compile.sh (override)'\n"
            "tab in the configuration editor). When present, it is used instead of this shared\n"
            "script for that configuration only."
        )
        self._show_help_dialog("compile.sh Help", help_text)

    def _show_execute_sh_help(self) -> None:
        help_text = (
            "Execution Script (execute.sh)\n\n"
            "Purpose:\n"
            "The execute.sh script runs your application and collects profiling data for\n"
            "analysis.\n\n"
            "Requirements:\n"
            "  • Must execute the application built by compile.sh\n"
            "  • Should pass all command-line arguments to the application\n"
            "  • Must return exit code 0 on success\n"
            "  • Must be executable from the project root directory\n\n"
            "Example:\n"
            "#!/bin/bash\n"
            "./program <args>\n\n"
            "Notes:\n"
            "The script is executed in each compilation mode (sequential, instrumented, etc.)\n"
            "to collect performance data."
        )
        self._show_help_dialog("execute.sh Help", help_text)

    def _show_seq_settings_help(self) -> None:
        help_text = (
            "Sequential Compilation Settings (seq_settings.json)\n\n"
            "Purpose:\n"
            "The seq_settings.json file contains configuration parameters for compiling\n"
            "your application in sequential mode.\n\n"
            "Contents:\n"
            "  • CC: C compiler command\n"
            "  • CXX: C++ compiler command\n"
            "  • CFLAGS: Flags for C compilation\n"
            "  • CXXFLAGS: Flags for C++ compilation\n\n"
            "Usage:\n"
            "Sequential mode provides a baseline measurement for performance comparison.\n"
            "This is the first compilation mode used to establish reference performance metrics."
        )
        self._show_help_dialog("seq_settings.json Help", help_text)

    def _show_dp_settings_help(self) -> None:
        help_text = (
            "DiscoPoP Instrumentation Settings (dp_settings.json)\n\n"
            "Purpose:\n"
            "The dp_settings.json file contains configuration parameters for compiling\n"
            "your application with full DiscoPoP instrumentation.\n\n"
            "Modifications from Sequential:\n"
            "  • CC is set to discopop_cc\n"
            "  • CXX is set to discopop_cxx\n"
            "  • Other flags are preserved from sequential settings\n\n"
            "Usage:\n"
            "This mode instruments your code to collect detailed profiling data about\n"
            "parallelization opportunities and performance characteristics."
        )
        self._show_help_dialog("dp_settings.json Help", help_text)

    def _show_hd_settings_help(self) -> None:
        help_text = (
            "Hotspot Detection Settings (hd_settings.json)\n\n"
            "Purpose:\n"
            "The hd_settings.json file contains configuration parameters for compiling\n"
            "your application with hotspot detection instrumentation.\n\n"
            "Modifications from Sequential:\n"
            "  • CC is set to discopop_hotspot_cc\n"
            "  • CXX is set to discopop_hotspot_cxx\n"
            "  • -fopenmp flag is added to CFLAGS and CXXFLAGS\n\n"
            "Usage:\n"
            "Hotspot detection performs lightweight profiling to identify performance-critical\n"
            "code regions without the overhead of full instrumentation."
        )
        self._show_help_dialog("hd_settings.json Help", help_text)

    def _show_par_settings_help(self) -> None:
        help_text = (
            "Parallel Execution Settings (par_settings.json)\n\n"
            "Purpose:\n"
            "The par_settings.json file contains configuration parameters for compiling\n"
            "your application with OpenMP parallelization.\n\n"
            "Modifications from Sequential:\n"
            "  • CC and CXX are preserved from sequential settings\n"
            "  • -fopenmp flag is added to CFLAGS and CXXFLAGS\n\n"
            "Usage:\n"
            "This mode compiles your parallelized code (as suggested by DiscoPoP analysis)\n"
            "with OpenMP support to execute on multiple processors."
        )
        self._show_help_dialog("par_settings.json Help", help_text)
