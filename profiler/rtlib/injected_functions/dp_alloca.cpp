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
#include "../DPUtils.hpp"

#include "../runtimeFunctionsGlobals.hpp"

#include "../callback_scope.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

using namespace std;

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_alloca(LID lid, char *var, ADDR startAddr, ADDR endAddr, int64_t numBytes, int64_t numElements) {
  DP_CALLBACK_SCOPE(ALLOCA);
}
}

} // namespace __dp
