# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from tkinter import ttk, scrolledtext
from typing import Any, Optional, Dict

from discopop_library.ProjectManager.ProjectManagerArguments import ProjectManagerArguments
from discopop_library.ProjectManager.gui.mixins.helpers import Tooltip


class ConfigManagerMixinBase:
    """Base class declaring the interface expected by all ConfigManagerApp mixins."""

    # Core attributes
    arguments: ProjectManagerArguments
    config_dir: str
    current_config: Optional[str]
    was_initialized: bool

    # UI elements - main layout
    paned: tk.PanedWindow
    status_label: tk.Label
    tooltip: Optional[Tooltip]
    right_tabs: ttk.Notebook
    editor_tab_index: int

    # Left panel - configuration list
    listbox: tk.Listbox
    new_button: tk.Button
    edit_compilation_button: tk.Button

    # Editor tab
    text_areas: Dict[str, tk.Text]
    modified_files: Dict[str, bool]
    save_button: tk.Button

    # Pattern Detection tab
    pattern_detection_tab_index: int

    # Execute panel elements
    mode_vars: Dict[str, tk.BooleanVar]
    mode_checkbuttons: Dict[str, tk.Checkbutton]
    mode_tooltip_timers: Dict[str, str]
    thread_var: tk.IntVar
    label_prefix_var: tk.StringVar
    timeout_execution_var: tk.IntVar
    timeout_compilation_var: tk.IntVar
    log_level_var: tk.StringVar
    inplace_var: tk.BooleanVar
    skip_cleanup_var: tk.BooleanVar
    run_button: tk.Button
    output_text: scrolledtext.ScrolledText
    generate_report_button: tk.Button

    # Report panel elements
    results_tree: ttk.Treeview
    view_report_button: tk.Button

    # Compilation editor
    compilation_editor_open: bool
    compilation_text_areas: Dict[str, tk.Text]
    compilation_modified_files: Dict[str, bool]
    compilation_notebook: Optional[ttk.Notebook]
    compilation_tabs: Dict[str, int]
    compilation_tab_tooltips: Dict[int, tuple[str, Tooltip]]
    compilation_tooltip_timer: Optional[str]
    current_tooltip_tab: Optional[int]
    test_compilation_button: tk.Button
    derive_compilation_button: tk.Button
    derive_button_tooltip: Optional[Tooltip]
    derive_button_tooltip_timer: Optional[str]

    # Pattern Detection panel elements
    explorer_output_text: Optional[scrolledtext.ScrolledText]
    explorer_run_button: Optional[tk.Button]
    browse_suggestions_button: Optional[tk.Button]
    explorer_running: bool
    pattern_types_vars: Optional[Dict[str, tk.BooleanVar]]
    jobs_var: Optional[tk.StringVar]

    # Apply Suggestions (Execute tab)
    suggestions_mode_var: tk.StringVar
    suggestions_count_label: tk.Label
    autotuner_suggestions_info_label: tk.Label

    # Autotuning panel elements
    autotuning_output_text: Optional[scrolledtext.ScrolledText]
    autotuning_run_button: Optional[tk.Button]
    autotuning_config_label: Optional[tk.Label]
    autotuning_running: bool
    autotuning_threads_var: Optional[tk.StringVar]
    autotuning_hotspot_types_vars: Optional[Dict[str, tk.BooleanVar]]
    autotuning_algorithm_var: Optional[tk.StringVar]
    autotuning_log_level_var: Optional[tk.StringVar]
    autotuning_suggestions_label: Optional[tk.Label]
    autotuning_tab_index: int

    # Methods that mixins call on each other
    # Note: Methods from tk.Tk (after, after_cancel, bind, wait_window, update_idletasks)
    # are inherited at runtime and should not be defined here as stubs - they would
    # shadow the real implementations due to MRO

    def _load_config(self) -> None:
        """Load configuration from disk."""
        ...

    def _save_config(self) -> None:
        """Save configuration to disk."""
        ...

    def _refresh_config_list(self) -> None:
        """Refresh the configuration list display."""
        ...

    def _on_config_selected(self, event: Any) -> None:
        """Handle configuration selection."""
        ...

    def _update_execute_modes(self) -> None:
        """Update execution mode availability."""
        ...

    def _build_execute_panel(self, parent: tk.Frame) -> None:
        """Build the execute panel UI."""
        ...

    def _build_report_panel(self, parent: tk.Frame) -> None:
        """Build the report panel UI."""
        ...

    def _update_report_display(self) -> None:
        """Update the report display."""
        ...

    def _validate_execution_inputs(self) -> bool:
        """Validate execution input fields."""
        return True

    def _run_execution(self) -> None:
        """Run the execution."""
        ...

    def _open_compilation_editor(self) -> None:
        """Open the compilation editor."""
        ...

    def _update_derive_button_state(self) -> None:
        """Update the derive button state."""
        ...

    def _new_config(self) -> None:
        """Create a new configuration."""
        ...

    def _copy_config(self) -> None:
        """Copy a configuration."""
        ...

    def _rename_config(self) -> None:
        """Rename a configuration."""
        ...

    def _delete_config(self) -> None:
        """Delete a configuration."""
        ...

    def _generate_report(self) -> None:
        """Generate a report."""
        ...

    def _view_report(self) -> None:
        """View the report."""
        ...

    def _reset_execution_results(self) -> None:
        """Reset execution results."""
        ...

    def _reset_project_data(self) -> None:
        """Reset project data."""
        ...

    def _maybe_open_wizard(self) -> None:
        """Maybe open the configuration wizard."""
        ...

    def _handle_save_shortcut(self) -> None:
        """Handle save shortcut."""
        ...

    def _start_modification_polling(self) -> None:
        """Start polling for file modifications."""
        ...

    def _check_modification(self, filename: str) -> None:
        """Check if a file has been modified."""
        ...

    def _check_compilation_modification(self, filename: str) -> None:
        """Check if a compilation file has been modified."""
        ...

    def _save_compilation_files(self) -> None:
        """Save compilation files."""
        ...

    def _get_help_command(self, filename: str) -> Optional[Any]:
        """Get the help command for a file."""
        ...

    def _format_json_content(self, content: str) -> str:
        """Format JSON content."""
        return ""

    def _run_test_compilation(self) -> None:
        """Run a test compilation."""
        ...

    def _on_config_right_click(self, event: Any) -> None:
        """Handle right-click on configuration."""
        ...

    def _build_pattern_detection_panel(self, parent: tk.Frame) -> None:
        """Build the pattern detection panel UI."""
        ...

    def _update_pattern_detection_ui(self) -> None:
        """Update the pattern detection UI based on prerequisites."""
        ...

    def _run_pattern_detection(self) -> None:
        """Run the pattern detection."""
        ...

    def _update_pattern_detection_tab_state(self, enabled: bool) -> None:
        """Update the pattern detection tab enabled/disabled state."""
        ...

    def _open_suggestion_browser(self) -> None:
        """Open the suggestion browser dialog."""
        ...

    def _refresh_suggestion_selection_display(self) -> None:
        """Refresh the suggestion selection count label in the Execute tab."""
        ...

    def _build_autotuning_panel(self, parent: tk.Frame) -> None:
        """Build the autotuning panel UI."""
        ...

    def _update_autotuning_ui(self) -> None:
        """Update the autotuning UI based on suggestion availability."""
        ...

    def _refresh_autotuning_suggestions_display(self) -> None:
        """Refresh the selected suggestions display in the autotuning panel."""
        ...

    def _update_autotuning_config_display(self) -> None:
        """Update the configuration display label in the autotuning panel."""
        ...
