# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from argparse import ArgumentParser
from pathlib import Path

from discopop_library.PathManagement.PathManagement import get_path, get_path_or_none
from .discopop_explorer import ExplorerArguments, run


def parse_args() -> ExplorerArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP Explorer")
    # all flags that are not considered stable should be added to the experimental_parser
    experimental_parser = parser.add_argument_group(
        "EXPERIMENTAL",
        "Arguments for the task pattern detector and other experimental features. These flags are considered EXPERIMENTAL and they may or may not be removed or changed in the near future.",
    )

    # fmt: off
    parser.add_argument(
        "--path", type=str, default="./",
        help="Directory with input data")
    parser.add_argument(
        "--cu-xml", type=str, default="Data.xml",
        help="CU node xml file")
    parser.add_argument(
        "--dep-file", type=str, default="dp_run_dep.txt",
        help="Dependencies text file"
    )
    parser.add_argument(
        "--loop-counter", type=str, default="loop_counter_output.txt",
        help="Loop counter data"
    )
    parser.add_argument(
        "--reduction", type=str, default="reduction.txt",
        help="Reduction variables file"
    )
    parser.add_argument(
        "--fmap", type=str, default="FileMapping.txt",
        help="File mapping")
    parser.add_argument(
        "--plugins", type=str, nargs="*", default=[],
        help="Plugins to execute")
    parser.add_argument(
        "--dp-build-path", type=str, default=Path(__file__).resolve().parent.parent / "build",
        help="Path to DiscoPoP build folder"
    )
    # flags related to output and formatting:
    parser.add_argument(
        "--json", type=str, nargs="?", default=None, const="patterns.json",
        help="Json output")
    parser.add_argument(
        "--profiling", type=str, nargs="?", default=None, const="profiling_stats.txt",
        help="Enable profiling. If a path is given, the profiling stats are written to the given file, otherwise to profiling_stats.txt",
    )
    parser.add_argument(
        "--dump-pet", type=str, nargs="?", default=None, const="pet_dump.json",
        help="Dump PET Graph to JSON file. If a path is given, the PET Graph is written to the given file, otherwise to pet_dump.json",
    )
    parser.add_argument(
        "--dump-detection-result", type=str, nargs="?", default=None, const="detection_result_dump.json",
        help="Dump DetectionResult object to JSON file. If a path is given, the DetectionResult object is written to the given file, otherwise to detection_result_dump.json. Contents are equivalent to the json output. NOTE: This dump contains a dump of the PET Graph!",
    )

    # EXPERIMENTAL FLAGS:
    # temporary flag for microbenchmark file
    experimental_parser.add_argument(
        "--microbench-file", type=str, default=None,
        help="path to a microbenchmark json file",
    )

    # flags related to task pattern detector:
    experimental_parser.add_argument(
        "--task-pattern", action="store_true",
        help="Enables the task parallelism pattern identification. Requires --cu-inst-res and --llvm-cxxfilt-path to be set.",
    )
    experimental_parser.add_argument(
        "--detect-scheduling-clauses", action="store_true",
        help="Enables the detection of scheduling clauses for parallel loops.")

    experimental_parser.add_argument(
        "--generate-data-cu-inst", type=str, default=None,
        help="Generates Data_CUInst.txt file and stores it in the given directory. Stops the regular execution of the discopop_explorer. Requires --cu-xml, --dep-file, --loop-counter, --reduction.",
    )
    experimental_parser.add_argument(
        "--cu-inst-res", type=str, default=None,
        help="CU instantiation result file."
    )
    experimental_parser.add_argument(
        "--llvm-cxxfilt-path", type=str, default=None,
        help="Path to llvm-cxxfilt executable. Required for task pattern detector if non-standard path should be used.",
    )
    # fmt: on

    arguments = parser.parse_args()

    # ensure that --cu-inst-res and --llvm-cxxfilt-path are set if --task-pattern is set
    if arguments.task_pattern and (arguments.cu_inst_res is None or arguments.llvm_cxxfilt_path is None):
        parser.error("--task-pattern requires --cu-inst-res and --llvm-cxxfilt-path to be set")

    # ensure that --cu-xml, --dep-file, --loop-counter, --reduction are set if --generate-data-cu-inst is set
    # NOTE: no need to check, the defaults got us covered
    # if arguments.generate_data_cu_inst is not None and (arguments.cu_xml is None or arguments.dep_file is None or arguments.loop_counter is None or arguments.reduction is None):
    #    parser.error("--generate-data-cu-inst requires --cu-xml, --dep-file, --loop-counter, --reduction to be set")

    # post processing of arguments: interpret relative paths as relative to project path
    arguments.path = str(Path(arguments.path).resolve())
    arguments.cu_xml = get_path(arguments.path, arguments.cu_xml)
    arguments.dep_file = get_path(arguments.path, arguments.dep_file)
    arguments.loop_counter = get_path(arguments.path, arguments.loop_counter)
    arguments.reduction = get_path(arguments.path, arguments.reduction)
    arguments.fmap = get_path(arguments.path, arguments.fmap)
    arguments.json = get_path_or_none(arguments.path, arguments.json)
    arguments.cu_inst_res = get_path_or_none(arguments.path, arguments.cu_inst_res)
    arguments.generate_data_cu_inst = get_path_or_none(arguments.path, arguments.generate_data_cu_inst)
    arguments.profiling = get_path_or_none(arguments.path, arguments.profiling)
    arguments.dump_pet = get_path_or_none(arguments.path, arguments.dump_pet)
    arguments.dump_detection_result = get_path_or_none(arguments.path, arguments.dump_detection_result)
    arguments.microbench_file = get_path_or_none(arguments.path, arguments.microbench_file)

    return ExplorerArguments(
        discopop_build_path=arguments.dp_build_path,
        microbench_file=arguments.microbench_file,
        project_path=arguments.path,
        cu_xml_file=arguments.cu_xml,
        dep_file=arguments.dep_file,
        loop_counter_file=arguments.loop_counter,
        reduction_file=arguments.reduction,
        file_mapping_file=arguments.fmap,
        plugins=arguments.plugins,
        enable_task_pattern=arguments.task_pattern,
        detect_scheduling_clauses=arguments.detect_scheduling_clauses,
        enable_profiling_dump_file=arguments.profiling,
        enable_pet_dump_file=arguments.dump_pet,
        enable_detection_result_dump_file=arguments.dump_detection_result,
        generate_data_cu_inst=arguments.generate_data_cu_inst,
        cu_inst_result_file=arguments.cu_inst_res,
        llvm_cxxfilt_path=arguments.llvm_cxxfilt_path,
        enable_json_file=arguments.json,
    )


def main():
    arguments = parse_args()
    run(arguments)


if __name__ == "__main__":
    main()
