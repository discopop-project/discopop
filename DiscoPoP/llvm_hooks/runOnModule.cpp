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
bool DiscoPoP::runOnModule(Module &M, ModuleAnalysisManager &MAM) {
  cout << "MODULE " << M.getName().str() << "\n";

  doInitialization(M);
  module_ = &M;
  ctx_ = &module_->getContext();

  // prepare saving the mapping from instructionID to lineID for backwards compatibility
  instructionID_to_lineID_file = new std::ofstream();
  std::string tmp0(getenv("DOT_DISCOPOP_PROFILER"));
  tmp0 += "/instructionID_to_lineID_mapping.txt";
  instructionID_to_lineID_file->open(tmp0.data(), std::ios_base::app);

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
    runOnFunction(F, MAM);
  }

  // DPReduction

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
  instrument_module(&M, &trueVarNamesFromMetadataMap, MAM);

  dp_reduction_insert_functions();

  // disambiguating instructions
  assign_instruction_ids_to_dp_reduction_functions(M);
  // update argument instruction ids
  update_argument_instruction_ids(M);
  // prepare information for call state transitioning and instruction mapping during dynamic analysis.
  // -> build static calltree for state transition and instruction mapping preparation
  StaticCalltree static_calltree = buildStaticCalltree(M);
  // -> assign unique stateIDs to all possible call states
  auto enumerated_paths_result = enumerate_paths(static_calltree);
  auto enumerated_paths = enumerated_paths_result.first;
  auto state_transitions = enumerated_paths_result.second;
  // add fucntion exit edges to state_transitions
  add_function_exit_edges_to_transitions(state_transitions, enumerated_paths);
  // save the generated paths and transitions to disk
  save_initial_path(enumerated_paths);
  save_enumerated_paths(enumerated_paths);
  save_path_state_transitions(state_transitions);
//  TODO: Calculate state transitions based on prefix relations and lookup in calltree
  // -> prepare state transition lookup tables
  save_static_calltree_to_dot(static_calltree);

  // save current instructionID for continuation in the next Module
  InstructionIDCounter = unique_llvm_ir_instruction_id;

  // save current stateID for continuation in the next Module
  CallpathStateIDCounter = unique_callpath_state_id;

  if (instructionID_to_lineID_file != NULL && instructionID_to_lineID_file->is_open()) {
    instructionID_to_lineID_file->flush();
    instructionID_to_lineID_file->close();
  }

  if (reduction_file != NULL && reduction_file->is_open()) {
    reduction_file->flush();
    reduction_file->close();
  }

  if (loop_counter_file != NULL && loop_counter_file->is_open()) {
    loop_counter_file->flush();
    loop_counter_file->close();
  }
  // End DPReduction

  doFinalization(M);

  return true;
}
