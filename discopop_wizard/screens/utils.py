import pytermgui as ptg
import sys


def submit(manager: ptg.WindowManager, window: ptg.Window, values: dict) -> None:
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value
    manager.stop()


def exit_program(manager: ptg.WindowManager) -> None:
    manager.stop()
