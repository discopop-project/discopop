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


void DiscoPoP::assign_instruction_ids_to_dp_reduction_functions(Module &M){
  for (Function &F : M) {
    for(BasicBlock &BB: F){
      for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
        auto instruction = &*BI;
        if(isa<CallInst>(instruction)){
          auto ci = cast<CallInst>(BI);
          Function* F = ci->getCalledFunction();
          if(F){
            auto fn = F->getName();
            if (fn.find("__dp_loop_incr") != string::npos)
            {
              // assign missing unique instruction id
              LLVMContext& ctx = BI->getContext();
              int32_t llvm_ir_instruction_id = unique_llvm_ir_instruction_id++;
              MDNode* N = MDNode::get(ctx, MDString::get(ctx, "dp.md.instr.id:"+to_string(llvm_ir_instruction_id)));
              BI->setMetadata("dp.md.instr.id", N);
              // fill instructionID to lineID mapping file
              *instructionID_to_lineID_file << to_string(llvm_ir_instruction_id) << " " << decodeLID(getLID(&*BI, fileID)) << "\n";
            }
          }
        }
      }
    }
  }
}

void DiscoPoP::update_argument_instruction_ids(Module &M){
  cout << "Updating argument instruction ids...\n";
  for (Function &F : M) {
    for(BasicBlock &BB: F){
      for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
        auto instruction = &*BI;
        if(isa<CallInst>(instruction)){
          auto ci = cast<CallInst>(BI);
          Function* F = ci->getCalledFunction();
          if(F){
            auto fn = F->getName();
            if (fn.find("__dp_loop_entry") != string::npos)
            {
              // Get InstructionID of callinstruction
              MDNode* md = BI->getMetadata("dp.md.instr.id");
              int32_t callInstructionID = 0;
              if(md){
                // Metadata exists
                std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
                callInstructionID_str.erase(0, 15);
                callInstructionID = stoi(callInstructionID_str);
              }
              // update the function argument
              if(callInstructionID != 0){
                ci->setArgOperand(2, ConstantInt::get(Int32, callInstructionID));
              }
            }
            if (fn.find("__dp_loop_incr") != string::npos)
            {
              // Get InstructionID of callinstruction
              MDNode* md = BI->getMetadata("dp.md.instr.id");
              int32_t callInstructionID = 0;
              if(md){
                // Metadata exists
                std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
                callInstructionID_str.erase(0, 15);
                callInstructionID = stoi(callInstructionID_str);
              }
              // update the function argument
              if(callInstructionID != 0){
                ci->setArgOperand(1, ConstantInt::get(Int32, callInstructionID));
              }
            }
          }
        }
      }
    }
  }
}

// returns a mapping from loop id to the instruction id of the loop entry call
std::unordered_map<int32_t, int32_t> get_loop_entry_instructionIDs(Function &F){
  std::unordered_map<int32_t, int32_t> loop_entry_instruction_ids;
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_entry") != string::npos) // avoid instrumentation calls
          {
            // get id of entered loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }

              // Get InstructionID of callinstruction
              MDNode* md = BI->getMetadata("dp.md.instr.id");
              if(md){
                // Metadata exists
                std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
                callInstructionID_str.erase(0, 15);
                int32_t callInstructionID = stoi(callInstructionID_str);
                loop_entry_instruction_ids[loop_id] = callInstructionID;
              }
            }
            else {
              // operand was not a ConstantInt
            }
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Loop entry instruction ids:\n";
  for(auto pair: loop_entry_instruction_ids){
    cout << "  " << to_string(pair.first) << " -> " << pair.second << "\n";
  }
  // !DEBUG

  return loop_entry_instruction_ids;
}

// returns a mapping from loop id to the instruction id of the loop exit call
std::unordered_map<int32_t, int32_t> get_loop_exit_instructionIDs(Function &F){
  std::unordered_map<int32_t, int32_t> loop_exit_instruction_ids;
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_exit") != string::npos) // avoid instrumentation calls
          {
            // get id of exited loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }

              // Get InstructionID of callinstruction
              MDNode* md = BI->getMetadata("dp.md.instr.id");
              if(md){
                // Metadata exists
                std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
                callInstructionID_str.erase(0, 15);
                int32_t callInstructionID = stoi(callInstructionID_str);
                loop_exit_instruction_ids[loop_id] = callInstructionID;
              }
            }
            else {
              // operand was not a ConstantInt
            }
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Loop exit instruction ids:\n";
  for(auto pair: loop_exit_instruction_ids){
    cout << "  " << to_string(pair.first) << " -> " << pair.second << "\n";
  }
  // !DEBUG

  return loop_exit_instruction_ids;
}

// returns a mapping from loop id to the instruction id of the loop increment call
std::unordered_map<int32_t, int32_t> get_loop_increment_instructionIDs(Function &F){
  std::unordered_map<int32_t, int32_t> loop_increment_instruction_ids;
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_incr") != string::npos) // avoid instrumentation calls
          {
            // get id of incremented loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(0))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }

              // Get InstructionID of callinstruction
              MDNode* md = BI->getMetadata("dp.md.instr.id");
              if(md){
                // Metadata exists
                std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
                callInstructionID_str.erase(0, 15);
                int32_t callInstructionID = stoi(callInstructionID_str);
                loop_increment_instruction_ids[loop_id] = callInstructionID;
              }
            }
            else {
              // operand was not a ConstantInt
            }
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Loop increment instruction ids:\n";
  for(auto pair: loop_increment_instruction_ids){
    cout << "  " << to_string(pair.first) << " -> " << pair.second << "\n";
  }
  // !DEBUG

  return loop_increment_instruction_ids;
}

