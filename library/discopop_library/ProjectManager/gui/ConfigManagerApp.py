# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations

import os
import tkinter as tk
from tkinter import ttk
from typing import Optional
from ttkthemes import ThemedStyle  # type: ignore

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
from discopop_library.ProjectManager.utilities.initializeFiles import (
    initialize_configuration_files,
)
from discopop_library.ProjectManager.gui import widgets
from discopop_library.ProjectManager.gui.widgets import create_styled_output_console, heading_label
from discopop_library.ProjectManager.gui.mixins.helpers import (
    Tooltip,
    show_error,
    enable_text_context_menu,
)
from discopop_library.ProjectManager.gui.mixins.execute_panel import ExecutePanelMixin
from discopop_library.ProjectManager.gui.mixins.report_panel import ReportPanelMixin
from discopop_library.ProjectManager.gui.mixins.config_list import ConfigListMixin
from discopop_library.ProjectManager.gui.mixins.file_editor import FileEditorMixin
from discopop_library.ProjectManager.gui.mixins.compilation_editor import CompilationEditorMixin
from discopop_library.ProjectManager.gui.mixins.config_crud import ConfigCrudMixin
from discopop_library.ProjectManager.gui.mixins.execution import ExecutionMixin
from discopop_library.ProjectManager.gui.mixins.report import ReportMixin
from discopop_library.ProjectManager.gui.mixins.help_dialogs import HelpDialogsMixin
from discopop_library.ProjectManager.gui.mixins.wizard_launcher import WizardLauncherMixin
from discopop_library.ProjectManager.gui.mixins.explorer_integration import ExplorerIntegrationMixin
from discopop_library.ProjectManager.gui.mixins.autotuning_panel import AutotuningPanelMixin
from discopop_library.ProjectManager.gui.widgets import CATPPUCCIN_CYAN


