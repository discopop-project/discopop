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
[--cu-inst-res <cuinstres>] [--llvm-cxxfilt-path <cxxfp>] [--generate-data-cu-inst <outputdir>]

Options:
    --path=<path>               Directory with input data [default: ./]
    --cu-xml=<cuxml>            CU node xml file [default: Data.xml]
    --dep-file=<depfile>        Dependencies text file [default: dp_run_dep.txt]
    --loop-counter=<loopcount>  Loop counter data [default: loop_counter_output.txt]
    --reduction=<reduction>     Reduction variables file [default: reduction.txt]
    --fmap=<fmap>               File mapping [default: FileMapping.txt]
    --json=<json_out>           Json output
    --plugins=<plugs>           Plugins to execute
    --cu-inst-res=<cuinstres>   CU instantiation result file. Task Pattern Detector is executed if this option is set.
    --llvm-cxxfilt-path=<cxxfp> Path to llvm-cxxfilt executable. Required for Task Pattern Detector
                                if non-standard path should be used.
    --generate-data-cu-inst=<outputdir>     Generates Data_CUInst.txt file and stores it in the given directory.
                                            Stops the regular execution of the discopop_explorer.
                                            Requires --cu-xml, --dep-file, --loop-counter, --reduction.
    -h --help                   Show this screen
"""

import json
import os
import sys
import time

from docopt import docopt  # type:ignore
from schema import Schema, Use, SchemaError  # type:ignore

from . import run, __version__
from .json_serializer import PatternInfoSerializer

docopt_schema = Schema({
    '--path': Use(str),
    '--cu-xml': Use(str),
    '--dep-file': Use(str),
    '--loop-counter': Use(str),
    '--reduction': Use(str),
    '--fmap': Use(str),
    '--plugins': Use(str),
    '--json': Use(str),
    '--cu-inst-res': Use(str),
    '--llvm-cxxfilt-path': Use(str),
    '--generate-data-cu-inst': Use(str),
})


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

    path = arguments['--path']

    cu_xml = get_path(path, arguments['--cu-xml'])
    dep_file = get_path(path, arguments['--dep-file'])
    loop_counter_file = get_path(path, arguments['--loop-counter'])
    reduction_file = get_path(path, arguments['--reduction'])
    file_mapping = get_path(path, 'FileMapping.txt')
    cu_inst_result_file = get_path(path, arguments['--cu-inst-res'])

    for file in [cu_xml, dep_file, loop_counter_file, reduction_file]:
        if not os.path.isfile(file):
            print(f"File not found: \"{file}\"")
            sys.exit()

    plugins = [] if arguments['--plugins'] == 'None' else arguments['--plugins'].split(' ')

    if arguments['--generate-data-cu-inst'] != 'None':
        # start generation of Data_CUInst and stop execution afterwards
        from .generate_Data_CUInst import wrapper as generate_data_cuinst_wrapper
        generate_data_cuinst_wrapper(cu_xml, dep_file, loop_counter_file, reduction_file,
                                     arguments['--generate-data-cu-inst'])
        sys.exit(0)

    start = time.time()

    res = run(cu_xml, dep_file, loop_counter_file, reduction_file, plugins, file_mapping=file_mapping,
              cu_inst_result_file=cu_inst_result_file, llvm_cxxfilt_path=arguments['--llvm-cxxfilt-path'])

    end = time.time()

    if arguments['--json'] == 'None':
        print(str(res))
    else:
        with open(arguments['--json'], 'w') as f:
            json.dump(res, f, indent=2, cls=PatternInfoSerializer)

    print("Time taken for pattern detection: {0}".format(end - start))


if __name__ == "__main__":
    main()
