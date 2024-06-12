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

#include "../DPTypes.hpp"

#include "../callstack/CallStack.hpp"
#include <cstdint>
#include <unordered_map>
#include <unordered_set>

namespace __dp {

class PerfectShadow : public AbstractShadow {
public:
  PerfectShadow(int slotSize, int size, int numHash) : PerfectShadow() {}

  PerfectShadow() {
    sigRead = new std::unordered_map<int64_t, sigElement>();
    sigWrite = new std::unordered_map<int64_t, sigElement>();
#if DP_CALLSTACK_PROFILING
    addrToLastReadAccessCallStack = new std::unordered_map<int64_t, CallStack *>();
    addrToLastWriteAccessCallStack = new std::unordered_map<int64_t, CallStack *>();
#endif
  }

  PerfectShadow(const PerfectShadow &other) = delete;
  PerfectShadow(PerfectShadow &&other) {
    sigRead = other.sigRead;
    sigWrite = other.sigWrite;

    other.sigRead = nullptr;
    other.sigWrite = nullptr;
  }

  PerfectShadow &operator=(const PerfectShadow &other) = delete;
  PerfectShadow &operator=(PerfectShadow &&other) {
    std::swap(sigRead, other.sigRead);
    std::swap(sigWrite, other.sigWrite);

    return *this;
  }

  ~PerfectShadow() {
    delete sigRead;
    delete sigWrite;

#if DP_CALLSTACK_PROFILING
    for (auto elem : *addrToLastReadAccessCallStack) {
      cleanReadAccessCallStack(elem.first);
    }
    for (auto elem : *addrToLastWriteAccessCallStack) {
      cleanWriteAccessCallStack(elem.first);
    }
    delete addrToLastReadAccessCallStack;
    delete addrToLastWriteAccessCallStack;
#endif
  }

  inline sigElement testInRead(std::int64_t memAddr) { return (*sigRead)[memAddr]; }

  inline sigElement testInWrite(std::int64_t memAddr) { return (*sigWrite)[memAddr]; }

  inline sigElement insertToRead(std::int64_t memAddr, sigElement value) {
    sigElement oldValue = testInRead(memAddr);
    (*sigRead)[memAddr] = value;
    return oldValue;
  }

  inline sigElement insertToWrite(std::int64_t memAddr, sigElement value) {
    sigElement oldValue = testInWrite(memAddr);
    (*sigWrite)[memAddr] = value;
    return oldValue;
  }

  inline void updateInRead(std::int64_t memAddr, sigElement newValue) { (*sigRead)[memAddr] = newValue; }

  inline void updateInWrite(std::int64_t memAddr, sigElement newValue) { (*sigWrite)[memAddr] = newValue; }

  inline void removeFromRead(std::int64_t memAddr) { (*sigRead)[memAddr] = 0; }

  inline void removeFromWrite(std::int64_t memAddr) { (*sigWrite)[memAddr] = 0; }