// collect loops in the given function and return the listof loop ids
// Encodes nesting via inner vectors
std::vector<std::vector<int32_t>> get_loopIDs_in_function_body(Function &F){
  std::vector<std::vector<int32_t>> nested_loop_ids;
  std::vector<int32_t> loop_ids;
  int32_t nesting_counter = 0;

  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_entry") != string::npos) // avoid instrumentation calls
          {
            // get id of entered loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }
              loop_ids.push_back(loop_id);
              nesting_counter++;
            }
            else {
              // operand was not a ConstantInt
            }

          }
          else{
            if (fn.find("__dp_loop_exit") != string::npos) // avoid instrumentation calls
            {
              nesting_counter--;
              if(nesting_counter == 0){
                nested_loop_ids.push_back(loop_ids);
                std::vector<int32_t> tmp;
                loop_ids = tmp;
              }
            }
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Nested loop ids:\n";
  for(auto entry: nested_loop_ids){
    cout << "--> ";
    for(auto inner: entry){
      cout << inner << " ";
    }
    cout << "\n";
  }

  // !DEBUG

  return nested_loop_ids;
}

typedef int8_t TRANSITION_TYPE; // 0 -> enterLoop, 1 -> exitLoop, 2 -> incrementLoop
#define TRANSITION_TYPE_ENTERLOOP 0
#define TRANSITION_TYPE_EXITLOOP 1
#define TRANSITION_TYPE_INCREMENTLOOP 2

typedef int32_t LOOP_ID;
typedef std::vector<int32_t> ITERATION_INSTANCE;

