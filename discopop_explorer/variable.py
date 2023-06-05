# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import json
from typing import Optional


class Variable(object):
    operation: Optional[str]

    def __init__(self, type, name, defLine, accessMode="", sizeInByte=0):
        self.type = type
        self.name: str = name
        self.defLine = defLine
        self.operation = None
        self.accessMode = accessMode
        # To prevent potentially dividing by 0, set the sizeInByte to 8 in case it is unknown.
        # Sizes are mainly unknown if the underlying variable is a pointer type.
        # Since Pointers in 64-bit architectures occupy 8 bytes, this size is chosen as the "default" at this point.
        if sizeInByte == 0:
            sizeInByte = 8
        self.sizeInByte = sizeInByte

    def __hash__(self):
        return hash(self.name)

    def __eq__(self, other):
        return isinstance(other, Variable) and self.name == other.name

    def __lt__(self, other):
        return self.name < other.name

    def __str__(self):
        return self.name

    def toJSON(self):
        if self.operation is None:
            return self.name
        else:
            return self.operation + ":" + self.name
