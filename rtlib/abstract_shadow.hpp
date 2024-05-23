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

#include "CallStack.hpp"

#include <cstdint>
#include <unordered_set>

namespace __dp {

class Shadow {
public:
  virtual ~Shadow() {}

  virtual sigElement testInRead(int64_t memAddr) = 0;

  virtual sigElement testInWrite(int64_t memAddr) = 0;

  virtual sigElement insertToRead(int64_t memAddr, sigElement value) = 0;

  virtual sigElement insertToWrite(int64_t memAddr, sigElement value) = 0;

  virtual void updateInRead(int64_t memAddr, sigElement newValue) = 0;

  virtual void updateInWrite(int64_t memAddr, sigElement newValue) = 0;

  virtual void removeFromRead(int64_t memAddr) = 0;

  virtual void removeFromWrite(int64_t memAddr) = 0;

  virtual std::unordered_set<ADDR> getAddrsInRange(int64_t startAddr,
                                                   int64_t endAddr) = 0;

                                                   virtual CallStack* getLastReadAccessCallStack(int64_t memAddr); 
 
        virtual void setLastReadAccessCallStack(int64_t memAddr, CallStack* p_cs); 
 
        virtual void cleanReadAccessCallStack(int64_t memAddr); 
 
        virtual CallStack* getLastWriteAccessCallStack(int64_t memAddr); 
 
        virtual void setLastWriteAccessCallStack(int64_t memAddr, CallStack* p_cs); 
 
        virtual void cleanWriteAccessCallStack(int64_t memAddr); 
};

} // namespace __dp
