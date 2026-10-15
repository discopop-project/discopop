/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#pragma once

#include <cstdint>

namespace dp {

struct VarCounter {
  unsigned int counters[2] = {0, 0};
  int64_t mem_addr = 0;
  bool valid = true;

  bool operator==(const VarCounter& other) const noexcept {
    return counters[0] == other.counters[0] && counters[1] == other.counters[1] && mem_addr == other.mem_addr &&
           valid == other.valid;
  }

  bool operator!=(const VarCounter& other) const noexcept { return !(*this == other); }
};

}  // namespace dp
