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



// create a complete list of callpaths and intermediate states based on the static call tree of the module
// and assign unique identifiers to every state
std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> DiscoPoP::enumerate_paths(StaticCalltree& calltree){
  std::cout << "Enumerating Paths...\n";
  std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths;
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
  std::stack<std::vector<StaticCalltreeNode*>> stack;
  // -> initialize
  for(auto node_ptr: entry_nodes){
    std::vector<StaticCalltreeNode*> v;
    v.push_back(node_ptr);
    stack.push(v);
  }
  // -> process stack
  while(!stack.empty()){
    auto current_path = stack.top();
    stack.pop();
    paths[unique_callpath_state_id++] = current_path;
    for(auto succ_pair: current_path.back()->successors){
      int32_t trigger_instructionID = succ_pair.first;  // currently unused!
      for(auto succ: succ_pair.second){
        // check for cycles
        if(std::find(current_path.begin(), current_path.end(), succ) != current_path.end()){
          // already contained in current_path
          continue;
        }
        auto tmp_path = current_path;
        tmp_path.push_back(succ);
        stack.push(tmp_path);
      }
    }
  }

  return paths;
}

void DiscoPoP::save_enumerated_paths(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths){
  for(auto pair: paths){
    // construct path string
    std::string path_str = "";
    for(auto node_ptr: pair.second){
      path_str += node_ptr->get_label() + "-->";
    }
    // save path string to file
    *stateID_to_callpath_file << to_string(pair.first) << " " << path_str << "\n";
  }
}


// prepare a lookup table for every state in the static call tree to allow transitions between states in constant time
// Keys of the lookup tables should be the instructionIDs of call instructions.

// prepare a lookup table to map from a unique instructionID and the current state pointer to the disambiguatedInstructionID, i.e.
// the instruction indentifier, that also encodes the call path taken to execute the instruction
