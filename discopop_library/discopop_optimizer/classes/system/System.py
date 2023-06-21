from typing import Dict, List, Tuple, Optional

from sympy import Symbol, Expr

from discopop_library.discopop_optimizer.classes.system.Network import Network
from discopop_library.discopop_optimizer.classes.system.devices.Device import Device


class System(object):
    __devices: Dict[int, Device]
    __network: Network
    __next_free_device_id: int

    def __init__(self):
        self.__devices = dict()
        self.__network = Network()
        self.__next_free_device_id = 0

    # todo: support the replication of device ids (e.g. CPU-0 and GPU-0)

    def add_device(self, device: Device):
        device_id = self.__next_free_device_id
        self.__next_free_device_id += 1
        self.__devices[device_id] = device

    def get_device(self, device_id: Optional[int]) -> Device:
        if device_id is None:
            return self.__devices[0]
        return self.__devices[device_id]

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
