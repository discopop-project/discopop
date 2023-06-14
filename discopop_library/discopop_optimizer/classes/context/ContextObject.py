from typing import Dict, Set, Tuple, cast, List, Optional

from sympy import Expr, Integer, Symbol  # type: ignore

from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.Variables.Experiment import Experiment
from discopop_library.discopop_optimizer.classes.context.Update import Update
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.discopop_optimizer.classes.types.DataAccessType import (
    WriteDataAccess,
    ReadDataAccess,
)


class ContextObject(object):
    last_visited_node_id: int
    last_seen_device_ids: List[DeviceID]
    seen_writes_by_device: Dict[DeviceID, Dict[MemoryRegion, Set[WriteDataAccess]]]
    necessary_updates: Set[Update]

    def __init__(
        self, initializing_node_id: int, last_seen_device_ids: Optional[List[DeviceID]] = None
    ):
        self.seen_writes_by_device = dict()
        self.necessary_updates = set()
        self.last_visited_node_id = initializing_node_id
        self.last_seen_device_ids = last_seen_device_ids if last_seen_device_ids is not None else []
        self.snapshot_stack = []  # type: ignore
        self.save_stack = []  # type: ignore  # list of lists of ContextObjects, one list per branching depth

    def __str__(self):
        return str(self.necessary_updates)

    def calculate_and_perform_necessary_updates(
        self, node_reads: Set[ReadDataAccess], reading_device_id: int, reading_node_id: int
    ):
        """checks if the specified list of ReadDataAccesses performed by the specified device id makes updates
        necessary. If so, the updates will get append to the list of updates of the current ContextObject.
        The list of seen writes by device of the ContextObject will be updated to reflect the identified data transfers.
        A reference to the object is returned."""
        required_updates: Set[Update] = set()
        for read in node_reads:
            # check if the reading device has the latest view of the memory
            for device_id in self.seen_writes_by_device:
                if device_id == reading_device_id:
                    continue
                if read.memory_region not in self.seen_writes_by_device[device_id]:
                    # read memory region is currently "unknown" to the device, thus is can be skipped
                    continue
                other_devices_known_writes = self.seen_writes_by_device[device_id][
                    read.memory_region
                ]

                is_first_data_occurrence = False
                if read.memory_region not in self.seen_writes_by_device[reading_device_id]:
                    # reading device does not currently "know" about the read memory region. create a new entry.
                    self.seen_writes_by_device[reading_device_id][read.memory_region] = set()
                    is_first_data_occurrence = True

                known_writes = self.seen_writes_by_device[reading_device_id]
                unknown_writes = other_devices_known_writes.difference(known_writes)

                for data_write in unknown_writes:
                    required_updates.add(
                        Update(
                            source_node_id=self.last_visited_node_id,
                            target_node_id=reading_node_id,
                            source_device_id=device_id,
                            target_device_id=reading_device_id,
                            write_data_access=data_write,
                            is_first_data_occurrence=is_first_data_occurrence,
                        )
                    )
                    # print("--> UPDATE registired")

        # todo: check if this is sufficient
        for update in required_updates:
            self.seen_writes_by_device[update.target_device_id][
                update.write_data_access.memory_region
            ].add(update.write_data_access)

        self.necessary_updates.update(required_updates)
        return self

    def add_writes(self, node_writes: Set[WriteDataAccess], writing_device_id: int):
        """Add the specified writes to the list of seen writes of the given device
        and returns a reference to this ContextObject."""
        # check if the device is known to the context
        if writing_device_id not in self.seen_writes_by_device:
            self.seen_writes_by_device[writing_device_id] = dict()

        for write in node_writes:
            # check if memory region is already present in self.seen_writes_by_device before adding the write access
            if write.memory_region not in self.seen_writes_by_device[writing_device_id]:
                self.seen_writes_by_device[writing_device_id][write.memory_region] = set()
            # add write to the list of seen writes
            self.seen_writes_by_device[writing_device_id][write.memory_region].add(write)
        return self

    def get_transfer_costs(self, environment: Experiment) -> CostModel:
        """Calculates the amount of data transferred between devices as specified by self.necessary_updates and
        calculates an estimation for the added transfer costs under the assumption,
        that no transfers happen concurrently and every transfer is executed in a blocking, synchronous manner.
        """
        total_transfer_costs = Integer(0)
        symbolic_memory_region_sizes = True
        symbol_value_suggestions = dict()
        for update in self.necessary_updates:
            # add static costs incurred by the transfer initialization
            system = environment.get_system()
            source_device = system.get_device(cast(int, update.source_device_id))
            target_device = system.get_device(cast(int, update.target_device_id))
            initialization_costs = system.get_network().get_transfer_initialization_costs(
                source_device, target_device
            )

            total_transfer_costs += initialization_costs

            # add costs incurred by the transfer itself
            transfer_speed = system.get_network().get_transfer_speed(source_device, target_device)

            # value suggestion used for symbolic values
            transfer_size, value_suggestion = environment.get_memory_region_size(
                update.write_data_access.memory_region,
                use_symbolic_value=symbolic_memory_region_sizes,
            )
            # save suggested memory region size from Environment
            if symbolic_memory_region_sizes:
                symbol_value_suggestions[cast(Symbol, transfer_size)] = value_suggestion

            transfer_costs = transfer_size / transfer_speed

            total_transfer_costs += transfer_costs
        if symbolic_memory_region_sizes:
            return CostModel(
                Integer(0), total_transfer_costs, symbol_value_suggestions=symbol_value_suggestions
            )
        else:
            return CostModel(Integer(0), total_transfer_costs)

    def set_last_visited_node_id(self, node_id: int):
        self.last_visited_node_id = node_id
