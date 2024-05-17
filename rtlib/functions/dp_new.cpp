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

#include "../DPTypes.hpp"

#include "../iFunctionsGlobals.hpp"

#include "../../share/include/timer.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

using namespace std;

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_new(LID lid, ADDR startAddr, ADDR endAddr, int64_t numBytes) {
  if ((!dpInited) || (targetTerminated)){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_new\n";
#endif
  timers->start(TimerRegion::NEW);

  // instrumentation function for new and malloc
  int64_t buffer = nextFreeMemoryRegionId;
  string allocId = to_string(buffer);
  nextFreeMemoryRegionId++;

  // calculate endAddr of memory region
  endAddr = startAddr + numBytes;

  allocatedMemRegTree->allocate_region(startAddr, endAddr, buffer,
                                       tempAddrCount, NUM_WORKERS);

  if (DP_DEBUG) {
    cout << "new/malloc: " << dputil::decodeLID(lid) << ", " << allocId << ", "
         << std::hex << startAddr << " - " << std::hex << endAddr;
    printf(" NumBytes: %lld\n", numBytes);
  }

  allocatedMemoryRegions->emplace_back(lid, allocId, startAddr, endAddr, numBytes, -1);
  lastHitIterator = allocatedMemoryRegions->end();
  lastHitIterator--;

  // update known min and max ADDR
  if (startAddr < smallestAllocatedADDR) {
    smallestAllocatedADDR = startAddr;
  }
  if (endAddr > largestAllocatedADDR) {
    largestAllocatedADDR = endAddr;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_new\n";
#endif
  timers->stop_and_add(TimerRegion::NEW);
}

}

} // namespace __dp
