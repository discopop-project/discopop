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
from dataclasses import dataclass
import json
import os
import pstats2  # type:ignore
import sys
import time

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore
from typing import List, Optional
from pathlib import Path

from .json_serializer import PatternInfoSerializer
from discopop_library.global_data.version.utils import get_version
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)
from discopop_library.PathManagement.PathManagement import get_path


from pluginbase import PluginBase  # type:ignore

from .PETGraphX import PETGraphX
from .parser import parse_inputs
from .pattern_detection import PatternDetectorX
from discopop_library.result_classes.DetectionResult import DetectionResult


def run(
    project_path: str,
    cu_xml: str,
    dep_file: str,
    loop_counter_file: str,  # TODO we should be able to read all info from the _dep.txt file (?)
    reduction_file: str,
    plugins: List[str],
    file_mapping: Optional[str] = None,
    cu_inst_result_file: Optional[str] = None,
    llvm_cxxfilt_path: Optional[str] = None,
    discopop_build_path: Optional[str] = None,
    enable_task_pattern: bool = False,
) -> DetectionResult:
    pet = PETGraphX.from_parsed_input(*parse_inputs(cu_xml, dep_file, reduction_file, file_mapping))
    print("PET CREATION FINISHED.")
    # pet.show()
    # TODO add visualization

    plugin_base = PluginBase(package="plugins")

    plugin_source = plugin_base.make_plugin_source(searchpath=[Path(__file__).parent / "plugins"])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin before: " + plugin_name)
        pet = p.run_before(pet)

    pattern_detector = PatternDetectorX(pet)

    res: DetectionResult = pattern_detector.detect_patterns(
        project_path,
        cu_xml,
        dep_file,
        loop_counter_file,
        reduction_file,
        file_mapping,
        cu_inst_result_file,
        llvm_cxxfilt_path,
        discopop_build_path,
        enable_task_pattern,
    )

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        # print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res


@dataclass
class ExplorerArguments(object):
    """Container Class for the arguments passed to the discopop_explorer"""

    discopop_build_path: str
    microbench_file: Optional[str]
    project_path: str
    cu_xml_file: str
    dep_file: str
    loop_counter_file: str
    reduction_file: str
    file_mapping_file: str
    plugins: List[str]
    enable_task_pattern: bool
    enable_profiling_dump_file: Optional[str]  # None means no dump, otherwise the path
    enable_pet_dump_file: Optional[str]  # None means no dump, otherwise the path
    enable_detection_result_dump_file: Optional[str]  # None means no dump, otherwise the path
    # TODO generate_data_cu_inst: specify exact path instead of directory
    generate_data_cu_inst: Optional[str]  # none: generate Data_CUInst.txt in given dir & exit
    cu_inst_result_file: Optional[str]
    llvm_cxxfilt_path: Optional[str]
    json: Optional[str]

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_explorer, e.g check if given files exist"""
        validation_failure = False

        # check for missing files
        missing_files = []
        for file in [
            self.cu_xml_file,
            self.dep_file,
            self.loop_counter_file,
            self.reduction_file,
            self.file_mapping_file,
        ]:  # TODO more files?
            if not os.path.isfile(file):
                missing_files.append(file)
        if missing_files:
            validation_failure = True
            print("The following files are missing:")
            for file in missing_files:
                print(file)

        # validate discopop build path
        # TODO validate discopop build path

        if validation_failure:
            print("Exiting...")
            sys.exit()


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
        microbench_file=arguments["--microbench-file"], # optionally specify path
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
        generate_data_cu_inst=None if arguments["--generate-data-cu-inst"] == "None" else arguments["--generate-data-cu-inst"], # optionally specify path
        cu_inst_result_file=get_path(arguments["--path"], arguments["--cu-inst-res"]),
        llvm_cxxfilt_path=arguments["--llvm-cxxfilt-path"],
        json=None if arguments["--json"] == "None" else arguments["--json"], # optionally specify path
    )
    # fmt: on


def main():
    arguments = parse_args()

    if arguments.enable_profiling_dump_file is not None:
        profile = cProfile.Profile()
        profile.enable()

    if arguments.generate_data_cu_inst is not None:
        # start generation of Data_CUInst and stop execution afterwards
        from .generate_Data_CUInst import wrapper as generate_data_cuinst_wrapper

        generate_data_cuinst_wrapper(
            arguments.cu_xml_file,
            arguments.dep_file,
            arguments.loop_counter_file,
            arguments.reduction_file,
            arguments.generate_data_cu_inst,
        )
        sys.exit(0)

    start = time.time()

    res = run(
        arguments.project_path,
        arguments.cu_xml_file,
        arguments.dep_file,
        arguments.loop_counter_file,
        arguments.reduction_file,
        arguments.plugins,
        file_mapping=arguments.file_mapping_file,
        cu_inst_result_file=arguments.cu_inst_result_file,
        llvm_cxxfilt_path=arguments.llvm_cxxfilt_path,
        discopop_build_path=arguments.discopop_build_path,
        enable_task_pattern=arguments.enable_task_pattern,
    )

    end = time.time()

    if arguments.enable_pet_dump_file is not None:
        with open(arguments.enable_pet_dump_file, "w+") as f:
            f.write(res.pet.dump_to_pickled_json())
            f.flush()
            f.close()

    if arguments.enable_detection_result_dump_file is not None:
        with open(arguments.enable_detection_result_dump_file, "w+") as f:
            f.write(res.dump_to_pickled_json())
            f.flush()
            f.close()

    if arguments.json is None:
        print(str(res))
    else:
        # todo re-enable?
        # print(str(res))
        # since PETGraphX is not JSON Serializable, delete the field prior to executing the serialization
        del res.pet
        with open(arguments.json, "w") as f:
            json.dump(res, f, indent=2, cls=PatternInfoSerializer)

    if arguments.enable_profiling_dump_file is not None:
        profile.disable()
        if os.path.exists(arguments.enable_profiling_dump_file):
            os.remove(arguments.enable_profiling_dump_file)
        with open(arguments.enable_profiling_dump_file, "w+") as f:
            stats = pstats2.Stats(profile, stream=f).sort_stats("time").reverse_order()
            stats.print_stats()

    print("Time taken for pattern detection: {0}".format(end - start))

    # demonstration of Microbenchmark possibilities
    if arguments.microbench_file is not None:
        microbench_file = get_path(
            arguments.project_path, arguments.microbench_file
        )  # NOTE: the json file is not usually located in the project, this is just for demonstration purposes
        if not os.path.isfile(microbench_file):
            raise FileNotFoundError(f"Microbenchmark file not found: {microbench_file}")
        extrapBench = ExtrapInterpolatedMicrobench(microbench_file)
        sympyExpr = extrapBench.getFunctionSympy()
        print(sympyExpr)
        print(sympyExpr.free_symbols)


if __name__ == "__main__":
    main()
