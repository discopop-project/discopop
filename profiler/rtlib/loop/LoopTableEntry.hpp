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

#include "DPTypes.hpp"

#include <cstdint>

namespace dp {

// For loop tracking
struct LoopTableEntry {
  LoopTableEntry(std::int32_t function_level, std::int32_t loop_id, std::int32_t number_hits, LID begin_line)
      : func_level(function_level), loop_id(loop_id), begin(begin_line), count_(number_hits) {
  }

  std::int32_t func_level;
  std::int32_t loop_id;
  LID begin;

  bool operator==(const LoopTableEntry &other) const noexcept {
    return func_level == other.func_level && loop_id == other.loop_id && count_ == other.count_ && begin == other.begin;
  }

  bool operator!=(const LoopTableEntry &other) const noexcept { return !(*this == other); }

  std::int32_t GetCount() const noexcept { return count_; }

  void IncrementCount() noexcept { ++count_; }


private:
  std::int32_t count_;
};

} // namespace dp