  inline std::unordered_set<ADDR> getAddrsInRange(std::int64_t startAddr, std::int64_t endAddr) {
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

  const std::unordered_map<std::int64_t, sigElement> *getSigRead() const noexcept { return sigRead; }

  const std::unordered_map<std::int64_t, sigElement> *getSigWrite() const noexcept { return sigWrite; }

#if DP_CALLSTACK_PROFILING
  inline CallStack *getLastReadAccessCallStack(int64_t memAddr) { return (*addrToLastReadAccessCallStack)[memAddr]; }

  inline void setLastReadAccessCallStack(int64_t memAddr, CallStack *p_cs) {
    // check if entry exists already
    std::unordered_map<int64_t, CallStack *>::const_iterator got = (*addrToLastReadAccessCallStack).find(memAddr);
    if (got == (*addrToLastReadAccessCallStack).end()) {
      // no entry exists
      (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
    } else {
      // entry exists already. Cleanup the old CallStack and save the new one.
      CallStack *p_old_cs = (CallStack *)(*addrToLastReadAccessCallStack)[memAddr];
      if (p_old_cs) {
        delete p_old_cs;
      }
      (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
    }
  }

  inline void cleanReadAccessCallStack(int64_t memAddr) {
    if ((*addrToLastReadAccessCallStack)[memAddr]) {
      delete (*addrToLastReadAccessCallStack)[memAddr];
      (*addrToLastReadAccessCallStack)[memAddr] = nullptr;
    }
  }

  inline CallStack *getLastWriteAccessCallStack(int64_t memAddr) { return (*addrToLastWriteAccessCallStack)[memAddr]; }

  inline void setLastWriteAccessCallStack(int64_t memAddr, CallStack *p_cs) {
    // check if entry exists already
    std::unordered_map<int64_t, CallStack *>::const_iterator got = (*addrToLastWriteAccessCallStack).find(memAddr);
    if (got == (*addrToLastWriteAccessCallStack).end()) {
      // no entry exists
      (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
    } else {
      // entry exists already. Cleanup the old CallStack and save the new one.
      CallStack *p_old_cs = (CallStack *)(*addrToLastWriteAccessCallStack)[memAddr];
      if (p_old_cs) {
        delete p_old_cs;
      }
      (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
    }
  }

  inline void cleanWriteAccessCallStack(int64_t memAddr) {
    if ((*addrToLastWriteAccessCallStack)[memAddr]) {
      delete (*addrToLastWriteAccessCallStack)[memAddr];
      (*addrToLastWriteAccessCallStack)[memAddr] = nullptr;
    }
  }
#endif

private:
  std::unordered_map<std::int64_t, sigElement> *sigRead;
  std::unordered_map<std::int64_t, sigElement> *sigWrite;
#if DP_CALLSTACK_PROFILING
  std::unordered_map<int64_t, CallStack *> *addrToLastReadAccessCallStack;
  std::unordered_map<int64_t, CallStack *> *addrToLastWriteAccessCallStack;
#endif
};

// Hopefully faster version

class PerfectShadow2 : public AbstractShadow {
public:
  PerfectShadow2() {
    read_cache.reserve(1024);
    write_cache.reserve(1024);
#if DP_CALLSTACK_PROFILING
    addrToLastReadAccessCallStack = new std::unordered_map<int64_t, CallStack *>();
    addrToLastWriteAccessCallStack = new std::unordered_map<int64_t, CallStack *>();
#endif
  }

  ~PerfectShadow2() {
#if DP_CALLSTACK_PROFILING
    for (auto elem : *addrToLastReadAccessCallStack) {
      cleanReadAccessCallStack(elem.first);
    }
    for (auto elem : *addrToLastWriteAccessCallStack) {
      cleanWriteAccessCallStack(elem.first);
    }
    delete addrToLastReadAccessCallStack;
    delete addrToLastWriteAccessCallStack;
#endif
  }

  sigElement testInRead(const std::int64_t memAddr) noexcept { return read_cache[memAddr]; }

  sigElement testInWrite(const std::int64_t memAddr) noexcept { return write_cache[memAddr]; }

  sigElement insertToRead(const std::int64_t memAddr, const sigElement value) {
    const auto iterator = read_cache.find(memAddr);

    if (iterator == read_cache.end()) {
      read_cache[memAddr] = value;
      return 0;
    }

    const auto old_value = iterator->second;
    iterator->second = value;
    return old_value;
  }

  sigElement insertToWrite(const std::int64_t memAddr, const sigElement value) {
    const auto iterator = write_cache.find(memAddr);

    if (iterator == write_cache.end()) {
      write_cache[memAddr] = value;
      return 0;
    }

    const auto old_value = iterator->second;
    iterator->second = value;
    return old_value;
  }

  void updateInRead(const std::int64_t memAddr, const sigElement newValue) noexcept { read_cache[memAddr] = newValue; }

  void updateInWrite(const std::int64_t memAddr, const sigElement newValue) noexcept {
    write_cache[memAddr] = newValue;
  }

  void removeFromRead(const std::int64_t memAddr) { read_cache[memAddr] = 0; }

  void removeFromWrite(const std::int64_t memAddr) { write_cache[memAddr] = 0; }

  std::unordered_set<ADDR> getAddrsInRange(const std::int64_t startAddr, const std::int64_t endAddr) noexcept {
    std::unordered_set<ADDR> result{};
    result.reserve(read_cache.size() + write_cache.size());

    for (const auto &pair : read_cache) {
      const auto addr = pair.first;
      if (addr >= startAddr && addr <= endAddr) {
        result.insert(addr);
      }
    }

    for (const auto &pair : write_cache) {
      const auto addr = pair.first;
      if (addr >= startAddr && addr <= endAddr) {
        result.insert(addr);
      }
    }

    return result;
  }

  const hashmap<int64_t, sigElement> *getSigRead() const noexcept { return &read_cache; }

  const hashmap<int64_t, sigElement> *getSigWrite() const noexcept { return &write_cache; }

#if DP_CALLSTACK_PROFILING
  inline CallStack *getLastReadAccessCallStack(int64_t memAddr) { return (*addrToLastReadAccessCallStack)[memAddr]; }

  inline void setLastReadAccessCallStack(int64_t memAddr, CallStack *p_cs) {
    // check if entry exists already
    std::unordered_map<int64_t, CallStack *>::const_iterator got = (*addrToLastReadAccessCallStack).find(memAddr);
    if (got == (*addrToLastReadAccessCallStack).end()) {
      // no entry exists
      (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
    } else {
      // entry exists already. Cleanup the old CallStack and save the new one.
      CallStack *p_old_cs = (CallStack *)(*addrToLastReadAccessCallStack)[memAddr];
      if (p_old_cs) {
        delete p_old_cs;
      }
      (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
    }
  }

  inline void cleanReadAccessCallStack(int64_t memAddr) {
    if ((*addrToLastReadAccessCallStack)[memAddr]) {
      delete (*addrToLastReadAccessCallStack)[memAddr];
      (*addrToLastReadAccessCallStack)[memAddr] = nullptr;
    }
  }

  inline CallStack *getLastWriteAccessCallStack(int64_t memAddr) { return (*addrToLastWriteAccessCallStack)[memAddr]; }

  inline void setLastWriteAccessCallStack(int64_t memAddr, CallStack *p_cs) {
    // check if entry exists already
    std::unordered_map<int64_t, CallStack *>::const_iterator got = (*addrToLastWriteAccessCallStack).find(memAddr);
    if (got == (*addrToLastWriteAccessCallStack).end()) {
      // no entry exists
      (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
    } else {
      // entry exists already. Cleanup the old CallStack and save the new one.
      CallStack *p_old_cs = (CallStack *)(*addrToLastWriteAccessCallStack)[memAddr];
      if (p_old_cs) {
        delete p_old_cs;
      }
      (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
    }
  }

  inline void cleanWriteAccessCallStack(int64_t memAddr) {
    if ((*addrToLastWriteAccessCallStack)[memAddr]) {
      delete (*addrToLastWriteAccessCallStack)[memAddr];
      (*addrToLastWriteAccessCallStack)[memAddr] = nullptr;
    }
  }
#endif

private:
  hashmap<int64_t, sigElement> read_cache{};
  hashmap<int64_t, sigElement> write_cache{};
#if DP_CALLSTACK_PROFILING
  std::unordered_map<int64_t, CallStack *> *addrToLastReadAccessCallStack;
  std::unordered_map<int64_t, CallStack *> *addrToLastWriteAccessCallStack;
#endif
};

} // namespace __dp
