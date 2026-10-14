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

#include <cstdint>

#include "lid_constants.hpp"

// #define SKIP_DUP_INSTR 1

typedef std::int64_t sigElement;

namespace __dp {
// The runtime debug flag, defined in runtimeFunctionsGlobals.cpp. Declared in this header and
// not only in runtimeFunctionsGlobals.hpp, because the managers below rtlib report through it
// as well and cannot include that header: it includes them.
extern bool DP_DEBUG;
} // namespace __dp

// TODO(Lukas): Is this valid?
#define USE_EMHASH

#ifdef USE_EMHASH
#include "emhash/hash_set8.hpp"
#include "emhash/hash_table7.hpp"
namespace __dp {
template <typename KeyT, typename ValueT> using hashmap = emhash7::HashMap<KeyT, ValueT>;
template <typename KeyT> using hashset = emhash8::HashSet<KeyT>;
} // namespace __dp
#else
#include <unordered_map>
#include <unordered_set>
namespace __dp {
template <typename KeyT, typename ValueT> using hashmap = std::unordered_map<KeyT, ValueT>;
template <typename KeyT> using hashset = std::unordered_set<KeyT>;
} // namespace __dp
#endif
