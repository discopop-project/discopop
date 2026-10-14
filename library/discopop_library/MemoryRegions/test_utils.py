# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from pathlib import Path

from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_library.MemoryRegions.utils import get_sizes_of_memory_regions


def test_missing_file_means_no_known_sizes(tmp_path: Path) -> None:
    missing = str(tmp_path / "memory_regions.txt")
    assert get_sizes_of_memory_regions({MemoryRegion("1")}, missing) == {}
    assert get_sizes_of_memory_regions(set(), missing, return_all_memory_regions=True) == {}


def test_empty_file_means_no_known_sizes(tmp_path: Path) -> None:
    empty = tmp_path / "memory_regions.txt"
    empty.write_text("")
    assert get_sizes_of_memory_regions({MemoryRegion("1")}, str(empty)) == {}