// returns all combinations of allowed loop iteration counters for the given loop ids
// contained in the parent function
//std::vector<ITERATION_INSTANCE> get_loop_iteration_instances_and_transitions(std::vector<std::vector<LOOP_ID>> contained_loops, std::vector<LOOP_ID>  sequentialized_contained_loops){
  std::unordered_map<string, std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>>> get_loop_iteration_instances_and_transitions(std::vector<std::vector<LOOP_ID>> contained_loops, std::vector<LOOP_ID>  sequentialized_contained_loops){
  std::vector<ITERATION_INSTANCE> loop_iteration_instances;
  // describes transitions between loop instances
  std::unordered_map<string, std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>>> loop_iteration_instance_transitions;

  // initialize
  ITERATION_INSTANCE init_vector;
  for(auto outer: contained_loops){
    for(auto inner: outer){
      init_vector.push_back(0);
    }
  }
  int32_t loop_count = init_vector.size();

  // instantiate loop iterations
  int32_t offset = 0;
  for(auto outer : contained_loops){
    // fill base state with don't cares
    ITERATION_INSTANCE base_state;
    for(int i = 0; i < loop_count; ++i){
      base_state.push_back(3);
    }

    // create instances
    std::vector<ITERATION_INSTANCE> instances;
    instances.push_back(base_state);
    int32_t inner_index = 0;
    std::vector<ITERATION_INSTANCE> parent_instances;  // iteration instances of the parent loop
    for(auto inner: outer){
      // get loop id from position via lookup in sequentialized_contained_loops
      auto loop_id = sequentialized_contained_loops[offset];

      std::vector<ITERATION_INSTANCE> new_instances;
      for(auto instance: instances){
        // check for instances, where the parent loops are active
        bool skip_instance = false;
        for(int32_t negative_parent_loop_offset = 1; negative_parent_loop_offset <= inner_index; ++negative_parent_loop_offset){
          if(instance[offset-negative_parent_loop_offset] == 3){
            // parent loop is not active
            skip_instance = true;
            break;
          }
        }
        if(skip_instance){
          continue;
        }

        // "iteration index '3', i.e. dont care already represented by initialization
        auto instance_copy_0 = instance;
        auto instance_copy_1 = instance;
        auto instance_copy_2 = instance;
        instance_copy_0[offset] = 0;
        instance_copy_1[offset] = 1;
        instance_copy_2[offset] = 2;
        new_instances.push_back(instance_copy_0);
        new_instances.push_back(instance_copy_1);
        new_instances.push_back(instance_copy_2);

        // register transitions between loop iterations
        // -> convert instances to strings
        string instance_copy_0_str = "";
        for(auto it_count: instance_copy_0){
          instance_copy_0_str += to_string(it_count);
        }
        string instance_copy_1_str = "";
        for(auto it_count: instance_copy_1){
          instance_copy_1_str += to_string(it_count);
        }
        string instance_copy_2_str = "";
        for(auto it_count: instance_copy_2){
          instance_copy_2_str += to_string(it_count);
        }
        // -> register transition for iteration 0 -> 1
        // ---> extend map
        if(loop_iteration_instance_transitions.count(instance_copy_0_str) == 0){
          std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>> tmp;
          std::unordered_map<LOOP_ID, string> tmp_0, tmp_1, tmp_2;
          tmp[TRANSITION_TYPE_ENTERLOOP] = tmp_0;
          tmp[TRANSITION_TYPE_EXITLOOP] = tmp_1;
          tmp[TRANSITION_TYPE_INCREMENTLOOP] = tmp_2;
          loop_iteration_instance_transitions[instance_copy_0_str] = tmp;
        }
        // ---> register transition
        loop_iteration_instance_transitions[instance_copy_0_str][TRANSITION_TYPE_INCREMENTLOOP][loop_id] = instance_copy_1_str;
        // -> register transition for iteration 1 -> 2
        // ---> extend map
        if(loop_iteration_instance_transitions.count(instance_copy_1_str) == 0){
          std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>> tmp;
          std::unordered_map<LOOP_ID, string> tmp_0, tmp_1, tmp_2;
          tmp[TRANSITION_TYPE_ENTERLOOP] = tmp_0;
          tmp[TRANSITION_TYPE_EXITLOOP] = tmp_1;
          tmp[TRANSITION_TYPE_INCREMENTLOOP] = tmp_2;
          loop_iteration_instance_transitions[instance_copy_1_str] = tmp;
        }
        // ---> register transition
        loop_iteration_instance_transitions[instance_copy_1_str][TRANSITION_TYPE_INCREMENTLOOP][loop_id] = instance_copy_2_str;
        // -> register transition for iteration 2 -> 0
        // ---> extend map
        if(loop_iteration_instance_transitions.count(instance_copy_2_str) == 0){
          std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>> tmp;
          std::unordered_map<LOOP_ID, string> tmp_0, tmp_1, tmp_2;
          tmp[TRANSITION_TYPE_ENTERLOOP] = tmp_0;
          tmp[TRANSITION_TYPE_EXITLOOP] = tmp_1;
          tmp[TRANSITION_TYPE_INCREMENTLOOP] = tmp_2;
          loop_iteration_instance_transitions[instance_copy_2_str] = tmp;
        }
        // ---> register transition
        loop_iteration_instance_transitions[instance_copy_2_str][TRANSITION_TYPE_INCREMENTLOOP][loop_id] = instance_copy_0_str;

        // register transitions between parents and iteration instances
        for(auto parent_instance : parent_instances){
          // get string
          string parent_instance_str = "";
          for(auto it_count: parent_instance){
            parent_instance_str += to_string(it_count);
          }
          // ---> extend map
          if(loop_iteration_instance_transitions.count(parent_instance_str) == 0){
            std::unordered_map<TRANSITION_TYPE, std::unordered_map<LOOP_ID, string>> tmp;
            std::unordered_map<LOOP_ID, string> tmp_0, tmp_1, tmp_2;
            tmp[TRANSITION_TYPE_ENTERLOOP] = tmp_0;
            tmp[TRANSITION_TYPE_EXITLOOP] = tmp_1;
            tmp[TRANSITION_TYPE_INCREMENTLOOP] = tmp_2;
            loop_iteration_instance_transitions[parent_instance_str] = tmp;
          }
          // ---> register entering transition
          string child_instance_0_str = parent_instance_str;
          child_instance_0_str[offset] = '0';
          loop_iteration_instance_transitions[parent_instance_str][TRANSITION_TYPE_ENTERLOOP][loop_id] = child_instance_0_str;

          // register exiting transitions
          string child_instance_1_str = parent_instance_str;
          child_instance_1_str[offset] = '1';
          string child_instance_2_str = parent_instance_str;
          child_instance_2_str[offset] = '2';
          loop_iteration_instance_transitions[child_instance_0_str][TRANSITION_TYPE_EXITLOOP][loop_id] = parent_instance_str;
          loop_iteration_instance_transitions[child_instance_1_str][TRANSITION_TYPE_EXITLOOP][loop_id] = parent_instance_str;
          loop_iteration_instance_transitions[child_instance_2_str][TRANSITION_TYPE_EXITLOOP][loop_id] = parent_instance_str;
        }

        // register outer loop entry and exit
        if(inner_index == 0){
          // register outer loop entry
          loop_iteration_instance_transitions["entry_points"][TRANSITION_TYPE_ENTERLOOP][loop_id] = instance_copy_0_str;
          // register outer loop exit
          loop_iteration_instance_transitions[instance_copy_0_str][TRANSITION_TYPE_EXITLOOP][loop_id] = "exit_points";
          loop_iteration_instance_transitions[instance_copy_1_str][TRANSITION_TYPE_EXITLOOP][loop_id] = "exit_points";
          loop_iteration_instance_transitions[instance_copy_2_str][TRANSITION_TYPE_EXITLOOP][loop_id] = "exit_points";
        }

      }
      for(auto instance_vector: new_instances){
        instances.push_back(instance_vector);
      }
      offset++;
      inner_index++;
      parent_instances = new_instances;
    }
    for(auto instance_vector: instances){
      // only push "interesting" states, i.e., such, that contain not only don't cares
      for(auto elem: instance_vector){
        if(elem != 3){
          loop_iteration_instances.push_back(instance_vector);
          break;
        }
      }
    }
  }

  // DEBUG
  cerr << "States: " << "\n";
  for(auto outer_entry: loop_iteration_instances){
    cerr << "---> ";
    for(auto inner_entry: outer_entry){
      cerr << inner_entry;
    }
    cerr << "\n";
  }
  //
  cerr << "State transitions: " << "\n";
  for(auto pair_1: loop_iteration_instance_transitions){
    cerr << "--> " << pair_1.first << "\n";
    for(auto pair_2: pair_1.second){
      string transition_type_string = "";
      if(pair_2.first == TRANSITION_TYPE_ENTERLOOP){
        transition_type_string = "enter";
      }
      else if(pair_2.first == TRANSITION_TYPE_EXITLOOP){
        transition_type_string = "exit";
      }
      else{
        transition_type_string = "incr";
      }

      for(auto pair_3: pair_2.second){
        cerr << "  --> type: " << transition_type_string << " loop: " << pair_3.first << " --> " << pair_3.second << "\n";
      }
    }
  }

  // !DEBUG
  return loop_iteration_instance_transitions;
}


