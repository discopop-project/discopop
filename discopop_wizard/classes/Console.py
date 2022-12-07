# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import tkinter as tk
from tkinter import ttk


class Console(object):
    parent_frame: tk.Frame
    progress_bar: ttk.Progressbar
    log_screen: tk.Text

    def __init__(self, parent_frame: tk.Frame):
        self.content = []
        self.parent_frame = tk.Frame(parent_frame, bg="red")
        self.parent_frame.grid(row=1, column=1, sticky="nsew")
        self.__show_console()

    def print(self, msg: str):
        if not msg.endswith("\n"):
            msg = msg + "\n"
        self.log_screen.config(state=tk.NORMAL)
        self.log_screen.insert(tk.END, msg)
        self.log_screen.see(tk.END)
        self.log_screen.update()
        self.log_screen.config(state=tk.DISABLED)

    def clear(self):
        raise NotImplementedError("TODO")

    def start_progress(self):
        self.progress_bar.start(20)
        self.progress_bar.update()

    def stop_progress(self):
        self.progress_bar.stop()
        self.progress_bar.update()

    def __show_console(self):
        for c in self.parent_frame.winfo_children():
            c.destroy()
        # configure parent_frame
        self.parent_frame.rowconfigure(0, weight=1)
        self.parent_frame.columnconfigure(0, weight=1)
        # self.parent_frame.rowconfigure(2, weight=1)

        # create content frame and scroll bars
        self.log_screen = tk.Text(self.parent_frame, wrap=tk.NONE, height=8)
        self.log_screen.grid(row=0, column=0, sticky="nsew")
        self.log_screen.config(state=tk.DISABLED)

        # create a Scrollbar and associate it with the content frame
        y_scrollbar = ttk.Scrollbar(self.parent_frame, command=self.log_screen.yview)
        y_scrollbar.grid(row=0, column=1, sticky='nsew')
        self.log_screen['yscrollcommand'] = y_scrollbar.set
        x_scrollbar = ttk.Scrollbar(self.parent_frame, orient="horizontal", command=self.log_screen.xview)
        x_scrollbar.grid(row=1, column=0, columnspan=2, sticky='nsew')
        self.log_screen['xscrollcommand'] = x_scrollbar.set

        # create progress bar
        # self.progress_bar = ttk.Progressbar(self.parent_frame, orient=tk.HORIZONTAL, mode="determinate")
        # self.progress_bar.grid(row=2, column=0, columnspan=2, sticky="nsew")


