# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import cProfile
import json
import os
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import pstats2  # type:ignore
from pluginbase import PluginBase  # type:ignore

from discopop_library.PathManagement.PathManagement import get_path
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)
from discopop_library.result_classes.DetectionResult import DetectionResult
from .PETGraphX import PETGraphX
from .json_serializer import PatternInfoSerializer
from .parser import parse_inputs
from .pattern_detection import PatternDetectorX


@dataclass
class ExplorerArguments(object):
    """Container Class for the arguments passed to the discopop_explorer"""

    # input files and configuration
    discopop_build_path: str
    project_path: str
    cu_xml_file: str
    dep_file: str
    loop_counter_file: str
    reduction_file: str
    file_mapping_file: str
    plugins: List[str]
    # output and formatting
    enable_json_file: Optional[str]
    enable_profiling_dump_file: Optional[str]  # None means no dump, otherwise the path
    enable_pet_dump_file: Optional[str]  # None means no dump, otherwise the path
    enable_detection_result_dump_file: Optional[str]  # None means no dump, otherwise the path
    # experimental features:
    enable_task_pattern: bool
    detect_scheduling_clauses: bool
    generate_data_cu_inst: Optional[str]  # none: generate Data_CUInst.txt & exit
    cu_inst_result_file: Optional[str]
    llvm_cxxfilt_path: Optional[str]
    microbench_file: Optional[str]

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


def __run(
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
    enable_detection_of_scheduling_clauses: bool = False,
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
        enable_detection_of_scheduling_clauses,
    )

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        # print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res


def run(arguments: ExplorerArguments):
    """Run the discopop_explorer with the given arguments"""
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

    res = __run(
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
        enable_detection_of_scheduling_clauses=arguments.detect_scheduling_clauses,
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

    if arguments.enable_json_file is None:
        print(str(res))
    else:
        # todo re-enable?
        # print(str(res))
        # since PETGraphX is not JSON Serializable, delete the field prior to executing the serialization
        del res.pet
        with open(arguments.enable_json_file, "w+") as f:
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
