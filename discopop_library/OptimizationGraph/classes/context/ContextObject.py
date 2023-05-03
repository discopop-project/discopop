from typing import Dict, Set

from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.OptimizationGraph.CostModels.CostModel import CostModel
from discopop_library.OptimizationGraph.classes.context.Update import Update
from discopop_library.OptimizationGraph.classes.types.Aliases import DeviceID
from discopop_library.OptimizationGraph.classes.types.DataAccessType import (
    WriteDataAccess,
    ReadDataAccess,
)


class ContextObject(object):
    last_visited_node_id: int
    last_seen_device_id: DeviceID
    seen_writes_by_device: Dict[DeviceID, Dict[MemoryRegion, Set[WriteDataAccess]]]
    necessary_updates: Set[Update]

    def __init__(self, initializing_node_id: int, last_seen_device_id: DeviceID = None):
        self.seen_writes_by_device = dict()
        self.necessary_updates = set()
        self.last_visited_node_id = initializing_node_id
        self.last_seen_device_id = last_seen_device_id

    def __str__(self):
        return str(self.necessary_updates)

    def merge(self, other):
        raise NotImplementedError("TODO")

    def calculate_and_perform_necessary_updates(self, node_reads: Set[ReadDataAccess], reading_device_id: int,
                                                reading_node_id: int):
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
                other_devices_known_writes = self.seen_writes_by_device[device_id][read.memory_region]

                if read.memory_region not in self.seen_writes_by_device[reading_device_id]:
                    # reading device does not currently "know" about the read memory region. create a new entry.
                    self.seen_writes_by_device[reading_device_id][read.memory_region] = set()

                known_writes = self.seen_writes_by_device[reading_device_id]
                unknown_writes = other_devices_known_writes.difference(known_writes)
                for data_write in unknown_writes:
                    required_updates.add(
                        Update(source_node_id=self.last_visited_node_id, target_node_id=reading_node_id,
                               source_device_id=device_id, target_device_id=reading_device_id,
                               write_data_access=data_write))


        # todo: check if this is sufficient
        for update in required_updates:
            self.seen_writes_by_device[update.target_device_id][update.write_data_access.memory_region].add(update.write_data_access)

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


    def get_transfer_costs(self) -> CostModel:
        """Replaces the planned storage of update information for individual graph edges.
        Sums and returns the transfert costs represented by the current ContextObject."""
        raise NotImplementedError("TODO")

    def set_last_visited_node_id(self, node_id: int):
        self.last_visited_node_id = node_id
