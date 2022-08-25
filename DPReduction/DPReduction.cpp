/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include <iostream>

#include "llvm/ADT/StringRef.h"
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DebugInfo.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Operator.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Pass.h>
#include <llvm/PassSupport.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include "llvm/PassAnalysisSupport.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"

#include "Utils.h"

using namespace llvm;
using namespace std;


struct instr_info_t {
  std::string var_name_;
  int loop_line_nr_;
  int file_id_;
  llvm::StoreInst* store_inst_;
  llvm::LoadInst* load_inst_;
  char operation_ = ' ';
};

struct loop_info_t {
  int line_nr_;
  int file_id_;
  llvm::Instruction* first_body_instr_;
};

struct DPReduction : public llvm::ModulePass {
  static char ID;
  DPReduction() : ModulePass(ID) {}
  virtual bool runOnModule(llvm::Module& M);
  void getAnalysisUsage(llvm::AnalysisUsage& Info) const;

  void instrument_module(llvm::Module* module);
  void instrument_function(llvm::Function* function);
  void instrument_loop(int file_id, llvm::Loop* loop);
  llvm::Instruction* get_reduction_instr(llvm::Instruction* store_instr,
                                         llvm::Instruction** load_instr);

  void create_function_bindings();
  void insert_functions();
  StringRef getPassName() const;

  std::vector<instr_info_t> instructions_;
  std::map<int, llvm::Instruction*> loop_to_instr_;
  std::vector<loop_info_t> loops_;

  llvm::Function* add_instr_fn_;
  llvm::Function* add_ptr_instr_fn_;
  llvm::Function* loop_incr_fn_;
  llvm::Function* output_fn_;

  llvm::LLVMContext* ctx_;
  llvm::Module* module_;
};

// == LLVM setup ===============================================================
char DPReduction::ID = 0;
static llvm::RegisterPass<DPReduction> X("DPReduction", "Identify reduction variables", false,
                                        false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM)
{
    PM.add(new LoopInfoWrapperPass());
    //PM.add(new RegionInfoPass());
    PM.add(new DPReduction());
}

static RegisterStandardPasses DPReductionLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses DPReductionLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

ModulePass *createDPReductionPass()
{

    initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
    initializeRegionInfoPassPass(*PassRegistry::getPassRegistry());
    return new DPReduction();
}

StringRef DPReduction::getPassName() const
{
    return "DPReduction";
}

// == Options ==================================================================
static llvm::cl::opt<std::string> fmap_file(
    "fm-path", llvm::cl::desc("<file mapping file>"), llvm::cl::Required);

// == Implementation ===========================================================

// Creates the bindings for the functions that should be insterted to instrument
// the variable accesses.
void DPReduction::create_function_bindings() {

  // add_instr_rec
  llvm::Type* type_array[4];
  type_array[0] = llvm::Type::getInt32Ty(*ctx_);  // loop line number
  type_array[1] = llvm::Type::getInt64Ty(*ctx_);  // variable address
  type_array[2] = llvm::Type::getInt32Ty(*ctx_);  // instruction type
  llvm::ArrayRef<llvm::Type*> fn_args(type_array, 3);
  llvm::FunctionType* fn_type =
      llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), fn_args, false);
  add_instr_fn_ = llvm::dyn_cast<llvm::Function>(
      module_->getOrInsertFunction("add_instr_rec", fn_type));

  // add_ptr_instr
  type_array[3] = llvm::Type::getInt64Ty(*ctx_);  // pointer address
  llvm::ArrayRef<llvm::Type*> ptr_fn_args(type_array, 4);
  llvm::FunctionType* ptr_fn_type =
      llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), ptr_fn_args, false);
  add_ptr_instr_fn_ = llvm::dyn_cast<llvm::Function>(
      module_->getOrInsertFunction("add_ptr_instr_rec", ptr_fn_type));

  // incr_loop_counter
  llvm::Type* loop_incr_fn_arg_type = llvm::Type::getInt32Ty(*ctx_);
  llvm::ArrayRef<llvm::Type*> loop_incr_fn_args(loop_incr_fn_arg_type);
  llvm::FunctionType* loop_incr_fn_type = llvm::FunctionType::get(
      llvm::Type::getVoidTy(*ctx_), loop_incr_fn_args, false);
  loop_incr_fn_ = llvm::dyn_cast<llvm::Function>(
      module_->getOrInsertFunction("incr_loop_counter", loop_incr_fn_type));

  // loop_counter_output
  llvm::FunctionType* output_fn_type =
      llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), false);
  output_fn_ = llvm::dyn_cast<llvm::Function>(
      module_->getOrInsertFunction("loop_counter_output", output_fn_type));
}

