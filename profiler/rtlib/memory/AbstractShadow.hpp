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
#include <unordered_set>

namespace dp {

class AbstractShadow {
public:
  virtual ~AbstractShadow() {}

  virtual SigElement TestInRead(std::int64_t mem_addr) = 0;

  virtual SigElement TestInWrite(std::int64_t mem_addr) = 0;

  virtual SigElement InsertToRead(std::int64_t mem_addr, SigElement value) = 0;

  virtual SigElement InsertToWrite(std::int64_t mem_addr, SigElement value) = 0;

  virtual void UpdateInRead(std::int64_t mem_addr, SigElement new_value) = 0;

  virtual void UpdateInWrite(std::int64_t mem_addr, SigElement new_value) = 0;

  virtual void RemoveFromRead(std::int64_t mem_addr) = 0;

  virtual void RemoveFromWrite(std::int64_t mem_addr) = 0;

  virtual std::unordered_set<ADDR> GetAddrsInRange(std::int64_t start_addr, std::int64_t end_addr) = 0;

  virtual std::vector<std::pair<std::int64_t, SigElement>> GetReadKvPairs() = 0;

  virtual std::vector<std::pair<std::int64_t, SigElement>> GetWriteKvPairs() = 0;

  virtual void Print() = 0;
};

} // namespace dp
