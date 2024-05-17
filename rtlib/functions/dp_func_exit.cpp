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

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "Exiting function LID " << std::dec << dputil::decodeLID(lid);
      cout << " but target program has returned from main(). Destructors?"
           << endl;
    }
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "__dp_func_exit\n";
#endif
  timers->start(TimerRegion::FUNC_EXIT);


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
  //        if(stackAddrs->size() > 0){
  //            cout << "POP STACK ENTRY: " << hex << stackAddrs->top().first <<
  //            " -> " << hex << stackAddrs->top().second << " \n";
  //        }
  clearStackAccesses(
      stackAddrs->top().first,
      stackAddrs->top().second); // insert accesses with LID 0 to the queues
  stackAddrs->pop();
  //        if(stackAddrs->size() > 0){
  //            cout << "\tNEW TOP STACK ENTRY: " <<  hex <<
  //            stackAddrs->top().first << " -> " << hex <<
  //            stackAddrs->top().second << " \n";
  //        }
  scopeManager->leaveScope("function", lid);
  // !TEST

  if (isExit == 0)
    endFuncs->insert(lid);

  if (DP_DEBUG) {
    cout << "Exiting fucntion LID " << std::dec << dputil::decodeLID(lid) << endl;
    cout << "Function stack level = " << std::dec << FuncStackLevel << endl;
  }
  
  timers->stop_and_add(TimerRegion::FUNC_EXIT);
}

}

} // namespace __dp
