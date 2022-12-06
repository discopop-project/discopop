# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List
import tkinter as tk
from tkinter import ttk


class Console(object):
    content: List[str] = []
    progress_bar: ttk.Progressbar

    def __init__(self, parent_frame: tk.Frame):
        self.content = []
