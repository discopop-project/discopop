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

#include "../DiscoPoP.hpp"

// pass get invoked here
bool DiscoPoP::runOnModule(Module &M) {
  // cout << "MODULE " << M.getName().str() << "\n";

  long counter = 0;
  // cout << "\tFUNCTION:\n";
  for (Function &F : M) {
    /*
        string to_be_printed = "\t(" + to_string(++counter) + " / " +
       to_string(M.size()) + ") -- " + F.getName().str();
        while(to_be_printed.size() < 100){
            to_be_printed += " ";
        }
        cout << to_be_printed + "\r";
    */
    runOnFunction(F);
  }

  // DPReduction
  module_ = &M;
  ctx_ = &module_->getContext();

  reduction_file = new std::ofstream();
  std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
  tmp += "/reduction.txt";
  reduction_file->open(tmp.data(), std::ios_base::app);

  loop_counter_file = new std::ofstream();
  std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
  tmp2 += "/loop_counter_output.txt";
  loop_counter_file->open(tmp2.data(), std::ios_base::app);

  /*
  bool success = dp_reduction_init_util(FileMappingPath);
  if (!success) {
      llvm::errs() << "could not find the FileMapping file: " << FileMappingPath
  << "\n"; return false;
  }
  */
  instrument_module(&M, &trueVarNamesFromMetadataMap);

  dp_reduction_insert_functions();

  if (reduction_file != NULL && reduction_file->is_open()) {
    reduction_file->flush();
    reduction_file->close();
  }

  if (loop_counter_file != NULL && loop_counter_file->is_open()) {
    loop_counter_file->flush();
    loop_counter_file->close();
  }
  // End DPReduction
  return true;
}
