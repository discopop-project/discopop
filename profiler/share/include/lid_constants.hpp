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
// metadata (call path state, loop iterations) above, see LIDMETADATASIZE. Use dputil::encodeLID to build
// one; it checks that file id and line fit.
// Shared by the LLVM pass, which writes the LIDs into the instrumentation, and the runtime, which decodes them.
typedef std::int64_t LID;
typedef std::int64_t ADDR;

// Number of bits for holding the line number in a LID
constexpr int LIDSIZE = 18;

// Number of bits for holding LID Metadata (Column + Loop ID + Loop Iteration)
constexpr int LIDMETADATASIZE = 32;

// Number of bits for holding the location (file id and line number) of a LID
constexpr int LIDLOCATIONSIZE = 64 - LIDMETADATASIZE;

// Number of bits for holding the file id in a LID
constexpr int FILEIDSIZE = LIDLOCATIONSIZE - LIDSIZE;

// Number of lines in a single file: the lines 0 to MAXLNO - 1 can be encoded. Has to be 2^LIDSIZE.
constexpr int MAXLNO = 1 << LIDSIZE;

// Highest file id that can be encoded. File id 0 means "no file".
constexpr int MAXFILEID = (1 << FILEIDSIZE) - 1;

static_assert(LIDLOCATIONSIZE == 32, "the location of a LID is 32 bits wide: the runtime masks it with 0xFFFFFFFF");
static_assert(LIDSIZE > 0 && FILEIDSIZE > 0, "a LID needs bits for both its line and its file id");
