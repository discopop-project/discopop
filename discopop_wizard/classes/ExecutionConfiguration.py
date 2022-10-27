import jsons
from typing import List

from pytermgui import Collapsible, Container, Splitter, Window, Button
import pytermgui as ptg


class ExecutionConfiguration(object):
    label: str
    description: str
    executable_name: str
    executable_arguments: str
    project_base_path: str
    project_source: str
    project_build: str
    project_configure_options: str
    linker_flags: str
    threads: str
    notes: str

    def get_as_widget(self, manager: ptg.WindowManager):
        widget = Collapsible(self.label + ": " + self.description)

        details = Container(
            "Label: " + self.label,
            "Description: " + self.description,
            "Executable name: " + self.executable_name,
            "Executable arguments: " + self.executable_arguments,
            "Available threads: " + self.threads,
            "Project base path: " + self.project_base_path,
            "Project source path: " + self.project_source,
            "Project build path: " + self.project_build,
            "Project configure options: " + self.project_configure_options,
            "Project linker flags: " + self.linker_flags,
            "Additional notes: " + self.notes
        )
        widget.lazy_add(details)
        options = Container(
            Button(label="Execute", onclick=lambda *_: manager.stop()),
            ["Edit"],
            ["Delete"],
            ["Copy"],
            ["Exit", lambda *_: manager.stop()]
        )
        widget.lazy_add(options)
        return widget


    def init_from_dict(self, loaded: dict):
        for key in loaded:
            self.__dict__[key] = loaded[key]

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        self.label = values["Label: "]
        self.description = values["Description: "]
        self.executable_name = values["Executable name: "]
        self.executable_arguments = values["Executable arguments: "]
        self.threads = values["Available threads: "]
        self.project_base_path = values["Project base path: "]
        self.project_source = values["Project source path: "]
        self.project_build = values["Project build path: "]
        self.project_configure_options = values["Project configure options: "]
        self.linker_flags = values["Project linker flags: "]
        self.notes = values["Additional notes:"]

