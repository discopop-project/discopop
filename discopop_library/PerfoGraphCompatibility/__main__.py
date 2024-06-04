from argparse import ArgumentParser
from discopop_library.PerfoGraphCompatibility import PerfoGraphCompatibilityArguments
from discopop_library.GlobalLogger.setup import setup_logger
from discopop_library.PerfoGraphCompatibility.perfoGraphCompatibilityProvider import run


def parse_args() -> PerfoGraphCompatibilityArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP PerfoGraph compatibility tool")

    # fmt: off
    parser.add_argument("-ir", "--llvm_ir", type=str, help="path to llvm_ir file created by DiscoPoP")
    parser.add_argument("-dep", "--dynamic-deps", type=str, help="path to the dynamic_dependencies.txt file created by DiscoPoP")
    parser.add_argument("-o", "--output", type=str, help="output path for the modified dynamic dependencies file")
    parser.add_argument("-f", "--force-output",  action="store_true", help="overwrite the output file if already existing")
    # fmt: on

    arguments = parser.parse_args()

    return PerfoGraphCompatibilityArguments(
        llvm_ir_file=parser.llvm_ir,
        dynamic_deps_file=parser.dynamic_deps,
        output_file=parser.output,
        force_output=parser.force_output
    )


def main():
    arguments = parse_args()
    setup_logger(arguments)
    run(arguments)