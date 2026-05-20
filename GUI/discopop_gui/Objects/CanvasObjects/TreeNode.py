# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List
import tkinter as tk

from discopop_gui.Enums.ViewerMode import ViewerMode
from discopop_gui.Objects.Canvases.Viewables.Viewable import Viewable as ViewableCanvas

class TreeNode:
    def __init__(self, canvas : ViewableCanvas, oval_id : int, text_id : int):
        self._canvas = canvas
        self._oval_id : int = oval_id
        self._text_id : int = text_id
        self._children : List["TreeNode"] = []
        self._children_edges : List[int] = []
        self._total_parents : int = 0
        self._total_hide_requests : int = 0
        self._children_shown : bool = False

        self._canvas.tag_bind(self._oval_id, "<Button-1>", self._on_left_press)

    def _on_left_press(self, _ : tk.Event) -> None:
        if not (self._canvas.get_viewer_mode() == ViewerMode.MAIN):
            return
        
        if self._children_shown == False:
            self.show_children()
        else:
            self.hide_children()

        self._children_shown = not self._children_shown

    def add_child(self, child : "TreeNode", edge_id : int) -> None:
        self._children.append(child)
        self._children_edges.append(edge_id)
        child.increment_parent()

        if self._children_shown == False:
            self._canvas.itemconfigure(edge_id, state = "hidden")
            child.hide()

    def increment_parent(self) -> None:
        self._total_parents += 1

    def show(self) -> None:
        if self._children_shown == True:
            self.show_children()

        self._canvas.itemconfigure(self._oval_id, state = "normal")
        self._canvas.itemconfigure(self._text_id, state = "normal")
        self._total_hide_requests = max(self._total_hide_requests - 1, 0)

    def show_children(self) -> None:
        for i in range(len(self._children)):
            self._canvas.itemconfigure(self._children_edges[i], state = "normal")
            self._children[i].show()

    def hide(self) -> None:
        if self._total_hide_requests == self._total_parents:
            return
        
        self._total_hide_requests += 1
        
        if self._total_hide_requests == self._total_parents:
            self._canvas.itemconfigure(self._oval_id, state = "hidden")
            self._canvas.itemconfigure(self._text_id, state = "hidden")

            if self._children_shown == True:
                self.hide_children()

    def hide_children(self) -> None:
        for i in range(len(self._children)):
            self._canvas.itemconfigure(self._children_edges[i], state = "hidden")
            self._children[i].hide()