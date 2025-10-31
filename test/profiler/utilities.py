from typing import List
import re


def get_dependencies(path: str) -> List[str]:
    result: List[str] = []
    with open(path, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            sink = line.split(" ")[0]
            if sink.count(":") == 0:  # skip irrelevant lines
                continue
            pattern = re.compile(r"((RAW|WAR|WAW|INIT)\s((\d+:\d+)|\*)\|\S+)")
            for match in re.findall(pattern, line):
                result.append(sink + " " + match[0])
    return result
