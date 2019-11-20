#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/DebugInfo.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Pass.h>
#include <llvm/PassSupport.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>

#include "Util.h"

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

struct ModuleFunc : public llvm::ModulePass {
  static char ID;
  ModuleFunc() : ModulePass(ID) {}
  virtual bool runOnModule(llvm::Module& M);
  void getAnalysisUsage(llvm::AnalysisUsage& Info) const;

  void instrument_module(llvm::Module* module);
  void instrument_function(llvm::Function* function);
  void instrument_loop(int file_id, llvm::Loop* loop);
  llvm::Instruction* get_reduction_instr(llvm::Instruction* store_instr,
                                         llvm::Instruction** load_instr);

  void create_function_bindings();
  void insert_functions();

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
char ModuleFunc::ID = 0;
static llvm::RegisterPass<ModuleFunc> X("modulefunc", "Modulefunc Pass", false,
                                        false);

// == Options ==================================================================
static llvm::cl::opt<std::string> fmap_file(
    "fmap", llvm::cl::desc("<file mapping file>"), llvm::cl::Required);

// == Implementation ===========================================================

// Creates the bindings for the functions that should be insterted to instrument
// the variable accesses.
void ModuleFunc::create_function_bindings() {

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
void ModuleFunc::insert_functions() {
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
    llvm::Value* val = cur_instr->getOperand(0);
    if (val == load_val) return cur_instr;

    // The current instruction does not load the value from the address of
    // 'load_val'. But it might load the value from a variable where 'load_val'
    // is stored in, so find the previous use of the source operand.
    llvm::Instruction* prev_use = util::get_prev_use(cur_instr, val);
    if (prev_use) {
      if (llvm::isa<llvm::StoreInst>(prev_use)) {
        return get_load_instr(load_val, prev_use, reduction_operations);
      } else if (llvm::isa<llvm::GetElementPtrInst>(prev_use)) {
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
        return (found) ? cur_instr : nullptr;
      }
    } else {
      return nullptr;
    }
  }

  unsigned opcode = cur_instr->getOpcode();
  char c = util::get_char_for_opcode(opcode);
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
  if (!val || !llvm::isa<llvm::Instruction>(val)) {
    return nullptr;
  }

  llvm::Instruction* instr = llvm::cast<llvm::Instruction>(val);
  unsigned opcode = instr->getOpcode();
  char c = util::get_char_for_opcode(opcode);
  if (c != ' ') {
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
llvm::Instruction* ModuleFunc::get_reduction_instr(
    llvm::Instruction* store_instr, llvm::Instruction** load_instr) {

  // find the reduction operation for the source operand of the 'store_instr'
  llvm::Instruction* reduction_instr =
      find_reduction_instr(store_instr->getOperand(0));
  if (!reduction_instr) return nullptr;

  // Now find the destination address of the store instruction.
  // After that, search the load instruction that loads this value and store a
  // pointer to it in 'load_instr'.
  llvm::Value* store_dst = util::get_var_rec(store_instr->getOperand(1));
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
void ModuleFunc::instrument_loop(int file_id, llvm::Loop* loop) {
  llvm::BasicBlock* loop_header = loop->getHeader();
  auto loc = loop_header->begin()->getDebugLoc();
  if (!util::loc_exists(loc)) {
    return;
  }

  auto basic_blocks = loop->getBlocks();
  if (basic_blocks.size() < 3) {
    return;
  }

  // add an entry to the 'loops_' vector
  loop_info_t loop_info;
  loop_info.line_nr_ = loc.getLine();
  loop_info.file_id_ = file_id;
  loop_info.first_body_instr_ = &(*basic_blocks[1]->begin());
  loops_.push_back(loop_info);

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
  for (size_t i = 0; i < basic_blocks.size(); ++i) {
    llvm::BasicBlock* const bb = basic_blocks[i];

    std::string bb_name = bb->getName();
    if ((std::strncmp("for.inc", bb_name.c_str(), 7) == 0) ||
        (std::strncmp("for.cond", bb_name.c_str(), 8) == 0)) {
      continue;
    }

    for (auto instr_it = bb->begin(); instr_it != bb->end(); ++instr_it) {
      llvm::Instruction* instr = &(*instr_it);
      auto opcode = instr->getOpcode();
      if (opcode != llvm::Instruction::Store &&
          opcode != llvm::Instruction::Load) {
        continue;
      }

      // Add an entry to the corresponding map or invalidate an already
      // existing entry, if the same instruction is executed on multiple
      // lines.
      llvm::Value* operand = util::get_var(instr);
      if (operand) {
        std::map<llvm::Value*, llvm::Instruction*>* map_ptr =
            (opcode == llvm::Instruction::Store) ? &store_instructions
                                                 : &load_instructions;
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
        }
      }
    }
  }

  // only keep the instructions that satisfy the following conditions :
  // - a variable that is read must also be written in the loop
  // - a variable must not be read or written more than once
  // - the store instruction comes after the load instruction
  std::vector<instr_info_t> candidates;
  for (auto it = load_instructions.begin(); it != load_instructions.end();
       ++it) {
    if (!it->second) continue;

    auto it2 = store_instructions.find(it->first);
    if (it2 != store_instructions.end() && it2->second) {
      llvm::DebugLoc load_loc = it->second->getDebugLoc();
      llvm::DebugLoc store_loc = it2->second->getDebugLoc();
      if (!util::loc_exists(load_loc) || !util::loc_exists(store_loc)) continue;
      if (load_loc.getLine() > store_loc.getLine()) continue;
      if (load_loc.getLine() == loop_info.line_nr_) continue;

      if (it->first->hasName()) {
        instr_info_t info;
        info.var_name_ = it->first->getName();
        info.loop_line_nr_ = loop_info.line_nr_;
        info.file_id_ = file_id;
        info.store_inst_ = llvm::dyn_cast<llvm::StoreInst>(it2->second);
        candidates.push_back(info);
      }
    }
  }

  // now check if the variables are part of a reduction operation
  for (auto candidate : candidates) {
    llvm::Instruction* load_instr = nullptr;
    llvm::Instruction* instr =
        get_reduction_instr(candidate.store_inst_, &load_instr);
    if (instr) {
      candidate.load_inst_ = llvm::cast<llvm::LoadInst>(load_instr);
      candidate.operation_ = util::get_char_for_opcode(instr->getOpcode());
      instructions_.push_back(candidate);
    }
  }
}

// iterates over all loops in a function and calls 'instrument_loop' for each
// one
void ModuleFunc::instrument_function(llvm::Function* function) {
  llvm::errs() << "instrument_function : " << function->getName() << "\n";

  // get the corresponding file id
  unsigned file_id = util::get_file_id(function);
  if (file_id == 0) {
    return;
  }

#if OLD_CLANG_VER
  llvm::LoopInfo& loop_info = getAnalysis<llvm::LoopInfo>(*function);
#else
  llvm::LoopInfo& loop_info =
      getAnalysis<llvm::LoopInfoWrapperPass>(*function).getLoopInfo();
#endif

  for (auto loop_it = loop_info.begin(); loop_it != loop_info.end();
       ++loop_it) {
    instrument_loop(file_id, *loop_it);
  }
}

// iterates over all functions in the module and calls 'instrument_function'
// on suitable ones
void ModuleFunc::instrument_module(llvm::Module* module) {
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

void ModuleFunc::getAnalysisUsage(llvm::AnalysisUsage& Info) const {
#if OLD_CLANG_VER
  Info.addRequired<llvm::LoopInfo>();
#else
  Info.addRequired<llvm::LoopInfoWrapperPass>();
#endif
}

bool ModuleFunc::runOnModule(llvm::Module& M) {
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
