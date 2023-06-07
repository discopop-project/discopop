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

    def __str__(self):
        return (
            "Update("
            + str(self.source_node_id)
            + "@"
            + str(self.source_device_id)
            + ", "
            + str(self.target_node_id)
            + "@"
            + str(self.target_device_id)
            + ", "
            + " : "
            + str(self.write_data_access.memory_region)
            + ")"
        )