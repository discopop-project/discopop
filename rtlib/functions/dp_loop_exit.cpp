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
  cout << "enter __dp_loop_exit\n";
#endif
#ifdef DP_INTERNAL_TIMER
  timers->start(TimerRegion::LOOP_EXIT);
#endif

  if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "__dp_loop_exit() is not executed since target program has "
              "returned from main()."
           << endl;
    }
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::LOOP_EXIT);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_loop_exit\n";
#endif
    return;
  }

  // __dp_loop_exit() can be called without __dp_loop_entry()
  // being called. This can happen when a loop is encapsulated
  // by an "if" structure, and the condition of "if" fails
  if (loop_manager->is_single_exit(loopID)) {
    if (DP_DEBUG) {
      std::cout << "Ignored single exit of loop " << loop_manager->get_current_loop_id() << endl;
    }
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::LOOP_EXIT);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_loop_exit\n";
#endif
    return;
  }

  // See comments in __dp_loop_entry() for explanation.
  loop_manager->correct_func_level(FuncStackLevel);
  loop_manager->exit_loop(lid);

  memory_manager->leaveScope("loop", lid);
  
#ifdef DP_INTERNAL_TIMER
    timers->stop_and_add(TimerRegion::LOOP_EXIT);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_loop_exit\n";
#endif
}

}

} // namespace __dp