class ConfigManagerApp(  # type: ignore
    ExecutePanelMixin,
    ReportPanelMixin,
    ConfigListMixin,
    FileEditorMixin,
    CompilationEditorMixin,
    ConfigCrudMixin,
    ExecutionMixin,
    ReportMixin,
    HelpDialogsMixin,
    WizardLauncherMixin,
    ExplorerIntegrationMixin,
    AutotuningPanelMixin,
    tk.Tk,
):
    def __init__(self, arguments: ProjectManagerArguments, was_initialized: bool = False) -> None:
        super().__init__()
        self.title("DiscoPoP Project Manager")
        self.geometry("1600x1000")
        self.minsize(1400, 800)
        self.arguments = arguments
        self.was_initialized = was_initialized

        self.config_dir = arguments.project_config_dir
        self.tooltip: Optional[Tooltip] = None

        self._setup_styles()

        # --- BOTTOM BAR: Status (pack first to keep it at bottom) ---
        bottom_frame = ttk.Frame(self, height=45)
        bottom_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=5)
        bottom_frame.pack_propagate(False)

        self.status_label = ttk.Label(bottom_frame, text="Ready", foreground=widgets.STATUS_IDLE)
        self.status_label.pack(side=tk.LEFT, padx=10, pady=5)

        # Main layout: PanedWindow with left (configs) and right (editor/execute/report)
        self.paned = tk.PanedWindow(self, orient=tk.HORIZONTAL, sashrelief=tk.RAISED)
        self.paned.pack(fill=tk.BOTH, expand=True)

        # --- LEFT PANEL: Configuration List ---
        left_frame = ttk.Frame(self.paned)
        left_frame.pack_propagate(False)
        self.paned.add(left_frame, width=280, minsize=220)

        label = heading_label(left_frame, "Run Configs", title=True)
        label.pack(side=tk.TOP, padx=5, pady=5)

        self.listbox = tk.Listbox(
            left_frame,
            selectmode=tk.SINGLE,
            selectbackground=widgets.LISTBOX_SELECT_BG,
            selectforeground=widgets.LISTBOX_SELECT_FG,
            activestyle="none",
        )
        self.listbox.pack(side=tk.TOP, fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.listbox.bind("<<ListboxSelect>>", self._on_config_selected)
        self.listbox.bind("<Button-3>", self._on_config_right_click)

        button_frame = ttk.Frame(left_frame)
        button_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=5)

        self.new_button = ttk.Button(button_frame, text="+ New", command=self._new_config)
        self.new_button.pack(side=tk.TOP, fill=tk.X, pady=2)

        self.edit_compilation_button = ttk.Button(
            button_frame, text="Edit Compilation", command=self._open_compilation_editor
        )
        self.edit_compilation_button.pack(side=tk.TOP, fill=tk.X, pady=2)

        # --- RIGHT PANEL: Tab switcher (Editor / Execute / Report) ---
        right_frame = ttk.Frame(self.paned)
        self.paned.add(right_frame, minsize=600)

        self.right_tabs = ttk.Notebook(right_frame)
        self.right_tabs.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # Editor tab
        editor_frame = ttk.Frame(self.right_tabs)
        self.right_tabs.add(editor_frame, text="Editor")
        self.editor_tab_index = self.right_tabs.index(editor_frame)

        # Execute tab
        execute_frame = ttk.Frame(self.right_tabs)
        self.right_tabs.add(execute_frame, text="Execute")
        self.execute_tab_index = self.right_tabs.index(execute_frame)

        # Report tab
        report_tab_frame = ttk.Frame(self.right_tabs)
        self.right_tabs.add(report_tab_frame, text="Report")
        self._build_report_panel(report_tab_frame)

        # Pattern Detection tab
        pattern_detection_frame = ttk.Frame(self.right_tabs)
        self.right_tabs.add(pattern_detection_frame, text="Pattern Detection")
        self.pattern_detection_tab_index = self.right_tabs.index(pattern_detection_frame)
        self._build_pattern_detection_panel(pattern_detection_frame)

        # Autotuning tab
        autotuning_frame = ttk.Frame(self.right_tabs)
        self.right_tabs.add(autotuning_frame, text="Autotuning")
        self.autotuning_tab_index = self.right_tabs.index(autotuning_frame)
        self._build_autotuning_panel(autotuning_frame)
        self._update_pattern_detection_ui()

        # Content frames for execute.sh and the optional per-configuration compile.sh override
        self.text_areas: dict[str, tk.Text] = {}
        self.modified_files: dict[str, bool] = {}

        # Bottom bar with buttons — packed before the notebook so it always reserves its natural height
        bottom_editor_frame = ttk.Frame(editor_frame)
        bottom_editor_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=2)

        # Buttons on the left side
        self.save_button = ttk.Button(bottom_editor_frame, text="Save (Ctrl+S)", command=self._save_config)
        self.save_button.pack(side=tk.LEFT, padx=5)

        self.editor_notebook = ttk.Notebook(editor_frame)
        self.editor_notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # --- execute.sh tab ---
        execute_sh_frame = ttk.Frame(self.editor_notebook)
        self.editor_notebook.add(execute_sh_frame, text="execute.sh")

        execute_header_frame = ttk.Frame(execute_sh_frame)
        execute_header_frame.pack(fill=tk.X, padx=5, pady=5)

        execute_help_label = heading_label(execute_header_frame, "Execution script")
        execute_help_label.pack(side=tk.LEFT)

        execute_help_button = ttk.Button(execute_header_frame, text="Help", command=self._show_execute_sh_help)
        execute_help_button.pack(side=tk.RIGHT, padx=5)

        execute_text_frame = ttk.Frame(execute_sh_frame)
        execute_text_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        execute_scrollbar = ttk.Scrollbar(execute_text_frame)
        execute_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        execute_text_area = widgets.create_script_editor(execute_text_frame, yscrollcommand=execute_scrollbar.set)
        execute_text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        execute_scrollbar.config(command=execute_text_area.yview)
        enable_text_context_menu(execute_text_area)

        self.text_areas["execute.sh"] = execute_text_area
        self.modified_files["execute.sh"] = False

        # --- compile.sh override tab ---
        compile_sh_frame = ttk.Frame(self.editor_notebook)
        self.editor_notebook.add(compile_sh_frame, text="compile.sh (override)")

        compile_header_frame = ttk.Frame(compile_sh_frame)
        compile_header_frame.pack(fill=tk.X, padx=5, pady=5)

        compile_help_label = heading_label(compile_header_frame, "Compilation script override")
        compile_help_label.pack(side=tk.LEFT)

        compile_help_button = ttk.Button(compile_header_frame, text="Help", command=self._show_compile_sh_help)
        compile_help_button.pack(side=tk.RIGHT, padx=5)

        self.compile_override_button = ttk.Button(
            compile_header_frame, text="Add Override", command=self._toggle_compile_override
        )
        self.compile_override_button.pack(side=tk.RIGHT, padx=5)

        compile_text_frame = ttk.Frame(compile_sh_frame)
        compile_text_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        compile_scrollbar = ttk.Scrollbar(compile_text_frame)
        compile_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        compile_text_area = widgets.create_script_editor(compile_text_frame, yscrollcommand=compile_scrollbar.set)
        compile_text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        compile_scrollbar.config(command=compile_text_area.yview)
        enable_text_context_menu(compile_text_area)

        self.text_areas["compile.sh"] = compile_text_area
        self.modified_files["compile.sh"] = False

        self.editor_sub_tab_index = {
            "execute.sh": self.editor_notebook.index(execute_sh_frame),
            "compile.sh": self.editor_notebook.index(compile_sh_frame),
        }
        self.editor_sub_tab_labels = {
            "execute.sh": "execute.sh",
            "compile.sh": "compile.sh (override)",
        }

        # Build execute panel
        self._build_execute_panel(execute_frame)

        self.current_config: Optional[str] = None
        self.compilation_editor_open = False
        self.compilation_text_areas: dict[str, tk.Text] = {}
        self.compilation_modified_files: dict[str, bool] = {}
        self.compilation_notebook: Optional[ttk.Notebook] = None
        self.compilation_tabs: dict[str, int] = {}
        self.compilation_tab_tooltips: dict[int, tuple[str, Tooltip]] = {}
        self.compilation_tooltip_timer: Optional[str] = None
        self.current_tooltip_tab: Optional[int] = None
        self.derive_button_tooltip: Optional[Tooltip] = None
        self.derive_button_tooltip_timer: Optional[str] = None
        self.bind("<Control-s>", lambda event: self._handle_save_shortcut())
        self._refresh_config_list()
        self.after(100, self._maybe_open_wizard)
        self._start_modification_polling()

    def _setup_styles(self) -> None:
        """Single location for all shared ttk styles.

        Named button styles and the Treeview / Notebook tab styling all live
        here so components of the same type look identical wherever they are
        built (the Treeview and TNotebook.Tab styling used to be configured
        ad hoc from report_panel.py and compilation_editor.py).
        """
        style = ThemedStyle(self, theme="scidblue")

        style.configure(
            "TCombobox",
            fieldbackground="white",
            borderwidth=1,
            relief="solid",
            padding=2,
        )

        style.map(
            "TCombobox",
            fieldbackground=[("readonly", "#f0f0f0"), ("active", "white")],
            bordercolor=[("focus", CATPPUCCIN_CYAN)],
        )

        # Semantic button styles
        style.configure(widgets.STYLE_PRIMARY_BUTTON, font=(widgets.FONT_FAMILY, 11, "bold"))
        style.configure(widgets.STYLE_DANGER_BUTTON, foreground=widgets.STATUS_FAIL)
        style.map(widgets.STYLE_DANGER_BUTTON, foreground=[("disabled", widgets.STATUS_IDLE)])
        style.configure(widgets.STYLE_SUCCESS_BUTTON, foreground=widgets.APPLIED_FG)
        style.configure(widgets.STYLE_ICON_BUTTON, relief="flat", borderwidth=0, padding=0)

        # Notebook tabs (previously configured globally from compilation_editor.py,
        # which made the styling order-dependent).
        style.configure("TNotebook.Tab", padding=[10, 2], font=widgets.FONT_BODY)

        # Report Treeview (previously configured ad hoc in report_panel.py).
        style.configure(
            "Treeview",
            rowheight=40,
            font=(widgets.FONT_FAMILY, 10),
            fieldbackground=widgets.TREE_BG,
            background=widgets.TREE_BG,
            padding=2,
            bordercolor=widgets.TREE_BORDER,
        )
        style.configure(
            "Treeview.Heading",
            font=(widgets.FONT_FAMILY, 10, "bold"),
            borderwidth=1,
            relief="solid",
        )
        style.map("Treeview.Heading", background=[("", widgets.TREE_HEADING_BG)])
        style.map("Treeview", fieldbackground=[("", widgets.TREE_BG)])


def run_gui(arguments: ProjectManagerArguments) -> None:
    was_initialized = False
    if not os.path.exists(arguments.project_config_dir):
        try:
            from discopop_library.ProjectManager.utilities.initializeDirectories import initialize_directories

            initialize_directories(arguments)
            initialize_configuration_files(arguments)
            was_initialized = True
        except Exception as e:
            root = tk.Tk()
            root.withdraw()
            show_error(
                root,
                "Initialization Error",
                f"Failed to initialize project configuration:\n{e}",
            )
            root.destroy()
            return

    app = ConfigManagerApp(arguments, was_initialized=was_initialized)
    app.mainloop()
