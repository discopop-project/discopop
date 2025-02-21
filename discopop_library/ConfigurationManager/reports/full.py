# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os

from discopop_library.ConfigurationManager.ConfigurationManagerArguments import ConfigurationManagerArguments

import logging

from discopop_library.ConfigurationManager.reports.scaling import generate_scaling_report

logger = logging.getLogger("ConfigurationManager")


def generate_full_report(arguments: ConfigurationManagerArguments) -> None:

    generate_scaling_report(arguments)
