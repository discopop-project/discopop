from discopop_library.discopop_optimizer.classes.system.devices.Device import Device


class CPU(Device):
    def __init__(self, compute_capability, thread_count, openmp_device_id: int):
        super().__init__(compute_capability, thread_count, openmp_device_id)
