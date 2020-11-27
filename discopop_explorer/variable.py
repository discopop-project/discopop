# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


class Variable(object):
    operation: str

    def __init__(self, type, name):
        self.type = type
        self.name = name
        self.operation = None

    def __hash__(self):
        return hash(self.name)  # hash(self.type + self.name)

    def __eq__(self, other):
        return isinstance(other, Variable) and self.name == other.name  # and self.type == other.type

    def __str__(self):
        return self.name
