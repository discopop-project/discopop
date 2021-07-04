from typing import List


class VectorClock(object):
    clocks: List[int] = []
    length: int = -1

    def __init__(self, thread_count: int):
        """ initialize vector clock to contain <value of thread_count> zero´s.
        :param thread_count: amount of threads used in corresponding schedule.
        """
        self.clocks = []
        for i in range(thread_count):
            self.clocks += [0]
        self.length = thread_count

    def __str__(self):
        return "(" + " ".join([str(c) for c in self.clocks]) + ")"


def get_updated_vc(vc_1: VectorClock, vc_2: VectorClock) -> VectorClock:
    """calculate and return the updated vector clock on the basis of vc_1 and vc_2.
    Raises ValueError, if the length of vc_1 and vc_2 differ.
    :param vc_1: VectorClock
    :param vc_2: VectorClock
    :return: Updated VectorClock"""
    if vc_1.length != vc_2.length:
        raise ValueError("non-matching lengths: ", vc_1.length, vc_2.length)
    result = VectorClock(vc_1.length)
    for i in range(vc_1.length):
        tmp_val_1 = vc_1.clocks[i]
        tmp_val_2 = vc_2.clocks[i]
        result.clocks[i] = tmp_val_1 if tmp_val_1 >= tmp_val_2 else tmp_val_2
    return result


def compare_vc(vc_1: VectorClock, vc_2: VectorClock) -> bool:
    """compares vc_1 and vc_2 element wise.
    Returns True, if each element of vc_1 is smaller or equal to vc_2´s corresponding element.
    Returns False, otherwise.
    Raises ValueError, if the length of vc_1 is greater than the length of vc_2.
    :param vc_1: Vector Clock
    :param vc_2: Vector Clock
    :return: Boolean
    """
    if vc_1.length > vc_2.length:
        raise ValueError("vc_1 longer than vc_2: ", vc_1.length, vc_2.length)
    result: bool = True
    for i in range(vc_1.length):
        if vc_1.clocks[i] > vc_2.clocks[i]:
            result = False
    return result


def increase(vc: VectorClock, idx: int) -> VectorClock:
    """increases the clock value of vc stored at index idx by one.
    Raises ValueError, if idx is greater than vc.length.
    :param vc: Vector Clock to be modified
    :param idx: index of the counter to be increased
    :return: Vector Clock with increased value"""
    if idx > vc.length:
        raise ValueError("idx greater than vc.length: ", idx, vc.length)
    vc.clocks[idx] = vc.clocks[idx] + 1
    return vc
