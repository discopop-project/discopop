# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import tkinter as tk
from tkinter import filedialog
from tkinter import ttk

from discopop_wizard.screens.utils import create_tool_tip


def show_settings_screen(wizard):
    # clear content frame
    for c in wizard.window_frame.winfo_children():
        c.destroy()

    # build settings frame
    frame = tk.Frame(wizard.window_frame)
    frame.grid(row=1, column=1)

    # show labels
    tk.Label(frame, text="Directories:", justify=tk.RIGHT, font=wizard.style_font_bold).grid(
        row=1, column=1, sticky="ew"
    )
    tk.Label(frame, text="DiscoPoP build:", justify=tk.RIGHT, anchor="e").grid(
        row=3, column=1, sticky="ew"
    )
    tk.Label(frame, text="go/bin directory:", justify=tk.RIGHT, anchor="e").grid(
        row=4, column=1, sticky="ew"
    )

    ttk.Separator(frame, orient="horizontal").grid(row=5, column=1, sticky="ew", pady=10)
    tk.Label(frame, text="Executables:", justify=tk.RIGHT, font=wizard.style_font_bold).grid(
        row=6, column=1
    )
    tk.Label(frame, text="clang:", justify=tk.RIGHT, anchor="e").grid(row=7, column=1, sticky="ew")
    tk.Label(frame, text="clang++:", justify=tk.RIGHT, anchor="e").grid(
        row=8, column=1, sticky="ew"
    )
    tk.Label(frame, text="llvm-ar:", justify=tk.RIGHT, anchor="e").grid(
        row=9, column=1, sticky="ew"
    )
    tk.Label(frame, text="llvm-link:", justify=tk.RIGHT, anchor="e").grid(
        row=10, column=1, sticky="ew"
    )
    tk.Label(frame, text="llvm-dis:", justify=tk.RIGHT, anchor="e").grid(
        row=11, column=1, sticky="ew"
    )
    tk.Label(frame, text="llvm-opt:", justify=tk.RIGHT, anchor="e").grid(
        row=12, column=1, sticky="ew"
    )
    tk.Label(frame, text="llvm-llc:", justify=tk.RIGHT, anchor="e").grid(
        row=13, column=1, sticky="ew"
    )

    ttk.Separator(frame, orient="horizontal").grid(row=14, column=1, sticky="ew", pady=10)
    tk.Label(frame, text="Options:", justify=tk.RIGHT, font=wizard.style_font_bold).grid(
        row=15, column=1
    )
    tk.Label(frame, text="Use Docker Container for profiling:", justify=tk.RIGHT, anchor="e").grid(
        row=16, column=1, sticky="ew"
    )

    def __get_field_state():
        return tk.DISABLED if wizard.settings.use_docker_container_for_profiling else tk.NORMAL

    # show input fields
    discopop_build = tk.Entry(frame)
    discopop_build.grid(row=3, column=2, sticky="ew")
    discopop_build.insert(tk.END, wizard.settings.discopop_build_dir)
    discopop_build.config(state=__get_field_state())
    create_tool_tip(discopop_build, "Path to DiscoPoP build directory.")

    go_bin_path = tk.Entry(frame)
    go_bin_path.grid(row=4, column=2, sticky="ew")
    go_bin_path.insert(tk.END, wizard.settings.go_bin)
    go_bin_path.config(state=__get_field_state())
    create_tool_tip(go_bin_path, "Path to the bin folder inside the installation folder of Go.")

    clang = tk.Entry(frame, width=50)
    clang.grid(row=7, column=2, sticky="ew")
    clang.insert(tk.END, wizard.settings.clang)
    clang.config(state=__get_field_state())
    create_tool_tip(clang, "Path to the clang executable.")

    clangpp = tk.Entry(frame)
    clangpp.grid(row=8, column=2, sticky="ew")
    clangpp.insert(tk.END, wizard.settings.clangpp)
    clangpp.config(state=__get_field_state())
    create_tool_tip(clangpp, "Path to the clang++ executable.")

    llvm_ar = tk.Entry(frame)
    llvm_ar.grid(row=9, column=2, sticky="ew")
    llvm_ar.insert(tk.END, wizard.settings.llvm_ar)
    llvm_ar.config(state=__get_field_state())
    create_tool_tip(llvm_ar, "Path to the llvm-ar executable.")

    llvm_link = tk.Entry(frame)
    llvm_link.grid(row=10, column=2, sticky="ew")
    llvm_link.insert(tk.END, wizard.settings.llvm_link)
    llvm_link.config(state=__get_field_state())
    create_tool_tip(llvm_link, "Path to the llvm_link executable.")

    llvm_dis = tk.Entry(frame)
    llvm_dis.grid(row=11, column=2, sticky="ew")
    llvm_dis.insert(tk.END, wizard.settings.llvm_dis)
    llvm_dis.config(state=__get_field_state())
    create_tool_tip(llvm_dis, "Path to the llvm_dis executable.")

    llvm_opt = tk.Entry(frame)
    llvm_opt.grid(row=12, column=2, sticky="ew")
    llvm_opt.insert(tk.END, wizard.settings.llvm_opt)
    llvm_opt.config(state=__get_field_state())
    create_tool_tip(llvm_opt, "Path to the llvm_opt executable.")

    llvm_llc = tk.Entry(frame)
    llvm_llc.grid(row=13, column=2, sticky="ew")
    llvm_llc.insert(tk.END, wizard.settings.llvm_llc)
    llvm_llc.config(state=__get_field_state())
    create_tool_tip(llvm_llc, "Path to the llvm_llc executable.")

    use_docker_container_var = tk.IntVar(
        value=1 if wizard.settings.use_docker_container_for_profiling else 0
    )
    use_docker_container = tk.Checkbutton(frame, variable=use_docker_container_var)
    create_tool_tip(
        use_docker_container,
        "When un-checking, please save and re-open" " the settings to enable input fields!",
    )

    use_docker_container.grid(row=16, column=2)

    # show path selector buttons
    tk.Button(
        frame, text="Select", command=lambda: __overwrite_with_selection(discopop_build)
    ).grid(row=3, column=3)
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(go_bin_path)).grid(
        row=4, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(clang)).grid(
        row=7, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(clangpp)).grid(
        row=8, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(llvm_ar)).grid(
        row=9, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(llvm_link)).grid(
        row=10, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(llvm_dis)).grid(
        row=11, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(llvm_opt)).grid(
        row=12, column=3
    )
    tk.Button(frame, text="Select", command=lambda: __overwrite_with_selection(llvm_llc)).grid(
        row=13, column=3
    )

    # show save button
    tk.Button(
        frame,
        text="Save",
        command=lambda: save_settings(
            wizard,
            discopop_build,
            go_bin_path,
            clang,
            clangpp,
            llvm_ar,
            llvm_link,
            llvm_dis,
            llvm_opt,
            llvm_llc,
            use_docker_container_var,
        ),
    ).grid(row=17, column=2, pady=10)


