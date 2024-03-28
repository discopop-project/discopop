# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import json
import logging
import os
from typing import Dict, List, Tuple
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType, get_HotspotNodeType_from_string
from discopop_library.HostpotLoader.HotspotType import HotspotType, get_HotspotType_from_string

FILEID = int
STARTLINE = int
NAME = str


def run(arguments: HotspotLoaderArguments) -> Dict[HotspotType, List[Tuple[FILEID, STARTLINE, HotspotNodeType, NAME]]]:
    """Loads Hotspots for processing in other tools of the framework"""
    if arguments.verbose:
        print("HotspotLoader - Configuration:")
        print(arguments)

    logger = logging.getLogger("HotspotLoader")
    logger.info("LOADING HOTSPOTS")

    result_dict: Dict[HotspotType, List[Tuple[FILEID, STARTLINE, HotspotNodeType, NAME]]] = dict()

    if not os.path.exists(os.path.join(os.getcwd(), "hotspot_detection")):
        return result_dict
    if not os.path.exists(os.path.join(os.getcwd(), "hotspot_detection", "Hotspots.json")):
        return result_dict
    with open(os.path.join(os.getcwd(), "hotspot_detection", "Hotspots.json"), "r") as f:
        hotspots = json.load(f)

        print("HOTSPOTS: ")
        for key in hotspots:
            print("->", key)
            for entry in hotspots[key]:
                print("\t->", entry)
                # check if hotness is considered
                if entry["hotness"] in arguments.get_considered_hotness():
                    # check if type is considered
                    if entry["typ"] in arguments.get_considered_types():
                        print("\tCONSIDER")
                        if get_HotspotType_from_string(entry["hotness"]) not in result_dict:
                            result_dict[get_HotspotType_from_string(entry["hotness"])] = []

                        result_dict[get_HotspotType_from_string(entry["hotness"])].append(
                            (
                                int(entry["fid"]),
                                int(entry["lineNum"]),
                                get_HotspotNodeType_from_string(entry["typ"]),
                                entry["name"],
                            )
                        )
    print("LOADED: ")
    print(result_dict)
    return result_dict
