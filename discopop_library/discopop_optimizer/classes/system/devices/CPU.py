from discopop_library.discopop_optimizer.classes.system.devices.Device import Device


class CPU(Device):
    def __init__(
        self,
        compute_capability,
        thread_count,
        openmp_device_id: int,
        device_specific_compiler_flags: str,
    ):
        super().__init__(
            compute_capability, thread_count, openmp_device_id, device_specific_compiler_flags
        )
