import pytest
from .data_race_detector import State, goto_next_state, check_schedule
from .schedule import ScheduleElement, UpdateType, Schedule


class TestDataRaceDetector:

    def test_state_init_1(self):
        state = State(2, ["test_lock"], ["x", "y"])
        assert state.thread_clocks[0].clocks[0] == 1
        assert state.thread_clocks[0].clocks[1] == 0
        assert state.thread_clocks[1].clocks[0] == 0
        assert state.thread_clocks[1].clocks[1] == 1

    def test_state_init_2(self):
        state = State(2, ["test_lock"], ["x", "y"])
        assert state.lock_clocks["test_lock"].clocks == [0, 0]
        assert state.var_read_clocks["x"].clocks == [0, 0]
        assert state.var_read_clocks["y"].clocks == [0, 0]
        assert state.var_write_clocks["x"].clocks == [0, 0]
        assert state.var_write_clocks["y"].clocks == [0, 0]

    def test_perform_update_1(self):
        state = State(3, [], ["x"])
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(1)
        schedule_element_1.add_update("x", UpdateType.WRITE, [])
        state = goto_next_state(state, schedule_element_0)
        state = goto_next_state(state, schedule_element_1)
        assert state.thread_clocks[0].clocks == [2, 0, 0]
        assert state.thread_clocks[1].clocks == [1, 1, 0]
        assert state.thread_clocks[2].clocks == [1, 0, 1]
        assert state.var_read_clocks["x"].clocks == [0, 0, 0]
        assert state.var_write_clocks["x"].clocks == [0, 1, 0]

    def test_data_race_1(self):
        state = State(3, [], ["x"])
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(1)
        schedule_element_1.add_update("x", UpdateType.WRITE, [])
        schedule_element_2 = ScheduleElement(2)
        schedule_element_2.add_update("x", UpdateType.WRITE, [])
        state = goto_next_state(state, schedule_element_0)
        state = goto_next_state(state, schedule_element_1)
        with pytest.raises(ValueError):
            goto_next_state(state, schedule_element_2)

    def test_data_race_2(self):
        state = State(3, ["l"], ["x"])
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(1)
        schedule_element_1.add_update("l", UpdateType.LOCK, [])
        schedule_element_2 = ScheduleElement(1)
        schedule_element_2.add_update("x", UpdateType.WRITE, [])
        schedule_element_3 = ScheduleElement(1)
        schedule_element_3.add_update("l", UpdateType.UNLOCK, [])
        schedule_element_4 = ScheduleElement(2)
        schedule_element_4.add_update("x", UpdateType.READ, [])
        schedule_element_4.add_update("x", UpdateType.WRITE, [])
        state = goto_next_state(state, schedule_element_0)
        state = goto_next_state(state, schedule_element_1)
        state = goto_next_state(state, schedule_element_2)
        state = goto_next_state(state, schedule_element_3)
        assert state.thread_clocks[0].clocks == [2, 0, 0]
        assert state.thread_clocks[1].clocks == [1, 2, 0]
        assert state.thread_clocks[2].clocks == [1, 0, 1]
        assert state.lock_clocks["l"].clocks == [1, 1, 0]
        assert state.var_read_clocks["x"].clocks == [0, 0, 0]
        assert state.var_write_clocks["x"].clocks == [0, 1, 0]
        with pytest.raises(ValueError):
            state = goto_next_state(state, schedule_element_4)

    def test_no_data_race_1(self):
        state = State(3, ["l"], ["x", "y"])
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(2)
        schedule_element_1.add_update("l", UpdateType.LOCK, [])
        schedule_element_2 = ScheduleElement(2)
        schedule_element_2.add_update("x", UpdateType.WRITE, [])
        schedule_element_2.add_update("y", UpdateType.READ, [])
        schedule_element_3 = ScheduleElement(2)
        schedule_element_3.add_update("l", UpdateType.UNLOCK, [])
        schedule_element_4 = ScheduleElement(1)
        schedule_element_4.add_update("l", UpdateType.LOCK, [])
        schedule_element_5 = ScheduleElement(1)
        schedule_element_5.add_update("y", UpdateType.WRITE, [])
        schedule_element_5.add_update("x", UpdateType.READ, [])
        schedule_element_6 = ScheduleElement(1)
        schedule_element_6.add_update("l", UpdateType.UNLOCK, [])
        schedule_element_7 = ScheduleElement(0)
        schedule_element_7.add_update("", UpdateType.EXITPARALLEL, [1, 2])
        schedule_element_8 = ScheduleElement(0)
        schedule_element_8.add_update("y", UpdateType.WRITE, [])
        schedule_element_8.add_update("x", UpdateType.READ, [])
        schedule_element_8.add_update("y", UpdateType.READ, [])
        state = goto_next_state(state, schedule_element_0)
        state = goto_next_state(state, schedule_element_1)
        state = goto_next_state(state, schedule_element_2)
        state = goto_next_state(state, schedule_element_3)
        state = goto_next_state(state, schedule_element_4)
        state = goto_next_state(state, schedule_element_5)
        state = goto_next_state(state, schedule_element_6)
        state = goto_next_state(state, schedule_element_7)
        state = goto_next_state(state, schedule_element_8)
        assert state.thread_clocks[0].clocks == [2, 2, 2]
        assert state.thread_clocks[1].clocks == [1, 3, 1]
        assert state.thread_clocks[2].clocks == [1, 0, 3]
        assert state.lock_clocks["l"].clocks == [1, 1, 1]
        assert state.var_read_clocks["x"].clocks == [2, 1, 0]
        assert state.var_write_clocks["x"].clocks == [0, 0, 1]
        assert state.var_read_clocks["y"].clocks == [2, 0, 1]
        assert state.var_write_clocks["y"].clocks == [2, 1, 0]

    def test_check_schedule_no_data_race(self):
        schedule = Schedule()
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(2)
        schedule_element_1.add_update("l", UpdateType.LOCK, [])
        schedule_element_2 = ScheduleElement(2)
        schedule_element_2.add_update("x", UpdateType.WRITE, [])
        schedule_element_2.add_update("y", UpdateType.READ, [])
        schedule_element_3 = ScheduleElement(2)
        schedule_element_3.add_update("l", UpdateType.UNLOCK, [])
        schedule_element_4 = ScheduleElement(1)
        schedule_element_4.add_update("l", UpdateType.LOCK, [])
        schedule_element_5 = ScheduleElement(1)
        schedule_element_5.add_update("y", UpdateType.WRITE, [])
        schedule_element_5.add_update("x", UpdateType.READ, [])
        schedule_element_6 = ScheduleElement(1)
        schedule_element_6.add_update("l", UpdateType.UNLOCK, [])
        schedule_element_7 = ScheduleElement(0)
        schedule_element_7.add_update("", UpdateType.EXITPARALLEL, [1, 2])
        schedule_element_8 = ScheduleElement(0)
        schedule_element_8.add_update("y", UpdateType.WRITE, [])
        schedule_element_8.add_update("x", UpdateType.READ, [])
        schedule_element_8.add_update("y", UpdateType.READ, [])
        schedule.add_element(schedule_element_0)
        schedule.add_element(schedule_element_1)
        schedule.add_element(schedule_element_2)
        schedule.add_element(schedule_element_3)
        schedule.add_element(schedule_element_4)
        schedule.add_element(schedule_element_5)
        schedule.add_element(schedule_element_6)
        schedule.add_element(schedule_element_7)
        schedule.add_element(schedule_element_8)
        assert check_schedule(schedule) is None

    def test_check_schedule_data_race(self):
        schedule = Schedule()
        schedule_element_0 = ScheduleElement(0)
        schedule_element_0.add_update("", UpdateType.ENTERPARALLEL, [1, 2])
        schedule_element_1 = ScheduleElement(1)
        schedule_element_1.add_update("x", UpdateType.WRITE, [])
        schedule_element_2 = ScheduleElement(2)
        schedule_element_2.add_update("x", UpdateType.WRITE, [])
        schedule_element_3 = ScheduleElement(0)
        schedule_element_3.add_update("", UpdateType.EXITPARALLEL, [1, 2])
        schedule.add_element(schedule_element_0)
        schedule.add_element(schedule_element_1)
        schedule.add_element(schedule_element_2)
        schedule.add_element(schedule_element_3)
        ret_val = check_schedule(schedule)
        assert ret_val is not None
        dr_state, dr_schedule_element = ret_val
        assert dr_state.thread_clocks[0].clocks == [2, 0, 0]
        assert dr_state.thread_clocks[1].clocks == [1, 1, 0]
        assert dr_state.thread_clocks[2].clocks == [1, 0, 1]
        assert dr_state.var_read_clocks["x"].clocks == [0, 0, 0]
        assert dr_state.var_write_clocks["x"].clocks == [0, 1, 1]
        assert dr_schedule_element == schedule_element_2
