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

#include "static_callstate_transitions/utils.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>


namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_func_exit(LID lid, std::int32_t isExit) {
  if (!profiling_active()) {
    if (DP_DEBUG) {
      std::cout << "Exiting function LID " << std::dec << dputil::decodeLID(lid);
      std::cout << " but the runtime is not running. Destructors?" << std::endl;
    }
    return;
  }

  DP_CALLBACK_SCOPE(FUNC_EXIT);

  loop_manager->clean_function_exit(function_manager->get_current_stack_level(), lid);

  function_manager->reset_call(lid);
  function_manager->decrease_stack_level();


  if (isExit == 0) {
    function_manager->register_function_end(lid);
  }

  if (DP_DEBUG) {
    std::cout << "Exiting fucntion LID " << std::dec << dputil::decodeLID(lid) << std::endl;
    std::cout << "Function stack level = " << std::dec << function_manager->get_current_stack_level() << std::endl;
  }
  // restore the callpath state of the caller, still under the lock (released with dp_scope)
  leave_function_for_callstate();
}
}

} // namespace __dp
