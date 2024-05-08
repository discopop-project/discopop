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

#include "../../share/include/debug_print.hpp"
#include "../../share/include/timer.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <regex>
#include <set>
#include <string>

namespace __dp {

/******* Instrumentation function *******/
extern "C" {
// hybrid analysis
void __dp_add_bb_deps(char *depStringPtr) {
  if (!dpInited) {
    return;
  }
  
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("__dp_add_bb_deps");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ADD_BB_DEPS);
#endif

  std::string depString(depStringPtr);
  std::regex r0("[^\\/]+"), r1("[^=]+"), r2("[^,]+"), r3("[0-9]+:[0-9]+"),
      r4("(INIT|(R|W)A(R|W)).*");
  std::smatch res0, res1, res2, res3;

  while (regex_search(depString, res0, r0)) {
    std::string s(res0[0]);

    regex_search(s, res1, r1);
    std::string cond(res1[0]);

    if (bbList->find(stoi(cond)) == bbList->end()) {
      depString = res0.suffix();
      continue;
    }

    std::string line(res1.suffix());
    line.erase(0, 1);
    while (regex_search(line, res2, r2)) {
      std::string s(res2[0]);
      regex_search(s, res3, r3);
      std::string k(res3[0]);
      regex_search(s, res3, r4);
      std::string v(res3[0]);
      if (outPutDeps->count(k) == 0) {
        std::set<std::string> depSet;
        (*outPutDeps)[k] = depSet;
      }
      (*outPutDeps)[k].insert(v);
      line = res2.suffix();
    }
    depString = res0.suffix();
  }
}
// End HA
}

} // namespace __dp