def __overwrite_with_selection(target: tk.Entry):
    prompt_result = tk.filedialog.askdirectory()
    if len(prompt_result) != 0:
        target.delete(0, tk.END)
        target.insert(0, prompt_result)


def save_settings(
    wizard,
    discopop_build: tk.Entry,
    go_bin_path: tk.Entry,
    clang: tk.Entry,
    clangpp: tk.Entry,
    llvm_ar: tk.Entry,
    llvm_link: tk.Entry,
    llvm_dis: tk.Entry,
    llvm_opt: tk.Entry,
    llvm_llc: tk.Entry,
    use_docker_container_var,
):
    wizard.settings.discopop_build_dir = discopop_build.get()
    wizard.settings.go_bin = go_bin_path.get()
    wizard.settings.clang = clang.get()
    wizard.settings.clangpp = clangpp.get()
    wizard.settings.llvm_ar = llvm_ar.get()
    wizard.settings.llvm_link = llvm_link.get()
    wizard.settings.llvm_dis = llvm_dis.get()
    wizard.settings.llvm_opt = llvm_opt.get()
    wizard.settings.llvm_llc = llvm_llc.get()
    wizard.settings.use_docker_container_for_profiling = (
        True if use_docker_container_var.get() == 1 else False
    )

    wizard.settings.save_to_file(config_dir=wizard.config_dir)

    # return to main screen
    wizard.show_main_screen()
