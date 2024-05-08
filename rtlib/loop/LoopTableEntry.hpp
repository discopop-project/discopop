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

#include "../DPTypes.hpp"

#include <cstdint>

namespace __dp {

// For loop tracking
struct LoopTableEntry {
  LoopTableEntry(std::int32_t l, std::int32_t id, std::int32_t c, LID b)
      : funcLevel(l), loopID(id), count(c), begin(b) {}

  std::int32_t funcLevel;
  std::int32_t loopID;
  std::int32_t count;
  LID begin;
};

} // namespace __dp
