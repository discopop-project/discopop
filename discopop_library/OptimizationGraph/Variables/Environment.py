from typing import Dict

from sympy import Integer, Symbol, Expr, Float  # type: ignore


class Environment(object):
    ## SETTINGS
    # todo: convert Costs into estimated runtime, removes need for high overhead weight
    workload_overhead_weight = Integer(1500)
    do_all_overhead_weight_by_device: Dict[int, Expr] = {
        0: Integer(1500),
        1: Integer(3500),
        2: Integer(500),
    }

    # transfer_speeds: {source_device: {target_device: transfer speed}} (MB/s)
    same_device_transfer_speed: Expr = Integer(100000)
    transfer_speeds: Dict[int, Dict[int, Expr]] = {
        0: {0: same_device_transfer_speed, 1: same_device_transfer_speed, 2: Integer(1000)},
        1: {0: same_device_transfer_speed, 1: same_device_transfer_speed, 2: Integer(1000)},
        2: {0: Integer(1000), 1: Integer(1000), 2: same_device_transfer_speed}
    }
    ## END OF SETTINGS

    thread_num: Integer = Symbol(
        "CPU_thread_num"
    )  # Integer(4)  # thread number spawned by openmp parallel for pragmas
    thread_counts_by_device: Dict[int, Expr] = {
        0: Integer(1),
        1: thread_num,
        2: Symbol("GPU_thread_num"),
    }  # Integer(256)}
