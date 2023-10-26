# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from pathlib import Path
from typing import Dict

from discopop_library.PatchApplicator.PatchApplicatorArguments import PatchApplicatorArguments


def apply_patches(file_mapping: Dict[int, Path], arguments: PatchApplicatorArguments):
    raise NotImplementedError()
