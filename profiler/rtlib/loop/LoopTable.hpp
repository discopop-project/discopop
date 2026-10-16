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
#include <iostream>
#include <vector>

#include "LoopTableEntry.hpp"

namespace dp {

struct LoopTable {
 public:
  LoopTable() { contents_.reserve(32); }

  const LoopTableEntry& Top() const { return contents_.back(); }

  LoopTableEntry& NonConstTop() { return contents_.back(); }

  const LoopTableEntry& First() const { return contents_[0]; }

  const LoopTableEntry& TopMinusN(const std::size_t n) const { return contents_[contents_.size() - 1 - n]; }

  void Pop() { contents_.pop_back(); }

  bool empty() const { return contents_.empty(); }

  bool IsSingleExit(const std::int32_t loop_id) const {
    if (empty()) {
      return true;
    }

    if (Top().loop_id != loop_id) {
      return true;
    }

    return false;
  }

  void CorrectFuncLevel(const std::int32_t func_level) {
    if (Top().func_level != func_level) {
      if (dp_debug) {
        std::cout << "WARNING: changing funcLevel of Loop " << Top().loop_id << " from " << Top().func_level << " to "
                  << func_level << std::endl;
      }
      contents_.back().func_level = func_level;
    }
  }

  void Push(const LoopTableEntry new_element) { contents_.push_back(new_element); }

  std::size_t size() const { return contents_.size(); }

  LID UpdateLid(const LID old_lid) const {
    auto lid = old_lid;

    if (empty()) {
      return lid | (static_cast<LID>(0xFF) << 56);
    }

    // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark
    // loop iteration count as valid, last 7 bits for loop iteration) last 8
    // bits are sufficient, since metadata is only used to check for different
    // iterations, not exact values. first 32 bits of lid are reserved for
    // metadata and thus empty

    if (size() > 0) {
      lid = lid | (static_cast<LID>(First().loop_id & 0xFF) << 56);   // add masked loop id
      lid = lid | (static_cast<LID>(Top().GetCount() & 0x7F) << 48);  // add masked loop count
      lid = lid | 0x0080000000000000;                                 // mark loop count valid
    }

    if (size() > 1) {
      lid = lid | (static_cast<LID>(TopMinusN(1).GetCount() & 0x7F) << 40);  // add masked loop count
      lid = lid | 0x0000800000000000;                                        // mark loop count valid
    }

    if (size() > 2) {
      lid = lid | (static_cast<LID>(TopMinusN(2).GetCount() & 0x7F) << 32);  // add masked loop count
      lid = lid | 0x0000008000000000;                                        // mark loop count valid
    }

    return lid;
  }

  void IncrementTopCount() { contents_.back().IncrementCount(); }

  void DebugOutput() const {
    if (!dp_debug) {
      return;
    }
    if (empty()) {
      std::cout << "Loop Stack is empty." << std::endl;
    } else {
      std::cout << "TOP: (" << std::dec << Top().func_level << ")";
      std::cout << "Loop " << Top().loop_id << "." << std::endl;
    }
  }

 private:
  std::vector<LoopTableEntry> contents_;
};

}  // namespace dp