// Inserts calls to allow for dynamic analysis of the loops.
void DPReduction::insert_functions() {

  std::cout << "inserting functions: \n"; 
  
  std::ofstream out_file;
  out_file.open("reduction_meta.txt");

  // insert function calls to monitor the variable's load and store operations
  int instr_id = 1;
  for (auto const& instruction : instructions_) {
    int loop_id = instruction.loop_line_nr_;
    int store_line = instruction.store_inst_->getDebugLoc().getLine();

    llvm::Value* args[4];
    args[0] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), loop_id);
    args[1] = llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx_), instr_id);

    if (llvm::isa<llvm::GetElementPtrInst>(
            instruction.store_inst_->getOperand(1))) {
      if (!llvm::isa<llvm::GetElementPtrInst>(
              instruction.load_inst_->getOperand(0))) {
        llvm::errs() << "==== load instr is not a GetElementPtrInst ====\n";
        continue;
      }
      llvm::ArrayRef<llvm::Value*> args_ref(args, 4);

      args[2] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), 1);
      args[3] = llvm::PtrToIntInst::CreatePointerCast(
          instruction.store_inst_->getPointerOperand(),
          llvm::Type::getInt64Ty(*ctx_), "", instruction.store_inst_);
      llvm::CallInst::Create(add_ptr_instr_fn_, args_ref, "",
                             instruction.store_inst_);

      args[2] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), 0);
      args[3] = llvm::PtrToIntInst::CreatePointerCast(
          instruction.load_inst_->getPointerOperand(),
          llvm::Type::getInt64Ty(*ctx_), "", instruction.load_inst_);
      llvm::CallInst::Create(add_ptr_instr_fn_, args_ref, "",
                             instruction.load_inst_);
    } else {

      std::cout << "inserting add_instr_fn_n because operand is not a getelementptr \n";
      llvm::ArrayRef<llvm::Value*> args_ref(args, 3);

      args[2] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), 1);
      llvm::CallInst::Create(add_instr_fn_, args_ref, "",
                             instruction.store_inst_);

      args[2] = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), 0);
      llvm::CallInst::Create(add_instr_fn_, args_ref, "",
                             instruction.load_inst_);
    }

    out_file << instruction.file_id_ << " ";
    out_file << instr_id++ << " ";
    out_file << instruction.var_name_ << " ";
    out_file << loop_id << " ";
    out_file << store_line << " ";
    out_file << instruction.operation_ << "\n";
  }
  out_file.close();

  // insert function calls to monitor loop iterations
  out_file.open("loop_meta.txt");
  int loop_id = 1;
  for (auto const& loop_info : loops_) {
    llvm::Value* val =
        llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), loop_id);
    llvm::ArrayRef<llvm::Value*> args(val);
    llvm::CallInst::Create(loop_incr_fn_, args, "",
                           loop_info.first_body_instr_);

    out_file << loop_info.file_id_ << " ";
    out_file << loop_id++ << " ";
    out_file << loop_info.line_nr_ << "\n";
  }
  out_file.close();

  // add a function to output the final data
  llvm::Function* main_fn = module_->getFunction("main");
  if (main_fn) {
    for (auto it = llvm::inst_begin(main_fn); it != llvm::inst_end(main_fn);
         ++it) {
      if (llvm::isa<llvm::ReturnInst>(&(*it))) {
        llvm::IRBuilder<> ir_builder(&(*it));
        ir_builder.CreateCall(output_fn_);
        break;
      }
    }
  } else {
    llvm::errs() << "Error : Could not find a main function\n";
  }
}

