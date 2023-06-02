from discopop_explorer.PETGraphX import MemoryRegion
from discopop_library.discopop_optimizer.classes.types.Aliases import DeviceID
from discopop_library.discopop_optimizer.classes.types.DataAccessType import WriteDataAccess


class Update(object):
    source_node_id: int
    target_node_id: int
    source_device_id: DeviceID
    target_device_id: DeviceID
    write_data_access: WriteDataAccess

    def __init__(
        self,
        source_node_id: int,
        target_node_id: int,
        source_device_id: DeviceID,
        target_device_id: DeviceID,
        write_data_access: WriteDataAccess,
    ):
        self.source_node_id = source_node_id
        self.target_node_id = target_node_id
        self.source_device_id = source_device_id
        self.target_device_id = target_device_id
        self.write_data_access = write_data_access
