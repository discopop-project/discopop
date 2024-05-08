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

void __dp_call(LID lid) {
  if (!dpInited) {
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_call\n";
#endif
#ifdef DP_INTERNAL_TIMER
  timers->start(TimerRegion::CALL);
#endif

  lastCallOrInvoke = lid;

#ifdef DP_INTERNAL_TIMER
  timers->stop_and_add(TimerRegion::CALL);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_call\n";
#endif
}

}

} // namespace __dp
