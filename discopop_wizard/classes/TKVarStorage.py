# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk


class TKVarStorage(object):
    # code preview settings
    toggle_var_code_preview_show_metadata_regions: tk.IntVar
    toggle_var_code_preview_show_metadata_live_device_variables: tk.IntVar
    toggle_var_code_preview_show_line_numbers: tk.IntVar
    toggle_var_code_preview_disable_compile_check: tk.IntVar

    def __init__(self, wizard):
        self.wizard = wizard
        self.toggle_var_code_preview_show_metadata_regions = tk.IntVar(
            value=self.wizard.settings.code_preview_show_metadata_regions
        )
        self.toggle_var_code_preview_show_line_numbers = tk.IntVar(
            value=self.wizard.settings.code_preview_show_line_numbers
        )
        self.toggle_var_code_preview_show_metadata_live_device_variables = tk.IntVar(
            value=self.wizard.settings.code_preview_show_metadata_live_device_variables
        )
        self.toggle_var_code_preview_disable_compile_check = tk.IntVar(
            value=self.wizard.settings.code_preview_disable_compile_check
        )

    def toggle_code_preview_setting_action(self):
        """overwrites the respective value in wizard.settings and triggers saving the new settings."""
        self.wizard.settings.code_preview_show_metadata_regions = (
            self.toggle_var_code_preview_show_metadata_regions.get()
        )
        self.wizard.settings.code_preview_show_metadata_live_device_variables = (
            self.toggle_var_code_preview_show_metadata_live_device_variables.get()
        )
        self.wizard.settings.code_preview_show_line_numbers = self.toggle_var_code_preview_show_line_numbers.get()
        self.wizard.settings.code_preview_disable_compile_check = (
            self.toggle_var_code_preview_disable_compile_check.get()
        )
        self.wizard.settings.save_to_file(self.wizard.config_dir)
        self.wizard.console.print("Saved settings.")
