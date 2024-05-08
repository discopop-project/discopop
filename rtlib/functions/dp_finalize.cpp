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

#include "dp_func_exit.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

using namespace std;

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_finalize(LID lid) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  pthread_compatibility_mutex.lock();
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_finalize\n";
#endif
#ifdef DP_INTERNAL_TIMER
  timers->start(TimerRegion::FINALIZE);
#endif

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_finalize() has been called before. Doing nothing this time "
              "to avoid double free."
           << endl;
    }
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
    pthread_compatibility_mutex.unlock();
#endif
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::FINALIZE);
    timers->print(std::cout);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_finalize\n";
#endif
    return;
  }

  // release mutex so it can be re-aquired in the called __dp_func_exit
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  pthread_compatibility_mutex.unlock();
#endif

  while (FuncStackLevel >= 0) {
    __dp_func_exit(lid, 1);
  }

  // use lock_guard here, since no other mutex-aquiring function is called
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif

  // Returning from main or exit from somewhere, clear up everything.
  assert(FuncStackLevel == -1 &&
         "Program terminates without clearing function stack!");
  assert(loopStack->empty() &&
         "Program terminates but loop stack is not empty!");

  if (DP_DEBUG) {
    cout << "Program terminates at LID " << std::dec << dputil::decodeLID(lid)
         << ", clearing up" << endl;
  }

  finalizeParallelization();
  outputLoops();
  outputFuncs();
  outputAllocations();
  // hybrid analysis
  generateStringDepMap();
  // End HA
  outputDeps();

  delete loopStack;
  delete endFuncs;
  // hybrid analysis
  delete allDeps;
  delete outPutDeps;
  delete bbList;
  // End HA

  for (auto loop : *loops) {
    delete loop.second;
  }
  delete loops;

  for (auto fb : *beginFuncs) {
    delete fb.second;
  }
  delete beginFuncs;

  // TEST
  // delete scopeManager;
  // !TEST

  *out << dputil::decodeLID(lid) << " END program" << endl;
  out->flush();
  out->close();

  delete out;

  dpInited = false;
  targetTerminated = true; // mark the target program has returned from main()

  if (DP_DEBUG) {
    cout << "Program terminated." << endl;
  }

#ifdef DP_INTERNAL_TIMER
  timers->stop_and_add(TimerRegion::FINALIZE);
  timers->print(std::cout);
  delete timers;
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_finalize\n";
#endif
}

}

} // namespace __dp
