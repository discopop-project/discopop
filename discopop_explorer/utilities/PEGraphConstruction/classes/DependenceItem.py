# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from dataclasses import dataclass
from typing import Any


@dataclass
class DependenceItem(object):
    sink: Any
    source: Any
    type: Any
    var_name: Any
    memory_region: Any
    is_gep_result_dependency: bool
    metadata: Any
    # TODO improve typing