// Finds the load instruction that actually loads the value from the address
// 'load_val'.
llvm::Instruction* get_load_instr(llvm::Value* load_val,
                                  llvm::Instruction* cur_instr,
                                  std::vector<char>& reduction_operations) {
  if (!load_val || !cur_instr) return nullptr;

 

  if (llvm::isa<llvm::LoadInst>(cur_instr)) {
    // Does the current instruction already load the value from the correct
    // address? If that is the case, return it.
    // check if operand is constantexpression
    // not call get operand but if getelementptr get the underlying operand
    llvm::Value* val = cur_instr->getOperand(0);
    if (val == load_val){
      std::cout << "returning cur_inst because val == load_val \n"; 
      llvm::errs() << *val << "\n";
      return cur_instr; 
      // one exception: if it is constant value like getelementptr constant expression
      // previous use cannot be the expression itself as it is inlined but is a previous load or store
      // instruction which would be erroneous
    } else if(llvm::isa<llvm::ConstantExpr>(val)) {
      std::cout << "is constant expression \n"; 
      llvm::errs() << *llvm::dyn_cast<llvm::GEPOperator>(val)->getPointerOperand() << "pointer operand \n";
     
      llvm::Value* points_to = llvm::dyn_cast<llvm::GEPOperator>(val)->getPointerOperand();
      if (points_to == load_val) {
          std::cout << "points to! \n"; 
          return cur_instr; 
      }          

    }
     

    
    
    // The current instruction does not load the value from the address of
    // 'load_val'. But it might load the value from a variable where 'load_val'
    // is stored in, so find the previous use of the source operand.
    llvm::Instruction* prev_use = util::get_prev_use(cur_instr, val);
    llvm::errs() << *prev_use << "\n"; 
    if (prev_use) {
      if (llvm::isa<llvm::StoreInst>(prev_use)) {
        std::cout << "surprising store instruction \n";
        return get_load_instr(load_val, prev_use, reduction_operations);
      } else if (llvm::isa<llvm::GetElementPtrInst>(prev_use)) {
        std::cout << "is getelementptrinst \n"; 
        llvm::errs() << *prev_use << "\n"; 
        llvm::GetElementPtrInst* ptr_instr =
            llvm::cast<llvm::GetElementPtrInst>(prev_use);
        llvm::Value* points_to = util::points_to_var(ptr_instr);
        if (points_to == load_val) {
          return cur_instr;
        } else {
          bool found = static_cast<bool>(get_load_instr(
              load_val, llvm::dyn_cast<llvm::Instruction>(points_to),
              reduction_operations));
          return (found) ? cur_instr : nullptr;
        }
      } else {
        bool found = static_cast<bool>(
            get_load_instr(load_val, prev_use, reduction_operations));
        std::cout << "bool is\n"; 
        std::cout << found << "\n";    
        return (found) ? cur_instr : nullptr;
      }
    } else {
      std::cout << "current instruction is not load instruction \n"; 
      std::cout << "returning null pointer\n";
      return nullptr;
    }
  }


  char c = util::get_char_for_opcode(cur_instr);
  if (c != ' ') {
    reduction_operations.push_back(c);
  }

  // The current instruction is not a load instruction. Follow the operands
  // of the current instruction recursively until the desired load instruction
  // is reached.
  llvm::Instruction* result = nullptr;
  for (int i = 0; i != cur_instr->getNumOperands(); ++i) {
    llvm::Value* operand = cur_instr->getOperand(i);
    if (llvm::isa<llvm::Instruction>(operand)) {
      result = get_load_instr(load_val, llvm::cast<llvm::Instruction>(operand),
                              reduction_operations);
      if (result) {
        break;
      }
    }
  }

  if (!result && c != ' ') {
    reduction_operations.pop_back();
  }

  return result;
}

// returns the reduction instruction where 'val' is the operand if it can find
// such an operation
llvm::Instruction* find_reduction_instr(llvm::Value* val) {
  errs () << *val << "\n";
  if (!val || !llvm::isa<llvm::Instruction>(val)) {
    return nullptr;
  }

  errs() << *val << "val from find reduction instruction \n";

  llvm::Instruction* instr = llvm::cast<llvm::Instruction>(val);
  unsigned opcode = instr->getOpcode();
  
  // not reduction instruction will be returned but the extractvalue instruction
  char c = util::get_char_for_opcode(instr);
 
  cout << "char for opcode is: " << c << "\n"; 
  if (c != ' ') {
    // if the front end generates a call instruction to llvm then the instruction has 
    // to be built here or there must be a different way to deal with this operation
    return instr;
  } else if (opcode == llvm::Instruction::Load) {
    llvm::Instruction* prev_use =
        util::get_prev_use(instr, instr->getOperand(0));
    return find_reduction_instr(prev_use);
  } else if (opcode == llvm::Instruction::Store) {
    return find_reduction_instr(instr->getOperand(0));
  }
  return nullptr;
}

