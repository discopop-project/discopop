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


#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

#include "memory/PerfectShadow.hpp"
#include "timer.hpp"

#include <cstddef>
#include <cstdint>
#include <functional>
#include <iostream>
#include <unistd.h>
#include <unordered_set>
#include <vector>

#ifdef __linux__
#include <sched.h>
#endif

using namespace std;

namespace __dp {

namespace {

// What a deferred access is identified by: the address, the instruction and call path state
// its LID carries, whether it reads or writes, and whether it is one of the markers the
// hybrid analysis inserts. Two accesses that agree on all of it derive the same dependency
// from the state the earlier chunks left behind. Leaving the direction out of this made a
// read swallow the write that followed it on the same address and line.
struct DeferredAccess {
  ADDR addr;
  LID lid;
  bool isRead;
  bool skip;

  bool operator==(const DeferredAccess &other) const noexcept {
    return addr == other.addr && lid == other.lid && isRead == other.isRead && skip == other.skip;
  }
};

struct DeferredAccessHash {
  std::size_t operator()(const DeferredAccess &access) const noexcept {
    const std::size_t flags = (access.isRead ? 1u : 0u) | (access.skip ? 2u : 0u);
    return std::hash<ADDR>()(access.addr) ^ (std::hash<LID>()(access.lid) << 1) ^ (flags << 3);
  }
};

// After this many deferred accesses in one chunk, the deduplication has to have paid for
// itself -- see DEFERRED_DEDUP_MIN_HIT_RATE. Long enough to measure, short enough that a
// chunk of 100000 accesses does not spend much of itself deciding.
constexpr std::size_t DEFERRED_DEDUP_TRIAL = 4096;

// The share of deferred accesses that has to be a repeat of one already queued for the table
// to be worth a hash insert per access. Code that walks a new address every time -- a linked
// list, a large array touched once -- finds nothing and drops far below this.
constexpr double DEFERRED_DEDUP_MIN_HIT_RATE = 0.25;

} // namespace

void *processFirstAccessQueue(void *arg) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_DEPS);
#endif

  const std::intptr_t id = reinterpret_cast<std::intptr_t>(arg);
  myMap = new depMap();

  FirstAccessQueueChunk *current = nullptr;


  while (true) {
    // get chunk from queue
    current = firstAccessQueue.get(&secondAccessQueue);

    // check if chunk aquired
    if (current) {
      // process chunk
      AbstractShadow *SMem = new PerfectShadow2();
      std::vector<AccessInfo> *entry_condition_accesses = new std::vector<AccessInfo>();
      std::unordered_set<DeferredAccess, DeferredAccessHash> already_deferred;
      // Given up once the chunk turns out not to repeat its accesses.
      bool deduplicate = true;
      std::size_t deferred_seen = 0;
      std::size_t deferred_repeats = 0;

      for (AccessInfo access : *(current->get_buffer())) {
        if (!(access.addr || access.lid)) {
          continue;
        }

        // An access can be analyzed against the chunk local shadow only once that shadow
        // knows everything about its address, and it does from the first write to it on.
        // Before that, "no earlier write in this chunk" is not "no earlier write", and where
        // the chunk boundary happens to fall decides what is reported. So everything up to
        // and including the first write to an address is analyzed by the second queue, which
        // carries the state the earlier chunks left behind.
        bool is_entry_condition_access = SMem->testInWrite(access.addr) == 0;
        if (is_entry_condition_access) {
          // Once per address and LID: the second queue would derive the same dependency from
          // the second one, and a read heavy chunk repeats the same pair thousands of times.
          // The shadow below is still updated for every one of them, so the state this chunk
          // hands on is the state of its last access.
          if (deduplicate) {
            ++deferred_seen;
            if (already_deferred.insert(DeferredAccess{access.addr, access.lid, access.isRead, access.skip})
                    .second) {
              entry_condition_accesses->push_back(access);
            } else {
              ++deferred_repeats;
            }
            if (deferred_seen == DEFERRED_DEDUP_TRIAL &&
                static_cast<double>(deferred_repeats) / static_cast<double>(deferred_seen) <
                    DEFERRED_DEDUP_MIN_HIT_RATE) {
              already_deferred.clear();
              deduplicate = false;
            }
          } else {
            entry_condition_accesses->push_back(access);
          }
          // register the read / write represented by the access to allow the identification of correct dependencies for
          // the rest of the chunk
          if (access.isRead) {
            SMem->insertToRead(access.addr, access.lid);
          } else {
            SMem->insertToWrite(access.addr, access.lid);
          }
        } else {
          // handle access as known from the legacy variant of the profiler
          analyzeSingleAccess(SMem, access);
        }
      }
      // publish the values of the promises in the current chunk
      current->entry_boundary_first_addr_accesses.set_value(entry_condition_accesses);
      current->exit_boundary_SMem.set_value(SMem);

      // the thread's dependencies stay in myMap across chunks, deduplicated, and are merged into
      // allDeps once when the thread ends: merging (and freeing) them per chunk allocated and freed
      // a set per dependency sink and chunk again and again
      delete current;

    } else {
      if (finalizeParallelizationCalled) {
        // no chunks left to process. Let thread finish.
        break;
      }         // let thread sleep and try fetching a chunk again after potentially preparing an new chunk
        firstAccessQueueChunkBuffer.prepare_chunk_if_required(FIRST_ACCESS_QUEUE_CHUNK_SIZE);
        usleep(1000);

    }
  }

  mergeDeps();
  // the dependencies are merged into allDeps; the map itself belongs to this thread
  delete myMap;
  myMap = nullptr;


  if (DP_DEBUG) {
#ifdef __linux__
    cout << "thread " << id << " on core " << sched_getcpu() << " exits... \n";
#else
    cout << "thread " << id << " exits... \n";
#endif
  }

  pthread_exit(nullptr);
  return nullptr;
}

