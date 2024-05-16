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
void __dp_read(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count) {
#else
void __dp_read(LID lid, ADDR addr, char *var) {
#endif

  if (!dpInited){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_read\n";
#endif
  timers->start(TimerRegion::READ);

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_read() is not executed since target program has returned "
              "from main()."
           << endl;
    }
    timers->stop_and_add(TimerRegion::READ);
    return;
  }
  // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
  if (lastaddr == addr && count >= 2) {
    timers->stop_and_add(TimerRegion::READ);
    return;
  }
#endif

  lastCallOrInvoke = 0;
  lastProcessedLine = lid;

  if (DP_DEBUG) {
    cout << "instLoad at encoded LID " << std::dec << dputil::decodeLID(lid)
         << " and addr " << std::hex << addr << endl;
  }

  // TEST
  // check for stack access
  timers->start(TimerRegion::STACK_CHECK_READ_ACCESS);
  bool is_stack_access = false;
  if (stackAddrs->top().first && stackAddrs->top().second) {
    if ((addr <= stackAddrs->top().first) &&
        (addr >= stackAddrs->top().second)) {
          timers->start(TimerRegion::STACK_FOUND_READ_ACCESS);
      is_stack_access = true;
          timers->stop_and_add(TimerRegion::STACK_FOUND_READ_ACCESS);
    }
  }
  timers->stop_and_add(TimerRegion::STACK_CHECK_READ_ACCESS);
  // !TEST

  // addAccessInfo(true, lid, var, addr);
  int64_t workerID =
      ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
  AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
  current.isRead = true;
  current.lid = lid;
  current.var = var;
  current.AAvar = getMemoryRegionIdFromAddr(var, addr);
  current.addr = addr;
  current.isStackAccess = is_stack_access;
  timers->start(TimerRegion::STACK_CHECK_ADDR_IS_OWNED_BY_SCOPE);
  current.addrIsOwnedByScope =
      scopeManager->isOwnedByScope(addr, false);
  timers->stop_and_add(TimerRegion::STACK_CHECK_ADDR_IS_OWNED_BY_SCOPE);
  if(current.addrIsOwnedByScope){
    timers->start(TimerRegion::STACK_CHECK_ADDR_IS_OWNED_BY_SCOPE_TRUE);
      timers->stop_and_add(TimerRegion::STACK_CHECK_ADDR_IS_OWNED_BY_SCOPE_TRUE);
  }
  current.positiveScopeChangeOccuredSinceLastAccess =
      scopeManager->positiveScopeChangeOccuredSinceLastAccess(addr);

  if (is_stack_access) {
    // register stack read after check for
    // positiveScopeChangeOccuredSinceLastAccess
    scopeManager->registerStackRead(addr, lid, var);
  }

  // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop
  // iteration count as valid, last 7 bits for loop iteration) last 8 bits are
  // sufficient, since metadata is only used to check for different iterations,
  // not exact values. first 32 bits of current.lid are reserved for metadata
  // and thus empty
  if (loopStack->size() > 0) {
    if (loopStack->size() == 1) {
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id
      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
    } else if (loopStack->size() == 2) {
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id
      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(1).count & 0x7F))
                                   << 40); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000800000000000; // mark loop count valid
    } else {                                     // (loopStack->size() >= 3)
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id
      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(1).count & 0x7F))
                                   << 40); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000800000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(2).count & 0x7F))
                                   << 32); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000008000000000; // mark loop count valid
    }
  } else {
    // mark loopID as invalid (0xFF to allow 0 as valid loop id)
    current.lid = current.lid | (((LID)0xFF) << 56);
  }

  if (tempAddrCount[workerID] == CHUNK_SIZE) {
    pthread_mutex_lock(&addrChunkMutexes[workerID]);
    addrChunkPresent[workerID] = true;
    chunks[workerID].push(tempAddrChunks[workerID]);
    pthread_cond_signal(&addrChunkPresentConds[workerID]);
    pthread_mutex_unlock(&addrChunkMutexes[workerID]);
    tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
    tempAddrCount[workerID] = 0;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_read\n";
#endif

  timers->stop_and_add(TimerRegion::READ);
}
}

} // namespace __dp
