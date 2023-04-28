from sympy import Integer, Symbol  # type: ignore


class Environment(object):

    ## SETTINGS
    workload_overhead_weight = Integer(1500)
    ## END OF SETTINGS

    thread_num: Integer = Symbol("thread_num") # Integer(4)  # thread number spawned by openmp parallel for pragmas