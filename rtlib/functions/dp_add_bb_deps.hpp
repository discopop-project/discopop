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

#pragma once

#include "../DPTypes.hpp"

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

// hybrid analysis
void __dp_add_bb_deps(char *depStringPtr);
// End HA

}

} // namespace __dp
