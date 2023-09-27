# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os
import pickle
import tkinter as tk
from tkinter import Button
from typing import List, Optional, cast

import jsonpickle  # type: ignore
import jsons  # type: ignore

from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.bindings.CodeGenerator import export_code
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot
from discopop_library.discopop_optimizer.gui.presentation.OptionTable import (
    show_options,
    add_random_models,
)
from discopop_library.discopop_optimizer.gui.widgets.ScrollableFrame import ScrollableFrameWidget
from discopop_library.discopop_optimizer.utilities.MOGUtilities import data_at


def show_function_models(
    experiment: Experiment,
    parent_frame: tk.Frame,
    destroy_window_after_execution: bool,
    show_functions: Optional[List[FunctionRoot]] = None,
):
    considered_functions = show_functions if show_functions is not None else experiment.function_models
    # show function selection dialogue
    parent_frame.rowconfigure(0, weight=1)
    parent_frame.rowconfigure(1, weight=1)
    parent_frame.columnconfigure(1, weight=1)
    parent_frame.columnconfigure(0, weight=1)

    scrollable_frame_widget = ScrollableFrameWidget(parent_frame)
    scrollable_frame = scrollable_frame_widget.get_scrollable_frame()

    spawned_windows: List[tk.Toplevel] = []

    # populate scrollable frame
    for idx, function in enumerate(considered_functions):
        function_button = Button(
            scrollable_frame,
            text=function.name,
            command=lambda func=function: show_options(  # type: ignore
                # random options might be added by show_options
                experiment.detection_result.pet,
                experiment.optimization_graph,
                experiment,
                experiment.function_models[func],
                experiment.sorted_free_symbols,
                experiment.free_symbol_ranges,
                experiment.free_symbol_distributions,
                func,
                parent_frame,
                spawned_windows,
                window_title="Function: " + func.name,
            ),
        )
        function_button.grid(row=idx, column=0)

    # finalize scrollable frame
    scrollable_frame_widget.finalize(row_count=len(considered_functions), row=0, col=0)

    def __on_press():
        for w in spawned_windows:
            try:
                w.destroy()
            except tk.TclError:
                pass
        if destroy_window_after_execution:
            for c in parent_frame.winfo_children():
                c.destroy()
            parent_frame.winfo_toplevel().destroy()
        else:
            parent_frame.quit()

    # add exit button
    exit_button = Button(parent_frame, text="Exit", command=lambda: __on_press())  # type: ignore
    exit_button.grid(row=1, column=0)

    parent_frame.mainloop()


def perform_headless_execution(
    experiment: Experiment,
):
    print("Headless execution...")
    for function in experiment.function_models:
        print("\t", function.name)
        # generate random models
        updated_options = add_random_models(
            None,
            experiment.detection_result.pet,
            experiment.optimization_graph,
            experiment,
            experiment.function_models[function],
            experiment.sorted_free_symbols,
            experiment.free_symbol_ranges,
            experiment.free_symbol_distributions,
            function,
            None,
            [],
            show_results=False,
        )

        # save models
        experiment.function_models[function] = updated_options
        # export models to code
        for opt, ctx, label in experiment.function_models[function]:
            export_code(
                experiment.detection_result.pet,
                experiment.optimization_graph,
                experiment,
                opt,
                ctx,
                label,
                function,
            )


def export_to_json(experiment: Experiment):
    # convert functionRoot in function_models to node ids
    to_be_added = []
    to_be_deleted = []
    for old_key in experiment.function_models:
        new_key = old_key.node_id
        to_be_added.append((new_key, experiment.function_models[old_key]))
        to_be_deleted.append(old_key)

    for k1 in to_be_deleted:
        del experiment.function_models[k1]
    for k2, v in to_be_added:
        experiment.function_models[k2] = v  # type: ignore

    experiment_dump_path: str = os.path.join(experiment.discopop_optimizer_path, "last_experiment.pickle")
    if not os.path.exists(experiment.discopop_optimizer_path):
        os.makedirs(experiment.discopop_optimizer_path)
    pickle.dump(experiment, open(experiment_dump_path, "wb"))


def restore_session(json_file: str) -> Experiment:
    experiment: Experiment = pickle.load(open(json_file, "rb"))

    # convert keys of function_models to FunctionRoot objects
    to_be_added = []
    to_be_deleted = []
    for old_key in experiment.function_models:
        new_key = cast(FunctionRoot, data_at(experiment.optimization_graph, cast(int, old_key)))
        to_be_added.append((new_key, experiment.function_models[old_key]))
        to_be_deleted.append(old_key)

    for k, v in to_be_added:
        experiment.function_models[k] = v
    for k in to_be_deleted:
        del experiment.function_models[k]

    return experiment
