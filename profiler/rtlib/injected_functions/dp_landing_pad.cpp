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

#include "dp_landing_pad.hpp"

#include <mutex>

#include "callback_scope.hpp"
#include "runtimeFunctionsGlobals.hpp"
#include "static_callstate_transitions/utils.hpp"

namespace dp {

/******* Instrumentation function *******/
extern "C" {

// An exception unwinds the stack without running the __dp_func_exit of the functions it leaves.
// Their callpath states are discarded here, when the landing pad of the function which continues
// is reached.
void __dp_landing_pad(int32_t function_entry_id) {
  DP_CALLBACK_SCOPE(LANDING_PAD);

  ResumeFunctionForCallstate(function_entry_id);
}
}

}  // namespace dp
