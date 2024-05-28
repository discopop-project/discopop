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

void __dp_report_bb(uint32_t bbIndex) {
  if ((!dpInited) || (targetTerminated)){
    return;
  }
  
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_report_bb\n";
  cout << "bbIndex: " << std::to_string(bbIndex) << "\n";
#endif
  timers->start(TimerRegion::REPORT_BB);

  bbList->insert(bbIndex);
#ifdef DP_RTLIB_VERBOSE
  cout << "exit __dp_report_bb\n";
#endif

  timers->stop_and_add(TimerRegion::REPORT_BB);
}

}

} // namespace __dp