void *processSecondAccessQueue(void *arg) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_DEPS);
#endif

  const std::intptr_t id = reinterpret_cast<std::intptr_t>(arg);
  myMap = new depMap();

  SecondAccessQueueElement *current = nullptr;
  AbstractShadow *SMem = new PerfectShadow2();

  while (true) {
    // get chunk from queue
    current = secondAccessQueue.get();

    // check if chunk aquired
    if (current) {
      // check entry boundary conditions for data dependencies
      auto promised_first_accesses_vector_ptr = current->entry_boundary_first_addr_accesses.get();
      for (auto &entry_accesses : *(promised_first_accesses_vector_ptr)) {
        // ignore unused entries of the vector
        if (!(entry_accesses.addr || entry_accesses.lid)) {
          continue;
        }
        analyzeSingleAccess(SMem, entry_accesses);
      }

      // update persistent SMem with exit boundary conditions (aka merge the local into the persistent shadow memories)
      AbstractShadow *promised_last_smem_ptr = current->exit_boundary_SMem.get();

      auto sigRead = ((PerfectShadow2 *)promised_last_smem_ptr)->getSigRead();
      auto sigWrite = ((PerfectShadow2 *)promised_last_smem_ptr)->getSigWrite();

      // identify required updates to SMem
      // iterate over addresses to be merged
      for (auto it = promised_first_accesses_vector_ptr->begin(); it < promised_first_accesses_vector_ptr->end();
           ++it) {
        SMem->updateInRead(it->addr, sigRead->at(it->addr));
        SMem->updateInWrite(it->addr, sigWrite->at(it->addr));
      }

      // cleanup promises
      delete promised_first_accesses_vector_ptr;
      delete promised_last_smem_ptr;

      delete current;

    } else {
      if (finalizeParallelizationCalled) {
        // a first queue worker may have moved a chunk into the second queue since the get() above.
        // FirstAccessQueue::get registers the element in the second queue while holding the first queue's lock, so once
        // the first queue is empty, every element is visible in the second queue: check them in this order
        if (firstAccessQueue.empty() && secondAccessQueue.empty()) {
          // no chunks left to process. Let thread finish.
          break;
        }           usleep(1000);

      } else {
        // let thread sleep and try fetching a chunk again
        usleep(1000);
      }
    }
  }


  delete SMem;
  mergeDeps();
  // the dependencies are merged into allDeps; the map itself belongs to this thread
  delete myMap;
  myMap = nullptr;

  if (DP_DEBUG) {
#ifdef __linux__
    cout << "thread " << id << " processing secondAccessQueue on core " << sched_getcpu() << " exits... \n";
#else
    cout << "thread " << id << " processing secondAccessQueue exits... \n";
#endif
  }

  pthread_exit(nullptr);
  return nullptr;
}

} // namespace __dp
