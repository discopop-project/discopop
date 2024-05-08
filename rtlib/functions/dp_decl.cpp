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
void __dp_decl(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count) {
#else
void __dp_decl(LID lid, ADDR addr, char *var) {
#endif

  if (!dpInited){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_decl\n";
#endif
#ifdef DP_INTERNAL_TIMER
  timers->start(TimerRegion::DECL);
#endif

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_write() is not executed since target program has returned "
              "from main()."
           << endl;
    }
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::DECL);
#endif
    return;
  }
  // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
  if (lastaddr == addr && count >= 2) {
    timers->stop_and_add(TimerRegion::DECL);
    return;
  }
#endif
  // For tracking function call or invoke
  lastCallOrInvoke = 0;
  lastProcessedLine = lid;

  if (DP_DEBUG) {
    cout << "instStore at encoded LID " << std::dec << dputil::decodeLID(lid)
         << " and addr " << std::hex << addr << endl;
  }

  int64_t workerID =
      ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
  AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
  current.isRead = false;
  current.lid = loop_manager->update_lid(0);
  current.var = var;
  current.AAvar = getMemoryRegionIdFromAddr(var, addr);
  current.addr = addr;
  current.skip = true;

  if (tempAddrCount[workerID] == CHUNK_SIZE) {
    pthread_mutex_lock(&addrChunkMutexes[workerID]);
    addrChunkPresent[workerID] = true;
    chunks[workerID].push(tempAddrChunks[workerID]);
    pthread_cond_signal(&addrChunkPresentConds[workerID]);
    pthread_mutex_unlock(&addrChunkMutexes[workerID]);
    tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
    tempAddrCount[workerID] = 0;
  }

#ifdef DP_INTERNAL_TIMER
  timers->stop_and_add(TimerRegion::DECL);
#endif
#ifdef DP_RTLIB_VERBOSE
  std::cout << "exit __dp_decl\n";
#endif
}

}

} // namespace __dp