int get_op_order(char c) {
  if (c == '*' || c == '/') return 5;
  if (c == '+' || c == '-') return 4;
  if (c == '&') return 3;
  if (c == '^') return 2;
  if (c == '|') return 1;
  return 0;
}

// Retrieves the reduction operation for the operand that is stored by the
// 'store_instr' (if such a reduction operation exists).
// The parameter 'load_instr' will point to the load instruction that actually
// loads the value (if such a load instruction exists).
llvm::Instruction* DPReduction::get_reduction_instr(
    llvm::Instruction* store_instr, llvm::Instruction** load_instr) {
  // error for rust lies here 
  cout << "getting reduction instruction\n";
  errs() << *store_instr << "\n"; 
  errs () << *load_instr << "\n";

  // find the reduction operation for the source operand of the 'store_instr'
  llvm::Instruction* reduction_instr =
      find_reduction_instr(store_instr->getOperand(0));
  if (!reduction_instr) return nullptr;
  cout << "find_reduction_instr was not null \n";
  errs() << *reduction_instr << "\n"; 

  // Now find the destination address of the store instruction.
  // After that, search the load instruction that loads this value and store a
  // pointer to it in 'load_instr'.
  std::cout << "store destination debug start \n"; 
  llvm::Value* store_dst = util::get_var_rec(store_instr->getOperand(1));
  llvm::errs() << *store_dst << " store destination\n";
  if (store_dst) {
    std::vector<char> reduction_operations;
    *load_instr =
        get_load_instr(store_dst, reduction_instr, reduction_operations);


    // { *, / } > { +, - } > { & } > { ^ } > { | }
    if (reduction_operations.size() > 1) {
      int order = get_op_order(reduction_operations[0]);
      for (size_t i = 1; i != reduction_operations.size(); ++i) {
        int order_i = get_op_order(reduction_operations[i]);
        if (order_i > order) {
          *load_instr = nullptr;
          return nullptr;
        }
      }
    }
    if (*load_instr) return reduction_instr;
  }

  return nullptr;
}

