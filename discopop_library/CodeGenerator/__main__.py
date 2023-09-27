# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop Code Generator

Usage:
    discopop_code_generator --fmap <path> --json <path> --outputdir <path> [--patterns <str>] [--compile-check-command <str>] [--skip-compilation-check]

OPTIONAL ARGUMENTS:
    --fmap=<file>               File mapping
    --json=<file>               Json output of the DiscoPoP Explorer
    --outputdir=<path>          Directory for the modified source files
    --patterns=<str>            Comma-separated list of pattern types to be applied
                                Possible values: reduction, do_all, simple_gpu, combined_gpu
    --skip-compilation-check    Do not validate the inserted patterns by compiling the resulting source code.
    --compile-check-command=<str>     Specify a command to be executed for performing the compile check (e.g. "cd .. && make")
    -h --help                   Show this screen
"""
import os
import sys
from typing import Dict, List

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore

from discopop_library.CodeGenerator.CodeGenerator import (
    from_json_strings as generate_code_from_json_strings,
)
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json
from discopop_library.PathManagement.PathManagement import load_file_mapping, get_path

docopt_schema = Schema(
    {
        "--fmap": Use(str),
        "--json": Use(str),
        "--patterns": Use(str),
        "--outputdir": Use(str),
        "--skip-compilation-check": Use(str),
        "--compile-check-command": Use(str),
    }
)


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
    relevant_patterns: List[str] = (
        []
        if arguments["--patterns"] == "None"
        else (arguments["--patterns"].split(",") if "," in arguments["--patterns"] else [arguments["--patterns"]])
    )
    # validate patterns
    for pattern in relevant_patterns:
        if pattern not in ["reduction", "do_all", "simple_gpu", "combined_gpu"]:
            raise ValueError("Unsupported pattern name: ", pattern, " given in '--patterns' argument!")

    for file in [file_mapping_file, json_file]:
        if not os.path.isfile(file):
            raise FileNotFoundError("File not found: ", file)
    if not os.path.exists(outputdir):
        os.mkdir(outputdir)

    file_mapping_dict = load_file_mapping(file_mapping_file)

    identified_patterns = read_patterns_from_json_to_json(json_file, relevant_patterns)

    print("SKIP COMPILATION CHECK? ", arguments["--skip-compilation-check"], file=sys.stderr)
    print("\ttype: ", type(arguments["--skip-compilation-check"]), file=sys.stderr)
    print("COMPILE CHECK COMMAND? ", arguments["--compile-check-command"], file=sys.stderr)
    print("\ttype: ", type(arguments["--compile-check-command"]), file=sys.stderr)

    print("FILE MAPPING: ", file_mapping_dict)
    print("patterns:", identified_patterns)

    modified_code = generate_code_from_json_strings(
        file_mapping_dict,
        identified_patterns,
        skip_compilation_check=True if arguments["--skip-compilation-check"] != "False" else False,
        compile_check_command=arguments["--compile-check-command"]
        if arguments["--compile-check-command"] != "None"
        else None,
    )

    modified_code_by_new_location: Dict[str, str] = dict()
    for file_id in modified_code:
        old_location = file_mapping_dict[file_id]
        print("OLD LOC: ", old_location)
        new_location = os.path.join(outputdir, str(old_location).split("/.discopop/")[1])
        print("NEW LOC: ", new_location)

        modified_code_by_new_location[new_location] = modified_code[file_id]

    # output modified code
    for file_path in modified_code_by_new_location:
        with open(file_path, "w+") as f:
            f.write(modified_code_by_new_location[file_path])
            f.close()

    print("Written modified source code to: ", outputdir)


if __name__ == "__main__":
    main()
