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
[--dump-detection-result <bool>]

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
    -h --help                   Show this screen
"""
import os

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from pathlib import Path

from discopop.discopop_explorer.API import run_with_args
from discopop.discopop_library.commons import get_path

from ._version import __version__

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
    }
)


def main():
    # parse arguments
    arguments = docopt(__doc__, version=f"DiscoPoP Version {__version__}")

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    path = arguments["--path"]
    cu_xml = get_path(path, arguments["--cu-xml"])
    dep_file = get_path(path, arguments["--dep-file"])
    loop_counter_file = get_path(path, arguments["--loop-counter"])
    reduction_file = get_path(path, arguments["--reduction"])
    file_mapping = get_path(path, "FileMapping.txt")
    cu_inst_result_file = get_path(path, arguments["--cu-inst-res"])
    if arguments["--dp-build-path"] != "None":
        discopop_build_path = arguments["--dp-build-path"]
    else:
        # set default discopop build path
        discopop_build_path = Path(__file__).resolve().parent.parent
        discopop_build_path = os.path.join(discopop_build_path, "build")
    plugins = [] if arguments["--plugins"] == "None" else arguments["--plugins"].split(" ")
    enable_profiling = (arguments["--profiling"] == "true")
    enable_pet_dump = (arguments["--dump-pet"] == "true")
    generate_data_cu_inst = None if arguments["--generate-data-cu-inst"] == "None" else arguments["--generate-data-cu-inst"]
    llvm_cxxfilt_path = llvm_cxxfilt_path=arguments["--llvm-cxxfilt-path"]
    enable_task_pattern = arguments["--task-pattern"]
    enable_dump_detection_result = (arguments["--dump-detection-result"] == "true")
    json_file = None if arguments["--json"] == "None" else arguments["--json"]

    run_with_args(
        path,
        cu_xml,
        dep_file,
        loop_counter_file,
        reduction_file,
        file_mapping,
        cu_inst_result_file,
        discopop_build_path,
        plugins, enable_profiling,
        enable_pet_dump, generate_data_cu_inst,
        llvm_cxxfilt_path, enable_task_pattern,
        enable_dump_detection_result,
        json_file
    )



if __name__ == "__main__":
    main()
