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

void __dp_func_exit(LID lid, int32_t isExit) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_func_exit\n";
#endif
#ifdef DP_INTERNAL_TIMER
  timers->start(TimerRegion::FUNC_EXIT);
#endif

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "Exiting function LID " << std::dec << dputil::decodeLID(lid);
      cout << " but target program has returned from main(). Destructors?"
           << endl;
    }
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::FUNC_EXIT);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_func_exit\n";
#endif
    return;
  }

  lastCallOrInvoke = 0;
  lastProcessedLine = lid;

  // Clear up all unfinished loops in the function.
  // This usually happens when using return inside loop.
  while (!loopStack->empty() &&
         (loopStack->top().funcLevel == FuncStackLevel)) {

    // No way to get the real end line of loop. Use the line where
    // function returns instead.
    LoopRecords::iterator loop = loops->find(loopStack->top().begin);
    assert(loop != loops->end() &&
           "A loop ends without its entry being recorded.");
    if (loop->second->end == 0) {
      loop->second->end = lid;
    } else {
      // TODO: FIXME: loop end line > return line
    }
    loop->second->total += loopStack->top().count;
    ++loop->second->nEntered;

    if (DP_DEBUG) {
      cout << "(" << std::dec << loopStack->top().funcLevel << ")";
      cout << "Loop " << loopStack->top().loopID
           << " exits since function returns." << endl;
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
  }
  --FuncStackLevel;

  // TEST
  // clear information on allocated stack addresses
  const auto last_addresses = memory_manager->pop_last_stack_address();
  clearStackAccesses(last_addresses.first, last_addresses.second); // insert accesses with LID 0 to the queues
  memory_manager->leaveScope("function", lid);
  // !TEST

  if (isExit == 0)
    endFuncs->insert(lid);

  if (DP_DEBUG) {
    cout << "Exiting fucntion LID " << std::dec << dputil::decodeLID(lid) << endl;
    cout << "Function stack level = " << std::dec << FuncStackLevel << endl;
  }

#ifdef DP_INTERNAL_TIMER
  timers->stop_and_add(TimerRegion::FUNC_EXIT);
#endif
#ifdef DP_RTLIB_VERBOSE
  std::cout << "exit __dp_func_exit\n";
#endif
}

}

} // namespace __dp
