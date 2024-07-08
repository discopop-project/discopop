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

/* metadata format in LLVM IR:
!5 = metadata !{
  i32,      ;; Tag (see below)  // DW_TAG_pointer_type:     0
  metadata, ;; Reference to context  // 1
  metadata, ;; Name (may be "" for anonymous types) // 2
  metadata, ;; Reference to file where defined (may be NULL) // 3
  i32,      ;; Line number where defined (may be 0) // 4
  i64,      ;; Size in bits // 5
  i64,      ;; Alignment in bits // 6
  i64,      ;; Offset in bits // 7
  i32,      ;; Flags to encode attributes, e.g. private // 8
  metadata, ;; Reference to type derived from     // 9   --> get operand at
index 9 metadata, ;; (optional) Name of the Objective C property associated with
            ;; Objective-C an ivar, or the type of which this
            ;; pointer-to-member is pointing to members of.
  metadata, ;; (optional) Name of the Objective C property getter selector.
  metadata, ;; (optional) Name of the Objective C property setter selector.
  i32       ;; (optional) Objective C property attributes.
}

A real case would be:
!2 = metadata !{
  i32 524307,        ;; Tag   // 0
  metadata !1,       ;; Context // 1
  metadata !"Color", ;; Name // 2
  metadata !1,       ;; Compile unit // 3
  i32 1,             ;; Line number // 4
  i64 96,            ;; Size in bits // 5
  i64 32,            ;; Align in bits // 6
  i64 0,             ;; Offset in bits // 7
  i32 0,             ;; Flags // 8
  null,              ;; Derived From // 9
  metadata !3,       ;; Elements // 10 --> list of elements
  i32 0              ;; Runtime Language
}
*/
// TODO: atomic variables
void DiscoPoP::runOnBasicBlock(BasicBlock &BB) {
  for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
    if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI)) {
      assert(DI->getOperand(0));
      if (AllocaInst *alloc = dyn_cast<AllocaInst>(DI->getOperand(0))) {
        Type *type = alloc->getAllocatedType();
        Type *structType = type;
        unsigned depth = 0;
        if (type->getTypeID() == Type::PointerTyID) {
          while (structType->getTypeID() == Type::PointerTyID) {
            structType = cast<PointerType>(structType)->getElementType();
            ++depth;
          }
        }
        if (structType->getTypeID() == Type::StructTyID) {
          assert(DI->getOperand(1));
          MDNode *varDesNode = DI->getVariable();
          assert(varDesNode->getOperand(5));
          MDNode *typeDesNode = cast<MDNode>(varDesNode->getOperand(5));
          MDNode *structNode = typeDesNode;
          if (type->getTypeID() == Type::PointerTyID) {
            MDNode *ptr = typeDesNode;
            for (unsigned i = 0; i < depth; ++i) {
              assert(ptr->getOperand(9));
              ptr = cast<MDNode>(ptr->getOperand(9));
            }
            structNode = ptr;
          }
          DINode *strDes = cast<DINode>(structNode);
          // DIDescriptor strDes(structNode);
          // handle the case when we have pointer to struct (or pointer to
          // pointer to struct ...)
          if (strDes->getTag() == dwarf::DW_TAG_pointer_type) {
            DINode *ptrDes = strDes;
            do {
              if (structNode->getNumOperands() < 10)
                break;
              assert(structNode->getOperand(9));
              structNode = cast<MDNode>(structNode->getOperand(9));
              ptrDes = cast<DINode>(structNode);
            } while (ptrDes->getTag() != dwarf::DW_TAG_structure_type);
          }

          if (strDes->getTag() == dwarf::DW_TAG_typedef) {
            assert(strDes->getOperand(9));
            structNode = cast<MDNode>(strDes->getOperand(9));
          }
          strDes = cast<DINode>(structNode);
          if (strDes->getTag() == dwarf::DW_TAG_structure_type) {
            string strName(structType->getStructName().data());
            if (Structs.find(strName) == Structs.end()) {
              processStructTypes(strName, structNode);
            }
          }
        }
      }
    }
    // alloca instruction
    else if (isa<AllocaInst>(BI)) {
      AllocaInst *AI = cast<AllocaInst>(BI);

      // if the option is set, check if the AllocaInst is static at the entry
      // block of a function and skip it's instrumentation. This leads to a
      // strong improvement of the profiling time if a lot of function calls are
      // used, but results in a worse accurracy. As the default, the accurate
      // profiling is used. Effectively, this check disables the instrumentation
      // of allocas which belong to function parameters.

      if (DP_MEMORY_PROFILING_SKIP_FUNCTION_ARGUMENTS) {
        if (!AI->isStaticAlloca()) {
          // only instrument non-static alloca instructions
          instrumentAlloca(AI);
        }
      } else {
        // instrument every alloca instruction
        instrumentAlloca(AI);
      }

    }
    // load instruction
    else if (isa<LoadInst>(BI)) {
      instrumentLoad(cast<LoadInst>(BI));
    }
    // // store instruction
    else if (isa<StoreInst>(BI)) {
      instrumentStore(cast<StoreInst>(BI));
    }
    // call and invoke
    else if (isaCallOrInvoke(&*BI)) {
      Function *F;
      if (isa<CallInst>(BI))
        F = (cast<CallInst>(BI))->getCalledFunction();
      else if (isa<InvokeInst>(BI))
        F = (cast<InvokeInst>(BI))->getCalledFunction();

      // For ordinary function calls, F has a name.
      // However, sometimes the function being called
      // in IR is encapsulated by "bitcast()" due to
      // the way of compiling and linking. In this way,
      // getCalledFunction() method returns NULL.
      StringRef fn = "";
      if (F) {
        fn = F->getName();
        if (fn.find("__dp_") != string::npos) // avoid instrumentation calls
        {
          continue;
        }
        if (fn.find("__clang_") != string::npos) // clang helper calls
        {
          continue;
        }
        if (fn.equals("pthread_exit")) {
          // pthread_exit does not return to its caller.
          // Therefore, we insert DpFuncExit before pthread_exit
          IRBuilder<> IRBRet(&*BI);
          ArrayRef<Value *> arguments({ConstantInt::get(Int32, getLID(&*BI, fileID)), ConstantInt::get(Int32, 0)});
          IRBRet.CreateCall(DpFuncExit, arguments);
          continue;
        }
        if (fn.equals("exit") || F->doesNotReturn()) // using exit() to terminate program
        {
          // only insert DpFinalize right before the main program exits
          insertDpFinalize(&*BI);
          continue;
        }
        if (fn.equals("_Znam") || fn.equals("_Znwm") || fn.equals("malloc")) {
          if (isa<CallInst>(BI)) {
            instrumentNewOrMalloc(cast<CallInst>(BI));
          } else if (isa<InvokeInst>(BI)) {
            instrumentNewOrMalloc(cast<InvokeInst>(BI));
          }
          continue;
        }
        if (fn.equals("realloc")) {
          if (isa<CallInst>(BI)) {
            instrumentRealloc(cast<CallInst>(BI));
          } else if (isa<InvokeInst>(BI)) {
            instrumentRealloc(cast<InvokeInst>(BI));
          }
          continue;
        }
        if (fn.equals("calloc")) {
          if (isa<CallInst>(BI)) {
            instrumentCalloc(cast<CallInst>(BI));
          } else if (isa<InvokeInst>(BI)) {
            instrumentCalloc(cast<InvokeInst>(BI));
          }
        }

        if (fn.equals("posix_memalign")) {
          if (isa<CallInst>(BI)) {
            instrumentPosixMemalign(cast<CallInst>(BI));
          } else if (isa<InvokeInst>(BI)) {
            instrumentPosixMemalign(cast<InvokeInst>(BI));
          }
          continue;
        }
        if (fn.equals("_ZdlPv") || fn.equals("free")) {
          instrumentDeleteOrFree(cast<CallBase>(BI));
          continue;
        }
      }
      LID lid = getLID(&*BI, fileID);
      if (lid > 0) // calls on non-user code are not instrumented
      {
        IRBuilder<> IRBCall(&*BI);
        IRBCall.CreateCall(DpCallOrInvoke, ConstantInt::get(Int32, lid));
        if (DP_DEBUG) {
          if (isa<CallInst>(BI)) {
            if (!fn.equals(""))
              errs() << "calling " << fn << " on " << lid << "\n";
            else
              errs() << "calling unknown function on " << lid << "\n";
          } else {
            if (!fn.equals(""))
              errs() << "invoking " << fn << " on " << lid << "\n";
            else
              errs() << "invoking unknown function on " << lid << "\n";
          }
        }
      }
    }
    // return
    else if (isa<ReturnInst>(BI)) {
      LID lid = getLID(&*BI, fileID);
      assert((lid > 0) && "Returning on LID = 0!");

      Function *parent = BB.getParent();
      assert(parent != NULL);
      StringRef fn = parent->getName();

      if (fn.equals("main")) // returning from main
      {
        insertDpFinalize(&*BI);
      } else {
        IRBuilder<> IRBRet(&*BI);
        ArrayRef<Value *> arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, 0)});
        IRBRet.CreateCall(DpFuncExit, arguments);
      }

      if (DP_DEBUG) {
        errs() << fn << " returning on " << lid << "\n";
      }
    }
  }
}