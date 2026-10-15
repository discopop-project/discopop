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

#include <vector>

#include "VarCounter.hpp"

namespace dp {

class LoopCounter {
 public:
  void IncrLoopCounter(int loop_id) {
    const std::size_t required_size = static_cast<std::size_t>(loop_id) + 1;
    if (loop_counters_.size() < required_size) {
      loop_counters_.resize(required_size);
    }

    loop_counters_[loop_id] += 1;
  }

  const std::vector<unsigned int>& GetLoopCounters() const noexcept { return loop_counters_; }

 private:
  std::vector<unsigned int> loop_counters_;
};

}  // namespace dp
