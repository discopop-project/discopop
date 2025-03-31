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

#include <cstdint>
#include <unordered_map>
#include <unordered_set>
#include "../runtimeFunctionsGlobals.hpp"

namespace __dp {

class PerfectShadow : public AbstractShadow {
public:
  PerfectShadow(int slotSize, int size, int numHash) : PerfectShadow() {}

  PerfectShadow() {
    sigRead = new std::unordered_map<int64_t, sigElement>();
    sigWrite = new std::unordered_map<int64_t, sigElement>();
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
  }

  inline void testInRead(std::int64_t memAddr, sigElement& buffer_lastRead) { buffer_lastRead = (*sigRead)[memAddr]; }

  inline void testInWrite(std::int64_t memAddr, sigElement& buffer_lastWrite) { buffer_lastWrite = (*sigWrite)[memAddr]; }

  inline void insertToRead(std::int64_t memAddr, sigElement value, sigElement& buffer_lastRead) {
    testInRead(memAddr, buffer_lastRead);
    (*sigRead)[memAddr] = value;
  }

  inline void insertToWrite(std::int64_t memAddr, sigElement value, sigElement& buffer_lastWrite) {
    testInWrite(memAddr, buffer_lastWrite);
    (*sigWrite)[memAddr] = value;
  }

  inline void updateInRead(std::int64_t memAddr, sigElement newValue) { (*sigRead)[memAddr] = newValue; }

  inline void updateInWrite(std::int64_t memAddr, sigElement newValue) { (*sigWrite)[memAddr] = newValue; }

  inline void removeFromRead(std::int64_t memAddr) { (*sigRead)[memAddr] = 0; }

  inline void removeFromWrite(std::int64_t memAddr) { (*sigWrite)[memAddr] = 0; }

  /*
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
  */

  const std::unordered_map<std::int64_t, sigElement> *getSigRead() const noexcept { return sigRead; }

  const std::unordered_map<std::int64_t, sigElement> *getSigWrite() const noexcept { return sigWrite; }

private:
  std::unordered_map<std::int64_t, sigElement> *sigRead;
  std::unordered_map<std::int64_t, sigElement> *sigWrite;
};

// Hopefully faster version

class PerfectShadow2 : public AbstractShadow {
public:
  PerfectShadow2() {
    read_cache.reserve(1024);
    write_cache.reserve(1024);
  }

  ~PerfectShadow2() {}

  void testInRead(const std::int64_t memAddr, sigElement& buffer_lastRead) noexcept { buffer_lastRead = read_cache[memAddr]; }

  void testInWrite(const std::int64_t memAddr, sigElement& buffer_lastWrite) noexcept { buffer_lastWrite = write_cache[memAddr]; }

  void insertToRead(const std::int64_t memAddr, const sigElement value, sigElement& buffer_lastRead) {
    const auto iterator = read_cache.find(memAddr);

    if (iterator == read_cache.end()) {
      read_cache[memAddr] = value;
      buffer_lastRead = 0;
      return;
    }

    buffer_lastRead = iterator->second;
    iterator->second = value;
    return;
  }

  void insertToWrite(const std::int64_t memAddr, const sigElement value, sigElement& buffer_lastWrite) {
    const auto iterator = write_cache.find(memAddr);

    if (iterator == write_cache.end()) {
      write_cache[memAddr] = value;
      buffer_lastWrite = 0;
      return;
    }

    buffer_lastWrite = iterator->second;
    iterator->second = value;
    return;
  }

  void updateInRead(const std::int64_t memAddr, const sigElement newValue) noexcept { read_cache[memAddr] = newValue; }

  void updateInWrite(const std::int64_t memAddr, const sigElement newValue) noexcept {
    write_cache[memAddr] = newValue;
  }

  void removeFromRead(const std::int64_t memAddr) { read_cache[memAddr] = 0; }

  void removeFromWrite(const std::int64_t memAddr) { write_cache[memAddr] = 0; }

  /*
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
  */

  const hashmap<int64_t, sigElement> *getSigRead() const noexcept { return &read_cache; }

  const hashmap<int64_t, sigElement> *getSigWrite() const noexcept { return &write_cache; }

private:
  hashmap<int64_t, sigElement> read_cache{};
  hashmap<int64_t, sigElement> write_cache{};
};

// Hopefully even faster version

#define GET_STACK_OFFSET(MEMADDR) ((stack_base_addr - MEMADDR) >> 3)
#define MAX_DISTANCE 0x3B9ACA00

class PerfectShadow3 : public AbstractShadow {
  public:
    PerfectShadow3(){
        internal_global_reads.reserve(1024);
        internal_global_writes.reserve(1024);
        internal_stack_reads.resize(1);
        internal_stack_writes.resize(1);
        internal_heap_reads.resize(1);
        internal_heap_writes.resize(1);
    }

    ~PerfectShadow3() {
    }

