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
  if (!dpInited){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  std::cout << "enter __dp_alloca\n";
#endif
  timers->start(TimerRegion::ALLOCA);
  
  // create entry to list of allocatedMemoryRegions
  const std::string allocId = memory_manager->allocate_memory(lid, startAddr, endAddr, numBytes, numElements);

  if (DP_DEBUG) {
    cout << "alloca: " << var << " (" << allocId << ") @ " << dputil::decodeLID(lid)
         << " : " << std::hex << startAddr << " - " << std::hex << endAddr
         << " -> #allocations: " << memory_manager->get_number_allocations()
         << "\n";
  }

#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_alloca\n";
#endif

  timers->stop_and_add(TimerRegion::ALLOCA);
}

}

} // namespace __dp
