# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import warnings
from typing import Dict, List, Tuple, Optional

from sympy import Float, Symbol, Expr, Integer
from discopop_library.discopop_optimizer.classes.enums.Distributions import FreeSymbolDistribution

from discopop_library.discopop_optimizer.classes.system.Network import Network
from discopop_library.discopop_optimizer.classes.system.devices.CPU import CPU
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device
from discopop_library.discopop_optimizer.classes.system.devices.GPU import GPU
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments


class System(object):
    __devices: Dict[int, Device]
    __network: Network
    __next_free_device_id: int
    __device_do_all_overhead_models: Dict[Device, Expr]
    __device_reduction_overhead_models: Dict[Device, Expr]
    __symbol_substitutions: List[
        Tuple[
            Symbol,
            Optional[float],
            Optional[float],
            Optional[float],
            Optional[FreeSymbolDistribution],
        ]
    ]

    def __init__(self, arguments: OptimizerArguments):
        self.__devices = dict()
        self.__network = Network()
        self.__next_free_device_id = 0
        self.__device_do_all_overhead_models = dict()
        self.__device_reduction_overhead_models = dict()
        self.__symbol_substitutions = []

        # define a default system
        # todo replace with benchmark results and / or make user definable
        device_0_threads = Symbol("device_0_threads")  # Integer(48)
        # register substitution
        self.__symbol_substitutions.append(
            (device_0_threads, float(16), float(1), float(16), FreeSymbolDistribution.RIGHT_HEAVY)
        )

        device_0 = CPU(
            Integer(3000000000),
            device_0_threads,
            openmp_device_id=-1,
            device_specific_compiler_flags="COMPILE FOR CPU",
        )  # Device 0 always acts as the host system
        gpu_compiler_flags = "COMPILE FOR CPU"
        device_1 = GPU(
            Integer(512000000),
            Integer(512),
            openmp_device_id=0,
            device_specific_compiler_flags="COMPILE FOR GPU",
        )
        device_2 = GPU(
            Integer(512000000),
            Integer(512),
            openmp_device_id=1,
            device_specific_compiler_flags="COMPILE FOR GPU",
        )
        self.add_device(device_0)
        self.add_device(device_1)
        self.add_device(device_2)
        # define Network
        network = self.get_network()
        network.add_connection(device_0, device_0, Integer(100000), Integer(0))
        network.add_connection(device_0, device_1, Integer(10000), Integer(1000000))
        network.add_connection(device_1, device_0, Integer(10000), Integer(1000000))
        network.add_connection(device_1, device_1, Integer(100000), Integer(0))

        network.add_connection(device_0, device_2, Integer(100), Integer(10000000))
        network.add_connection(device_2, device_0, Integer(100), Integer(10000000))
        network.add_connection(device_2, device_2, Integer(1000), Integer(0))

        network.add_connection(device_1, device_2, Integer(100), Integer(500000))
        network.add_connection(device_2, device_1, Integer(100), Integer(500000))

    # todo: support the replication of device ids (e.g. CPU-0 and GPU-0)

    def set_device_doall_overhead_model(self, device: Device, model: Expr):
        print("System: Set DOALL overhead model: ", model)
        self.__device_do_all_overhead_models[device] = model

    def set_reduction_overhead_model(self, device: Device, model: Expr):
        print("System: Set REDUCTION overhead model: ", model)
        self.__device_reduction_overhead_models[device] = model

    def get_device_doall_overhead_model(self, device: Device) -> Expr:
        if device not in self.__device_do_all_overhead_models:
            warnings.warn("No DOALL overhead model, assuming 0 for device: " + str(device))
            return Expr(Integer(0))
        return self.__device_do_all_overhead_models[device]

    def get_device_reduction_overhead_model(self, device: Device) -> Expr:
        if device not in self.__device_reduction_overhead_models:
            warnings.warn("No REDUCTION overhead model, assuming 0 for device: " + str(device))
            return Expr(Integer(0))
        return self.__device_reduction_overhead_models[device]

    def add_device(self, device: Device):
        device_id = self.__next_free_device_id
        self.__next_free_device_id += 1
        self.__devices[device_id] = device

    def get_device(self, device_id: Optional[int]) -> Device:
        if device_id is None:
            return self.__devices[0]
        return self.__devices[device_id]

    def get_device_ids_by_type(self, device_type: type) -> List[int]:
        result_device_ids = []
        for device_id in self.__devices:
            if type(self.__devices[device_id]) == device_type:
                result_device_ids.append(device_id)
        return result_device_ids

    def get_network(self) -> Network:
        return self.__network

    def get_free_symbols(self) -> List[Tuple[Symbol, Optional[Expr]]]:
        result_list: List[Tuple[Symbol, Optional[Expr]]] = []
        for device in self.__devices.values():
            result_list += device.get_free_symbols()
        result_list += self.__network.get_free_symbols()
        return result_list

    def get_device_id(self, device: Device) -> int:
        for key in self.__devices:
            if device == self.__devices[key]:
                return key
        raise ValueError("Unknown device: ", device)

    def get_symbol_values_and_distributions(
        self,
    ) -> List[Tuple[Symbol, Optional[float], Optional[float], Optional[float], Optional[FreeSymbolDistribution]]]:
        return self.__symbol_substitutions