    void testInRead(const std::int64_t memAddr, sigElement& buffer_lastRead) noexcept {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_TEST_IN_READ);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          buffer_lastRead = internal_stack_reads[stack_distance];
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          buffer_lastRead = internal_heap_reads[heap_distance];
          return;
        }
      }
      // global access
      buffer_lastRead = internal_global_reads[memAddr];
      return;

      // return read_cache[memAddr];
    }

    void testInWrite(const std::int64_t memAddr, sigElement& buffer_lastWrite) noexcept {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_TEST_IN_WRITE);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          buffer_lastWrite = internal_stack_writes[stack_distance];
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          buffer_lastWrite = internal_heap_writes[heap_distance];
          return;
        }
      }
      // global access
      buffer_lastWrite = internal_global_writes[memAddr];
      return;
    }

    void insertToRead(const std::int64_t memAddr, const sigElement value, sigElement& buffer_lastRead) {
#ifdef DP_INTERNAL_TIMER
        const auto timer = Timer(timers, TimerRegion::SMEM_INSERT_TO_READ);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          buffer_lastRead = internal_stack_reads[stack_distance];
          internal_stack_reads[stack_distance] = value;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          buffer_lastRead = internal_heap_reads[heap_distance];
          internal_heap_reads[heap_distance] = value;
          return;
        }
      }
      // global access
      const auto iterator = internal_global_reads.find(memAddr);

      if (iterator == internal_global_reads.end()) {
        internal_global_reads[memAddr] = value;
        buffer_lastRead = 0;
        return;
      }

      buffer_lastRead = iterator->second;
      iterator->second = value;
      return;
    }

    void insertToWrite(const std::int64_t memAddr, const sigElement value, sigElement& buffer_lastWrite) {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_INSERT_TO_WRITE);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          buffer_lastWrite = internal_stack_writes[stack_distance];
          internal_stack_writes[stack_distance] = value;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          buffer_lastWrite = internal_heap_writes[heap_distance];
          internal_heap_writes[heap_distance] = value;
          return;
        }
      }
      // global access
      const auto iterator = internal_global_writes.find(memAddr);

      if (iterator == internal_global_writes.end()) {
        internal_global_writes[memAddr] = value;
        buffer_lastWrite = 0;
        return;
      }

      buffer_lastWrite = iterator->second;
      iterator->second = value;
      return;
    }

    void updateInRead(const std::int64_t memAddr, const sigElement newValue) noexcept {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_UPDATE_IN_READ);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          internal_stack_reads[stack_distance] = newValue;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          internal_heap_reads[heap_distance] = newValue;
          return;
        }
      }
      // global access
      internal_global_reads[memAddr] = newValue;
      // read_cache[memAddr] = newValue;
      }

    void updateInWrite(const std::int64_t memAddr, const sigElement newValue) noexcept {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_UPDATE_IN_WRITE);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          internal_stack_writes[stack_distance] = newValue;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          internal_heap_writes[heap_distance] = newValue;
          return;
        }
      }
      // global access
      internal_global_writes[memAddr] = newValue;
      //write_cache[memAddr] = newValue;
    }

    void removeFromRead(const std::int64_t memAddr) {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_REMOVE_FROM_READ);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          internal_stack_reads[stack_distance] = 0;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          internal_heap_reads[heap_distance] = 0;
          return;
        }
      }
      // global access
      internal_global_reads[memAddr] = 0;
    }

    void removeFromWrite(const std::int64_t memAddr) {
#ifdef DP_INTERNAL_TIMER
      const auto timer = Timer(timers, TimerRegion::SMEM_REMOVE_FROM_WRITE);
#endif
      auto stack_distance = stack_base_addr - memAddr;
      auto heap_distance = memAddr - heap_base_addr;

      if(stack_distance < heap_distance){
        if (stack_distance < MAX_DISTANCE){
          // stack access
          // INCREASE STACK DATASTRUCTURE SIZE
          if(stack_distance > internal_stack_reads.size()){
            internal_stack_reads.resize(stack_distance+1);
            internal_stack_writes.resize(stack_distance+1);
          }
          internal_stack_writes[stack_distance] = 0;
          return;
        }
      }
      else{
        if(heap_distance < MAX_DISTANCE){
          // heap access
          // INCREASE Heap DATASTRUCTURE SIZE
          if(heap_distance > internal_heap_reads.size()){
            internal_heap_reads.resize(heap_distance+1);
            internal_heap_writes.resize(heap_distance+1);
          }
          internal_heap_writes[heap_distance] = 0;
          return;
        }
      }
      // global access
      internal_global_writes[memAddr] = 0;
    }

    const hashmap<int64_t, sigElement> *getSigRead() const noexcept {
      std::cout << "GetSigRead" << std::endl;
      //return &read_cache;
    }

    const hashmap<int64_t, sigElement> *getSigWrite() const noexcept {
      std::cout << "GetSigWrite" << std::endl;
      // return &write_cache;
    }

  private:

    std::vector<sigElement> internal_stack_reads;
    std::vector<sigElement> internal_stack_writes;
    std::vector<sigElement> internal_heap_reads;
    std::vector<sigElement> internal_heap_writes;
    hashmap<int64_t, sigElement> internal_global_reads{};
    hashmap<int64_t, sigElement> internal_global_writes{};

  };

} // namespace __dp
