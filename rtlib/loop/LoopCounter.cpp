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

#include "LoopCounter.hpp"

namespace __dp {

void LoopCounter::incr_loop_counter(int loop_id) {
  if (loop_counters_.size() < loop_id + 1) {
    loop_counters_.resize(loop_id + 1);
  }

  loop_counters_[loop_id] += 1;
}

} // namespace __dp
