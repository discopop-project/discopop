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

//#define SKIP_DUP_INSTR 1

#include "DiscoPoP.hpp"

// after the includes: LLVM headers define their own DEBUG_TYPE
#undef DEBUG_TYPE
#define DEBUG_TYPE "dpop"
//#define DEBUG_TYPE "dp-omissions"

using llvm::DINamespace;
using llvm::DINode;
using llvm::DIType;
using llvm::IntegerType;
using llvm::MDNode;
using llvm::MDString;
using llvm::PointerType;
using llvm::Type;
using llvm::cast;
using llvm::dyn_cast;
using llvm::errs;

// Initializations
void DiscoPoP::setupDataTypes() {
  Void = const_cast<Type *>(Type::getVoidTy(*ThisModuleContext));
  Int32 = const_cast<IntegerType *>(IntegerType::getInt32Ty(*ThisModuleContext));
  Int64 = const_cast<IntegerType *>(IntegerType::getInt64Ty(*ThisModuleContext));
  CharPtr = PointerType::getUnqual(Type::getInt8Ty(*ThisModuleContext));
}

void DiscoPoP::setupCallbacks() {
  /* function name
   * return value type
   * arg types
   *
   * the callbacks are extern "C" functions of the runtime library, whose signatures are in
   * rtlib/injected_functions/<callback>.hpp: a location (LID) or address is a 64 bit integer there, so it is
   * declared as Int64 here. A narrower declaration would leave the upper half of the argument
   * register unspecified. test/instrumentation/test_callback_signatures.py compares both.
   */

  DpFinalize = ThisModule->getOrInsertFunction("__dp_finalize", Void, Int64);

  DpRead = ThisModule->getOrInsertFunction("__dp_read", Void,
#ifdef SKIP_DUP_INSTR
                                           Int64, Int64, CharPtr, Int64, Int64
#else
                                           Int64, Int64, CharPtr
#endif
  );

  DpWrite = ThisModule->getOrInsertFunction("__dp_write", Void,
#ifdef SKIP_DUP_INSTR
                                            Int64, Int64, CharPtr, Int64, Int64
#else
                                            Int64, Int64, CharPtr
#endif
  );

  DpAlloca = ThisModule->getOrInsertFunction("__dp_alloca", Void,

                                             Int64, CharPtr, Int64, Int64, Int64, Int64);

  DpNew = ThisModule->getOrInsertFunction("__dp_new", Void, Int64, Int64, Int64, Int64);

  DpDelete = ThisModule->getOrInsertFunction("__dp_delete", Void, Int64, Int64);

  DpCallOrInvoke = ThisModule->getOrInsertFunction("__dp_call", Void, Int64, Int32);

  DpFuncEntry = ThisModule->getOrInsertFunction("__dp_func_entry", Void, Int64, Int32, Int32);

  DpFuncExit = ThisModule->getOrInsertFunction("__dp_func_exit", Void, Int64, Int32);

  DpLoopEntry = ThisModule->getOrInsertFunction("__dp_loop_entry", Void, Int64, Int32, Int32);

  DpLoopExit = ThisModule->getOrInsertFunction("__dp_loop_exit", Void, Int64, Int32, Int32);

  DpTakenBranchCounterIncr =
      ThisModule->getOrInsertFunction("__dp_incr_taken_branch_counter", Void, CharPtr, Int32, Int32);
}

// DPReduction end

#if false  // NOTE (25-10-30) DISABLED FOR LLVM 19 COMPATIBILITY REASONS
void DiscoPoP::processStructTypes(std::string const &fullStructName, MDNode *structNode) {
  assert(structNode && "structNode cannot be NULL");
  DIType *strDes = cast<DIType>(structNode);
  assert(strDes->getTag() == dwarf::DW_TAG_structure_type);
  // sometimes it's impossible to get the list of struct members (e.g badref)
  if (structNode->getNumOperands() <= 10 || structNode->getOperand(10) == NULL) {
    errs() << "cannot process member list of this struct: \n";
    structNode->dump();
    return;
  }
  Structs[fullStructName] = structNode;

  MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
  for (unsigned i = 0; i < memberListNodes->getNumOperands(); ++i) {
    assert(memberListNodes->getOperand(i));
    MDNode *member = cast<MDNode>(memberListNodes->getOperand(i));
    DINode *memberDes = cast<DINode>(member);
    // DIDescriptor memberDes(member);
    if (memberDes->getTag() == dwarf::DW_TAG_member) {
      assert(member->getOperand(9));
      MDNode *memberType = cast<MDNode>(member->getOperand(9));
      DIType *memberTypeDes = cast<DIType>(memberType);
      // DIType memberTypeDes(memberType);
      if (memberTypeDes->getTag() == dwarf::DW_TAG_structure_type) {
        std::string fullName = "";
        // try to get namespace
        if (memberType->getNumOperands() > 2 && structNode->getOperand(2) != NULL) {
          MDNode *namespaceNode = cast<MDNode>(structNode->getOperand(2));
          DINamespace *dins = cast<DINamespace>(namespaceNode);
          // DINameSpace dins(namespaceNode);
          fullName = "struct." + std::string(dins->getName().data()) + "::";
        }
        // fullName += string(memberType->getOperand(3)->getName().data());
        fullName += (dyn_cast<MDString>(memberType->getOperand(3)))->getString();

        if (Structs.find(fullName) == Structs.end())
          processStructTypes(fullName, memberType);
      }
    }
  }
}
#endif
