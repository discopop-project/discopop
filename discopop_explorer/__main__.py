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
[--dp-build-path=<dpbuildpath>] [--generate-data-cu-inst <outputdir>] [--profiling <bool>] [--call-graph <file>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml]
    --dep-file=<depfile>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt]
    --reduction=<reduction>     Reduction variables file [default: reduction.txt]
    --fmap=<fmap>               File mapping [default: FileMapping.txt]
    --json=<json_out>           Json output
    --plugins=<plugs>           Plugins to execute
    --task-pattern              Enables the task parallelism pattern identification.
                                Requires --cu-inst-res and --llvm-cxxfilt-path to be set.
    --cu-inst-res=<cuinstres>   CU instantiation result file.
    --llvm-cxxfilt-path=<cxxfp> Path to llvm-cxxfilt executable. Required for task pattern detector
                                if non-standard path should be used.
    --dp-build-path=<dpbuildpath>           Path to DiscoPoP build folder [default: discopop/build]
    --generate-data-cu-inst=<outputdir>     Generates Data_CUInst.txt file and stores it in the given directory.
                                            Stops the regular execution of the discopop_explorer.
                                            Requires --cu-xml, --dep-file, --loop-counter, --reduction.
    --profiling=<bool>          Enable profiling. [default: false]
    --call-graph=<path>         Enable call graph creation and output result to given path.
    -h --help                   Show this screen
"""
import cProfile
import io
import json
import os
import pstats
import sys
import time
from pstats import SortKey

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from pathlib import Path

from . import run, __version__
from .json_serializer import PatternInfoSerializer

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
        "--call-graph": Use(str),
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

    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, file_mapping]:
        if not os.path.isfile(file):
            print(f'File not found: "{file}"')
            sys.exit()

    plugins = [] if arguments["--plugins"] == "None" else arguments["--plugins"].split(" ")

    if arguments["--profiling"] == "true":
        profile = cProfile.Profile()
        profile.enable()

    if arguments["--generate-data-cu-inst"] != "None":
        # start generation of Data_CUInst and stop execution afterwards
        from .generate_Data_CUInst import wrapper as generate_data_cuinst_wrapper

        generate_data_cuinst_wrapper(
            cu_xml,
            dep_file,
            loop_counter_file,
            reduction_file,
            arguments["--generate-data-cu-inst"],
        )
        sys.exit(0)

    start = time.time()

    if arguments["--call-graph"] != "None":
        print("call graph creation enabled...")
        from pycallgraph2 import PyCallGraph  # type: ignore
        from pycallgraph2.output import GraphvizOutput  # type: ignore
        from pycallgraph2 import Config
        from pycallgraph2 import GlobbingFilter
        from pycallgraph2 import Grouper
        groups = []
        for dir in os.walk(os.getcwd() + "/discopop_validation"):
            groups.append(dir[0].replace(os.getcwd() + "/", "").replace("/", ".") + ".*")
        groups = sorted(groups, reverse=True)
        trace_grouper = Grouper(groups)

        config = Config()
        config.trace_grouper = trace_grouper
        config.trace_filter = GlobbingFilter(include=[
            'discopop_explorer.*',
            '__main_*',
        ])
        res = None
        with PyCallGraph(output=GraphvizOutput(output_file=arguments["--call-graph"]), config=config):
            res = run(
                cu_xml,
                dep_file,
                loop_counter_file,
                reduction_file,
                plugins,
                file_mapping=file_mapping,
                cu_inst_result_file=cu_inst_result_file,
                llvm_cxxfilt_path=arguments["--llvm-cxxfilt-path"],
                discopop_build_path=discopop_build_path,
                enable_task_pattern=arguments["--task-pattern"],
            )
    else:
        res = run(
            cu_xml,
            dep_file,
            loop_counter_file,
            reduction_file,
            plugins,
            file_mapping=file_mapping,
            cu_inst_result_file=cu_inst_result_file,
            llvm_cxxfilt_path=arguments["--llvm-cxxfilt-path"],
            discopop_build_path=discopop_build_path,
            enable_task_pattern=arguments["--task-pattern"],
        )

    end = time.time()

    if arguments["--json"] == "None":
        print(str(res))
    else:
        print(str(res))
        with open(arguments["--json"], "w") as f:
            json.dump(res, f, indent=2, cls=PatternInfoSerializer)

    if arguments["--profiling"] == "true":
        profile.disable()
        if os.path.exists("profiling_stats.txt"):
            os.remove("profiling_stats.txt")
        with open("profiling_stats.txt", "w+") as f:
            stats = pstats.Stats(profile, stream=f).sort_stats(SortKey.TIME).reverse_order()
            stats.print_stats()

    print("Time taken for pattern detection: {0}".format(end - start))


if __name__ == "__main__":
    main()
