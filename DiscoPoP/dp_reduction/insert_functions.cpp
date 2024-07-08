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

// Inserts calls to allow for dynamic analysis of the loops.
void DiscoPoP::dp_reduction_insert_functions() {

  // insert function calls to monitor the variable's load and store operations
  for (auto const &instruction : instructions_) {
    int store_line = instruction.store_inst_->getDebugLoc().getLine();

    // output information about the reduction variables
    *reduction_file << " FileID : " << instruction.file_id_;
    *reduction_file << " Loop Line Number : " << instruction.loop_line_nr_;
    *reduction_file << " Reduction Line Number : " << to_string(store_line);
    *reduction_file << " Variable Name : " << instruction.var_name_;
    *reduction_file << " Operation Name : " << instruction.operation_ << "\n";
  }

  // insert function calls to monitor loop iterations
  std::ofstream loop_metadata_file;
  std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
  tmp += "/loop_meta.txt";
  loop_metadata_file.open(tmp.data());
  int loop_id = 1;
  llvm::Type *loop_incr_fn_arg_type = llvm::Type::getInt32Ty(*ctx_);
  llvm::ArrayRef<llvm::Type *> loop_incr_fn_args(loop_incr_fn_arg_type);
  llvm::FunctionType *loop_incr_fn_type =
      llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), loop_incr_fn_args, false);
  FunctionCallee incr_loop_counter_callee = module_->getOrInsertFunction("__dp_loop_incr", loop_incr_fn_type);

  for (auto const &loop_info : loops_) {
    llvm::Value *val = llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), loop_id);
    llvm::ArrayRef<llvm::Value *> args(val);
    llvm::CallInst::Create(incr_loop_counter_callee, args, "", loop_info.first_body_instr_);
    loop_metadata_file << loop_info.file_id_ << " ";
    loop_metadata_file << loop_id++ << " ";
    loop_metadata_file << loop_info.line_nr_ << "\n";
  }
  loop_metadata_file.close();

  // add a function to output the final data
  // dp_loop_output
  llvm::FunctionType *output_fn_type = llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), false);
  FunctionCallee loop_counter_output_callee = module_->getOrInsertFunction("__dp_loop_output", output_fn_type);
  FunctionCallee cu_taken_branch_counter_output_callee =
      module_->getOrInsertFunction("__dp_taken_branch_counter_output", output_fn_type);
  llvm::Function *main_fn = module_->getFunction("main");
  if (main_fn) {
    for (auto it = llvm::inst_begin(main_fn); it != llvm::inst_end(main_fn); ++it) {
      if (llvm::isa<llvm::ReturnInst>(&(*it))) {
        llvm::IRBuilder<> ir_builder(&(*it));
        ir_builder.CreateCall(loop_counter_output_callee);
        if (DP_BRANCH_TRACKING) {
          ir_builder.CreateCall(cu_taken_branch_counter_output_callee);
        }
        break;
      }
    }
  } else {
    llvm::errs() << "Warning : Could not find a main function\n";
  }
}