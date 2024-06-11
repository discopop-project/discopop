from typing import Dict, List, Tuple, Optional, cast
import os


def get_edge_descriptions(
    filepath: str,
    categories: Dict[str, int] = {"RAW": 10, "WAR": 11, "WAW": 12},
    detect_category_using_startswith: bool = True,
) -> List[Tuple[int, int, int]]:
    """Parses the dependencies in the given file and returns a list of edge descriptions to be added to the PerfoGraph.
    The flag detect_category_using_startswith can be used to, for example, interpret a RAW_II_0 dependency as a regular RAW.
    If it is set to False, the RAW_II_0 dependency would be ignored in case of the default categories."""
    if not os.path.exists(filepath):
        raise FileNotFoundError

    edge_description_tuples: List[Tuple[int, int, int]] = []

    with open(filepath, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            # only consider dependency lines
            if not line.startswith("!"):
                continue

            split_line = line.split(" ")
            # get first entry in split_lines (sink)
            sink_instruction_id = int(split_line[0].replace("!", ""))
            # parse remaining list entries as sets of two (dependency type + description)
            idx = 1
            while idx < len(split_line):
                # get dependency type
                dependency_type = split_line[idx]
                idx += 1
                # check if dependency type is relevant and get category id if so
                category_id: Optional[int] = None
                if not detect_category_using_startswith:
                    if dependency_type not in categories:
                        continue
                    category_id = categories[dependency_type]
                else:
                    is_relevant = False
                    for category in categories:
                        if dependency_type.startswith(category):
                            is_relevant = True
                            category_id = categories[category]
                            break
                    if not is_relevant:
                        # skip the description and go to next entry
                        idx += 1
                        continue

                # get dependency description
                dependency_description = split_line[idx]

                # get source instruction from dependency description
                raw_source_instruction_id = dependency_description.split("|")[0]
                source_instruction_id = int(raw_source_instruction_id.replace("!", ""))

                # register a new PerfoGraph edge description tuple if category_id is valid
                if category_id is not None:
                    edge_description_tuples.append((sink_instruction_id, category_id, source_instruction_id))

    return edge_description_tuples