// returns a map from loopID to a vector of callInstructionIDs contained in the loop
std::unordered_map<int32_t, std::vector<int32_t>> get_loop_callInstruction_affectance(Function &F){
  std::unordered_map<int32_t, std::vector<int32_t>> result_map;

  std::vector<int32_t> entered_loops;

  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      auto instruction = &*BI;
      // modify entered loops if required
      if(isa<CallInst>(instruction)){
        auto ci = cast<CallInst>(BI);
        Function* F = ci->getCalledFunction();
        if(F){
          auto fn = F->getName();
          if (fn.find("__dp_loop_entry") != string::npos) // avoid instrumentation calls
          {
            // get id of entered loop
            if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
              // operand is a ConstantInt, we can use CI here
              int32_t loop_id;
              if (CI->getBitWidth() <= 32) {
                loop_id = CI->getSExtValue();
              }
              entered_loops.push_back(loop_id);
              // DEBUG
              cout << "entered_loops:\n";
              for(auto elem: entered_loops){
                cout << "--> " << elem << "\n";
              }
              // !DEBUG
            }
            else {
              // operand was not a ConstantInt
            }
          }
          else{
            if (fn.find("__dp_loop_exit") != string::npos) // avoid instrumentation calls
            {
              int32_t loop_id;
              // get id of entered loop
              if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(ci->getArgOperand(1))) {
                // operand is a ConstantInt, we can use CI here
                if (CI->getBitWidth() <= 32) {
                  loop_id = CI->getSExtValue();
                }
                // Erase loop_id from entered loops
                for (auto it = entered_loops.begin(); it != entered_loops.end();)
                {
                    if (*it == loop_id)
                        it = entered_loops.erase(it);
                    else
                        ++it;
                }
              }
              else {
                // operand was not a ConstantInt
              }
            }
          }
        }
      }

      // register relation between loop and call instruction
      Function *F = nullptr;
      if(isa<CallInst>(BI)){
        F = (cast<CallInst>(BI))->getCalledFunction();
      }
      else if(isa<InvokeInst>(BI)){
        F = (cast<InvokeInst>(BI))->getCalledFunction();
      }
      // check if a call was encountered
      if (F) {
        // ignore instrumentation functions
        auto fn = F->getName();
        if (fn.find("__dp_") != string::npos) // avoid instrumentation calls
        {
          continue;
        }
        if (fn.find("__clang_") != string::npos) // clang helper calls
        {
          continue;
        }
        if (fn.find("llvm.dbg.declare") != string::npos) // llvm debug helper calls
        {
          continue;
        }
        // Get InstructionID of callinstruction
        MDNode* md = BI->getMetadata("dp.md.instr.id");
        if(md){
          // Metadata exists
          std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
          callInstructionID_str.erase(0, 15);
          int callInstructionID = stoi(callInstructionID_str);

          // extend map
          for(auto loop_id: entered_loops){
            if(result_map.count(loop_id) == 0){
              std::vector<int32_t> tmp;
              result_map[loop_id] = tmp;
            }
            result_map[loop_id].push_back(callInstructionID);
          }
        }
      }
    }
  }

  // DEBUG
  cout << "Loop->CallInst affectance:\n";
  for(auto pair: result_map){
    cout << "--> " << pair.first << "\n";
    for(auto call_inst_id: pair.second){
      cout << "-----> " << call_inst_id << "\n";
    }
  }
  // !DEBUG

  return result_map;
}

// inverts the given map. Returns a map from CallInstructionID to LoopIDs which affect it.
std::unordered_map<int32_t, std::vector<int32_t>> get_inverted_loop_callInstruction_affectance(std::unordered_map<int32_t, std::vector<int32_t>> loop_call_affectance){
  std::unordered_map<int32_t, std::vector<int32_t>> result_map;
  for(auto pair: loop_call_affectance){
    auto loop_id = pair.first;
    for(auto call_inst_id: pair.second){
      if(result_map.count(call_inst_id) == 0){
        std::vector<int32_t> tmp;
        result_map[call_inst_id] = tmp;
      }
      result_map[call_inst_id].push_back(loop_id);
    }
  }

  // DEBUG
  cout << "CallInst->Loop affectance:\n";
  for(auto pair: result_map){
    cout << "--> " << pair.first << "\n";
    for(auto call_inst_id: pair.second){
      cout << "-----> " << call_inst_id << "\n";
    }
  }
  // !DEBUG

  return result_map;
}

std::vector<LOOP_ID> sequentialize_contained_loops(std::vector<std::vector<int32_t>> contained_loops){
  std::vector<LOOP_ID> loops;
    for(auto outer: contained_loops){
      for(auto inner: outer){
        loops.push_back(inner);
      }
    }
  return loops;
}

//get_loop_entry_instances(iteration_instances, contained_loops);

