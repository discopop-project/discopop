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
#include "../iFunctions.hpp"

#include "../../share/include/debug_print.hpp"
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
#ifdef SKIP_DUP_INSTR
void __dp_read(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count) {
#else
void __dp_read(LID lid, ADDR addr, const char *var) {
#endif

  if (!dpInited || targetTerminated) {
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("__dp_read");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::READ);
#endif

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_read() is not executed since target program has returned "
              "from main()."
           << endl;
    }
    return;
  }
  // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
  if (lastaddr == addr && count >= 2) {
    return;
  }
#endif

  function_manager->reset_call(lid);

  if (DP_DEBUG) {
    cout << "instLoad at encoded LID " << std::dec << dputil::decodeLID(lid)
         << " and addr " << std::hex << addr << endl;
  }

  // TEST
  // check for stack access
#if DP_STACK_ACCESS_DETECTION
  bool is_stack_access = memory_manager->is_stack_access(addr);
#endif
  // !TEST

#if defined DP_NUM_WORKERS && DP_NUM_WORKERS == 0
  AccessInfo current;
#else
  int64_t workerID =
      ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
  AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
#endif
  current.isRead = true;
  current.lid = loop_manager->update_lid(lid);
  current.var = var;
  current.AAvar = getMemoryRegionIdFromAddr(var, addr);
  current.addr = addr;
  
#if DP_STACK_ACCESS_DETECTION
  current.isStackAccess = is_stack_access;
  current.addrIsOwnedByScope =
      memory_manager->isFirstWrittenInScope(addr, false);
  current.positiveScopeChangeOccuredSinceLastAccess =
      memory_manager->positiveScopeChangeOccuredSinceLastAccess(addr);
  if (is_stack_access) {
    // register stack read after check for
    // positiveScopeChangeOccuredSinceLastAccess
    memory_manager->registerStackRead(addr, lid, var);
  }
#endif
  
#if defined DP_NUM_WORKERS && DP_NUM_WORKERS == 0
  analyzeSingleAccess(singleThreadedExecutionSMem, current);
#else
  if (tempAddrCount[workerID] == CHUNK_SIZE) {
    pthread_mutex_lock(&addrChunkMutexes[workerID]);
    addrChunkPresent[workerID] = true;
    chunks[workerID].push(tempAddrChunks[workerID]);
    pthread_cond_signal(&addrChunkPresentConds[workerID]);
    pthread_mutex_unlock(&addrChunkMutexes[workerID]);
    tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
    tempAddrCount[workerID] = 0;
  }
#endif
}

}

} // namespace __dp