// Goes through all instructions in a loop and determines if they might be
// suitable for reduction.
// An entry is added to the 'loops_' vector and for each suitable instruction,
// an entry is added to the 'instructions_' vector.
void DPReduction::instrument_loop(int file_id, llvm::Loop* loop) {
  llvm::BasicBlock* loop_header = loop->getHeader();

  std::string header_name  = loop_header->getName(); 
  
  cout << "loop header name" << header_name << "\n";
  llvm::errs() << *loop_header << "\n"; 
  int loopLine; 


  
  //this does not work because some front ends like swift can generate instructions
  //that do not have a pproper debugloc 
  //could check if dilocation is 0 because this seems to be the only exception to this
  // then iterate to other instructions until proper one is foundf
  auto loc = loop_header->begin()->getDebugLoc();

  if(util::loc_exists(loc)){
    std::cout << "getting scope" << "\n"; 
    llvm::DIScope *scopeInfo = loc->getScope();
    llvm::errs() << *scopeInfo << "\n";

    if(llvm::isa<llvm::DILexicalBlockFile>(scopeInfo)) {
      //must cast here statically?
      // get the lexical block
      std::cout << "is lexical block file"; 
      llvm::errs() << *scopeInfo << "\n";
      loopLine = llvm::cast<llvm::DILexicalBlock>(scopeInfo->getScope())->getLine();

    } else if(llvm::isa<llvm::DILexicalBlock>(scopeInfo)) {
      // must be dilexicalblock
      std::cout << "is lexical block"; 
      llvm::errs() << *scopeInfo << "\n";
      loopLine = llvm::cast<llvm::DILexicalBlock>(scopeInfo)->getLine();
    } else {
      llvm::errs() << *scopeInfo << "\n";
      std::cout << "an error has occured \n";
      }
 } else {
   return; 
 }

  // can get this from scope
  //this is says header is in line zero for swift 
  std::cout << loopLine << "debug location for loop line \n"; 

  auto basic_blocks = loop->getBlocks();
  if (basic_blocks.size() < 3) {
    return;
  }

  std::cout << "instrumenting loop: \n"; 

  // add an entry to the 'loops_' vector
  loop_info_t loop_info;
  loop_info.line_nr_ = loopLine;
  loop_info.file_id_ = file_id;

  // in rust, a loop header can go over multiple basic blocks
  // need to make this more dynamic
  loop_info.first_body_instr_ = &(*basic_blocks[1]->begin());
  loops_.push_back(loop_info);
  std::cout << loop_info.line_nr_ << "\n"; 


  // call 'instrument_loop' on all its subloops
  auto const sub_loops = loop->getSubLoops();
  for (auto loop_it = sub_loops.begin(); loop_it != sub_loops.end();
       ++loop_it) {
    instrument_loop(file_id, *loop_it);
  }

  // The key corresponds to the variable that is loaded / stored.
  // The value points to the actual load / store instruction.
  std::map<llvm::Value*, llvm::Instruction*> load_instructions;
  std::map<llvm::Value*, llvm::Instruction*> store_instructions;

  // Scan all instructions in the loop's basic blocks to find the load and
  // store instructions. 
  std::cout << "instrumenting loop basic blocks: \n"; 
  for (size_t i = 0; i < basic_blocks.size(); ++i) {
    std::cout << "entering basic block: \n"; 
  
    llvm::BasicBlock* const bb = basic_blocks[i];

    std::string bb_name = bb->getName();
    std::cout << bb_name << "\n";
    //todo: must find different way to find inc and cond block for loops in rust and swift
   
    // with generators in rust, the inc and cond basic block are both the header
    if ((std::strncmp("for.inc", bb_name.c_str(), 7) == 0) ||
        (std::strncmp("for.cond", bb_name.c_str(), 8) == 0) ||
        // skip header basic block even if not labeled
        (loop_header == bb)) {
      continue;
    }


    for (auto instr_it = bb->begin(); instr_it != bb->end(); ++instr_it) {
      llvm::Instruction* instr = &(*instr_it);

      auto opcode = instr->getOpcode();
      if (opcode != llvm::Instruction::Store &&
          opcode != llvm::Instruction::Load) {
        continue;
      }

      llvm::errs() << "found instruction in current basic block" << *instr << "\n"; 



      // Add an entry to the corresponding map or invalidate an already
      // existing entry, if the same instruction is executed on multiple
      // lines.
      llvm::Value* operand = util::get_var(instr);
      
      if (operand) {
        std:: cout << "new operand found\n"; 
        llvm::errs() << *operand << "\n";
        std::map<llvm::Value*, llvm::Instruction*>* map_ptr =
            (opcode == llvm::Instruction::Store) ? &store_instructions
                                                 : &load_instructions;

            std::string debug_helper =  (opcode == llvm::Instruction::Store) ? "store instruction"
                                                 : "load instruction";
            std::cout << "identified" << debug_helper << "\n";   

            llvm::errs() << "instruction : " << *instr << "\n";
            std::cout << "\n";      

        // insetion went wrong? i think reading twice from variable can still be reduction
        if (!map_ptr->insert(std::make_pair(operand, instr)).second) {
          if ((*map_ptr)[operand]) {
            llvm::DebugLoc new_loc = instr->getDebugLoc();
            llvm::DebugLoc old_loc = (*map_ptr)[operand]->getDebugLoc();

            if (!util::loc_exists(new_loc) || !util::loc_exists(old_loc)) {
              (*map_ptr)[operand] = nullptr;
            } else if (new_loc.getLine() != old_loc.getLine()) {
              (*map_ptr)[operand] = nullptr;
            }
          }
        } else  {
          llvm::errs() << *instr << "\n"; 
          std::cout << "added instruction successfully to map \n";
        }
      }
    }
  }

  // only keep the instructions that satisfy the following conditions :
  // - a variable that is read must also be written in the loop
  // - a variable must not be read or written more than once
  //
  // - the store instruction comes after the load instruction
  std::cout << "creating candidates list \n";

  std::vector<instr_info_t> candidates;
  for (auto it = load_instructions.begin(); it != load_instructions.end();
       ++it) {
    if (!it->second) continue;

    // gets pointer to value that is read from
    auto it2 = store_instructions.find(it->first);
    if (it2 != store_instructions.end() && it2->second) {
      llvm::DebugLoc load_loc = it->second->getDebugLoc();
      llvm::DebugLoc store_loc = it2->second->getDebugLoc();
      if (!util::loc_exists(load_loc) || !util::loc_exists(store_loc)) continue;
      // abort if load of this variable happens after store
      if (load_loc.getLine() > store_loc.getLine()) continue;
      // abort if load is in loop header
      if (load_loc.getLine() == loop_info.line_nr_) continue;

      if (it->first->hasName()) {
        instr_info_t info;
        //todo: in rust for array reads, the operand of array indexing load
        // only importand when arr[i] is the accumulator
        // instruction has no name because the getelementptr instruction has none
        // currently no support for arrays as reducers
        cout << "should have no name" << "\n";
        llvm::errs() << *it->first << "\n";
        info.var_name_ = it->first->getName();
        info.loop_line_nr_ = loop_info.line_nr_;
        info.file_id_ = file_id;
        info.store_inst_ = llvm::dyn_cast<llvm::StoreInst>(it2->second);
        candidates.push_back(info);
        errs() << *info.store_inst_ << "\n"; 
        std::cout << "ADDED INSTRUCTION TO CANDIDATES \n";
      }
    }
  }

  // now check if the variables are part of a reduction operation
  std::cout << "priting candidates \n";
  for (auto candidate : candidates) {
    std::cout << candidate.var_name_ << "\n"; 
    std::cout << candidate.loop_line_nr_ << "\n"; 
    llvm::errs () << *candidate.store_inst_ << "\n"; 

    llvm::Instruction* load_instr = nullptr;
    // this returns null not only if the reduction instruction is null but also if load_instr is null 
    llvm::Instruction* instr =
        get_reduction_instr(candidate.store_inst_, &load_instr);
        std::cout << "instruction: \n";


    if (instr) {
      errs () << *instr << "\n";
      candidate.load_inst_ = llvm::cast<llvm::LoadInst>(load_instr);
      cout << "the proper found load instruction is \n"; 
      errs() << *candidate.load_inst_ << "\n";

      // must be edited for rust/swift  with llvm.operation function calls
      candidate.operation_ = util::get_char_for_opcode(instr);
      std::cout << "added candidate to instruction vector \n";
      errs () << *candidate.load_inst_ << "\n";
      instructions_.push_back(candidate);
    } else {
      std::cout << "!!! instruction was null for \n" << candidate.var_name_ << "\n"; 
      
    }
  }
}

