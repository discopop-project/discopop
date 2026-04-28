# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import tkinter as tk
from typing import Any

class Viewable(tk.Canvas):
    def __init__(self, parent: tk.Misc, *args: Any, **kwargs: Any) -> None:
        super().__init__(parent, *args, **kwargs)

        self.original_coordinates: dict[int, tuple[float, ...]] = {}

        self.drag_start_x: float | None = None
        self.drag_start_y: float | None = None
        self.drag_rectangle_id: int | None = None
        self.drag_button: int | None = None

        self.bind("<ButtonPress-1>", self._left_press)
        self.bind("<B1-Motion>", self._left_drag)
        self.bind("<ButtonRelease-1>", self._left_release)

        self.bind("<ButtonPress-3>", self._right_press)
        self.bind("<B3-Motion>", self._right_drag)
        self.bind("<ButtonRelease-3>", self._right_release)

    def _left_press(self, event: tk.Event) -> None:
        self._start_drag(event, button=1)

    def _left_drag(self, event: tk.Event) -> None:
        self._update_drag_rectangle(event, outline="blue")

    def _left_release(self, event: tk.Event) -> None:
        self._finish_drag(event, button=1)

    def _right_press(self, event: tk.Event) -> None:
        self._start_drag(event, button=3)

    def _right_drag(self, event: tk.Event) -> None:
        self._update_drag_rectangle(event, outline="red")

    def _right_release(self, event: tk.Event) -> None:
        self._finish_drag(event, button=3)

    def _start_drag(self, event: tk.Event, button: int) -> None:
        self.drag_start_x = self.canvasx(event.x)
        self.drag_start_y = self.canvasy(event.y)
        assert self.drag_start_x is not None
        assert self.drag_start_y is not None
        self.drag_button = button

        if self.drag_rectangle_id is not None:
            super().delete(self.drag_rectangle_id)

        self.drag_rectangle_id = super().create_rectangle(
            self.drag_start_x,
            self.drag_start_y,
            self.drag_start_x,
            self.drag_start_y,
            outline="blue" if button == 1 else "red",
            dash=(4, 2),
        )

    def _update_drag_rectangle(self, event: tk.Event, outline: str) -> None:
        if (
            self.drag_start_x is None
            or self.drag_start_y is None
            or self.drag_rectangle_id is None
        ):
            return

        current_x = self.canvasx(event.x)
        current_y = self.canvasy(event.y)

        self.itemconfig(self.drag_rectangle_id, outline=outline)
        self.coords(
            self.drag_rectangle_id,
            self.drag_start_x,
            self.drag_start_y,
            current_x,
            current_y,
        )

    def _finish_drag(self, event: tk.Event, button: int) -> None:
        if (
            self.drag_start_x is None
            or self.drag_start_y is None
            or self.drag_rectangle_id is None
        ):
            self._reset_drag_state()
            return

        end_x = self.canvasx(event.x)
        end_y = self.canvasy(event.y)

        x1 = min(self.drag_start_x, end_x)
        y1 = min(self.drag_start_y, end_y)
        x2 = max(self.drag_start_x, end_x)
        y2 = max(self.drag_start_y, end_y)

        if x2 - x1 > 5 and y2 - y1 > 5:
            if button == 1:
                self._left_drag_area_selected(x1, y1, x2, y2)
            elif button == 3:
                self._right_drag_area_selected(x1, y1, x2, y2)

        super().delete(self.drag_rectangle_id)
        self._reset_drag_state()

    def _reset_drag_state(self) -> None:
        self.drag_start_x = None
        self.drag_start_y = None
        self.drag_rectangle_id = None
        self.drag_button = None

    def _left_drag_area_selected(
        self,
        x1: float,
        y1: float,
        x2: float,
        y2: float,
    ) -> None:
        self._zoom_in(x1, y1, x2, y2)

    def _zoom_in(
        self,
        x1: float,
        y1: float,
        x2: float,
        y2: float,
    ) -> None:
        canvas_width = self.winfo_width()
        canvas_height = self.winfo_height()

        if canvas_width <= 1:
            canvas_width = int(self.cget("width"))

        if canvas_height <= 1:
            canvas_height = int(self.cget("height"))

        selected_width = x2 - x1
        selected_height = y2 - y1

        if selected_width <= 0 or selected_height <= 0:
            return

        center_x = (x1 + x2) / 2
        center_y = (y1 + y2) / 2

        canvas_ratio = canvas_width / canvas_height
        selected_ratio = selected_width / selected_height
        scale_factor = 1

        if selected_ratio > canvas_ratio:
            scale_factor = canvas_width / selected_width
        else:
            scale_factor = canvas_height / selected_height

        self.scale("all", center_x, center_y, scale_factor, scale_factor)
        dx = (canvas_width / 2) - center_x
        dy = (canvas_height / 2) - center_y

        self.move("all", dx, dy)

    def _right_drag_area_selected(
        self,
        x1: float,
        y1: float,
        x2: float,
        y2: float,
    ) -> None:
        print(f"Right-drag area selected: {x1}, {y1}, {x2}, {y2}")

    def _store_original_coordinates(self, item_id: int) -> None:
        self.original_coordinates[item_id] = tuple(self.coords(item_id))

    def create_oval(self, *args: Any, **kwargs: Any) -> int:
        item_id = super().create_oval(*args, **kwargs)
        self._store_original_coordinates(item_id)
        return item_id

    def create_line(self, *args: Any, **kwargs: Any) -> int:
        item_id = super().create_line(*args, **kwargs)
        self._store_original_coordinates(item_id)
        return item_id

    def create_text(self, *args: Any, **kwargs: Any) -> int:
        item_id = super().create_text(*args, **kwargs)
        self._store_original_coordinates(item_id)
        return item_id

    def create_rectangle(self, *args: Any, **kwargs: Any) -> int:
        item_id = super().create_rectangle(*args, **kwargs)
        self._store_original_coordinates(item_id)
        return item_id

    def create_polygon(self, *args: Any, **kwargs: Any) -> int:
        item_id = super().create_polygon(*args, **kwargs)
        self._store_original_coordinates(item_id)
        return item_id

    def delete(self, *args: Any) -> None:
        if "all" in args:
            self.original_coordinates.clear()
        else:
            for item in args:
                if isinstance(item, int):
                    self.original_coordinates.pop(item, None)

        super().delete(*args)