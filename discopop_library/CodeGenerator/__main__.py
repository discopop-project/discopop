# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop Code Generator

Usage:
    discopop_code_generator --fmap <path> --json <path> --outputdir <path> [--patterns <str>]

OPTIONAL ARGUMENTS:
    --fmap=<file>               File mapping
    --json=<file>               Json output of the DiscoPoP Explorer
    --outputdir=<path>          Directory for the modified source files
    --patterns=<str>            Comma-separated list of pattern types to be applied
                                Possible values: reduction, do_all
    -h --help                   Show this screen
"""
import os
from typing import Dict, List

import pstats2  # type:ignore
from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore

from discopop_library.CodeGenerator.CodeGenerator import from_json_strings as generate_code_from_json_strings
from discopop_library.FileMapping.FileMapping import load_file_mapping
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json

docopt_schema = Schema(
    {
        "--fmap": Use(str),
        "--json": Use(str),
        "--patterns": Use(str),
        "--outputdir": Use(str),
    }
)


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Applies the code modifications specified by the given JSON file and writes
    the modified source code structure into outputdir.
    Note that only modified source code files will be written to outputdir."""
    arguments = docopt(__doc__)

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    file_mapping_file = get_path(os.getcwd(), arguments["--fmap"])
    json_file = get_path(os.getcwd(), arguments["--json"])
    outputdir = arguments["--outputdir"]
    relevant_patterns: List[str] = [] if arguments["--patterns"] == "None" else (
        arguments["--patterns"].split(",") if "," in arguments["--patterns"] else arguments["--patterns"])

    for file in [file_mapping_file, json_file]:
        if not os.path.isfile(file):
            raise FileNotFoundError('File not found: ', file)
    if not os.path.exists(outputdir):
        os.mkdir(outputdir)

    file_mapping_dict = load_file_mapping(file_mapping_file)

    identified_patterns = read_patterns_from_json_to_json(json_file, relevant_patterns)

    modified_code = generate_code_from_json_strings(file_mapping_dict, identified_patterns)

    modified_code_by_new_location: Dict[str, str] = dict()
    for file_id in modified_code:
        old_location = file_mapping_dict[file_id]
        new_location = os.path.join(outputdir, old_location.split("/.discopop/")[1])
        modified_code_by_new_location[new_location] = modified_code[file_id]

    # output modified code
    for file_path in modified_code_by_new_location:
        with open(file_path, "w+") as f:
            f.write(modified_code_by_new_location[file_path])
            f.close()

    print("Written modified source code to: ", outputdir)


if __name__ == "__main__":
    main()