// builds a call tree for the given Module on the basis of the statically available information
StaticCalltree DiscoPoP::buildStaticCalltree(Module &M) {
  StaticCalltree calltree;
  for (Function &F : M) {
    cerr << "Iter FUNC..." << F.getName().str() << "\n";
    // get loops contained in F
    cerr << "DBG: Function: " << F.getName().str() << " getting loop ids..." << "\n";
    auto contained_loops = get_loopIDs_in_function_body(F);
    auto sequentialized_contained_loops = sequentialize_contained_loops(contained_loops);
    auto loop_entry_instructionIDs = get_loop_entry_instructionIDs(F);
    auto loop_exit_instructionIDs = get_loop_exit_instructionIDs(F);
    auto loop_increment_instructionIDs = get_loop_increment_instructionIDs(F);
    // DEBUG
    cerr << "DBG: Function: " << F.getName().str() << " Loops: " << contained_loops.size() << "\n";
    // !DEBUG

    // for each loop, allow 3 values to represent the currently executed iteration
    // create one instance of the function_node in the calltree per combination of iterations.
    // In case of 4 contained loops, this creates 4^3=64 nodes for the function F.
    // The value 3 is chosen to keep the amount of total states somewhat concise, while still allowing to distinguish between
    // intra- and inter-iteration dependencies with a comparatively high probability.
    // Valid Iteration counters are 0, 1, and 2. A value of 3 acts as a "dont care" symbol.
    // --> calculate iteration instances and thus the amount of states
    cerr << "DBG: " << "getting loop iteration instances... contained loops: " << contained_loops.size() << "\n";
    //auto iteration_instances = get_loop_iteration_instances(contained_loops, sequentialized_contained_loops);
    auto iteration_instances_and_transitions = get_loop_iteration_instances_and_transitions(contained_loops, sequentialized_contained_loops);
//    auto loop_entry_instances = get_loop_entry_instances(iteration_instances, contained_loops);
    cerr << "DBG: " << "Done..." << "\n";

    // create StaticCalltreeNode instances for function F
    std::vector<StaticCalltreeNode*> function_node_instances;

    StaticCalltreeNode* original_function_node_ptr = calltree.get_or_insert_function_node(F.getName().str());
    //function_node_instances.push_back(original_function_node_ptr);


    std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> loop_activity_map;
    std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> loop_entry_nodes_map;
    std::unordered_map<string, StaticCalltreeNode*> instance_to_node_map;
    //for(auto instance: iteration_instances){
    for(auto pair: iteration_instances_and_transitions){
      auto instance = pair.first;

      // skip instance "entry_points"
      if (instance.find("entry_points") != string::npos)
      {
        continue;
      }

      StaticCalltreeNode* function_node_ptr = calltree.get_or_insert_function_node(F.getName().str(), instance);
      function_node_instances.push_back(function_node_ptr);
      instance_to_node_map[instance] = function_node_ptr;

      // register entry edges into the loop state
      //calltree.addEdge(original_function_node_ptr, function_node_ptr, 0);

      // register loop activity for later use (loop active, if iteration count != 3 (i.e. don't care))
      for(int idx = 0; idx < instance.size(); ++idx){
        int iteration_counter = instance[idx] - '0';
        if(iteration_counter != 3){
          // get loop id from position via lookup in sequentialized_contained_loops
          auto active_loop_id = sequentialized_contained_loops[idx];
          if(loop_activity_map.count(active_loop_id) == 0){
            std::vector<StaticCalltreeNode*> tmp;
            loop_activity_map[active_loop_id] = tmp;
          }
          loop_activity_map[active_loop_id].push_back(function_node_ptr);

          // check if the current instance is an entry node to the loop.
          // save for later use if so.
          if (iteration_instances_and_transitions.find("entry_points") != iteration_instances_and_transitions.end())
          {
            // "entry_points" is a key
            if (iteration_instances_and_transitions["entry_points"][TRANSITION_TYPE_ENTERLOOP].find(active_loop_id) != iteration_instances_and_transitions["entry_points"][TRANSITION_TYPE_ENTERLOOP].end())
            {
              // entry point for loop is registered
              if(iteration_instances_and_transitions["entry_points"][TRANSITION_TYPE_ENTERLOOP][active_loop_id] == instance){
                // instance is an entry point to the loop
                cout << "ENTRY POINT FOUND: " << instance << "\n";
                //
                if(loop_entry_nodes_map.find(active_loop_id) == loop_entry_nodes_map.end()){
                  std::vector<StaticCalltreeNode*> tmp;
                  loop_entry_nodes_map[active_loop_id] = tmp;
                }
                loop_entry_nodes_map[active_loop_id].push_back(function_node_ptr);
              }
            }
          }

//          if(iteration_counter == 0){
//            loop_entry_nodes_map[active_loop_id].push_back(function_node_ptr);
//          }

        }

      }
    }
    cerr << "Done\n";


    // add entry edges into the loops
    cerr << "Add entry edges into the loops...\n";
    if (iteration_instances_and_transitions.find("entry_points") != iteration_instances_and_transitions.end())
    {
      for(auto pair: iteration_instances_and_transitions["entry_points"][TRANSITION_TYPE_ENTERLOOP]){
        auto loop_id = pair.first;
        auto loop_entry_instance = pair.second;
        calltree.addEdge(original_function_node_ptr, instance_to_node_map[loop_entry_instance], loop_entry_instructionIDs[loop_id]);
      }
    }

    // add transition edges between loop iteration nodes
    cerr << "Add transition edges between loop iterations...\n";
    for(auto pair_0: iteration_instances_and_transitions){
      auto source_instance = pair_0.first;
      if (source_instance.find("entry_points") != string::npos){
        // ignore the "entry_points" key in the transition map
        continue;
      }
      cerr << "--> source: " << source_instance << "\n";
      for(auto pair_1: pair_0.second){
        auto transition_type = pair_1.first;
        for(auto pair_2: pair_1.second){
          auto loop_id = pair_2.first;
          cerr << "----> loop_id: " << loop_id << "\n";
          auto target_instance = pair_2.second;
          cerr << "----> target_instance: " << target_instance << "\n";
          // determine nodes
          auto source_node = instance_to_node_map[source_instance];
          cerr << "----> source_node: " << source_node << "\n";
          StaticCalltreeNode* target_node = nullptr;
          if (target_instance.find("exit_points") != string::npos){
            // target is leaving a function scope, i.e. goes back to the function node
            target_node = original_function_node_ptr;
            if(transition_type == TRANSITION_TYPE_EXITLOOP){
              cerr << "FOUND TYPE EXIT!\n";
            }
          }
          else{
            target_node = instance_to_node_map[target_instance];
          }

          cerr << "----> target_node: " << target_node << "\n";
          // determine trigger instruction
          int32_t trigger_instruction = 0;
          if(transition_type == TRANSITION_TYPE_ENTERLOOP){
            trigger_instruction = loop_entry_instructionIDs[loop_id];
          }
          else if(transition_type == TRANSITION_TYPE_EXITLOOP){
            trigger_instruction = loop_exit_instructionIDs[loop_id];
          }
          else if(transition_type == TRANSITION_TYPE_INCREMENTLOOP){
            trigger_instruction = loop_increment_instructionIDs[loop_id];
          }
          // create edge
          cerr << "----> creating edge.. \n";
          calltree.addEdge(source_node, target_node, trigger_instruction);
          cerr << "----> Done.\n";
        }
      }
    }




    // get connection between loops and called functions inside the loops
    cerr << "Get loop call affectance..\n";
    auto loop_call_affectance = get_loop_callInstruction_affectance(F);
    auto inverted_loop_call_affectance = get_inverted_loop_callInstruction_affectance(loop_call_affectance);


    for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
      BasicBlock &BB = *FI;
      for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
        auto instruction = &*BI;
        Function *F = nullptr;
        if(isa<CallInst>(BI)){
          F = (cast<CallInst>(BI))->getCalledFunction();
        }
        else if(isa<InvokeInst>(BI)){
          F = (cast<InvokeInst>(BI))->getCalledFunction();
        }
        // check if a call was encountered
        if (F) {
          // ignore instrumentation functions
          auto fn = F->getName();
          if (fn.find("__dp_") != string::npos) // avoid instrumentation calls
          {
            continue;
          }
          if (fn.find("__clang_") != string::npos) // clang helper calls
          {
            continue;
          }
          if (fn.find("llvm.dbg.declare") != string::npos) // llvm debug helper calls
          {
            continue;
          }
          // register CallInstruction Node in StaticCalltree
          MDNode* md = BI->getMetadata("dp.md.instr.id");
          if(md){
            // Metadata exists
            std::string callInstructionID_str = cast<MDString>(md->getOperand(0))->getString().str();
            callInstructionID_str.erase(0, 15);
            int32_t callInstructionID = stoi(callInstructionID_str);
            StaticCalltreeNode* callInstructionNode_ptr = calltree.get_or_insert_instruction_node(callInstructionID);
            calltree.addEdge(original_function_node_ptr, callInstructionNode_ptr, callInstructionID);
            // connect to nodes if the loop contains the call and the loop is "active" and node is an entry node to the loop, i.e. iteration count is 0
            auto parent_loops = inverted_loop_call_affectance[callInstructionID];
            for(auto parent_loop_id : parent_loops){
              for(auto node_ptr: loop_activity_map[parent_loop_id]){
                calltree.addEdge(node_ptr, callInstructionNode_ptr, callInstructionID);
              }
            }
            StaticCalltreeNode* calleeNode_ptr = calltree.get_or_insert_function_node(F->getName().str());
            calltree.addEdge(callInstructionNode_ptr, calleeNode_ptr, 0);
          }
        }
      }
    }
    cerr << "Done Iter func...\n";
  }
