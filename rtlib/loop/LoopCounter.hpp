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

#include "VarCounter.hpp"

#include <vector>

namespace __dp {

class LoopCounter {
public:
  void incr_loop_counter(int loop_id);

  void incr_counter(int var_id, int instr_type);

  void update_ptr(int var_id, int instr_type, long long addr);

  std::vector<VarCounter> var_counters_;
  std::vector<unsigned> loop_counters_;
};

} // namespace __dp
