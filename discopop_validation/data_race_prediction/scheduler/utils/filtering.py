from typing import List

from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.classes.UpdateType import UpdateType


def filter_schedules(schedules: List[Schedule]):
    """schedules can contain invalid schedules (such, that violate locking orders (i.e. lock(a)-lock(a)-unlock(a)-unlock(a)).
    Filters out such cases and returns the filters list of valid schedules."""
    invalid_schedule_idx = []
    all_schedule_idx = []
    for idx, schedule in enumerate(schedules):
        all_schedule_idx.append(idx)
        used_locks = []
        breaker = False
        for elem in schedule.elements:
            for var_name, update_type, _, _ in elem.updates:

                if update_type is UpdateType.LOCK:
                    # check if already set lock is set again
                    if var_name in used_locks:
                        invalid_schedule_idx.append(idx)
                        breaker = True
                        break
                    # lock can be set
                    used_locks.append(var_name)
                elif update_type is UpdateType.UNLOCK:
                    # check if already free var is unlocked
                    if var_name not in used_locks:
                        invalid_schedule_idx.append(idx)
                        breaker = True
                        break
                    # lock can be freed
                    used_locks.remove(var_name)
            if breaker:
                break

    for idx in sorted(invalid_schedule_idx, reverse=True):
        schedules.pop(idx)
    return schedules
