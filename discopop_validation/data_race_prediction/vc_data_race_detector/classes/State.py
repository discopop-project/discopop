from typing import Dict, List

from .VectorClock import VectorClock


class State(object):
    # represents a state of the data race detector. Updated by each element of schedule.
    thread_count: int
    thread_clocks: Dict[int, VectorClock] = dict()
    lock_clocks: Dict[str, VectorClock] = dict()
    var_read_clocks: Dict[str, VectorClock] = dict()
    var_write_clocks: Dict[str, VectorClock] = dict()

    def __init__(self, thread_count: int, lock_names: List[str], var_names: List[str]):
        self.thread_count = thread_count
        self.thread_clocks = dict()
        self.lock_clocks = dict()
        self.var_read_clocks = dict()
        self.var_write_clocks = dict()
        for i in range(thread_count):
            self.thread_clocks[i] = VectorClock(thread_count)
            self.thread_clocks[i].clocks[i] = 1
        for l_name in lock_names:
            self.lock_clocks[l_name] = VectorClock(thread_count)
        for v_name in var_names:
            self.var_read_clocks[v_name] = VectorClock(thread_count)
            self.var_write_clocks[v_name] = VectorClock(thread_count)

    def __str__(self):
        return "Thread clocks: " + " ".join([str(key)+":"+str(self.thread_clocks[key]) for key in self.thread_clocks]) + "\n" + \
               "Lock clocks: " + " ".join([str(key)+":"+str(self.lock_clocks[key]) for key in self.lock_clocks]) + "\n" + \
               "Var Read clocks: " + " ".join([str(key)+":"+str(self.var_read_clocks[key]) for key in self.var_read_clocks]) + "\n" + \
               "Var Write clocks: " + " ".join([str(key)+":"+str(self.var_write_clocks[key]) for key in self.var_write_clocks])

    def __eq__(self, other):
        if type(other) != State:
            return False
        if self.thread_clocks != other.thread_clocks or \
            self.lock_clocks != other.lock_clocks or \
            self.var_read_clocks != other.var_read_clocks or \
            self.var_write_clocks != other.var_write_clocks:
            return False
        return True

    def add_var_entries_if_missing(self, var_name):
        if var_name not in self.lock_clocks:
            self.lock_clocks[var_name] = VectorClock(self.thread_count)
        if var_name not in self.var_read_clocks:
            self.var_read_clocks[var_name] = VectorClock(self.thread_count)
        if var_name not in self.var_write_clocks:
            self.var_write_clocks[var_name] = VectorClock(self.thread_count)