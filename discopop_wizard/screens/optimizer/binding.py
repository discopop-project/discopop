# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import tkinter as tk

from discopop_library.PathManagement.PathManagement import get_path
from discopop_library.discopop_optimizer.__main__ import start_optimizer


def create_optimizer_screen(wizard, parent_frame, execution_configuration):
    # close elements on optimizer_frame
    for c in parent_frame.winfo_children():
        c.destroy()

    canvas = tk.Canvas(parent_frame)
    canvas.pack(fill=tk.BOTH)

    arguments = dict()

    def overwrite_with_file_selection(target: tk.Entry):
        prompt_result = tk.filedialog.askopenfilename()
        if len(prompt_result) != 0:
            target.delete(0, tk.END)
            target.insert(0, prompt_result)

    ###
    tk.Label(
        canvas,
        text="Compile_command",
        justify=tk.RIGHT,
        anchor="e",
        font=wizard.style_font_bold_small,
    ).grid(row=1, column=0, sticky="ew")
    compile_command = tk.Entry(canvas, width=100)
    compile_command.insert(tk.END, "make")
    compile_command.grid(row=1, column=1, sticky="ew")
    ###
    tk.Label(
        canvas,
        text="DoAll microbench file",
        justify=tk.RIGHT,
        anchor="e",
        font=wizard.style_font_bold_small,
    ).grid(row=2, column=0, sticky="ew")
    doall_microbench_file = tk.Entry(canvas, width=100)
    doall_microbench_file.insert(tk.END, "None")
    doall_microbench_file.grid(row=2, column=1, sticky="ew")

    doall_microbench_file_path_selector = tk.Button(
        canvas, text="Select", command=lambda: overwrite_with_file_selection(doall_microbench_file)
    )
    doall_microbench_file_path_selector.grid(row=2, column=3)
    ###
    tk.Label(
        canvas,
        text="Reduction microbench file",
        justify=tk.RIGHT,
        anchor="e",
        font=wizard.style_font_bold_small,
    ).grid(row=3, column=0, sticky="ew")
    reduction_microbench_file = tk.Entry(canvas, width=100)
    reduction_microbench_file.insert(tk.END, "None")
    reduction_microbench_file.grid(row=3, column=1, sticky="ew")

    reduction_microbench_file_path_selector = tk.Button(
        canvas,
        text="Select",
        command=lambda: overwrite_with_file_selection(reduction_microbench_file),
    )
    reduction_microbench_file_path_selector.grid(row=3, column=3)
    ###
    tk.Label(
        canvas,
        text="Exhaustive search",
        justify=tk.RIGHT,
        anchor="e",
        font=wizard.style_font_bold_small,
    ).grid(row=4, column=0, sticky="ew")
    exhaustive_search = tk.IntVar(canvas)
    exhaustive_search.set(1)
    cb = tk.Checkbutton(canvas, onvalue=1, offvalue=0)
    cb.grid(row=4, column=1)

    start_button = tk.Button(
        canvas,
        text="Start Optimizer for " + execution_configuration.value_dict["label"],
        command=lambda: __start_optimizer(
            execution_configuration,
            compile_command,
            doall_microbench_file,
            reduction_microbench_file,
            exhaustive_search,
            parent_frame,
        ),
    )
    start_button.grid(row=5, column=0)

    print("CREATING OPTIMIZER SCREEN")


def __start_optimizer(
    execution_configuration,
    compile_command,
    doall_microbench_file,
    reduction_microbench_file,
    exhaustive_search,
    parent_frame,
):
    arguments = {
        "--project": execution_configuration.value_dict["project_path"],
        "--detection-result-dump": get_path(
            execution_configuration.value_dict["working_copy_path"], "detection_result_dump.json"
        ),
        "--execute-created-models": False,
        "--clean-created-code": False,
        "--code-export-path": get_path(
            execution_configuration.value_dict["project_path"], ".discopop_optimizer/code_exports"
        ),
        "--dp-output-path": execution_configuration.value_dict["working_copy_path"],
        "--file-mapping": get_path(
            execution_configuration.value_dict["working_copy_path"], "FileMapping.txt"
        ),
        "--executable-arguments": execution_configuration.value_dict["executable_arguments"],
        "--executable-name": execution_configuration.value_dict["executable_name"],
        "--linker-flags": execution_configuration.value_dict["linker_flags"],
        "--make-target": execution_configuration.value_dict["make_target"],
        "--make-flags": execution_configuration.value_dict["make_flags"],
        "--execution-repetitions": 1,
        "--execute-single-model": False,
        "--compile-command": compile_command.get(),
        "--execution-append-measurements": False,
        "--exhaustive-search": True if exhaustive_search.get() == 1 else False,
        "--headless-mode": False,
        "--doall-microbench-file": doall_microbench_file.get(),
        "--reduction-microbench-file": reduction_microbench_file.get(),
        "--dp-optimizer-path": get_path(
            execution_configuration.value_dict["project_path"], ".discopop_optimizer"
        ),
    }

    # close elements on optimizer_frame
    for c in parent_frame.winfo_children():
        c.destroy()

    start_optimizer(arguments, parent_frame=parent_frame)
