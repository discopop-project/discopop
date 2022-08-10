"""Source code differences

Usage:
    detect_file_modifications [--original_file <path>] [--modified_file <path>]

Options:
    --original_file=<path>               Path to original file
    --modified_file=<path>               Path to potentially modified file
    -h --help                   Show this screen
"""
import os
import sys
from difflib import unified_diff

from docopt import docopt
from schema import SchemaError, Schema, Use  # type: ignore


docopt_schema = Schema({
    '--original_file': Use(str),
    '--modified_file': Use(str),
})


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    """Argument handling."""
    arguments = docopt(__doc__)
    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    original_file = arguments["--original_file"]
    modified_file = arguments["--modified_file"]

    print("ORG: ", original_file)
    print("MOD: ", modified_file)

    with open(original_file, "r") as orig:
        with open(modified_file, "r") as modif:
            sys.stdout.writelines(unified_diff(orig.readlines(), modif.readlines(), fromfile=original_file, tofile=modified_file))

if __name__ == "__main__":
    main()


