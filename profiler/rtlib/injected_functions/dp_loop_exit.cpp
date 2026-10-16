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

#include "dp_loop_exit.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

#include "DPTypes.hpp"
#include "callback_scope.hpp"
#include "runtimeFunctionsGlobals.hpp"
#include "static_callstate_transitions/utils.hpp"

namespace dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_loop_exit(LID lid, std::int32_t loop_id, std::int32_t instruction_id) {
  DP_CALLBACK_SCOPE(LOOP_EXIT);

  // __dp_loop_exit() can be called without __dp_loop_entry()
  // being called. This can happen when a loop is encapsulated
  // by an "if" structure, and the condition of "if" fails
  if (loop_manager->IsSingleExit(loop_id)) {
    if (dp_debug) {
      std::cout << "Ignored single exit of loop " << loop_manager->GetCurrentLoopId() << std::endl;
    }
    return;
  }

  // See comments in __dp_loop_entry() for explanation.
  const auto function_stack_level = function_manager->GetCurrentStackLevel();
  loop_manager->CorrectFuncLevel(function_stack_level);
  loop_manager->ExitLoop(lid);

  UpdateCallstate(instruction_id);
}
}

}  // namespace dp
