# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from pathlib import Path
from typing import List, Optional

from pluginbase import PluginBase  # type:ignore

from .PETGraphX import PETGraphX
from ._version import __version__
from .parser import parse_inputs
from .pattern_detection import DetectionResult, PatternDetectorX


def run(cu_xml: str, dep_file: str, loop_counter_file: str, reduction_file: str, plugins: List[str],
        file_mapping: Optional[str] = None, cu_inst_result_file: Optional[str] = None,
        llvm_cxxfilt_path: Optional[str] = None) -> DetectionResult:
    pet = PETGraphX.from_parsed_input(*parse_inputs(cu_xml, dep_file,
                                                    loop_counter_file, reduction_file))
    # TODO add visualization
    # pet.show()

    plugin_base = PluginBase(package='plugins')

    plugin_source = plugin_base.make_plugin_source(
        searchpath=[Path(__file__).parent / 'plugins'])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin before: " + plugin_name)
        pet = p.run_before(pet)

    pattern_detector = PatternDetectorX(pet)

    res: DetectionResult = pattern_detector.detect_patterns(cu_xml, dep_file, loop_counter_file, reduction_file,
                                                            file_mapping, cu_inst_result_file, llvm_cxxfilt_path)

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res
