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

#include "dp_reduction/ReductionInstrumenter.hpp"


// iterates over all loops in a function and calls 'instrument_loop' for each
// one
void dp_reduction::ReductionInstrumenter::instrument_function(llvm::Function *function, llvm::LoopInfo &loop_info) {

  // get the corresponding file id
  std::int32_t tmp_file_id = services_.getFileID(*function);
  if (tmp_file_id == 0) {
    return;
  }

  //llvm::LoopInfo &loop_info = getAnalysis<llvm::LoopInfoWrapperPass>(*function).getLoopInfo();

  for (auto loop_it = loop_info.begin(); loop_it != loop_info.end(); ++loop_it) {
    instrument_loop(*function, tmp_file_id, *loop_it, loop_info);
  }
}
