import os.path
from typing import Dict


def load_file_mapping(fmap_path: str) -> Dict[int, str]:
    if not os.path.exists(fmap_path):
        raise ValueError("Path does not exist! ", fmap_path)

    file_mapping: Dict[int, str] = dict()

    with open(fmap_path, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_id = int(split_line[0])
            file_path = split_line[1]
            file_mapping[file_id] = file_path
    return file_mapping