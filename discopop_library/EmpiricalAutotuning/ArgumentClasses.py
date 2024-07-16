from dataclasses import dataclass
from discopop_library.ArgumentClasses.GeneralArguments import GeneralArguments


@dataclass
class AutotunerArguments(GeneralArguments):
    """Container Class for the arguments passed to the discopop autotuner"""

    def __post_init__(self) -> None:
        self.__validate()

    def __validate(self) -> None:
        """Validate the arguments passed to the discopop autotuner, e.g check if given files exist"""
        pass