//  calltree.printToDOT();
  return calltree;
}




typedef int32_t CALLPATH_STATE_ID;
typedef int32_t INSTRUCTION_ID;

// retrieve the CallpathStateId of the given path.
CALLPATH_STATE_ID get_id_from_callpath(std::vector<StaticCalltreeNode*>& target_path, std::unordered_map<CALLPATH_STATE_ID, std::vector<StaticCalltreeNode*>>& paths){
  CALLPATH_STATE_ID fallback = 0;
  int target_path_length = target_path.size();
  for(auto pair: paths){
    if(pair.second.size() != target_path_length){
      continue;
    }
    // compare target path and the candidate element-wise
    bool valid = true;
    for(int idx = 0; idx < target_path_length; ++idx){
      if (target_path[idx] != pair.second[idx]){
        valid = false;
        break;
      }
    }
    // return the id, if a match was found
    if(valid){
      return pair.first;
    }
  }
  return fallback;
}

// create a complete list of callpaths and intermediate states based on the static call tree of the module
// and assign unique identifiers to every state
std::pair<std::unordered_map<CALLPATH_STATE_ID, std::vector<StaticCalltreeNode*>>, std::unordered_map<CALLPATH_STATE_ID, std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID>>> DiscoPoP::enumerate_paths(StaticCalltree& calltree){
  std::cout << "Enumerating Paths...\n";
  std::unordered_map<CALLPATH_STATE_ID, std::vector<StaticCalltreeNode*>> paths;
  std::unordered_map<CALLPATH_STATE_ID, std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID>> state_transitions;
  std::unordered_map<CALLPATH_STATE_ID, std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID>> inverse_state_transitions;
  // path id 0 is reserved for debugging and initialization purposes
  // select entry nodes
  std::vector<StaticCalltreeNode*> entry_nodes;
  for(auto pair: calltree.function_map){
    if(pair.second->predecessors.size() == 0){
      entry_nodes.push_back(pair.second);
    }
  }
  // show entry nodes
  std::cout << "Entry nodes:\n";
  for(auto node_ptr: entry_nodes){
    std::cout << "--> " << node_ptr->get_label() << "\n";
  }
  // traverse the static calltree to build the paths
  std::stack<std::tuple<CALLPATH_STATE_ID, INSTRUCTION_ID, std::vector<StaticCalltreeNode*>>> stack;
  // -> initialize
  for(auto node_ptr: entry_nodes){
    std::vector<StaticCalltreeNode*> v;
    v.push_back(node_ptr);
    stack.push(std::make_tuple(0, 0, v));
  }
  // -> process stack
  while(!stack.empty()){
    auto current_tuple = stack.top();
    auto predecessor_state_id = std::get<0>(current_tuple);
    auto transition_instruction = std::get<1>(current_tuple);
    auto current_path = std::get<2>(current_tuple);
    stack.pop();
    // register current path
    auto current_state_id = unique_callpath_state_id++;
    paths[current_state_id] = current_path;
    // register transition
    if(state_transitions.find(predecessor_state_id) == state_transitions.end()){
      std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID> tmp;
      state_transitions[predecessor_state_id] = tmp;
    }
    state_transitions[predecessor_state_id][transition_instruction] = current_state_id;
    // register inverse transition
    if(inverse_state_transitions.find(current_state_id) == inverse_state_transitions.end()){
      std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID> tmp;
      inverse_state_transitions[current_state_id] = tmp;
    }
    inverse_state_transitions[current_state_id][transition_instruction] = predecessor_state_id;

    // enqueue successors
    for(auto succ_pair: current_path.back()->successors){
      int32_t trigger_instructionID = succ_pair.first;  // currently unused!
      for(auto succ: succ_pair.second){
        // check for cycles
        auto cycle_pos = std::find(current_path.begin(), current_path.end(), succ);
        if(cycle_pos != current_path.end()){
          // already contained in current_path
          cout << "Found loop. Ignoring successor transition: " << current_state_id << " " << current_path.back()->get_label() << " -> " << succ->get_label() << " Inst: " << trigger_instructionID << "\n";



          // get prefix path of the cycle
          std::vector<StaticCalltreeNode*> cycle_prefix_path;
          for(auto elem_it = current_path.begin(); elem_it <= cycle_pos; ++elem_it){
            cycle_prefix_path.push_back(*elem_it);
          }

          // DEBUG
          string current_path_str = "";
          for(auto elem: current_path){
            current_path_str += elem->get_label() + "-->";
          }
          cout << "Current_path: " << current_path_str << "\n";

          string cycle_prefix_path_str = "";
          for(auto elem: cycle_prefix_path){
            cycle_prefix_path_str += elem->get_label() + "-->";
          }
          cout << "CYCLE PREFIX: " << cycle_prefix_path_str << "\n";
          // !DEBUG

          // get id of the target path
          auto cycle_prefix_path_stateID = get_id_from_callpath(cycle_prefix_path, paths);
          cout << "RETRIEVED ID: " << cycle_prefix_path_stateID << "\n";;
          // register transition
          if(state_transitions.find(current_state_id) == state_transitions.end()){
            std::unordered_map<INSTRUCTION_ID, CALLPATH_STATE_ID> tmp;
            state_transitions[current_state_id] = tmp;
          }
          // check for potential overwrites
          if(state_transitions[current_state_id].find(trigger_instructionID) != state_transitions[current_state_id].end()){
            cout << "  TRANSITION EXISTS: " << state_transitions[current_state_id][trigger_instructionID] << "\n";
            cout << "  NEW / ALTERNATIVE TARGET: " << cycle_prefix_path_stateID << "\n";
          }
          state_transitions[current_state_id][trigger_instructionID] = cycle_prefix_path_stateID;
          cout << "  ADDED TRANSITION: " << current_state_id << " " << trigger_instructionID << " " << cycle_prefix_path_stateID << "\n";

          continue;
        }
        auto tmp_path = current_path;
        tmp_path.push_back(succ);
        stack.push(std::make_tuple(current_state_id, trigger_instructionID, tmp_path));
      }
    }
  }

  return std::make_pair(paths, state_transitions);
}

