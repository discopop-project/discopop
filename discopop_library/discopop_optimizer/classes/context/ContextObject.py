# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, Set, List, Optional

from sympy import Expr, Integer, Symbol  # type: ignore

from discopop_explorer.PEGraphX import MemoryRegion
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

    def __init__(self, initializing_node_id: int, last_seen_device_ids: Optional[List[DeviceID]] = None):
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
                # todo test
                required_updates = set()

                if device_id == reading_device_id:
                    continue
                if read.memory_region not in self.seen_writes_by_device[device_id]:
                    # read memory region is currently "unknown" to the device, thus is can be skipped
                    continue
                other_devices_known_writes = self.seen_writes_by_device[device_id][read.memory_region]

                is_first_data_occurrence = False
                if read.memory_region not in self.seen_writes_by_device[reading_device_id]:
                    # reading device does not currently "know" about the read memory region. create a new entry.
                    self.seen_writes_by_device[reading_device_id][read.memory_region] = set()
                    is_first_data_occurrence = True

                known_writes = self.seen_writes_by_device[reading_device_id][read.memory_region]
                unknown_writes = other_devices_known_writes.difference(known_writes)

                # todo debug: test: only consider the "latest" write
                unknown_writes_dict = dict()
                for entry in unknown_writes:
                    if entry.memory_region not in unknown_writes_dict:
                        unknown_writes_dict[entry.memory_region] = entry
                    else:
                        if unknown_writes_dict[entry.memory_region].unique_id < entry.unique_id:
                            # replace old write with "newer" write
                            unknown_writes_dict[entry.memory_region] = entry

                # unknown_writes = {max(unknown_writes, key=lambda x: x.unique_id)}
                unknown_writes = set(unknown_writes_dict.values())

                for data_write in unknown_writes:
                    # if device <-> device update is required, split it into two distinct updates
                    if device_id != 0 and reading_device_id != 0:
                        #                         print("Device <-> Device update required!")

                        # check if data is known to the host
                        if data_write.memory_region not in self.seen_writes_by_device[0]:
                            self.seen_writes_by_device[0][data_write.memory_region] = set()
                        if data_write not in self.seen_writes_by_device[0][data_write.memory_region]:
                            # register source device -> host update
                            required_updates.add(
                                Update(
                                    source_node_id=self.last_visited_node_id,
                                    target_node_id=reading_node_id,
                                    source_device_id=device_id,
                                    target_device_id=0,  # reading_device_id,
                                    write_data_access=data_write,
                                    is_first_data_occurrence=is_first_data_occurrence,
                                )
                            )
                        #                        else:
                        #                            print(
                        #                                "SKIPPED KNOWN WRITE: ",
                        #                                str(
                        #                                    Update(
                        #                                        source_node_id=self.last_visited_node_id,
                        #                                        target_node_id=reading_node_id,
                        #                                        source_device_id=device_id,
                        #                                        target_device_id=0,  # reading_device_id,
                        #                                        write_data_access=data_write,
                        #                                        is_first_data_occurrence=is_first_data_occurrence,
                        #                                    )
                        #                                ),
                        #                            )

                        # register host -> target device update
                        required_updates.add(
                            Update(
                                source_node_id=self.last_visited_node_id,
                                target_node_id=reading_node_id,
                                source_device_id=0,  # device_id,
                                target_device_id=reading_device_id,
                                write_data_access=data_write,
                                is_first_data_occurrence=is_first_data_occurrence,
                            )
                        )

                    else:
                        # Host -> Device or Device -> Host update
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

                # todo: check if this is sufficient
                for update in required_updates:
                    if (
                        update.write_data_access.memory_region
                        not in self.seen_writes_by_device[update.target_device_id]
                    ):
                        self.seen_writes_by_device[update.target_device_id][
                            update.write_data_access.memory_region
                        ] = set()
                    self.seen_writes_by_device[update.target_device_id][update.write_data_access.memory_region].add(
                        update.write_data_access
                    )

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

    def set_last_visited_node_id(self, node_id: int):
        self.last_visited_node_id = node_id
