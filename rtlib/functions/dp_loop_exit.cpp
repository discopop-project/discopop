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

void __dp_loop_exit(LID lid, int32_t loopID) {
  if(!dpInited){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "__dp_loop_exit\n";
#endif
  timers->start(TimerRegion::LOOP_EXIT);

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_loop_exit() is not executed since target program has "
              "returned from main()."
           << endl;
    }
    timers->stop_and_add(TimerRegion::LOOP_EXIT);
    return;
  }
  assert((loopStack != nullptr) && "Loop stack is not available!");

  // __dp_loop_exit() can be called without __dp_loop_entry()
  // being called. This can happen when a loop is encapsulated
  // by an "if" strucutre, and the condition of "if" fails
  bool singleExit = false;
  if (loopStack->empty())
    singleExit = true;
  else if (loopStack->top().loopID != loopID)
    singleExit = true;

  if (singleExit) {
    if (DP_DEBUG) {
      cout << "Ignored signle exit of loop " << loopStack->top().loopID << endl;
    }
    timers->stop_and_add(TimerRegion::LOOP_EXIT);
    return;
  }

  // See comments in __dp_loop_entry() for explanation.
  if (loopStack->top().funcLevel != FuncStackLevel) {
    if (DP_DEBUG) {
      cout << "WARNING: changing funcLevel of Loop " << loopStack->top().loopID
           << " from " << loopStack->top().funcLevel << " to " << FuncStackLevel
           << endl;
    }
    loopStack->top().funcLevel = FuncStackLevel;
  }

  LoopRecords::iterator loop = loops->find(loopStack->top().begin);
  assert(loop != loops->end() &&
         "A loop ends without its entry being recorded.");
  if (loop->second->end == 0) {
    loop->second->end = lid;
  } else {
    // New loop exit found and it's smaller than before. That means
    // the current exit point can be the break inside the loop.
    // In this case we ignore the current exit point and keep the
    // regular one.

    // Note: keep, as i may be necessary in the future?
    if (lid < loop->second->end) {
      //    loop->second->end = lid;
    }
    // New loop exit found and it's bigger than before. This can
    // happen when the previous exit is a break inside the loop.
    // In this case we update the loop exit to the bigger one.
    else if (lid > loop->second->end) {
      loop->second->end = lid;
    }
    // New loop exit found and it's the same as before. Good.
  }
  if (loop->second->maxIterationCount < loopStack->top().count) {
    loop->second->maxIterationCount = loopStack->top().count;
  }
  loop->second->total += loopStack->top().count;
  ++loop->second->nEntered;

  if (DP_DEBUG) {
    cout << "(" << std::dec << loopStack->top().funcLevel << ")";
    cout << "Loop " << loopStack->top().loopID << " exits." << endl;
  }

  loopStack->pop();

  if (DP_DEBUG) {
    if (loopStack->empty())
      cout << "Loop Stack is empty." << endl;
    else {
      cout << "TOP: (" << std::dec << loopStack->top().funcLevel << ")";
      cout << "Loop " << loopStack->top().loopID << "." << endl;
    }
  }

  scopeManager->leaveScope("loop", lid);
  timers->stop_and_add(TimerRegion::LOOP_EXIT);
}

}

} // namespace __dp
