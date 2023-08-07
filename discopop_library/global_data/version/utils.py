import os.path
from pathlib import Path


def get_version() -> str:
    parent_folder_path = Path(__file__).parent.absolute()
    with open(os.path.join(parent_folder_path, "VERSION")) as f:
        return f.read().rstrip()
