import json
import os.path
from typing import Dict, List


def read_patterns_from_json_to_json(json_path: str) -> Dict[str, List[str]]:
    pattern_json_strings_by_type: Dict[str, List[str]] = dict()

    if not os.path.exists(json_path):
        raise ValueError("Path does not exist!", json_path)

    with open(json_path, "r") as f:
        data = json.load(f)
        for key in data:
            if key not in pattern_json_strings_by_type:
                pattern_json_strings_by_type[key] = []
            for entry in data[key]:
                pattern_json_strings_by_type[key].append(json.dumps(entry))

    return pattern_json_strings_by_type