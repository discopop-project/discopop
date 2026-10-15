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
#include <thread>

using namespace llvm;
using namespace std;
using namespace dputil;

// pass get invoked here
bool DiscoPoP::runOnModule(Module &M, ModuleAnalysisManager &MAM) {
  cout << "MODULE " << M.getName().str() << "\n";

  doInitialization(M);

  // prepare saving the mapping from instructionID to lineID for backwards compatibility
  instructionID_to_lineID_file = profiler_files::open("instructionID_to_lineID_mapping.txt");

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

  dp_reduction::ReductionInstrumenter reduction(
      M, {[this](Function &F) { return getCachedFileID(F); }, [this](Loop *L) { return get_or_register_loop_id(L); },
          [this](Instruction *I) { return dp_reduction_determineVariableName(I, &trueVarNamesFromMetadataMap); }});

  reduction.instrument_module(MAM);

  reduction.insert_functions();

  // disambiguating instructions
  assign_instruction_ids_to_dp_reduction_functions(M);
  // update argument instruction ids
  update_argument_instruction_ids(M);
  // restore callpath states after exceptions (needs the function entry ids)
  instrument_landing_pads(M);
  // prepare information for call state transitioning and instruction mapping during dynamic analysis.
  // -> build static calltree for state transition and instruction mapping preparation
  cout << "Building static calltree..\n";
  StaticCalltree static_calltree = static_callpaths::buildStaticCalltree(M, loop_id_to_identity);
  cout << "Done building static calltree..\n";
  // -> assign unique stateIDs to all possible call states
  cout << "Enumerating paths..\n";
  auto start = chrono::high_resolution_clock::now();
  std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> state_transitions;
  std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> inverse_state_transitions;
  [[maybe_unused]] auto state_transitions_ptr = &state_transitions;
  [[maybe_unused]] auto inverset_state_transitions_ptr = &inverse_state_transitions;
  auto static_calltree_ptr = &static_calltree;
  auto call_path_tree_ptr = static_callpaths::enumerate_paths(static_calltree, &state_transitions, &inverse_state_transitions, unique_callpath_state_id);
  auto end = chrono::high_resolution_clock::now();
  auto time = std::chrono::duration_cast<std::chrono::milliseconds>(end-start).count();
  cout << "Done enumerating paths.. took: " << (time/1000.0) << "s" << std::endl;

  // DEBUG
  //std::cout << "CallPathTree: " << std::endl;
  //std::cout << call_path_tree_ptr->to_dot_string();
  //std::cout << "! CallPathTree " << std::endl;
  // !DEBUG


  // add fucntion exit edges to state_transitions
  cout << "START AFEETT..\n";
  //add_function_exit_edges_to_transitions(state_transitions, call_path_tree_ptr); // enumerated_paths, path_to_id_map);
  static_callpaths::add_function_exit_edges_to_transitions(call_path_tree_ptr); // enumerated_paths, path_to_id_map);
  cout << "Done AFEETT..\n";


  // save the generated paths and transitions to disk
  std::thread t1([call_path_tree_ptr](){static_callpaths::save_initial_path(call_path_tree_ptr);});
  std::thread t2([call_path_tree_ptr](){static_callpaths::save_enumerated_paths(call_path_tree_ptr);});
  //std::thread t3([this, state_transitions_ptr](){this->save_path_state_transitions(state_transitions_ptr);});
  std::thread t3([call_path_tree_ptr](){static_callpaths::save_path_state_transitions(call_path_tree_ptr);});
  std::thread t4([static_calltree_ptr](){static_callpaths::save_static_calltree_to_dot(static_calltree_ptr);});
  std::thread t5([call_path_tree_ptr](){static_callpaths::save_function_entries(call_path_tree_ptr);});

  t1.join();
  t2.join();
  t3.join();
  t4.join();
  t5.join();


  // save current instructionID for continuation in the next Module
  InstructionIDCounter = unique_llvm_ir_instruction_id;

  // update the global path id so the next module starts with a new id
  unique_callpath_state_id = call_path_tree_ptr->get_current_free_path_id();

  // save current stateID for continuation in the next Module
  CallpathStateIDCounter = unique_callpath_state_id;

  // closing flushes
  instructionID_to_lineID_file.close();
  reduction.close();
  // End DPReduction

  doFinalization(M);

  delete call_path_tree_ptr;

  return true;
}
