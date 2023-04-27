from sympy import Integer, Symbol  # type: ignore


class Environment(object):

    thread_num: Integer = Symbol("thread_num") # Integer(4)  # thread number spawned by openmp parallel for pragmas