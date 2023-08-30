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
import cProfile
import json
import os
import pstats2  # type:ignore
import sys
import time

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from pathlib import Path


from . import run
from .json_serializer import PatternInfoSerializer
from discopop_library.global_data.version.utils import get_version
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)

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


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute

    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)


def main():
    arguments = docopt(__doc__, version=f"DiscoPoP Version {get_version()}")

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    path = arguments["--path"]

    cu_xml = get_path(path, arguments["--cu-xml"])
    dep_file = get_path(path, arguments["--dep-file"])
    loop_counter_file = get_path(path, arguments["--loop-counter"])
    reduction_file = get_path(path, arguments["--reduction"])
    file_mapping = get_path(path, arguments["--fmap"])
    cu_inst_result_file = get_path(path, arguments["--cu-inst-res"])
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, file_mapping]:
        if not os.path.isfile(file):
            print(f'File not found: "{file}"')
            sys.exit()

    if arguments["--dp-build-path"] != "None":
        discopop_build_path = arguments["--dp-build-path"]
    else:
        # set default discopop build path
        discopop_build_path = Path(__file__).resolve().parent.parent
        discopop_build_path = os.path.join(discopop_build_path, "build")

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

    if arguments["--dump-pet"] == "true":
        with open(get_path(path, "pet_dump.json"), "w+") as f:
            f.write(res.pet.dump_to_pickled_json())
            f.flush()
            f.close()

    if arguments["--dump-detection-result"] == "true":
        with open(get_path(path, "detection_result_dump.json"), "w+") as f:
            f.write(res.dump_to_pickled_json())
            f.flush()
            f.close()

    if arguments["--json"] == "None":
        print(str(res))
    else:
        # todo re-enable?
        # print(str(res))
        # since PETGraphX is not JSON Serializable, delete the field prior to executing the serialization
        del res.pet
        with open(arguments["--json"], "w") as f:
            json.dump(res, f, indent=2, cls=PatternInfoSerializer)

    if arguments["--profiling"] == "true":
        profile.disable()
        if os.path.exists("profiling_stats.txt"):
            os.remove("profiling_stats.txt")
        with open("profiling_stats.txt", "w+") as f:
            stats = pstats2.Stats(profile, stream=f).sort_stats("time").reverse_order()
            stats.print_stats()

    print("Time taken for pattern detection: {0}".format(end - start))

    # demonstration of Microbenchmark possibilities
    if arguments["--microbench-file"] != "None":
        microbench_file = get_path(path, arguments["--microbench-file"])
        if not os.path.isfile(microbench_file):
            raise FileNotFoundError(f"Microbenchmark file not found: {microbench_file}")

        extrapBench = ExtrapInterpolatedMicrobench(microbench_file)
        sympyExpr = extrapBench.getFunctionSympy()
        print(sympyExpr)
        print(sympyExpr.free_symbols)


if __name__ == "__main__":
    main()
