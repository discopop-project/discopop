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

#include "dp_new.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

#include "DPTypes.hpp"
#include "callback_scope.hpp"
#include "runtimeFunctionsGlobals.hpp"

namespace dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_new(LID /*lid*/, ADDR /*startAddr*/, ADDR /*endAddr*/, std::int64_t /*numBytes*/) { DP_CALLBACK_SCOPE(NEW); }
}

}  // namespace dp
