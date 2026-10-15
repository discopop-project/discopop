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

#include "DPTypes.hpp"

#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

#include "callback_scope.hpp"
#include "hybrid_analysis/bb_deps.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>


namespace dp {

/******* Instrumentation function *******/
extern "C" {

// hybrid analysis: reports an execution of the basic block whose dependencies
// handed over under bbIndex have their sources in the same execution of that
// basic block (or no source instruction at all, INIT). Both ends of these
// dependencies therefore carry the current callpath state.
void __dp_report_bb(std::uint32_t bb_index) {
  DP_CALLBACK_SCOPE(REPORT_BB);

#ifdef DP_RTLIB_VERBOSE
  std::cout << "bb_index: " << std::to_string(bb_index) << '\n';
#endif

  const std::uint32_t state = CurrentCallpathStateIdForBbReports();
  bb_list->Record(bb_index, state, state);
}
}

} // namespace dp
