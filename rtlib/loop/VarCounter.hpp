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

namespace __dp {

struct VarCounter {
  VarCounter() : counters_{0, 0}, mem_addr_(0), valid_(true) {}

  unsigned counters_[2];
  long long mem_addr_;
  bool valid_;
};

} // namespace __dp
