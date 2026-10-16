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

#include "DPTypes.hpp"

namespace dp {

/******* Instrumentation function *******/
extern "C" {

// functionEntryID: instruction id of this __dp_func_entry call, identifies the function
void __dp_func_entry(LID lid, int32_t is_start, int32_t function_entry_id);
}

}  // namespace dp
