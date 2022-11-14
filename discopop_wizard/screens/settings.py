import pytermgui as ptg
from tkinter import filedialog
import os

from discopop_wizard.classes.Settings import Settings


def push_settings_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    if wizard.arguments.no_gui:
        # show terminal input fields
        body = (
            ptg.Window(
                "",
                "Specify paths to the following executables and directories.",
                "",
                ptg.InputField(wizard.settings.clang, prompt="clang (exe): "),
                ptg.InputField(wizard.settings.clangpp, prompt="clang++ (exe): "),
                ptg.InputField(wizard.settings.llvm_ar, prompt="llvm-ar (exe): "),
                ptg.InputField(wizard.settings.llvm_link, prompt="llvm-link (exe): "),
                ptg.InputField(wizard.settings.llvm_dis, prompt="llvm-dis (exe): "),
                ptg.InputField(wizard.settings.llvm_opt, prompt="llvm-opt (exe): "),
                ptg.InputField(wizard.settings.llvm_llc, prompt="llvm-llc (exe): "),
                ptg.InputField(wizard.settings.go_bin, prompt="go (bin directory): "),
                box="DOUBLE",
            )
            .set_title("[210 bold]DiscoPoP Settings")
        )
    else:
        # show GUI prompts
        # define selectors
        selector_1 = ptg.Button(label="clang (exe): " + wizard.settings.clang)
        selector_1.onclick = lambda *_: file_selector(selector_1, "clang (exe): ")
        selector_1.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_2 = ptg.Button(label="clang++ (exe): " + wizard.settings.clangpp)
        selector_2.onclick = lambda *_: file_selector(selector_2, "clang++ (exe): ")
        selector_2.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_3 = ptg.Button(label="llvm-ar (exe): " + wizard.settings.llvm_ar)
        selector_3.onclick = lambda *_: file_selector(selector_3, "llvm-ar (exe): ")
        selector_3.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_4 = ptg.Button(label="llvm-link (exe): " + wizard.settings.llvm_link)
        selector_4.onclick = lambda *_: file_selector(selector_4, "llvm-link (exe): ")
        selector_4.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_5 = ptg.Button(label="llvm-dis (exe): " + wizard.settings.llvm_dis)
        selector_5.onclick = lambda *_: file_selector(selector_5, "llvm-dis (exe): ")
        selector_5.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_6 = ptg.Button(label="llvm-opt (exe): " + wizard.settings.llvm_opt)
        selector_6.onclick = lambda *_: file_selector(selector_6, "llvm-opt (exe): ")
        selector_6.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_7 = ptg.Button(label="llvm-llc (exe): " + wizard.settings.llvm_llc)
        selector_7.onclick = lambda *_: file_selector(selector_7, "llvm-llc (exe): ")
        selector_7.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_8 = ptg.Button(label="go (bin directory): " + wizard.settings.go_bin)
        selector_8.onclick = lambda *_: directory_selector(selector_8, "go (bin directory): ")
        selector_8.parent_align = ptg.enums.HorizontalAlignment.LEFT
        # create assemble body
        body = (
            ptg.Window(
                "",
                "Specify paths to the following executables and directories.",
                "",
                selector_1,
                selector_2,
                selector_3,
                selector_4,
                selector_5,
                selector_6,
                selector_7,
                selector_8,
                box="DOUBLE",
            )
            .set_title("[210 bold]DiscoPoP Settings")
        )
    buttons = (ptg.Window(
        ["Save", lambda *_: save_settings(manager, body, config_dir, wizard)],
    ))
    wizard.show_body_windows(manager, [(body, 0.75), (buttons, 0.2)])


def save_settings(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard):
    values = dict()
    for widget in window:
        if isinstance(widget, ptg.InputField):
            values[widget.prompt] = widget.value
            continue

        if isinstance(widget, ptg.Button):
            key = widget.label[0 : widget.label.index(":") + 2]
            value = widget.label[widget.label.index(":") + 2 : ]
            values[key] = value
            continue

        if isinstance(widget, ptg.Container):
            label, field = iter(widget)
            values[label.value] = field.value

    if __check_values(values, wizard, manager):

        settings = Settings()
        settings.init_from_values(values)

        settings_path = os.path.join(config_dir, "SETTINGS.txt")
        # remove old config if present
        if os.path.exists(settings_path):
            os.remove(settings_path)
        # write config to file
        with open(settings_path, "w+") as f:
            f.write(settings.get_as_json_string())

        # save settings in wizard
        wizard.settings = settings

        # output to console
        wizard.print_to_console(manager, "Saved SETTINGS")
        # restart Wizard to load new execution configurations
        manager.stop()
        wizard.clear_window_stacks()
        wizard.initialize_screen(config_dir)

def __check_values(values: dict, wizard, manager) -> bool:
    """returns true, if all settings have valid values.
    Returns false and prints error message to console, if not."""
    for key in values:
        value = values[key]
        # check if all values have been set
        if len(value) == 0:
            wizard.print_to_console(manager, "Setting not specified: " + key, style=3)
            return False
    return True


def file_selector(button_obj, prompt_str):
    selected_file = filedialog.askopenfilename()
    if type(selected_file) != str:
        return
    button_obj.label = prompt_str + selected_file


def directory_selector(button_obj, prompt_str):
    selected_dir = filedialog.askdirectory()
    if type(selected_dir) != str:
        return
    button_obj.label = prompt_str + selected_dir
