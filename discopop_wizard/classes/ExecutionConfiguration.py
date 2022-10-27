import jsons
from typing import List


class ExecutionConfiguration(object):
    project_base_path: str
    project_source: str
    project_build: str
    project_configure_options: List[str]
    linker_flags: List[str] = []
    executable_name: str
    executable_arguments: List[str]
    threads: str
    label: str
    description: str
    json: str

    def get_as_widget(self):
        return self.label + " " + self.threads + " " + " ".join(self.linker_flags)

    def init_from_dict(self, loaded: dict):
        for key in loaded:
            self.__dict__[key] = loaded[key]