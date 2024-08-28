# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from __future__ import annotations
from typing import TYPE_CHECKING
import logging

if TYPE_CHECKING:
    from discopop_explorer.discopop_explorer import ExplorerArguments
    from discopop_library.result_classes.DetectionResult import DetectionResult

logger = logging.getLogger("statistics")


def collect_statistics(arguments: ExplorerArguments, res: DetectionResult) -> None:
    logger.info("Collecting code statistics...")
    pass
