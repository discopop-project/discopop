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
#include "../DPUtils.hpp"

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

void __dp_alloca(LID lid, char *var, ADDR startAddr, ADDR endAddr,
                 int64_t numBytes, int64_t numElements) {
  if ((!dpInited) || (targetTerminated)){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  std::cout << "enter __dp_alloca\n";
#endif
  timers->start(TimerRegion::ALLOCA);

  std::int64_t buffer = nextFreeMemoryRegionId;
  std::string allocId = std::to_string(buffer);
  nextFreeMemoryRegionId++;
  // create entry to list of allocatedMemoryRegions
  std::string var_name = allocId;
  if (DP_DEBUG) {
    cout << "alloca: " << var << " (" << var_name << ") @ " << dputil::decodeLID(lid)
         << " : " << std::hex << startAddr << " - " << std::hex << endAddr
         << " -> #allocations: " << allocatedMemoryRegions->size()
         << "\n";
  }
  allocatedMemoryRegions->emplace_back(
          lid, var_name, startAddr, endAddr, numBytes, numElements);
  allocatedMemRegTree->allocate_region(startAddr, endAddr, buffer,
                                       tempAddrCount, NUM_WORKERS);

  // update known min and max ADDR
  if (startAddr < smallestAllocatedADDR) {
    smallestAllocatedADDR = startAddr;
  }
  if (endAddr > largestAllocatedADDR) {
    largestAllocatedADDR = endAddr;
  }

  // TEST
  // update stack base address, if not already set
  if (stackAddrs->top().first == 0) {
    //            cout << "SET STACK BASE!\n";
    stackAddrs->top().first = startAddr;
  }
  //        else{
  //            cout << "NOT NECESSARY: SET STACK BASE\n";
  //        }

  // update stack top address (note: stack grows top down!)
  if (stackAddrs->top().second == 0) {
    // initialize stack top address
    stackAddrs->top().second = endAddr;
  } else if (stackAddrs->top().second > endAddr) {
    // update stack top
    //            cout << "UPDATE STACK TOP: " << stackAddrs->top().second << "
    //            -->  " << endAddr << "\n";
    stackAddrs->top().second = endAddr;
  }

  //        cout << "STACK REGION: " << stackAddrs->top().first << " - " <<
  //        stackAddrs->top().second << "\n";
  // !TEST

#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_alloca\n";
#endif

  timers->stop_and_add(TimerRegion::ALLOCA);
}


}

} // namespace __dp
