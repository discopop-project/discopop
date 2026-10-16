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
#include <unordered_map>

#include "DPTypes.hpp"

namespace dp {

// For loop merging
// Assumption: no more than one loops can begin at the same line
struct LoopRecord {
  LoopRecord(LID e, std::int32_t t, std::int32_t n) : end(e), total(t), n_entered(n) {}

  LID end;
  std::int32_t total;
  std::int32_t n_entered;

  // maximum iterations executed during a single loop entry
  std::int32_t max_iteration_count = 0;

  bool operator==(const LoopRecord& other) const noexcept {
    return end == other.end && total == other.total && n_entered == other.n_entered &&
           max_iteration_count == other.max_iteration_count;
  }

  bool operator!=(const LoopRecord& other) const noexcept { return !(*this == other); }
};

using LoopRecords = std::unordered_map<LID, LoopRecord*>;

}  // namespace dp
