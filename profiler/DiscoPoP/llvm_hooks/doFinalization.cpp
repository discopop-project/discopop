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

#include "DiscoPoP.hpp"

using namespace llvm;
using namespace std;
using namespace dputil;

bool DiscoPoP::doFinalization(Module &M) {
  // unique InstructionID assignment
  // write the current count of unique instructions to a file to avoid duplication between modules.
  profiler_files::writeCounter("DP_InstructionIDCounter.txt", InstructionIDCounter);
  // unique InstructionID assignment end

  // unique CallpathStateID assignment
  // write the current count of unique callpath states to a file to avoid duplication between modules.
  profiler_files::writeCounter("DP_CallpathStateIDCounter.txt", CallpathStateIDCounter);
  // unique CallpathStateID assignment end

  // CUGeneration
  // write the current count of CUs to a file to avoid duplicate CUs.
  profiler_files::writeCounter("DP_CUIDCounter.txt", CUIDCounter);
  // CUGeneration end

  // DPInstrumentationOmission
  hybridAnalysis->finalize(M);
  // DPInstrumentationOmission end
  return true;
}
