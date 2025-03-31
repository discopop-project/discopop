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

#include "AbstractShadow.hpp"
#include "Signature.hpp"

#include <cstdint>
#include <iostream>

using namespace std;

namespace __dp {

class ShadowMemory : public AbstractShadow {
public:
  ShadowMemory(int slotSize, int size, int numHash) {
    sigRead = new Signature(slotSize, size, numHash);
    sigWrite = new Signature(slotSize, size, numHash);
  }

  ~ShadowMemory() {
    delete sigRead;
    delete sigWrite;
  }

  inline void testInRead(std::int64_t memAddr, sigElement& buffer_lastRead) { buffer_lastRead = sigRead->membershipCheck(memAddr); }

  inline void testInWrite(std::int64_t memAddr, sigElement& buffer_lastWrite) { buffer_lastWrite = sigWrite->membershipCheck(memAddr); }

  inline void insertToRead(std::int64_t memAddr, sigElement value, sigElement& buffer_lastRead) { buffer_lastRead = sigRead->insert(memAddr, value); }

  inline void insertToWrite(std::int64_t memAddr, sigElement value, sigElement& buffer_lastWrite) { buffer_lastWrite = sigWrite->insert(memAddr, value); }

  inline void updateInRead(std::int64_t memAddr, sigElement newValue) { sigRead->update(memAddr, newValue); }

  inline void updateInWrite(std::int64_t memAddr, sigElement newValue) { sigWrite->update(memAddr, newValue); }

  inline void removeFromRead(std::int64_t memAddr) { sigRead->remove(memAddr); }

  inline void removeFromWrite(std::int64_t memAddr) { sigWrite->remove(memAddr); }

  /*
  inline std::unordered_set<ADDR> getAddrsInRange(std::int64_t startAddr, std::int64_t endAddr) {
    // not possible for Shadow, since not all addresses are kept
    std::unordered_set<ADDR> result;
    return result;
  }
  */

private:
  Signature *sigRead;
  Signature *sigWrite;
};

} // namespace __dp
