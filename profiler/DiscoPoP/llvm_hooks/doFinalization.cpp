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


bool DiscoPoP::DoFinalization(llvm::Module &m) {
  // unique InstructionID assignment
  // write the current count of unique instructions to a file to avoid duplication between modules.
  profiler_files::WriteCounter("DP_InstructionIDCounter.txt", instruction_id_counter);
  // unique InstructionID assignment end

  // unique CallpathStateID assignment
  // write the current count of unique callpath states to a file to avoid duplication between modules.
  profiler_files::WriteCounter("DP_CallpathStateIDCounter.txt", callpath_state_id_counter);
  // unique CallpathStateID assignment end

  // CUGeneration
  // write the current count of CUs to a file to avoid duplicate CUs.
  profiler_files::WriteCounter("DP_CUIDCounter.txt", cu_id_counter);
  // CUGeneration end

  // DPInstrumentationOmission
  hybrid_analysis_->Finalize(m);
  // DPInstrumentationOmission end
  return true;
}
