import pytermgui as ptg
from tkinter import filedialog
import os

def push_settings_screen(manager: ptg.WindowManager, config_dir: str, wizard):
    if wizard.arguments.no_gui:
        # show terminal input fields
        body = (
            ptg.Window(
                "",
                "Specify paths to the following executables and directories.",
                "",
                ptg.InputField("text", prompt="clang (exe): "),
                ptg.InputField("text", prompt="clang++ (exe): "),
                ptg.InputField("text", prompt="llvm-ar (exe): "),
                ptg.InputField("text", prompt="llvm-link (exe): "),
                ptg.InputField("text", prompt="llvm-dis (exe): "),
                ptg.InputField("text", prompt="llvm-opt (exe): "),
                ptg.InputField("text", prompt="llvm-llc (exe): "),
                ptg.InputField("text", prompt="go (bin directory): "),
                box="DOUBLE",
            )
            .set_title("[210 bold]Settings")
        )
    else:
        # show GUI prompts
        # define selectors
        selector_1 = ptg.Button(label="clang (exe): select")
        selector_1.onclick = lambda *_: file_selector(selector_1, "clang (exe): ")
        selector_1.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_2 = ptg.Button(label="clang++ (exe): ")
        selector_2.onclick = lambda *_: file_selector(selector_2, "clang++ (exe): ")
        selector_2.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_3 = ptg.Button(label="llvm-ar (exe): ")
        selector_3.onclick = lambda *_: file_selector(selector_3, "llvm-ar (exe): ")
        selector_3.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_4 = ptg.Button(label="llvm-link (exe): ")
        selector_4.onclick = lambda *_: file_selector(selector_4, "llvm-link (exe): ")
        selector_4.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_5 = ptg.Button(label="llvm-dis (exe): ")
        selector_5.onclick = lambda *_: file_selector(selector_5, "llvm-dis (exe): ")
        selector_5.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_6 = ptg.Button(label="llvm-opt (exe): ")
        selector_6.onclick = lambda *_: file_selector(selector_6, "llvm-opt (exe): ")
        selector_6.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_7 = ptg.Button(label="llvm-llc (exe): ")
        selector_7.onclick = lambda *_: file_selector(selector_7, "llvm-llc (exe): ")
        selector_7.parent_align = ptg.enums.HorizontalAlignment.LEFT
        selector_8 = ptg.Button(label="go (bin directory): ")
        selector_8.onclick = lambda *_: file_selector(selector_8, "go (bin directory): ")
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
            .set_title("[210 bold]Settings")
        )

    dp_options = (ptg.Window(
        "Enable debug output",
        ptg.Checkbox(),
        "",
        "Enable hybrid dependency profiling",
        ptg.Checkbox()
    )
                  .set_title("DiscoPoP Options")
                  )
    buttons = (ptg.Window(
        ["Save", lambda *_: save_settings(manager, body, config_dir, wizard)],
    ))
    wizard.show_body_windows(manager, [(body, 0.6), (dp_options, 0.15), (buttons, 0.2)])


def save_settings(manager: ptg.WindowManager, window: ptg.Window, config_dir: str, wizard):
    # TODO
    values = dict()
    values["ID"] = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
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
    new_config = ExecutionConfiguration()
    new_config.init_from_values(values)

    config_path = os.path.join(config_dir, "execution_configurations", new_config.id + "_" + new_config.label + ".sh")
    # remove old config if present
    if os.path.exists(config_path):
        os.remove(config_path)
    # write config to file
    with open(config_path, "w+") as f:
        f.write(new_config.get_as_executable_script())

    # output to console
    wizard.print_to_console(manager, "Created configuration " + values["ID"])
    # restart Wizard to load new execution configurations
    manager.stop()
    wizard.clear_window_stacks()
    wizard.initialize_screen(config_dir)


def file_selector(button_obj, prompt_str):
    selected_file = filedialog.askopenfile()
    if type(selected_file) != str:
        return
    button_obj.label = prompt_str + selected_file


def directory_selector(button_obj, prompt_str):
    selected_dir = filedialog.askdirectory()
    if type(selected_dir) != str:
        return
    button_obj.label = prompt_str + selected_dir