// save the id of the initial state id to file
void DiscoPoP::save_initial_path(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths){
  // prepare saving the initial callpathStateID
  std::ofstream *file;
  file = new std::ofstream();
  std::string tmp01(getenv("DOT_DISCOPOP_PROFILER"));
  tmp01 += "/initial_stateID.txt";
  file->open(tmp01.data(), std::ios_base::trunc);
  // write file
  for(auto pair: paths){
    // select path for main file
    if(pair.second.size() != 1){
      continue;
    }

    if (pair.second[0]->get_label() == "main") // avoid instrumentation calls
    {
      cout << "FOUND MAIN PATH\n";
      // save path id to file
      *file << to_string(pair.first) << "\n";
      break;
    }
  }
  // close file handle
  if (file != NULL && file->is_open()) {
    file->flush();
    file->close();
  }
}

void DiscoPoP::save_enumerated_paths(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths){
  // prepare saving the mapping from callpath to callpathStateID for reference
  stateID_to_callpath_file = new std::ofstream();
  std::string tmp01(getenv("DOT_DISCOPOP_PROFILER"));
  tmp01 += "/stateID_to_callpath_mapping.txt";
  stateID_to_callpath_file->open(tmp01.data(), std::ios_base::app);
  // write file
  for(auto pair: paths){
    // construct path string
    std::string path_str = "";
    for(auto node_ptr: pair.second){
      path_str += node_ptr->get_label() + "-->";
    }
    // save path string to file
    *stateID_to_callpath_file << to_string(pair.first) << " " << path_str << "\n";
  }
  // close file handle
  if (stateID_to_callpath_file != NULL && stateID_to_callpath_file->is_open()) {
    stateID_to_callpath_file->flush();
    stateID_to_callpath_file->close();
  }
}

