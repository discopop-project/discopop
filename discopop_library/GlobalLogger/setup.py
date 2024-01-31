# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging

from discopop_library.ArgumentClasses.GeneralArguments import GeneralArguments


def setup_logger(arguments: GeneralArguments):
    if arguments.write_log:
        logging.basicConfig(filename="log.txt", level=arguments.log_level)
    else:
        logging.basicConfig(
            level=arguments.log_level,
            format="[DP][%(name)s] %(levelname)s: %(message)s",  # "[DiscoPoP][%(name)s] %(levelname)s: %(asctime)s: %(message)s"
        )

    logger = logging.getLogger("GlobalLogger")

    # create console handler and set level to debug
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)

    # create formatter
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")

    # add formatter to ch
    ch.setFormatter(formatter)

    # add ch to logger
    logger.addHandler(ch)

    logger.info("Logger configured")
