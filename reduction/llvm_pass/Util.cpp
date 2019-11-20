#include "Util.h"

#include <fstream>
#include <map>
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

namespace util {

std::map<std::string, int> path_to_id_;

bool init_util(std::string fmap_path) {
  std::ifstream fmap_file;
  fmap_file.open(fmap_path.c_str());
  if (!fmap_file.is_open()) {
    return false;
  }

  std::string line;
  while (std::getline(fmap_file, line)) {
    char filename[512] = {'\0'};
    int file_id = 0;

    int cnt = sscanf(line.c_str(), "%d\t%s", &file_id, filename);
    if (cnt == 2) {
      path_to_id_.emplace(std::string(filename), file_id);
    }
  }
  fmap_file.close();

  return true;
}

unsigned get_file_id(llvm::Function* func) {
  unsigned file_id = 0;

  // get the filepath of this function
  char abs_path[PATH_MAX] = {'\0'};
  for (auto bb_it = func->begin(); bb_it != func->end(); ++bb_it) {
    for (auto instr_it = bb_it->begin(); instr_it != bb_it->end(); ++instr_it) {
      llvm::MDNode* node = instr_it->getMetadata("dbg");
      if (!node) continue;

#if OLD_CLANG_VER
      llvm::DILocation di_loc = llvm::DILocation(node);
      llvm::StringRef filename = di_loc.getFilename();
      llvm::StringRef directory = di_loc.getDirectory();
#else
      llvm::DILocation* di_loc = llvm::dyn_cast<llvm::DILocation>(node);
      llvm::StringRef filename = di_loc->getFilename();
      llvm::StringRef directory = di_loc->getDirectory();
#endif

      char* success =
          realpath((directory.str() + "/" + filename.str()).c_str(), abs_path);
      if (!success) {
        realpath(filename.str().c_str(), abs_path);
      }

      break;
    }
    if (abs_path[0] != '\0') break;
  }

  if (abs_path[0] != '\0') {
    auto it = path_to_id_.find(std::string(abs_path));
    if (it != path_to_id_.end()) {
      file_id = it->second;
    } else {
      llvm::errs() << "could not find the path '" << abs_path
                   << "' in the fmap file\n";
    }
  }

  return file_id;
}

bool is_operand(llvm::Instruction* instr, llvm::Value* operand) {
  unsigned num_operands = instr->getNumOperands();
  for (unsigned i = 0; i < num_operands; ++i) {
    if (instr->getOperand(i) == operand) return true;
  }
  return false;
}

char get_char_for_opcode(unsigned opcode) {
  if (opcode == llvm::Instruction::Add || opcode == llvm::Instruction::FAdd)
    return '+';
  if (opcode == llvm::Instruction::Sub || opcode == llvm::Instruction::FSub)
    return '-';
  if (opcode == llvm::Instruction::Mul || opcode == llvm::Instruction::FMul)
    return '*';
  if (opcode == llvm::Instruction::And) return '&';
  if (opcode == llvm::Instruction::Or) return '|';
  if (opcode == llvm::Instruction::Xor) return '^';
  return ' ';
}

llvm::Instruction* get_prev_use(llvm::Instruction* instr, llvm::Value* val) {
  if (!instr) return nullptr;

  auto instr_users = val->users();
  bool instr_found = false;
  for (auto user : instr_users) {
    if (!llvm::isa<llvm::Instruction>(user)) {
      continue;
    }
    llvm::Instruction* usr_instr = llvm::cast<llvm::Instruction>(user);

    if (instr_found) {
      return usr_instr;
    } else if (usr_instr == instr) {
      instr_found = true;
      continue;
    }
  }
  return llvm::dyn_cast<llvm::Instruction>(val);
}

llvm::Value* get_var_rec(llvm::Value* val) {
  if (!val) return nullptr;

  if (llvm::isa<llvm::AllocaInst>(val) ||
      llvm::isa<llvm::GlobalVariable>(val)) {
    return val;
  }
  if (llvm::isa<llvm::GetElementPtrInst>(val)) {
    llvm::GetElementPtrInst* elem_ptr_instr =
        llvm::cast<llvm::GetElementPtrInst>(val);

    // struct member reductions are not supported by OpenMP
    llvm::Value* points_to = points_to_var(elem_ptr_instr);
    llvm::AllocaInst* a_instr = llvm::dyn_cast<llvm::AllocaInst>(points_to);
    llvm::Type* type =
        (a_instr) ? a_instr->getAllocatedType() : points_to->getType();
    if (type->isStructTy()) {
      return nullptr;
    }

    return get_var_rec(elem_ptr_instr->getPointerOperand());
  }
  if (llvm::isa<llvm::LoadInst>(val)) {
    llvm::LoadInst* load_instr = llvm::cast<llvm::LoadInst>(val);
    return get_var_rec(load_instr->getOperand(0));
  }

  return nullptr;
}

llvm::Value* get_var(llvm::Instruction* instr) {
  unsigned index = (llvm::isa<llvm::LoadInst>(instr)) ? 0 : 1;
  return get_var_rec(instr->getOperand(index));
}

llvm::Value* points_to_var(llvm::GetElementPtrInst* instr) {
  llvm::Value* points_to = nullptr;
  while (instr) {
    points_to = instr->getPointerOperand();
    instr = llvm::dyn_cast<llvm::GetElementPtrInst>(points_to);
  }
  return points_to;
}

}  // namespace util
