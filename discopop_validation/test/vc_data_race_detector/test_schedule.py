import pytest
from discopop.discopop_validation.vc_data_race_detector.schedule import ScheduleElement, Schedule, UpdateType


class TestSchedule:

    def test_add_update_1(self):
        se = ScheduleElement(0)
        se.add_update("test_var", UpdateType.READ)
        assert len(se.updates) == 1
        se.add_update("second_var", UpdateType.WRITE)
        assert len(se.updates) == 2
        assert se.updates[0][0] == "test_var"
        assert se.updates[0][1] == UpdateType.READ
        assert se.updates[0][2] == []
        assert se.updates[1][0] == "second_var"
        assert se.updates[1][1] == UpdateType.WRITE
        assert se.updates[1][2] == []

    def test_add_update_2(self):
        se = ScheduleElement(0)
        se.add_update("test_var", UpdateType.READ)
        assert len(se.updates) == 1
        se.add_update("second_var", UpdateType.WRITE)
        se.add_update("third_var", UpdateType.LOCK)
        assert len(se.updates) == 3
        assert se.updates[2][0] == "third_var"
        assert se.updates[2][1] == UpdateType.LOCK
        assert se.updates[2][2] == []
        assert se.lock_names == ["third_var"]

    def test_add_element(self):
        schedule = Schedule()
        se1 = ScheduleElement(0)
        se1.add_update("test_var", UpdateType.READ)
        schedule.add_element(se1)
        assert len(schedule.elements) == 1
        se2 = ScheduleElement(0)
        se2.add_update("test_var", UpdateType.READ)
        schedule.add_element(se2)
        assert len(schedule.elements) == 2
        assert schedule.elements[0] == se1
        assert schedule.elements[1] == se2
        assert schedule.lock_names == []
        assert schedule.var_names == ["test_var"]

    def test_add_update_missing_affected_tids(self):
        se1 = ScheduleElement(0)
        with pytest.raises(ValueError):
            se1.add_update("test_var", UpdateType.ENTERPARALLEL)

    def test_add_update_included_affected_tids(self):
        se1 = ScheduleElement(0)
        se1.add_update("test_var", UpdateType.ENTERPARALLEL, [1])
        assert True
