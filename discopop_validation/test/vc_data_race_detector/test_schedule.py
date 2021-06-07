import unittest
from discopop.discopop_validation.vc_data_race_detector.schedule import ScheduleElement, Schedule, UpdateType


class TestSchedule(unittest.TestCase):

    def test_add_update_1(self):
        se = ScheduleElement(0)
        se.add_update("test_var", UpdateType.READ)
        self.assertEqual(len(se.updates), 1)
        se.add_update("second_var", UpdateType.WRITE)
        self.assertEqual(len(se.updates), 2)
        self.assertEqual(se.updates[0][0], "test_var")
        self.assertEqual(se.updates[0][1], UpdateType.READ)
        self.assertEqual(se.updates[0][2], [])
        self.assertEqual(se.updates[1][0], "second_var")
        self.assertEqual(se.updates[1][1], UpdateType.WRITE)
        self.assertEqual(se.updates[1][2], [])

    def test_add_update_2(self):
        se = ScheduleElement(0)
        se.add_update("test_var", UpdateType.READ)
        self.assertEqual(len(se.updates), 1)
        se.add_update("second_var", UpdateType.WRITE)
        se.add_update("third_var", UpdateType.LOCK)
        self.assertEqual(len(se.updates), 3)
        self.assertEqual(se.updates[2][0], "third_var")
        self.assertEqual(se.updates[2][1], UpdateType.LOCK)
        self.assertEqual(se.updates[2][2], [])
        self.assertEqual(se.lock_names, ["third_var"])

    def test_add_element(self):
        schedule = Schedule()
        se1 = ScheduleElement(0)
        se1.add_update("test_var", UpdateType.READ)
        schedule.add_element(se1)
        self.assertEqual(len(schedule.elements), 1)
        se2 = ScheduleElement(0)
        se2.add_update("test_var", UpdateType.READ)
        schedule.add_element(se2)
        self.assertEqual(len(schedule.elements), 2)
        self.assertEqual(schedule.elements[0], se1)
        self.assertEqual(schedule.elements[1], se2)
        self.assertEqual(schedule.lock_names, [])
        self.assertEqual(schedule.var_names, ["test_var"])

    def test_add_update_missing_affected_tids(self):
        se1 = ScheduleElement(0)
        self.assertRaises(ValueError, se1.add_update, "test_var", UpdateType.ENTERPARALLEL)

    def test_add_update_included_affected_tids(self):
        se1 = ScheduleElement(0)
        se1.add_update("test_var", UpdateType.ENTERPARALLEL, [1])
        self.assertTrue(True)
