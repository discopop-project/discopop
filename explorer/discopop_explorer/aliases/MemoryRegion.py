# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from __future__ import annotations


class MemoryRegion(str):
    """Identity of the variable an access belongs to: the N of `var(N)` in the profiler's dependency files.

    The profiler does not track allocations: N is the address of the variable name the instrumentation
    passes to the runtime, so accesses to the same variable share a region and nothing is known about
    the allocation behind it (its size, or whether two names alias)."""

    # simpler but still strong typing alternative:
    def __init__(self, id_string: str):
        super().__init__()
        pass
