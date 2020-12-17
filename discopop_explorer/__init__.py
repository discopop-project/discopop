# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from pathlib import Path
from typing import List

from pluginbase import PluginBase  # type:ignore

from .PETGraphX import PETGraphX
from ._version import __version__
from .parser import parse_inputs
from .pattern_detection import DetectionResult, PatternDetectorX
import time


def run(cu_xml: str, dep_file: str, loop_counter_file: str, reduction_file: str, plugins: List[str]) \
        -> DetectionResult:
    t0 = time.time()
    pet = PETGraphX.from_parsed_input(*parse_inputs(cu_xml, dep_file,
                                                    loop_counter_file, reduction_file))
    # TODO add visualization
    t1 = time.time()
    print(f"parsing time: {t1-t0}")
    # pet.show() # not useful for large programs
    t2 = time.time()
    print(f"visualization: {t2-t1}")

    plugin_base = PluginBase(package='plugins')

    plugin_source = plugin_base.make_plugin_source(
        searchpath=[Path(__file__).parent / 'plugins'])

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin before: " + plugin_name)
        pet = p.run_before(pet)

    pattern_detector = PatternDetectorX(pet)

    res: DetectionResult = pattern_detector.detect_patterns()

    for plugin_name in plugins:
        p = plugin_source.load_plugin(plugin_name)
        print("executing plugin after: " + plugin_name)
        pet = p.run_after(pet)

    return res
