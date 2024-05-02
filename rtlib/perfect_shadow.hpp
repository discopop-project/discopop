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

#include "abstract_shadow.hpp"
#include "signature.hpp"

#include <iostream>
#include <stdint.h>
#include <unordered_map>
#include <vector>

namespace __dp {

class PerfectShadow : public Shadow {
public:
  PerfectShadow(int slotSize, int size, int numHash) : PerfectShadow() {}

  PerfectShadow() {
    sigRead = new std::unordered_map<int64_t, sigElement>();
    sigWrite = new std::unordered_map<int64_t, sigElement>();
  }

  ~PerfectShadow() {
    delete sigRead;
    delete sigWrite;
  }

  inline sigElement testInRead(int64_t memAddr) { return (*sigRead)[memAddr]; }

  inline sigElement testInWrite(int64_t memAddr) {
    return (*sigWrite)[memAddr];
  }

  inline sigElement insertToRead(int64_t memAddr, sigElement value) {
    sigElement oldValue = testInRead(memAddr);
    (*sigRead)[memAddr] = value;
    return oldValue;
  }

  inline sigElement insertToWrite(int64_t memAddr, sigElement value) {
    sigElement oldValue = testInWrite(memAddr);
    (*sigWrite)[memAddr] = value;
    return oldValue;
  }

  inline void updateInRead(int64_t memAddr, sigElement newValue) {
    (*sigRead)[memAddr] = newValue;
  }

  inline void updateInWrite(int64_t memAddr, sigElement newValue) {
    (*sigWrite)[memAddr] = newValue;
  }

  inline void removeFromRead(int64_t memAddr) { (*sigRead)[memAddr] = 0; }

  inline void removeFromWrite(int64_t memAddr) { (*sigWrite)[memAddr] = 0; }

  inline std::unordered_set<ADDR> getAddrsInRange(int64_t startAddr,
                                                  int64_t endAddr) {
    std::unordered_set<ADDR> result;
    for (auto pair : (*sigWrite)) {
      if ((pair.first >= startAddr) && (pair.first <= endAddr)) {
        result.insert(pair.first);
      }
    }
    for (auto pair : (*sigRead)) {
      if ((pair.first >= startAddr) && (pair.first <= endAddr)) {
        result.insert(pair.first);
      }
    }
    return result;
  }

private:
  std::unordered_map<int64_t, sigElement> *sigRead;
  std::unordered_map<int64_t, sigElement> *sigWrite;
};

} // namespace __dp
