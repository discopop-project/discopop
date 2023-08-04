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
from pathlib import Path
from typing import List, Optional

import pstats2  # type:ignore
from discopop_explorer.json_serializer import PatternInfoSerializer
from discopop_explorer.parser import parse_inputs
from discopop_explorer.pattern_detection import (DetectionResult,
                                                 PatternDetectorX)
from discopop_explorer.PETGraphX import PETGraphX
from discopop_library.commons import get_path
from pluginbase import PluginBase  # type:ignore


def run(
    cu_xml: str,
    dep_file: str,
    loop_counter_file: str,
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

    plugin_base = PluginBase(package="plugins")

    plugin_source = plugin_base.make_plugin_source(searchpath=[Path(__file__).parent / "plugins"])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin before: " + plugin_name)
        pet = p.run_before(pet)

    pattern_detector = PatternDetectorX(pet)

    res: DetectionResult = pattern_detector.detect_patterns(
        cu_xml,
        dep_file,
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


def run_with_args(
    path,
    cu_xml,
    dep_file,
    loop_counter_file,
    reduction_file,
    file_mapping,
    cu_inst_result_file,
    discopop_build_path,
    plugins, enable_profiling,
    enable_pet_dump,
    generate_data_cu_inst,
    llvm_cxxfilt_path,
    enable_task_pattern,
    enable_dump_detection_result,
    json_file
):
    # check if needed files exist
    for file in [cu_xml, dep_file, loop_counter_file, reduction_file, file_mapping]:
        if not os.path.isfile(file):
            print(f'File not found: "{file}"')
            sys.exit()

    # run with/without profiling
    if enable_profiling:
        profile = cProfile.Profile()
        profile.enable()

    # generate data cu inst and stop
    if generate_data_cu_inst:
        # start generation of Data_CUInst and stop execution afterwards
        from .generate_Data_CUInst import \
            wrapper as generate_data_cuinst_wrapper

        generate_data_cuinst_wrapper(
            cu_xml,
            dep_file,
            loop_counter_file,
            reduction_file,
            generate_data_cu_inst,
        )
        sys.exit(0)

    # run pattern detection
    start = time.time()

    res = run(
        cu_xml,
        dep_file,
        loop_counter_file,
        reduction_file,
        plugins,
        file_mapping=file_mapping,
        cu_inst_result_file=cu_inst_result_file,
        llvm_cxxfilt_path=llvm_cxxfilt_path,
        discopop_build_path=discopop_build_path,
        enable_task_pattern=enable_task_pattern,
    )

    end = time.time()

    # output results
    if enable_pet_dump:
        with open(get_path(path, "pet_dump.json"), "w+") as f:
            f.write(res.pet.dump_to_pickled_json())
            f.flush()
            f.close()

    if enable_dump_detection_result:
        with open(get_path(path, "detection_result_dump.json"), "w+") as f:
            f.write(res.dump_to_pickled_json())
            f.flush()
            f.close()

    if not json_file:
        print(str(res))
    else:
        # todo re-enable?
        # print(str(res))
        # since PETGraphX is not JSON Serializable, delete the field prior to executing the serialization
        del res.pet
        with open(json_file, "w") as f:
            json.dump(res, f, indent=2, cls=PatternInfoSerializer)

    if enable_profiling:
        profile.disable()
        if os.path.exists("profiling_stats.txt"):
            os.remove("profiling_stats.txt")
        with open("profiling_stats.txt", "w+") as f:
            stats = pstats2.Stats(profile, stream=f).sort_stats("time").reverse_order()
            stats.print_stats()

    print("Time taken for pattern detection: {0}".format(end - start))