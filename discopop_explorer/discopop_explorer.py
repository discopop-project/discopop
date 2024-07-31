# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import cProfile
import json
import logging
import os
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import pstats2  # type:ignore
from pluginbase import PluginBase  # type: ignore
from discopop_library.ArgumentClasses.GeneralArguments import GeneralArguments  # type: ignore
from discopop_library.HostpotLoader.HotspotLoaderArguments import HotspotLoaderArguments
from discopop_library.HostpotLoader.HotspotNodeType import HotspotNodeType
from discopop_library.HostpotLoader.HotspotType import HotspotType  # type:ignore

from discopop_library.LineMapping.initialize import initialize_line_mapping
from discopop_library.PathManagement.PathManagement import get_path, load_file_mapping
from discopop_library.discopop_optimizer.Microbench.ExtrapInterpolatedMicrobench import (
    ExtrapInterpolatedMicrobench,
)
from discopop_library.result_classes.DetectionResult import DetectionResult
from discopop_explorer.classes.PEGraphX import PEGraphX
from .json_serializer import PatternBaseSerializer
from discopop_explorer.utilities.PEGraphConstruction.parser import parse_inputs
from .pattern_detection import PatternDetectorX

from discopop_library.HostpotLoader.hostpot_loader import run as load_hotspots


@dataclass
class ExplorerArguments(GeneralArguments):
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
    enable_patterns: str
    # experimental features:
    enable_task_pattern: bool
    detect_scheduling_clauses: bool
    generate_data_cu_inst: Optional[str]  # none: generate Data_CUInst.txt & exit
    cu_inst_result_file: Optional[str]
    llvm_cxxfilt_path: Optional[str]
    microbench_file: Optional[str]
    load_existing_doall_and_reduction_patterns: bool

    def __post_init__(self) -> None:
        self.__validate()

    def __validate(self) -> None:
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
    enable_patterns: str = "*",
    enable_task_pattern: bool = False,
    enable_detection_of_scheduling_clauses: bool = False,
    hotspot_functions: Optional[Dict[HotspotType, List[Tuple[int, int, HotspotNodeType, str, float]]]] = None,
    load_existing_doall_and_reduction_patterns: bool = False,
) -> DetectionResult:
    pet = PEGraphX.from_parsed_input(*parse_inputs(cu_xml, dep_file, reduction_file, file_mapping))  # type: ignore
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

    if load_existing_doall_and_reduction_patterns:
        res: DetectionResult = pattern_detector.load_existing_doall_and_reduction_patterns(
            project_path,
            cu_xml,
            dep_file,
            loop_counter_file,
            reduction_file,
            file_mapping,
            cu_inst_result_file,
            llvm_cxxfilt_path,
            discopop_build_path,
            enable_patterns,
            enable_task_pattern,
            enable_detection_of_scheduling_clauses,
            hotspot_functions,
        )
    else:
        res = pattern_detector.detect_patterns(
            project_path,
            cu_xml,
            dep_file,
            loop_counter_file,
            reduction_file,
            file_mapping,
            cu_inst_result_file,
            llvm_cxxfilt_path,
            discopop_build_path,
            enable_patterns,
            enable_task_pattern,
            enable_detection_of_scheduling_clauses,
            hotspot_functions,
        )

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        # print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res


def run(arguments: ExplorerArguments) -> None:
    """Run the discopop_explorer with the given arguments"""
    logger = logging.getLogger("Explorer")

    # create explorer directory if not already present
    if not os.path.exists(os.path.join(arguments.project_path, "explorer")):
        os.mkdir(os.path.join(arguments.project_path, "explorer"))
    # create file to store next free pattern ids if not already present
    if not os.path.exists("next_free_pattern_id.txt"):
        with open("next_free_pattern_id.txt", "w") as f:
            f.write(str(0))
    # reset file lock in case of prior crashes
    if os.path.exists("next_free_pattern_id.txt.lock"):
        os.remove("next_free_pattern_id.txt.lock")

    if arguments.enable_profiling_dump_file is not None:
        profile = cProfile.Profile()
        profile.enable()

    try:
        if arguments.generate_data_cu_inst is not None:
            # start generation of Data_CUInst and stop execution afterwards
            from discopop_explorer.utilities.general.generate_Data_CUInst import wrapper as generate_data_cuinst_wrapper

            generate_data_cuinst_wrapper(
                arguments.cu_xml_file,
                arguments.dep_file,
                arguments.loop_counter_file,
                arguments.reduction_file,
                arguments.generate_data_cu_inst,
            )
            sys.exit(0)

        print("Loading Hotspots...")

        hotspots = load_hotspots(
            HotspotLoaderArguments(
                verbose=True,
                dot_discopop_path=os.getcwd(),
                get_loops=True,
                get_functions=True,
                get_YES=True,
                get_MAYBE=True,
                get_NO=False,
                log_level=arguments.log_level,
                write_log=arguments.write_log,
            )
        )

        print("Done.")

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
            enable_patterns=arguments.enable_patterns,
            enable_task_pattern=arguments.enable_task_pattern,
            enable_detection_of_scheduling_clauses=arguments.detect_scheduling_clauses,
            hotspot_functions=hotspots,
            load_existing_doall_and_reduction_patterns=arguments.load_existing_doall_and_reduction_patterns,
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
                json.dump(res, f, indent=2, cls=PatternBaseSerializer)

        # initialize the line_mapping.json
        initialize_line_mapping(load_file_mapping(arguments.file_mapping_file), arguments.project_path)

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

        # print profiling results
        if arguments.enable_profiling_dump_file is not None:
            profile.disable()
            if os.path.exists(arguments.enable_profiling_dump_file):
                os.remove(arguments.enable_profiling_dump_file)
            with open(arguments.enable_profiling_dump_file, "w+") as f:
                stats = pstats2.Stats(profile, stream=f).sort_stats("tottime").reverse_order()
                stats.print_stats()

    except BaseException as be:
        # required to correctly write profiling data if the program terminates
        # print profiling results
        if arguments.enable_profiling_dump_file is not None:
            profile.disable()
            if os.path.exists(arguments.enable_profiling_dump_file):
                os.remove(arguments.enable_profiling_dump_file)
            with open(arguments.enable_profiling_dump_file, "w+") as f:
                stats = pstats2.Stats(profile, stream=f).sort_stats("tottime").reverse_order()
                stats.print_stats()
        raise be