// iterates over all loops in a function and calls 'instrument_loop' for each
// one
void DPReduction::instrument_function(llvm::Function* function) {
  llvm::errs() << "instrument_function : " << function->getName() << "\n";

  // get the corresponding file id
  unsigned file_id = util::get_file_id(function);
  if (file_id == 0) {
    return;
  }

  llvm::LoopInfo& loop_info = getAnalysis<llvm::LoopInfoWrapperPass>(*function).getLoopInfo();

  for (auto loop_it = loop_info.begin(); loop_it != loop_info.end();
       ++loop_it) {
    instrument_loop(file_id, *loop_it);
  }
}

// iterates over all functions in the module and calls 'instrument_function'
// on suitable ones
void DPReduction::instrument_module(llvm::Module* module) {
  llvm::errs() << "instrument_module : " << module->getModuleIdentifier()
               << "\n";

  for (llvm::Module::iterator func_it = module->begin();
       func_it != module->end(); ++func_it) {
    llvm::Function* func = &(*func_it);
    std::string fn_name = func->getName();
    if (func->isDeclaration() || (strcmp(fn_name.c_str(), "NULL") == 0) ||
        fn_name.find("llvm") != std::string::npos) {
      continue;
    }
    instrument_function(func);
  }
}

void DPReduction::getAnalysisUsage(llvm::AnalysisUsage& Info) const {
  Info.addRequired<llvm::LoopInfoWrapperPass>();
}

bool DPReduction::runOnModule(llvm::Module& M) {
  module_ = &M;
  ctx_ = &module_->getContext();

  bool success = util::init_util(fmap_file);
  if (!success) {
    llvm::errs() << "could not find the FileMapping file\n";
    return false;
  }

  instrument_module(&M);

  create_function_bindings();
  insert_functions();

  return true;
}
