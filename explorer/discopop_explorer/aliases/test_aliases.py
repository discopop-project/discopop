# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Tests for the string aliases. NodeID ("<file_id>:<node_id>") and LineID ("<file_id>:<line>")
validate their format on construction, so a malformed id fails where it is created rather than
where it is first split apart."""

from __future__ import annotations

from typing import Any

import pytest

from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.aliases.MemoryRegion import MemoryRegion
from discopop_explorer.aliases.NodeID import NodeID


@pytest.mark.parametrize("alias", [NodeID, LineID])  # type: ignore[misc]
def test_well_formed_id_is_a_plain_string(alias: Any) -> None:
    value = alias("3:42")

    assert isinstance(value, str)
    assert value == "3:42"
    assert {value: 1}["3:42"] == 1, "usable interchangeably with the string as a dictionary key"


@pytest.mark.parametrize("alias", [NodeID, LineID])  # type: ignore[misc]
@pytest.mark.parametrize(  # type: ignore[misc]
    "malformed",
    [
        "342",  # no separator
        "1:2:3",  # too many parts
        "a:2",  # non-numeric file id
        "1:b",  # non-numeric node id / line
        ":",  # empty parts
        "",
    ],
)
def test_malformed_id_is_rejected(alias: Any, malformed: str) -> None:
    with pytest.raises(ValueError, match="Mal-formatted"):
        alias(malformed)


def test_memory_region_accepts_any_string() -> None:
    """Memory regions are opaque identifiers emitted by the profiler, e.g. "99381316572105"."""
    assert MemoryRegion("99381316572105") == "99381316572105"
    assert MemoryRegion("") == ""
