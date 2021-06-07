import pytest
from discopop.discopop_validation.vc_data_race_detector.vector_clock import *


class TestVectorClock:
    def test_length(self):
        assert 3 == VectorClock(3).length

    def test_init(self):
        assert [0, 0, 0] == VectorClock(3).clocks

    def test_get_updated_vc_differing_length(self):
        with pytest.raises(ValueError):
            get_updated_vc(VectorClock(3), VectorClock(4))

    def test_get_updated_vc_simple_update(self):
        assert [0, 0, 0] == get_updated_vc(VectorClock(3), VectorClock(3)).clocks

    def test_get_updated_vc_update(self):
        vc1 = VectorClock(3)
        vc1.clocks = [1, 2, 3]
        vc2 = VectorClock(3)
        vc2.clocks = [3, 2, 1]
        assert [3, 2, 3] == get_updated_vc(vc1, vc2).clocks

    def test_compare_vc_differing_lenght(self):
        with pytest.raises(ValueError):
            compare_vc(VectorClock(4), VectorClock(3))

    def test_compare_vc_true(self):
        vc_1 = VectorClock(3)
        vc_1.clocks = [1, 2, 3]
        vc_2 = VectorClock(3)
        vc_2.clocks = [2, 3, 4]
        assert compare_vc(vc_1, vc_2) is True

    def test_compare_vc_false(self):
        vc_1 = VectorClock(3)
        vc_1.clocks = [1, 2, 3]
        vc_2 = VectorClock(3)
        vc_2.clocks = [2, 1, 4]
        assert compare_vc(vc_1, vc_2) is False

    def test_increase(self):
        vc_1 = VectorClock(3)
        increase(vc_1, 2)
        assert [0, 1, 1] == increase(vc_1, 1).clocks

    def test_increase_value_error(self):
        vc_1 = VectorClock(3)
        with pytest.raises(ValueError):
            increase(vc_1, 4)
