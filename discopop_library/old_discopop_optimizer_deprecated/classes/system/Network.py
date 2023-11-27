# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, Tuple, List, Optional, cast

from sympy import Expr, Symbol

from discopop_library.discopop_optimizer.classes.system.devices.Device import Device


class Network(object):
    __transfer_speeds: Dict[Tuple[Device, Device], Expr]  # (MB/s)
    __transfer_initialization_costs: Dict[Tuple[Device, Device], Expr]

    def __init__(self):
        self.__transfer_speeds = dict()
        self.__transfer_initialization_costs = dict()

    def add_connection(self, source: Device, target: Device, transfer_speed: Expr, initialization_delay: Expr):
        self.__transfer_speeds[(source, target)] = transfer_speed
        self.__transfer_initialization_costs[(source, target)] = initialization_delay

    def get_transfer_speed(self, source: Device, target: Device):
        return self.__transfer_speeds[(source, target)]

    def get_transfer_initialization_costs(self, source: Device, target: Device):
        return self.__transfer_initialization_costs[(source, target)]

    def get_free_symbols(self) -> List[Tuple[Symbol, Optional[Expr]]]:
        result_list: List[Tuple[Symbol, Optional[Expr]]] = []
        for expr in self.__transfer_speeds.values():
            result_list += [(cast(Symbol, s), None) for s in expr.free_symbols]
        for expr in self.__transfer_initialization_costs.values():
            result_list += [(cast(Symbol, s), None) for s in expr.free_symbols]
        return result_list
