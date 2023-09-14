# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

"""Discopop explorer

Usage:
    discopop_explorer [--path <path>] [--cu-xml <cuxml>] [--dep-file <depfile>] [--plugins <plugs>] \
[--loop-counter <loopcount>] [--reduction <reduction>] [--json <json_out>] [--fmap <fmap>] \
[--task-pattern] [--cu-inst-res <cuinstres>] [--llvm-cxxfilt-path <cxxfp>] \
[--dp-build-path=<dpbuildpath>] [--generate-data-cu-inst <outputdir>] [--profiling <bool>] [--dump-pet <bool>]
[--dump-detection-result <bool>] [--microbench-file <json>]

OPTIONAL ARGUMENTS:
    --path=<dir>               Directory with input data [default: ./]
    --cu-xml=<file>            CU node xml file [default: Data.xml]
    --dep-file=<file>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<file>  Loop counter data [default: loop_counter_output.txt]
    --reduction=<file>     Reduction variables file [default: reduction.txt]
    --fmap=<file>               File mapping [default: FileMapping.txt]
    --json=<file>           Json output
    --plugins=<string>           Plugins to execute
    --task-pattern              Enables the task parallelism pattern identification.
                                Requires --cu-inst-res and --llvm-cxxfilt-path to be set.
    --cu-inst-res=<file>   CU instantiation result file.
    --llvm-cxxfilt-path=<file> Path to llvm-cxxfilt executable. Required for task pattern detector
                                if non-standard path should be used.
    --dp-build-path=<dir>           Path to DiscoPoP build folder [default: discopop/build]
    --generate-data-cu-inst=<dir>     Generates Data_CUInst.txt file and stores it in the given directory.
                                            Stops the regular execution of the discopop_explorer.
                                            Requires --cu-xml, --dep-file, --loop-counter, --reduction.
    --profiling=<bool>          Enable profiling. [default: false]
    --dump-pet=<bool>           Dump PET Graph to JSON file. [default: false]
    --dump-detection-result=<bool>  Dump DetectionResult object to JSON file. [default: true]
                                    Contents are equivalent to the json output.
                                    NOTE: This dump contains a dump of the PET Graph!
    --microbench-file=<file>    path to a microbenchmark json file
    -h --help                   Show this screen
"""
from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from pathlib import Path

from .discopop_explorer import ExplorerArguments, run_with_arguments
from discopop_library.global_data.version.utils import get_version
from discopop_library.PathManagement.PathManagement import get_path


def parse_args() -> ExplorerArguments:
    """Parse the arguments passed to the discopop_explorer"""
    arguments = docopt(__doc__, version=f"DiscoPoP Version {get_version()}")

    docopt_schema = Schema(
        {
            "--path": Use(str),
            "--cu-xml": Use(str),
            "--dep-file": Use(str),
            "--loop-counter": Use(str),
            "--reduction": Use(str),
            "--fmap": Use(str),
            "--plugins": Use(str),
            "--json": Use(str),
            "--task-pattern": Use(bool),
            "--cu-inst-res": Use(str),
            "--llvm-cxxfilt-path": Use(str),
            "--dp-build-path": Use(str),
            "--generate-data-cu-inst": Use(str),
            "--profiling": Use(str),
            "--dump-pet": Use(str),
            "--dump-detection-result": Use(str),
            "--microbench-file": Use(str),
        }
    )

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    # fmt: off
    return ExplorerArguments(
        discopop_build_path=arguments["--dp-build-path"] if arguments["--dp-build-path"] != "None" else Path(__file__).resolve().parent.parent / "build",
        microbench_file=None if arguments["--microbench-file"] == "None" else arguments["--microbench-file"], # optionally specify path
        project_path=arguments["--path"],
        cu_xml_file=get_path(arguments["--path"], arguments["--cu-xml"]),
        dep_file=get_path(arguments["--path"], arguments["--dep-file"]),
        loop_counter_file=get_path(arguments["--path"], arguments["--loop-counter"]),
        reduction_file=get_path(arguments["--path"], arguments["--reduction"]),
        file_mapping_file=get_path(arguments["--path"], arguments["--fmap"]),
        plugins=[] if arguments["--plugins"] == "None" else arguments["--plugins"].split(" "),
        enable_task_pattern=arguments["--task-pattern"],
        enable_profiling_dump_file=None if arguments["--profiling"] != "true" else get_path(arguments["--path"], "profiling_stats.txt"), # enable using --profiling true
        enable_pet_dump_file=None if arguments["--dump-pet"] != "true" else get_path(arguments["--path"], "pet_dump.json"), # enable using --dump-pet true
        enable_detection_result_dump_file=None if arguments["--dump-detection-result"] != "true" else get_path(arguments["--path"], "detection_result_dump.json"), # enable using --dump-detection-result true
        generate_data_cu_inst=None if arguments["--generate-data-cu-inst"] == "None" else get_path(arguments["--path"], arguments["--generate-data-cu-inst"] + "/Data_CUInst.txt"), # optionally specify path
        cu_inst_result_file=get_path(arguments["--path"], arguments["--cu-inst-res"]),
        llvm_cxxfilt_path=arguments["--llvm-cxxfilt-path"],
        json=None if arguments["--json"] == "None" else arguments["--json"], # optionally specify path
    )
    # fmt: on


def main():
    arguments = parse_args()
    run_with_arguments(arguments)


if __name__ == "__main__":
    main()
