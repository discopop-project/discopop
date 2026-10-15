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

// The differences between the supported LLVM versions (19 to 22) that the pass cannot avoid, in one place.
//
// LLVM 22 removed the overloads taking an Instruction * as insertion point: instructions are created before,
// and inserted after, a BasicBlock::iterator. Creating an instruction takes an iterator in every supported
// version, so the call sites need no distinction (`->getIterator()`); only what is not available in all of
// them is wrapped below.

#include "llvm/Config/llvm-config.h"
#include "llvm/IR/Instruction.h"

namespace llvmcompat {

// The instruction following `i` in its basic block, without debug intrinsics. LLVM 22 removed
// getNextNonDebugInstruction(): debug information is stored as records attached to the instructions there, so
// getNextNode() already skips it.
inline llvm::Instruction* NextInstruction(llvm::Instruction* i) {
#if LLVM_VERSION_MAJOR >= 22
  return i->getNextNode();
#else
  return i->getNextNonDebugInstruction();
#endif
}

// Inserts `i` after `pos`. insertAfter() takes an iterator from LLVM 22 on, an instruction before.
inline void InsertAfter(llvm::Instruction* i, llvm::Instruction* pos) {
#if LLVM_VERSION_MAJOR >= 22
  i->insertAfter(pos->getIterator());
#else
  i->insertAfter(pos);
#endif
}

}  // namespace llvmcompat
