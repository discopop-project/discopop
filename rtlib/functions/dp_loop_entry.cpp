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

#include "../CallStack.hpp"

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

void __dp_loop_entry(LID lid, int32_t loopID) {
  if (!dpInited){
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "__dp_loop_entry\n";
#endif
  timers->start(TimerRegion::LOOP_ENTRY);

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_loop_entry() is not executed since target program has "
              "returned from main()."
           << endl;
    }
    timers->stop_and_add(TimerRegion::LOOP_ENTRY);
    return;
  }
  assert((loopStack != nullptr) && "Loop stack is not available!");

  if (loopStack->empty() || (loopStack->top().loopID != loopID)) {
    // A new loop
    loopStack->push(LoopTableEntry(FuncStackLevel, loopID, 0, lid));
    if (loops->find(lid) == loops->end()) {
      loops->insert(pair<LID, LoopRecord *>(lid, new LoopRecord(0, 0, 0)));
      callStack->push(new CallStackEntry(1, lid, 0));
    }
    if (DP_DEBUG) {
      cout << "(" << std::dec << FuncStackLevel << ")Loop " << loopID
           << " enters." << endl;
    }
    scopeManager->enterScope("loop", lid);
  } else {
    // The same loop iterates again
    loopStack->top().count++;
    callStack->incrementIterationCounter();
    if (DP_DEBUG) {
      cout << "(" << std::dec << loopStack->top().funcLevel << ")";
      cout << "Loop " << loopStack->top().loopID << " iterates "
           << loopStack->top().count << " times." << endl;
    }

    // Handle error made in instrumentation.
    // When recorded loopStack->top().funcLevel is different
    // with the current FuncStackLevel, two possible errors
    // happen during instrumentation:
    // 1) the loop entry is wrong, earlier than the real place;
    // 2) return of at least one function call inside the loop
    //    is missing.
    // So far it seems the first case happens sometimes but
    // the second case has never been seen. Thus whenever we
    // encounter such problem, we trust the current FuncStackLevel
    // and update top().funcLevel.
    if (loopStack->top().funcLevel != FuncStackLevel) {
      if (DP_DEBUG) {
        cout << "WARNING: changing funcLevel of Loop "
             << loopStack->top().loopID << " from "
             << loopStack->top().funcLevel << " to " << FuncStackLevel << endl;
      }
      loopStack->top().funcLevel = FuncStackLevel;
    }

    scopeManager->leaveScope("loop_iteration", lid);
    scopeManager->enterScope("loop_iteration", lid);
  }
  
  timers->stop_and_add(TimerRegion::LOOP_ENTRY);
}

}

} // namespace __dp
