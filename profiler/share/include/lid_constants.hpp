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

// A location id (LID) names an instruction of the instrumented program: the id of its file in the upper
// bits and its line in the lower LIDSIZE bits, i.e. (file id << LIDSIZE) + line. The runtime adds its
// metadata (column, loop id, loop iterations) above, see LIDMETADATASIZE.
// Shared by the LLVM pass, which writes the LIDs into the instrumentation, and the runtime, which decodes them.
typedef std::int64_t LID;
typedef std::int64_t ADDR;

// Number of bits for holding the line number in a LID
constexpr int LIDSIZE = 14;

// Number of bits for holding LID Metadata (Column + Loop ID + Loop Iteration)
constexpr int LIDMETADATASIZE = 32;

// Maximum number of lines in a single file. Has to be 2^LIDSIZE.
constexpr int MAXLNO = 1 << LIDSIZE;
