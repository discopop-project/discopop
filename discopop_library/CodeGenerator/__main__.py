# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
import os
import sys
from typing import Dict, List

from discopop_library.CodeGenerator.CodeGenerator import (
    from_json_strings as generate_code_from_json_strings,
)
from discopop_library.CodeGenerator.CodeGeneratorArguments import CodeGeneratorArguments
from discopop_library.JSONHandler.JSONHandler import read_patterns_from_json_to_json
from discopop_library.PathManagement.PathManagement import load_file_mapping, get_path


def parse_args() -> CodeGeneratorArguments:
    """Parse the arguments passed to the discopop_code_generator"""
    parser = ArgumentParser(description="DiscoPoP Code Generator")
    # all flags that are not considered stable should be added to the experimental_parser
    # experimental_parser = parser.add_argument_group(
    #    "EXPERIMENTAL",
    #    "Arguments for experimental features. Experimental arguments may or may not be removed or changed in the future.",
    # )

    # fmt: off
    parser.add_argument("--fmap", type=str, help="File mapping")
    parser.add_argument("--json", type=str, help="Json output of the DiscoPoP Explorer")
    parser.add_argument("--outputdir", type=str, help="Directory for the modified source files")
    parser.add_argument("--patterns", type=str, help="Comma-separated list of pattern types to be applied. Possible values: reduction, do_all, simple_gpu, combined_gpu", default="None")
    parser.add_argument("--compile-check-command", type=str, help="Specify a command to be executed for performing the compile check (e.g. \"cd .. && make\")", default="None")

    parser.add_argument("--skip-compilation-check", action="store_true", help="Do not validate the inserted patterns by compiling the resulting source code.")

    # EXPERIMENTAL FLAGS:
    # fmt: on

    arguments = parser.parse_args()

    return CodeGeneratorArguments(
        fmap=arguments.fmap,
        json=arguments.json,
        patterns=arguments.patterns,
        outputdir=arguments.outputdir,
        skip_compilation_check=arguments.skip_compilation_check,
        compile_check_command=arguments.compile_check_command,
    )


def main():
    """Applies the code modifications specified by the given JSON file and writes
    the modified source code structure into outputdir.
    Note that only modified source code files will be written to outputdir."""
    arguments = parse_args()

    file_mapping_file = get_path(os.getcwd(), arguments.fmap)
    json_file = get_path(os.getcwd(), arguments.json)
    outputdir = arguments.outputdir
    relevant_patterns: List[str] = (
        []
        if arguments.patterns == "None"
        else (arguments.patterns.split(",") if "," in arguments.patterns else [arguments.patterns])
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

    print("SKIP COMPILATION CHECK? ", arguments.skip_compilation_check, file=sys.stderr)
    print("\ttype: ", type(arguments.skip_compilation_check), file=sys.stderr)
    print("COMPILE CHECK COMMAND? ", arguments.compile_check_command, file=sys.stderr)
    print("\ttype: ", type(arguments.compile_check_command), file=sys.stderr)

    print("FILE MAPPING: ", file_mapping_dict)
    print("patterns:", identified_patterns)

    modified_code = generate_code_from_json_strings(
        file_mapping_dict,
        identified_patterns,
        skip_compilation_check=arguments.skip_compilation_check,
        compile_check_command=arguments.compile_check_command if arguments.compile_check_command != "None" else None,
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