void DiscoPoP::save_path_state_transitions(std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> transitions){
  // prepare saving the callpathState transitions
  callpath_state_transitions_file = new std::ofstream();
  std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
  tmp += "/callpath_state_transitions.txt";
  callpath_state_transitions_file->open(tmp.data(), std::ios_base::app);
  // write file
  *callpath_state_transitions_file << "# Format: <source_state_id> <instruction_id> <target_state_id>\n";
  for(auto pair_1: transitions){
    for(auto pair_2: pair_1.second){
      *callpath_state_transitions_file << "" << pair_1.first << " " << pair_2.first << " " << pair_2.second << "\n";
    }
  }
  // close file handle
  if (callpath_state_transitions_file != NULL && callpath_state_transitions_file->is_open()) {
    callpath_state_transitions_file->flush();
    callpath_state_transitions_file->close();
  }

  // prepare saving the callpathState transitions as DOT file
  callpath_state_transitions_file = new std::ofstream();
  std::string tmp02(getenv("DOT_DISCOPOP_PROFILER"));
  tmp02 += "/callpath_state_transitions.dot";
  callpath_state_transitions_file->open(tmp02.data(), std::ios_base::app);
  // write file
  *callpath_state_transitions_file << "diGraph G {\n";
  for(auto pair_1: transitions){
    for(auto pair_2: pair_1.second){
      *callpath_state_transitions_file <<"  " << pair_1.first << " -> " << pair_2.second << " [label = " << pair_2.first << "];\n";
    }
  }
  *callpath_state_transitions_file << "}\n";
  // close file handle
  if (callpath_state_transitions_file != NULL && callpath_state_transitions_file->is_open()) {
    callpath_state_transitions_file->flush();
    callpath_state_transitions_file->close();
  }
}

void DiscoPoP::save_static_calltree_to_dot(StaticCalltree& calltree){
  std::ofstream *calltree_dot_file;
  // prepare saving the calltree as DOT file
  calltree_dot_file = new std::ofstream();
  std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
  tmp += "/static_calltree.dot";
  calltree_dot_file->open(tmp.data(), std::ios_base::app);
  // write file
  *calltree_dot_file << calltree.to_dot_string() << "\n";

  // close file handle
  if (calltree_dot_file != NULL && calltree_dot_file->is_open()) {
    calltree_dot_file->flush();
    calltree_dot_file->close();
  }
}

// prepare a lookup table for every state in the static call tree to allow transitions between states in constant time
// Keys of the lookup tables should be the instructionIDs of call instructions.

// prepare a lookup table to map from a unique instructionID and the current state pointer to the disambiguatedInstructionID, i.e.
// the instruction indentifier, that also encodes the call path taken to execute the instruction

string path_to_string(std::vector<StaticCalltreeNode*>& path){
  string path_str = "";
  for(auto elem: path){
    path_str += elem->get_label() + "-->";
  }
  return path_str;
}

// adds the state transition edges corresponding to returning from a function.
// for completeness and fail-safety, this edge is added to every state in a function, i.e., returning is possible from every state
void DiscoPoP::add_function_exit_edges_to_transitions(std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>>& state_transitions, std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths){
  TODO:
  // for each path in paths
    // rfind first call instruction
    // create prefix path, ending just before found call instruction
    // find state id for the prefix path
    // register edge transition from path to prefix path with trigger instruction "1" (i.e. leaving function)
  for(auto path: paths){
    auto path_id = path.first;
    // rfind first call instruction
    int last_call_idx = -1;
    for(int idx = path.second.size() - 1 ; idx >= 0; --idx ){
      auto path_node = path.second[idx];
      if(path_node->get_type() == true){
        // path node is a call instruction
        last_call_idx = idx;
        break;
      }
    }
    if(last_call_idx == -1){
      // no call found
      continue;
    }

    // create prefix path
    std::vector<StaticCalltreeNode*> prefix_path;
    for(int i = 0; i < last_call_idx; i++){
      prefix_path.push_back(path.second[i]);
    }

    // DEBUG
    string prefix_path_str = path_to_string(prefix_path);
    string path_str = path_to_string(path.second);
    cout << "Path: " << path_str << "\n";
    cout << "Prefix path: " << prefix_path_str << "\n";
    // !DEBUG

    // find state id for prefix path
    auto prefix_path_stateID = get_id_from_callpath(prefix_path, paths);
    cout << "--> PathID: " << prefix_path_stateID << "\n";

    // register transition edge from path to prefix path with trigger instruction "1" (i.e. leaving function)
    if(state_transitions.find(path_id) == state_transitions.end()){
      std::unordered_map<int32_t, int32_t> tmp;
      state_transitions[path_id] = tmp;
    }
    state_transitions[path_id][1] = prefix_path_stateID;
    cout << "--> Registered transition: " << path_id << " " << 1 << " --> " << prefix_path_stateID << "\n";
  }
}
