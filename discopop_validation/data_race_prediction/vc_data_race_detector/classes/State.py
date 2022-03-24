from typing import Dict, List

from .VectorClock import VectorClock, get_updated_vc


class State(object):
    # represents a state of the data race detector. Updated by each element of schedule.
    thread_count: int
    thread_clocks: Dict[int, VectorClock] = dict()
    lock_clocks: Dict[str, VectorClock] = dict()
    var_read_clocks: Dict[str, VectorClock] = dict()
    var_write_clocks: Dict[str, VectorClock] = dict()
    thread_id_to_clock_position_dict: Dict[int, int]

    def __init__(self, thread_count: int, lock_names: List[str], var_names: List[str]):
        self.thread_count = thread_count
        self.thread_clocks = dict()
        self.lock_clocks = dict()
        self.var_read_clocks = dict()
        self.var_write_clocks = dict()
        self.thread_id_to_clock_position_dict = dict()
        for i in range(thread_count):
            self.thread_clocks[i] = VectorClock(thread_count)
            self.thread_clocks[i].clocks[i] = 1
            self.thread_id_to_clock_position_dict[i] = [i]
        for l_name in lock_names:
            self.lock_clocks[l_name] = VectorClock(thread_count)
        for v_name in var_names:
            self.var_read_clocks[v_name] = VectorClock(thread_count)
            self.var_write_clocks[v_name] = VectorClock(thread_count)

    def fill_to_thread_count(self, new_thread_count):
        for i in range(self.thread_count, new_thread_count):
            for key in self.thread_clocks:
                self.thread_clocks[key].add_clock()
            for key in self.lock_clocks:
                self.lock_clocks[key].add_clock()
            for key in self.var_read_clocks:
                self.var_read_clocks[key].add_clock()
            for key in self.var_write_clocks:
                self.var_write_clocks[key].add_clock()
        while self.thread_count < new_thread_count:
            self.thread_clocks[self.thread_count] = VectorClock(new_thread_count)
            self.thread_count += 1

    def create_new_entries(self, thread_id):
        for key in self.thread_clocks:
            self.thread_clocks[key].add_clock()
        for key in self.lock_clocks:
            self.lock_clocks[key].add_clock()
        for key in self.var_read_clocks:
            self.var_read_clocks[key].add_clock()
        for key in self.var_write_clocks:
            self.var_write_clocks[key].add_clock()
        self.thread_id_to_clock_position_dict[thread_id] = self.thread_count
        self.thread_count += 1
        self.thread_clocks[thread_id] = VectorClock(self.thread_count)

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

    def remove_clocks_with_fingerprint(self, fingerprint: str):
        """removes clocks which have been created for the given fingerprint"""
        # keys which end with _+fingerprint need to be removed from the dictionaries
        # get keys which shall be removed
        remove_keys: List[str] = []
        for key in self.lock_clocks.keys():
            if key.endswith("_"+fingerprint):
                remove_keys.append(key)
        for key in remove_keys:
            del self.lock_clocks[key]
            del self.var_read_clocks[key]
            del self.var_write_clocks[key]