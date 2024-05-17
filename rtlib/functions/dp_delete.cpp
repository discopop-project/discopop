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

void __dp_delete(LID lid, ADDR startAddr) {
  if ((!dpInited) || (targetTerminated)){
    return;
  }
  
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_delete\n";
#endif
  timers->start(TimerRegion::DELETE);

  // DO NOT DELETE MEMORY REGIONS AS THEY ARE STILL REQUIRED FOR LOGGING

  // TODO more efficient implementation

  // find memory region to be deleted
/*        for(tuple<LID, string, int64_t, int64_t, int64_t, int64_t> entry :
   allocatedMemoryRegions){ if(get<2>(entry) == startAddr){
                // delete memory region
                cout << "delete/free: " << decodeLID(lid) << ", " <<
   get<1>(entry) << ", " << std::hex << startAddr << "\n";
                allocatedMemoryRegions.remove(entry);
                return;
            }
        }
        cout << "__dp_delete: Could not find base addr: " << std::hex <<
   startAddr << "\n";
*/
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_delete\n";
#endif

  timers->stop_and_add(TimerRegion::DELETE);
}

}

} // namespace __dp
