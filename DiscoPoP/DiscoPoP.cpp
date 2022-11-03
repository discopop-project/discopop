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

#define DEBUG_TYPE "dpop"
//#define SKIP_DUP_INSTR 1
// #define DEBUG_TYPE "dp-omissions"

// STATISTIC(totalInstrumentations, "Total DP-Instrumentations");
// STATISTIC(removedInstrumentations, "Disregarded DP-Instructions");

#include "DiscoPoP.h"

#define DP_DEBUG false
#define DP_hybrid_DEBUG false
#define DP_hybrid_SKIP false  //todo add parameter to disable hybrid dependence analysis on demand.

using namespace llvm;
using namespace std;
using namespace dputil;

// Command line options
// static cl::opt<bool> ClCheckLoopPar("dp-loop-par", cl::init(true),
//                                     cl::desc("Check loop parallelism"), cl::Hidden);
// char DiscoPoP::ID = 0;

// static RegisterPass<DiscoPoP> X("DiscoPoP", "DiscoPoP: finding potential parallelism.", false, false);

// static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM)
// {
//     PM.add(new LoopInfoWrapperPass());
//     PM.add(new DiscoPoP());
// }

// static RegisterStandardPasses DiscoPoPLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
// static RegisterStandardPasses DiscoPoPLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

// FunctionPass *createDiscoPoPPass()
// {
//     if (DP_DEBUG)
//     {
//         errs() << "create DiscoPoP \n";
//     }
//     initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
//     return new DiscoPoP();
// }

StringRef DiscoPoP::getPassName() const
{
    return "DiscoPoP";
}

// Initializations
void DiscoPoP::setupDataTypes()
{
    Void = const_cast<Type *>(Type::getVoidTy(*ThisModuleContext));
    Int32 = const_cast<IntegerType *>(IntegerType::getInt32Ty(*ThisModuleContext));
    Int64 = const_cast<IntegerType *>(IntegerType::getInt64Ty(*ThisModuleContext));
    CharPtr = const_cast<PointerType *>(Type::getInt8PtrTy(*ThisModuleContext));
}

void DiscoPoP::setupCallbacks()
{
    /* function name
     * return value type
     * arg types
     * NULL
     */
    DpInit = ThisModule->getOrInsertFunction("__dp_init",
                            Void,
                            Int32, Int32, Int32);

    DpFinalize = ThisModule->getOrInsertFunction("__dp_finalize",
                                Void,
                                Int32);

    DpRead = ThisModule->getOrInsertFunction("__dp_read",
                            Void,
#ifdef SKIP_DUP_INSTR
                            Int32, Int64, CharPtr, Int64, Int64
#else
                            Int32, Int64, CharPtr
#endif
                            );

    DpWrite = ThisModule->getOrInsertFunction("__dp_write",
                             Void,
#ifdef SKIP_DUP_INSTR
                             Int32, Int64, CharPtr, Int64, Int64
#else
                             Int32, Int64, CharPtr
#endif
                             );

    DpCallOrInvoke = ThisModule->getOrInsertFunction("__dp_call",
                                    Void,
                                    Int32);

    DpFuncEntry = ThisModule->getOrInsertFunction("__dp_func_entry",
                                 Void,
                                 Int32, Int32);

    DpFuncExit = ThisModule->getOrInsertFunction("__dp_func_exit",
                                Void,
                                Int32, Int32);

    DpLoopEntry = ThisModule->getOrInsertFunction("__dp_loop_entry",
                                 Void,
                                 Int32, Int32);

    DpLoopExit = ThisModule->getOrInsertFunction("__dp_loop_exit",
                                Void,
                                Int32, Int32);
}

bool DiscoPoP::doInitialization(Module &M)
{
    if (DP_DEBUG)
    {
        errs() << "DiscoPoP | 190: init pass DiscoPoP \n";
    }

// CUGeneration
{
CUIDCounter = 0;
  defaultIsGlobalVariableValue = false;
  ThisModule = &M;
  outCUIDCounter = NULL;

  initializeCUIDCounter();

  for (Module::global_iterator I = ThisModule->global_begin();
       I != ThisModule->global_end(); I++) {
    Value *globalVariable = dyn_cast<Value>(I);
    string glo = string(globalVariable->getName());
    if (glo.find(".") == glo.npos) {
      programGlobalVariablesSet.insert(glo);
      // originalVariablesSet.insert(glo);
    }
  }
}
// CUGeneration end

// DPInstrumentation
{
    // Export M to the outside
    ThisModule = &M;
    ThisModuleContext = &(M.getContext());

    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it)
    {
        GlobalVars.erase(it);
        // delete (*it);
    }
    
    GlobalVars.clear();
    Structs.clear();
    collectDebugInfo();

    // Initialize variables needed
    setupDataTypes();
    setupCallbacks();

    // Check loop parallelism?
    if (ClCheckLoopPar)
    {
        if (DP_DEBUG)
        {
            errs() << "check loop parallelism \n";
        }
        loopID = 0;
        //ocfg.open("CFG.txt", std::ios::out);
    }
    else
    {
        loopID = -1;
    }
}
  // DPInstrumentation end

  // DPInstrumentationOmission
{
  int bbDepCount = 0;

  ReportBB = M.getOrInsertFunction(
      "__dp_report_bb", 
      Void,
      Int32
  );
  ReportBBPair = M.getOrInsertFunction(
      "__dp_report_bb_pair", 
      Void,
      Int32, 
      Int32
  );
  VNF = new dputil::VariableNameFinder(M);
}
  // DPInstrumentationOmission end
    return true;
}

bool DiscoPoP::doFinalization(Module &M) {
  
  //CUGeneration

  // write the current count of CUs to a file to avoid duplicate CUs.
  if (outCUIDCounter && outCUIDCounter->is_open()) {
    *outCUIDCounter << CUIDCounter;
    outCUIDCounter->flush();
    outCUIDCounter->close();
  }
  // CUGeneration end

  // DPInstrumentationOmission
  for(Function &F: M){
  if(!F.hasName() || F.getName() != "main") continue;
    for(BasicBlock &BB : F){
      for(Instruction &I: BB){
        if(CallInst* call_inst = dyn_cast<CallInst>(&I)){
          if(Function *Fun = call_inst->getCalledFunction()){
            if(Fun->getName() == "__dp_finalize"){
              IRBuilder<> builder(call_inst);
              Value *V = builder.CreateGlobalStringPtr(StringRef(bbDepString), ".dp_bb_deps");
              CallInst::Create(
                F.getParent()->getOrInsertFunction("__dp_add_bb_deps", Void, CharPtr),
                V, "", call_inst
              );
            }
          }
        }
      }
    }
}
  // DPInstrumentationOmission end

  return true;
}

DiscoPoP::~DiscoPoP()
{
    if (ocfg.is_open())
    {
        ocfg.flush();
        ocfg.close();
    }
}

void DiscoPoP::getAnalysisUsage(AnalysisUsage &AU) const
{
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequiredTransitive<RegionInfoPass>();
  // NOTE: changed 'LoopInfo' to 'LoopInfoWrapperPass'
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addPreserved<LoopInfoWrapperPass>();
  // Get recursive functions called in loops. (Mo 5.11.2019)
  AU.addRequired<CallGraphWrapperPass>();
  AU.setPreservesAll();
}

// CUGeneration

void DiscoPoP::getFunctionReturnLines(Region *TopRegion, Node *root) {
  int lid = 0;
  for (Region::block_iterator bb = TopRegion->block_begin();
       bb != TopRegion->block_end(); ++bb) {
    for (BasicBlock::iterator instruction = (*bb)->begin();
         instruction != (*bb)->end(); ++instruction) {
      if (isa<StoreInst>(instruction)) {
        string varName = determineVariableName(&*instruction)->getName().str();
        size_t pos = varName.find("retval");
        if (pos != varName.npos) {
          lid = getLID(&*instruction, fileID);
          // errs() << "varName: " << varName << " " << dputil::decodeLID(lid)
          // << "\n";
          if (lid > 0)
            root->returnLines.insert(lid);
        }
      }
    }
  }
}

string DiscoPoP::determineVariableDefLine(Instruction *I) {
  string varDefLine{"LineNotFound"};

  string varName = determineVariableName(&*I)->getName().str();
  // varName = refineVarName(varName);
  varName = (varName.find(".addr") == varName.npos)
                ? varName
                : varName.erase(varName.find(".addr"), 5);
  // varName.erase(varName.find(".addr"), 5);
  // size_t pos = varName.find(".addr");
  // if (pos != varName.npos)
  //     varName.erase(varName.find(".addr"), 5);

  string varType = determineVariableType(&*I);

  if (programGlobalVariablesSet.count(varName)) {
    varDefLine = "GlobalVar";
    // TODO: Find definition line of global variables
  }

  // Start from the beginning of a function and look for the variable
  Function *F = I->getFunction();
  for (Function::iterator FI = F->begin(), FE = F->end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
      if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI)) {

        if (auto *N = dyn_cast<MDNode>(DI->getVariable())) {
          if (auto *DV = dyn_cast<DILocalVariable>(N)) {
            if (varType.find("ARRAY") != string::npos ||
                varType.find("STRUCT") != string::npos) {
              if (DV->getName() == varName) {
                varDefLine = to_string(fileID) + ":" + to_string(DV->getLine());
                break;
              }
            } else {
              string vn = "----";
              AllocaInst *AI = dyn_cast_or_null<AllocaInst>(DI->getAddress());
              if (AI) {
                for (User *U : AI->users()) {
                  if (StoreInst *SI = dyn_cast<StoreInst>(U)) {
                    vn = determineVariableName(&*SI)->getName().str();
                    break;
                  } else if (LoadInst *LI = dyn_cast<LoadInst>(U)) {
                    vn = determineVariableName(&*LI)->getName().str();
                    break;
                  }
                }
                if (vn == varName) {
                  varDefLine =
                      to_string(fileID) + ":" + to_string(DV->getLine());
                  break;
                }
              }
            }
          }
        }
      }
    }
  }
  return varDefLine;
}


string DiscoPoP::determineVariableType(Instruction *I) {
  string s = "";
  string type_str;
  int index = isa<StoreInst>(I) ? 1 : 0;
  raw_string_ostream rso(type_str);
  (*((I->getOperand(index))->getType())).print(rso);

  Value *operand = I->getOperand(index);

  if (operand->hasName()) {
    if (isa<GetElementPtrInst>(*operand)) {
      GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
      Value *ptrOperand = gep->getPointerOperand();
      PointerType *PTy = cast<PointerType>(ptrOperand->getType());
      // we've found a struct/class
      Type *structType = pointsToStruct(PTy);
      if (structType && gep->getNumOperands() > 2) {
        s = "STRUCT,";
      }
      // we've found an array
      if (PTy->getElementType()->getTypeID() == Type::ArrayTyID) {
        s = "ARRAY,";
      }
    }
  }

  s = s + rso.str();
  return s;
}

// recieves the region and outputs all variables and variables crossing basic
// block boundaries in the region.
void DiscoPoP::populateGlobalVariablesSet(Region *TopRegion,
                                              set<string> &globalVariablesSet) {

  map<string, BasicBlock *> variableToBBMap;
  bool isGlobalVariable;
  for (Region::block_iterator bb = TopRegion->block_begin();
       bb != TopRegion->block_end(); ++bb) {
    for (BasicBlock::iterator instruction = (*bb)->begin();
         instruction != (*bb)->end(); ++instruction) {
      if (isa<LoadInst>(instruction) || isa<StoreInst>(instruction) ||
          isa<CallInst>(instruction)) {

        // string varName = refineVarName(determineVariableName(instruction,
        // isGlobalVariable));
        // NOTE: changed 'instruction' to '&*instruction'
        string varName = determineVariableName(&*instruction, isGlobalVariable)->getName().str();

        if (isGlobalVariable) // add it if it is a global variable in the
                              // program
        {
          programGlobalVariablesSet.insert(varName);
        }

        if (variableToBBMap.find(varName) != variableToBBMap.end()) {
          // this var has already once recordded. check for bb id
          if (variableToBBMap[varName] != *bb) {
            // global variable found. Insert into the globalVariablesSet
            globalVariablesSet.insert(varName);
          }
        } else {
          // record usage of the variable.
          variableToBBMap.insert(pair<string, BasicBlock *>(varName, *bb));
          // errs() << varName << "\n";
        }
      }
    }
  }
}

void DiscoPoP::createCUs(Region *TopRegion, set<string> &globalVariablesSet,
                             vector<CU *> &CUVector,
                             map<string, vector<CU *>> &BBIDToCUIDsMap,
                             Node *root, LoopInfo &LI) {
  // NOTE: changed 'ThisModule->getDataLayout()' to
  // '&ThisModule->getDataLayout()'
  const DataLayout *DL =
      &ThisModule->getDataLayout(); // used to get data size of variables,
                                    // pointers, structs etc.
  Node *currentNode = root;
  CU *cu;
  int lid;
  string varName;
  string varType;
  set<string> suspiciousVariables;
  string basicBlockName;

  map<Loop *, Node *> loopToNodeMap;

  for (Region::block_iterator bb = TopRegion->block_begin();
       bb != TopRegion->block_end(); ++bb) {

    // Get the closest loop where bb lives in.
    // (loop == NULL) if bb is not in any loop.
    Loop *loop = LI.getLoopFor(*bb);
    if (loop) {
      // if bb is in a loop and if we have already created a node for that loop,
      // assign it to currentNode.
      if (loopToNodeMap.find(loop) != loopToNodeMap.end()) {
        currentNode = loopToNodeMap[loop];
        // errs() << "))))) " << dputil::decodeLID(currentNode->startLine) << "
        // " << dputil::decodeLID(currentNode->endLine) << "\n";
      }
      // else, create a new Node for the loop, add it as children of currentNode
      // and add it to the map.
      else {
        if (bb->getName().size() != 0) {
          // errs() << "Name: " << bb->getName() << "\n";
        }

        Node *n = new Node;
        n->type = nodeTypes::loop;
        n->parentNode = currentNode;
        currentNode->childrenNodes.push_back(n);

        loopToNodeMap[loop] = n;
        currentNode = n;
        // errs() << "--bb->Name: " << bb->getName() << " , " << "node->ID: " <<
        // currentNode->ID << "\n";
      }
    } else {
      if (bb->getName().size() != 0) {
        // errs() << "bb Name: " << bb->getName() << "\n";
      }
      // end of loops. go to the parent of the loop. may have to jump several
      // nodes in case of nested loops
      for (map<Loop *, Node *>::iterator it = loopToNodeMap.begin();
           it != loopToNodeMap.end(); it++)
        if (it->second ==
            currentNode) // current node found in loop map jump to its parent.
        {
          currentNode = currentNode->parentNode;
          it = loopToNodeMap
                   .begin(); // search the whole map again for current node
          if (it->second == currentNode) // due to it++ we need to check first
                                         // element of map ourself
            currentNode = currentNode->parentNode;
        }
    }

    cu = new CU;

    // errs() << "==== " << bb->getName() << "\n"; //"cu->ID: " << cu->ID << " ,
    // " << "node->ID: " << currentNode->ID << " , " << "tmpNode->ID: " <<
    // tmpNode->ID << " , " << "bb->Name: " << bb->getName() << "\n";

    if (bb->getName().size() == 0)
      bb->setName(cu->ID);

    cu->BBID = bb->getName().str();
    cu->BB = *bb; // Mohammad 23.12.2020
    currentNode->childrenNodes.push_back(cu);
    vector<CU *> basicBlockCUVector;
    basicBlockCUVector.push_back(cu);
    BBIDToCUIDsMap.insert(
        pair<string, vector<CU *>>(bb->getName(), basicBlockCUVector));

    for (BasicBlock::iterator instruction = (*bb)->begin();
         instruction != (*bb)->end(); ++instruction) {
      // NOTE: 'instruction' --> '&*instruction'
      lid = getLID(&*instruction, fileID);
      basicBlockName = bb->getName().str();
      if (lid > 0) {
        cu->instructionsLineNumbers.insert(lid);
        cu->instructionsCount++;
        // find return instructions
        if (isa<ReturnInst>(instruction)) {
          cu->returnInstructions.insert(lid);
        }
        // find branches to return instructions, i.e. return statements
        // Lukas 21.09.20
        else if (isa<BranchInst>(instruction)) {
          if ((cast<BranchInst>(instruction))->isUnconditional()) {
            if ((cast<BranchInst>(instruction))->getNumSuccessors() == 1) {
              BasicBlock *successorBB =
                  (cast<BranchInst>(instruction))->getSuccessor(0);
              for (BasicBlock::iterator innerInstruction = successorBB->begin();
                   innerInstruction != successorBB->end(); ++innerInstruction) {
                if (isa<ReturnInst>(innerInstruction)) {
                  cu->returnInstructions.insert(lid);
                  break;
                }
              }
            }
          }
        }
        //}
        if (isa<StoreInst>(instruction)) {

          // get size of data written into memory by this store instruction
          Value *operand = instruction->getOperand(1);
          Type *Ty = operand->getType();
          unsigned u = DL->getTypeSizeInBits(Ty);
          cu->writeDataSize += u;
          // varName = refineVarName(determineVariableName(instruction));
          varName = determineVariableName(&*instruction)->getName().str();
          varType = determineVariableType(&*instruction);
          // if(globalVariablesSet.count(varName) ||
          // programGlobalVariablesSet.count(varName))
          {
            suspiciousVariables.insert(varName);
            if (lid > 0)
              cu->writePhaseLineNumbers.insert(lid);
          }
        } else if (isa<LoadInst>(instruction)) {

          // get size of data read from memory by this load instruction
          Type *Ty = instruction->getType();
          unsigned u = DL->getTypeSizeInBits(Ty);
          cu->readDataSize += u;
          // varName = refineVarName(determineVariableName(instruction));
          varName = determineVariableName(&*instruction)->getName().str();
          if (suspiciousVariables.count(varName)) {
            // VIOLATION OF CAUTIOUS PROPERTY
            // it is a load instruction which read the value of a global
            // variable.
            // This global variable has already been stored previously.
            // A new CU should be created here.
            cu->readPhaseLineNumbers.erase(lid);
            cu->writePhaseLineNumbers.erase(lid);
            cu->instructionsLineNumbers.erase(lid);
            cu->instructionsCount--;
            if (cu->instructionsLineNumbers.empty()) {
              cu->removeCU();
              cu->startLine = -1;
              cu->endLine = -1;
            } else {
              cu->startLine = *(cu->instructionsLineNumbers.begin());
              cu->endLine = *(cu->instructionsLineNumbers.rbegin());
            }
            cu->basicBlockName = basicBlockName;
            CUVector.push_back(cu);
            suspiciousVariables.clear();
            CU *temp =
                cu; // keep current CU to make a reference to the successor CU
            cu = new CU;

            cu->BBID = bb->getName().str();
            cu->BB = *bb; // Mohammad 23.12.2020
            // errs() << "bb->Name: "  << bb->getName() << " , " << "cu->ID: "
            // << cu->ID  << " , " << "node->ID: " << currentNode->ID << "\n";

            currentNode->childrenNodes.push_back(cu);
            temp->successorCUs.push_back(cu->ID);
            BBIDToCUIDsMap[bb->getName().str()].push_back(cu);
            if (lid > 0) {
              cu->readPhaseLineNumbers.insert(lid);
              cu->instructionsLineNumbers.insert(lid);
            }
          } else {
            if (globalVariablesSet.count(varName) ||
                programGlobalVariablesSet.count(varName)) {
              if (lid > 0)
                cu->readPhaseLineNumbers.insert(lid);
            }
          }
        }
      }
    }
    if (cu->instructionsLineNumbers.empty()) {
      cu->removeCU();
      cu->startLine = -1;
      cu->endLine = -1;
    } else {
      cu->startLine = *(cu->instructionsLineNumbers.begin());
      cu->endLine = *(cu->instructionsLineNumbers.rbegin());
    }

    cu->basicBlockName = basicBlockName;
    CUVector.push_back(cu);
    suspiciousVariables.clear();

    // check for call instructions in current basic block
    for (BasicBlock::iterator instruction = (*bb)->begin();
         instruction != (*bb)->end(); ++instruction) {
      // Mohammad 6.7.2020: Don't create nodes for library functions (c++/llvm).
      int32_t lid = getLID(&*instruction, fileID);
      if (lid > 0) {

        if (isa<CallInst>(instruction)) {

          Function *f = (cast<CallInst>(instruction))->getCalledFunction();
          // TODO: DO the same for Invoke inst

          // Mohammad 6.7.2020
          Function::iterator FI = f->begin();
          bool externalFunction = true;
          string lid;

          for (Function::iterator FI = f->begin(), FE = f->end(); FI != FE;
               ++FI) {
            externalFunction = false;
            auto tempBI = FI->begin();
            if (DebugLoc dl = tempBI->getDebugLoc()) {
              lid = to_string(dl->getLine());
            } else {
              if (tempBI->getFunction()->getSubprogram())
                lid = to_string(
                    tempBI->getFunction()->getSubprogram()->getLine());
              else {
                lid = "LineNotFound";
              }
            }
            break;
          }
          if (externalFunction)
            continue;

          Node *n = new Node;
          n->type = nodeTypes::dummy;
          // For ordinary function calls, F has a name.
          // However, sometimes the function being called
          // in IR is encapsulated by "bitcast()" due to
          // the way of compiling and linking. In this way,
          // getCalledFunction() method returns NULL.
          // Also, getName() returns NULL if this is an indirect function call.
          if (f) {
            n->name = f->getName().str();

            // @Zia: This for loop appeared after the else part. For some
            // function calls, the value of f is null. I guess that is why you
            // have checked if f is not null here. Anyway, I (Mohammad) had to
            // bring the for loop inside to avoid the segmentation fault. If you
            // think it is not appropriate, find a solution for it. 14.2.2016
            for (Function::arg_iterator it = f->arg_begin(); it != f->arg_end();
                 it++) {
              string type_str;
              raw_string_ostream rso(type_str);
              (it->getType())->print(rso);
              Variable v(string(it->getName()), rso.str(), lid);
              n->argumentsList.push_back(v);
            }
          } else // get name of the indirect function which is called
          {
            Value *v = (cast<CallInst>(instruction))->getCalledOperand();
            Value *sv = v->stripPointerCasts();
            n->name = sv->getName().str();
          }

          // Recursive functions (Mo 5.11.2019)
          CallGraphWrapperPass *CGWP = &(getAnalysis<CallGraphWrapperPass>());
          if (isRecursive(*f, CGWP->getCallGraph())) {
            int lid = getLID(&*instruction, fileID);
            n->recursiveFunctionCall =
                n->name + " " + dputil::decodeLID(lid) + ",";
          }

          vector<CU *> BBCUsVector = BBIDToCUIDsMap[bb->getName().str()];
          // locate the CU where this function call belongs
          for (auto i : BBCUsVector) {
            int lid = getLID(&*instruction, fileID);
            if (lid >= i->startLine && lid <= i->endLine) {
              i->instructionsLineNumbers.insert(lid);
              i->childrenNodes.push_back(n);

              i->callLineTofunctionMap[lid].push_back(n);
              break;
            }
          }
        }
      }
    }
  }
}

void DiscoPoP::fillCUVariables(Region *TopRegion,
                                   set<string> &globalVariablesSet,
                                   vector<CU *> &CUVector,
                                   map<string, vector<CU *>> &BBIDToCUIDsMap) {
  int lid;
  string varName, varType, varDefLine;
  // Changed TerminatorInst to Instuction
  const Instruction *TInst;
  string successorBB;

  for (Region::block_iterator bb = TopRegion->block_begin();
       bb != TopRegion->block_end(); ++bb) {
    CU *lastCU = BBIDToCUIDsMap[bb->getName().str()]
                     .back(); // get the last CU in the basic block
    // get all successor basic blocks for bb
    TInst = bb->getTerminator();
    for (unsigned i = 0, nSucc = TInst->getNumSuccessors(); i < nSucc; ++i) {
      // get the name of successor basicBlock
      successorBB = TInst->getSuccessor(i)->getName().str();
      // get the first CU of the successor basicBlock and record its ID in
      // current CU's successorCUs
      lastCU->successorCUs.push_back(BBIDToCUIDsMap[successorBB].front()->ID);
    }

    auto bbCU = BBIDToCUIDsMap[bb->getName().str()].begin();
    for (BasicBlock::iterator instruction = (*bb)->begin();
         instruction != (*bb)->end(); ++instruction) {
      if (isa<LoadInst>(instruction) || isa<StoreInst>(instruction)) {
        // NOTE: changed 'instruction' to '&*instruction'
        lid = getLID(&*instruction, fileID);
        if (lid == 0)
          continue;
        // varName = refineVarName(determineVariableName(instruction));
        // NOTE: changed 'instruction' to '&*instruction', next 2 lines
        varName = determineVariableName(&*instruction)->getName().str();
        varType = determineVariableType(&*instruction);
        varDefLine = determineVariableDefLine(&*instruction);

        Variable v(varName, varType, varDefLine);

        std::string prefix("ARRAY");
        if (!varType.compare(0, prefix.size(), prefix)) {
          varName = "ARRAY, " + varName;
        }

        // errs() << "Name: "  << varName << " " << "Type: " << varType << "\n";

        if (lid > (*bbCU)->endLine) {
          bbCU = next(bbCU, 1);
        }
        if (globalVariablesSet.count(varName) ||
            programGlobalVariablesSet.count(varName)) {
          (*bbCU)->globalVariableNames.insert(v);
          // originalVariablesSet.insert(varName);
        } else {
          (*bbCU)->localVariableNames.insert(v);
          // originalVariablesSet.insert(varName);
        }
      }
    }
  }
}

void DiscoPoP::findStartEndLineNumbers(Node *root, int &start, int &end) {
  if (root->type == nodeTypes::cu) {
    if (start == -1 || start > root->startLine) {
      start = root->startLine;
    }

    if (end < root->endLine) {
      end = root->endLine;
    }
  }

  for (auto i : root->childrenNodes) {
    findStartEndLineNumbers(i, start, end);
  }
}

void DiscoPoP::fillStartEndLineNumbers(Node *root, LoopInfo &LI) {
  if (root->type != nodeTypes::cu) {
    int start = -1, end = -1;

    if (root->type == nodeTypes::loop) {
      for (auto i : root->childrenNodes) {
        if (i->type == nodeTypes::cu) {
          Loop *loop = LI.getLoopFor(i->BB);
          DebugLoc dl = loop->getStartLoc();
          int32_t lid = 0;
          lid = (fileID << LIDSIZE) + dl->getLine();
          loopStartLines[root->ID] = dputil::decodeLID(lid);
          break;
        }
      }
    }
    findStartEndLineNumbers(root, start, end);

    root->startLine = start;
    root->endLine = end;
  }

  for (auto i : root->childrenNodes) {
    fillStartEndLineNumbers(i, LI);
  }
}

void DiscoPoP::initializeCUIDCounter() {
  std::string CUCounterFile = "DP_CUIDCounter.txt";

  if (dputil::fexists(CUCounterFile)) {
    std::fstream inCUIDCounter(CUCounterFile, std::ios_base::in);
    ;
    inCUIDCounter >> CUIDCounter;
    inCUIDCounter.close();
  }
}

bool DiscoPoP::isRecursive(Function &F, CallGraph &CG) {
  auto callNode = CG[&F];
  for (unsigned i = 0; i < callNode->size(); i++) {
    if ((*callNode)[i]->getFunction() == &F)
      return true;
  }

  return false;
}

// CUGeneration end

//Helper functions
bool DiscoPoP::isaCallOrInvoke(Instruction *BI)
{
    return (BI != NULL) && ((isa<CallInst>(BI) && (!isa<DbgDeclareInst>(BI))) || isa<InvokeInst>(BI));
}

bool DiscoPoP::sanityCheck(BasicBlock *BB)
{
    int32_t lid;
    for (BasicBlock::iterator BI = BB->begin(), EI = BB->end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0)
        {
            return true;
        }
    }
    errs() << "WARNING: basic block " << BB << " doesn't contain valid LID.\n";
    return false;
}

// Control-flow analysis functions

void DiscoPoP::CFA(Function &F, LoopInfo &LI)
{
    SmallVector<BasicBlock *, 8> ExitBlocks;
    for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
    {
        BasicBlock *tmpBB = &*BB;
        ExitBlocks.clear();

        // Get the closest loop where tmpBB lives in.
        // (L == NULL) if tmpBB is not in any loop.
        Loop *L = LI.getLoopFor(tmpBB);

        // Check if tmpBB is the loop header (.cond) block.
        if (L != NULL && LI.isLoopHeader(tmpBB))
        {
            StringRef loopType = tmpBB->getName().split('.').first;
            if (DP_DEBUG)
            {
                errs() << "loop [" << loopType << "] header: " << tmpBB->getName() << "\n";
            }

            // If tmpBB is the header block, get the exit blocks of the loop.
            if (L->hasDedicatedExits())
            {
                // loop exits are in canonical form
                L->getUniqueExitBlocks(ExitBlocks);
            }
            else
            {
                // loop exits are NOT in canonical form
                L->getExitBlocks(ExitBlocks);
            }

            if (ExitBlocks.size() == 0)
            {
                errs() << "WARNING: loop at " << tmpBB << " is ignored: exit BB not found.\n";
                continue;
            }

            // When loop has break statement inside, exit blocks may contain
            // the if-else block containing the break. Since we always want
            // to find the real exit (.end) block, we need to check the
            // successors of the break statement(s).
            SmallVector<BasicBlock *, 4> RealExitBlocks;
            if (DP_DEBUG)
            {
                errs() << "loop exits:";
            }
            for (SmallVectorImpl<BasicBlock *>::iterator EI = ExitBlocks.begin(), END = ExitBlocks.end();
                    EI != END; ++EI)
            {
                StringRef exitType = (*EI)->getName().split('.').first;
                if (exitType.equals(loopType) && ((*EI)->getName().find("end") != string::npos) &&
                        (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), *EI) == RealExitBlocks.end()))
                {
                    RealExitBlocks.push_back(*EI);
                    if (DP_DEBUG)
                    {
                        errs() << " " << (*EI)->getName();
                    }
                }
                else
                {
		    // Changed TerminatorInst to Instruction
                    Instruction *TI = (*EI)->getTerminator();
                    assert(TI != NULL && "Exit block is not well formed!");
                    unsigned int numSucc = TI->getNumSuccessors();
                    for (unsigned int i = 0; i < numSucc; ++i)
                    {
                        BasicBlock *succ = TI->getSuccessor(i);
                        exitType = succ->getName().split('.').first;
                        if (exitType.equals(loopType) && (succ->getName().find("end") != string::npos) &&
                                (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), succ) == RealExitBlocks.end()))
                        {
                            RealExitBlocks.push_back(succ);
                            if (DP_DEBUG)
                            {
                                errs() << " " << succ->getName();
                            }
                        }
                    }
                }
            }
            if (DP_DEBUG)
            {
                errs() << "\n";
            }

            //assert((RealExitBlocks.size() == 1) && "Loop has more than one real exit block!");
            if (RealExitBlocks.size() == 0)
            {
                errs() << "WARNING: loop at " << tmpBB << " is ignored: exit blocks are not well formed.\n";
                continue;
            }

            // Check if entry block and exit block(s) have valid LID.
            bool hasValidEntry = sanityCheck(tmpBB);
            bool hasValidExit = false;
            for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                    EI != END; ++ EI)
            {
                hasValidExit = sanityCheck(*EI);
                if (hasValidExit == true)
                    break;
            }

            if (hasValidEntry && hasValidExit)
            {
                // Instrument loop header block.
                instrumentLoopEntry(tmpBB, loopID);

                // Instrument loop exit block(s).
                for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                        EI != END; ++ EI)
                {
                    instrumentLoopExit(*EI, loopID);
                }
                ++loopID;
            }
        }
    }
}

// pass get invoked here
bool DiscoPoP::runOnModule(Module &M) {
  // LoopInfo& LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
  for(Function &F: M){
    runOnFunction(F);
  }
}

bool DiscoPoP::runOnFunction(Function &F)
{
    if (DP_DEBUG)
    {
        errs() << "pass DiscoPoP: run pass on function\n";
    }

    StringRef funcName = F.getName();
    // Avoid functions we don't want to instrument
    if (funcName.find("llvm.") != string::npos)    // llvm debug calls
    {
        return false;
    }
    if (funcName.find("__dp_") != string::npos)       // instrumentation calls
    {
        return false;
    }
    if (funcName.find("__cx") != string::npos)        // c++ init calls
    {
        return false;
    }
    if (funcName.find("__clang") != string::npos)     // clang helper calls
    {
        return false;
    }
    if (funcName.find("_GLOBAL_") != string::npos)    // global init calls (c++)
    {
        return false;
    }
    if (funcName.find("pthread_") != string::npos)
    {
        return false;
    }

    vector<CU *> CUVector;
  set<string> globalVariablesSet; // list of variables which appear in more than
                                  // one basic block
  map<string, vector<CU *>> BBIDToCUIDsMap;

    determineFileID(F, fileID);
    
    // only instrument functions belonging to project source files
    if (!fileID)
        return false;

    // CUGeneration
{
      /********************* Initialize root values ***************************/
  Node *root = new Node;
  root->name = F.getName().str();
  root->type = nodeTypes::func;

  // Get list of arguments for this function and store them in root.
  // NOTE: changed the way we get the arguments
  // for (Function::ArgumentListType::iterator it = F.getArgumentList().begin();
  // it != F.getArgumentList().end(); it++) {

  BasicBlock *BB = &F.getEntryBlock();
  auto BI = BB->begin();
  string lid;
  if (DebugLoc dl = BI->getDebugLoc()) {
    lid = to_string(dl->getLine());
  } else {
    lid = to_string(BI->getFunction()->getSubprogram()->getLine());
  }

  for (Function::arg_iterator it = F.arg_begin(); it != F.arg_end(); it++) {

    string type_str;
    raw_string_ostream rso(type_str);
    (it->getType())->print(rso);

    Variable v(it->getName().str(), rso.str(), to_string(fileID) + ":" + lid);
    root->argumentsList.push_back(v);
  }
  /********************* End of initialize root values
   * ***************************/
  // errs()<< "000---\n";
  // NOTE: changed the pass name for loopinfo -- LoopInfo &LI =
  // getAnalysis<LoopInfo>();
  LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();

  // get the top level region
  RIpass = &getAnalysis<RegionInfoPass>(F);
  RI = &(RIpass->getRegionInfo());
  Region *TopRegion = RI->getTopLevelRegion();

  getTrueVarNamesFromMetadata(TopRegion, root, &trueVarNamesFromMetadataMap);

  getFunctionReturnLines(TopRegion, root);

  populateGlobalVariablesSet(TopRegion, globalVariablesSet);

  createCUs(TopRegion, globalVariablesSet, CUVector, BBIDToCUIDsMap, root, LI);

  fillCUVariables(TopRegion, globalVariablesSet, CUVector, BBIDToCUIDsMap);

  fillStartEndLineNumbers(root, LI);

  secureStream();

  // printOriginalVariables(originalVariablesSet);

  printData(root);

  for (auto i : CUVector) {
    delete (i);
  }
}
    // CUGeneration end

    // DPInstrumentation
{   
    // Check loop parallelism?
    if (ClCheckLoopPar)
    {
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();
        CFA(F, LI);
    }

    // Instrument the entry of the function.
    // Each function entry is instrumented, and the first
    // executed function will initialize shadow memory.
    // See the definition of __dp_func_entry() for detail.
    instrumentFuncEntry(F);

    // Traverse all instructions, collect loads/stores/returns, check for calls.
    for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI)
    {
        BasicBlock &BB = *FI;
        runOnBasicBlock(BB);
    }

    if (DP_DEBUG)
    {
        errs() << "pass DiscoPoP: finished function\n";
    }
}
    // DPInstrumentation end

    // DPInstrumentationOmission
    // int bbDepCount = 0; moved to doInitialization
  // string bbDepString;
{
    if(F.getInstructionCount() == 0) return false;
    if(DP_hybrid_SKIP) return true;
    if(DP_hybrid_DEBUG) errs() << "\n---------- Omission Analysis on " << F.getName() << " ----------\n";

    DebugLoc dl;
    Value *V;
    
    set<Instruction*> omittableInstructions;
    
    set<Value*> staticallyPredictableValues;
    // Get local values (variables)
    for (Instruction& I: F.getEntryBlock()) {
      if (AllocaInst* AI = dyn_cast<AllocaInst>(&I)) {
        staticallyPredictableValues.insert(AI);
      }
    }
    for (BasicBlock& BB: F){ for(Instruction& I: BB){
      // Remove from staticallyPredictableValues those which are passed to other functions (by ref/ptr)
      if(CallInst* call_inst = dyn_cast<CallInst>(&I)){
        if(Function *Fun = call_inst->getCalledFunction()){
          if(Fun->getName() == "__dp_write" || Fun->getName() == "__dp_read" || Fun->getName() == "__dp_alloca"){
            ++totalInstrumentations;
          }
          // if(DP_hybrid_DEBUG) errs() << " ----5 " << Fun->getName() << " " << call_inst->getNumOperands() << "\n";
          // if(dl = call_inst->getDebugLoc()) errs() << dl.getLine() << "," << dl.getCol();
          for(uint i = 0; i < call_inst->getNumOperands() - 1; ++i){
            V = call_inst->getArgOperand(i);
            std::set<Value*>::iterator it = staticallyPredictableValues.find(V);
            if(it != staticallyPredictableValues.end()){
              staticallyPredictableValues.erase(V);
              if(DP_hybrid_DEBUG) errs() << VNF->getVarName(V) << "\n";
            }
            // for(Value *w: staticallyPredictableValues){
              // for (auto w = staticallyPredictableValues.begin(); w != staticallyPredictableValues.end(); ) {
              // if(w == V){
                // w = staticallyPredictableValues.erase(w);
                // if(DP_hybrid_DEBUG) errs() << VNF->getVarName(V) << "\n";
              // }
            // }
          }
        }
      }
      // Remove values from locals if dereferenced
      if(isa<StoreInst>(I)){
        V = I.getOperand(0);
        for(Value *w: staticallyPredictableValues){
          if(w == V){
            staticallyPredictableValues.erase(V);
          }
        }
      }
    }}

    if(DP_hybrid_DEBUG){
      errs() << "--- Local Values ---\n";
      for(auto V: staticallyPredictableValues){
        errs() << VNF->getVarName(V) << "\n";
      }
    }

    // Perform the SPA dependence analysis
    int32_t fid;
    determineFileID(F, fid);
    map<BasicBlock*, set<string>> conditionalBBDepMap;
    map<BasicBlock*, map<BasicBlock*, set<string>>> conditionalBBPairDepMap;

    auto &DT = getAnalysis<DominatorTreeWrapperPass>(F).getDomTree();
    InstructionCFG CFG(VNF, F);
    InstructionDG DG(VNF, &CFG, fid);

    for(auto edge : DG.getEdges()){
      Instruction* Src = edge->getSrc()->getItem();
      Instruction* Dst = edge->getDst()->getItem();

      V = Src->getOperand(isa<StoreInst>(Src) ? 1 : 0);
      if(isa<AllocaInst>(Dst)) V = dyn_cast<Value>(Dst);

      if(staticallyPredictableValues.find(V) == staticallyPredictableValues.end()) continue;
      
      if(Src != Dst && DT.dominates(Dst, Src)){
        if(!conditionalBBDepMap.count(Src->getParent())){
          set<string> tmp;
          conditionalBBDepMap[Src->getParent()] = tmp;
        }
        conditionalBBDepMap[Src->getParent()].insert(DG.edgeToDPDep(edge));
      }
      else{
        if(!conditionalBBPairDepMap.count(Dst->getParent())){
          map<BasicBlock*, set<string>> tmp;
          conditionalBBPairDepMap[Dst->getParent()] = tmp;
        }
        if(!conditionalBBPairDepMap[Dst->getParent()].count(Src->getParent())){
          set<string> tmp;
          conditionalBBPairDepMap[Dst->getParent()][Src->getParent()] = tmp;
        }
        conditionalBBPairDepMap[Dst->getParent()][Src->getParent()].insert(DG.edgeToDPDep(edge));
      }
      omittableInstructions.insert(Src);
      omittableInstructions.insert(Dst);
    }

    // Omit SPA instructions with no dependences
    for(auto node: DG.getInstructionNodes()){
      if(!isa<StoreInst>(node->getItem()) && !!isa<LoadInst>(node->getItem())) continue;
      V = node->getItem()->getOperand(isa<StoreInst>(node->getItem()) ? 1 : 0);
      if(!DG.getInEdges(node).size() && !DG.getOutEdges(node).size() && staticallyPredictableValues.find(V) != staticallyPredictableValues.end())
        omittableInstructions.insert(node->getItem());
    }

    // Add observation of execution of single basic blocks
    for(auto pair : conditionalBBDepMap){
      // Insert call to reportbb
      Instruction* insertionPoint = pair.first->getTerminator();
      if(isa<ReturnInst>(pair.first->getTerminator())){
        insertionPoint = insertionPoint->getPrevNonDebugInstruction();
      }
      auto CI = CallInst::Create(
        ReportBB, 
        ConstantInt::get(Int32, bbDepCount),
        "",
        insertionPoint
      );
      
      // ---- Insert deps into string ----
      if(bbDepCount) bbDepString += "/";
      bool first = true;
      bbDepString += to_string(bbDepCount) + "=";
      for(auto dep: pair.second){
        if(!first) bbDepString += ",";
        bbDepString += dep;
        first=false;
      }
      // ---------------------------------
      ++bbDepCount;
    }

    // Add observation of in-order execution of pairs of basic blocks
    for(auto pair1 : conditionalBBPairDepMap){
      // Alloca and init semaphore var for BB
      auto AI = new AllocaInst(Int32, 0, "__dp_bb", F.getEntryBlock().getFirstNonPHI()->getNextNonDebugInstruction());
      new StoreInst(ConstantInt::get(Int32, 0), AI, false, AI->getNextNonDebugInstruction());

      for(auto pair2: pair1.second){
        // Insert check for semaphore
        Instruction* insertionPoint = pair2.first->getTerminator();
        if(isa<ReturnInst>(pair2.first->getTerminator()))
          insertionPoint = insertionPoint->getPrevNonDebugInstruction();
      
        auto LI = new LoadInst(Int32, AI, Twine(""), false, insertionPoint);
        ArrayRef< Value * > arguments({LI, ConstantInt::get(Int32, bbDepCount)});
        CallInst::Create(
          ReportBBPair,
          arguments,
          "",
          insertionPoint
        );

        // ---- Insert deps into string ----
        if(bbDepCount) bbDepString += "/";
        bbDepString += to_string(bbDepCount);
        bbDepString += "=";
        bool first = true;
        for(auto dep: pair2.second){
          if(!first) bbDepString += ",";
          bbDepString += dep;
          first=false;
        }
        // ----------------------------------
        ++bbDepCount;
      }
      // Insert semaphore update to true
      new StoreInst(ConstantInt::get(Int32, 1), AI, false, pair1.first->getTerminator());
    }

    if(DumpToDot){
      CFG.dumpToDot(fileName + "_" + string(F.getName()) + ".CFG.dot");
      DG.dumpToDot(fileName + "_" + string(F.getName()) + ".DG.dot");
    }
    
    if(DP_hybrid_DEBUG){
      errs() << "--- Conditional BB Dependences:\n";
      for(auto pair : conditionalBBDepMap){
        errs() << pair.first->getName() << ":\n";
        for(auto s: pair.second){
          errs() << "\t" << s << "\n";
        }
      }

      errs() << "--- Conditional BB-Pair Dependences:\n";
      for(auto pair1 : conditionalBBPairDepMap){
        for(auto pair2: pair1.second){
          errs() << pair1.first->getName() << "-";
          errs() << pair2.first->getName() << ":\n";
          for(auto s: pair2.second)
            errs() << "\t" << s << "\n";
        }
      }
    }
  
    if(DP_hybrid_DEBUG){
      errs() << "--- Program Instructions:\n";
      for (BasicBlock& BB: F){ for(Instruction& I: BB){
        if(!isa<StoreInst>(I) && !isa<LoadInst>(I) && !isa<AllocaInst>(I)) continue;
        errs() << "\t" << (isa<StoreInst>(I) ? "Write " : (isa<AllocaInst>(I) ? "Alloca " : "Read ")) << " | ";
        if(dl = I.getDebugLoc()) errs() << dl.getLine() << "," << dl.getCol();
        else errs() << F.getSubprogram()->getLine() << ",*";
        errs() << " | ";
        V = I.getOperand(isa<StoreInst>(I) ? 1 : 0);
        if(isa<AllocaInst>(I)) V = dyn_cast<Value>(&I);
        errs() << VNF->getVarName(V);
        
        if(omittableInstructions.find(&I) != omittableInstructions.end())
          errs() << " | OMITTED";
          
        errs() << "\n";
      }}
    }
    
    // Remove omittable instructions from profiling
    Instruction* DP_Instrumentation;
    for(Instruction* I : omittableInstructions){
      if(isa<AllocaInst>(I)) DP_Instrumentation = I->getNextNode()->getNextNode();
      else DP_Instrumentation = I->getPrevNode();
      
      if(!DP_Instrumentation) continue;
      if(CallInst* call_inst = dyn_cast<CallInst>(DP_Instrumentation)){
        if(Function* Fun = call_inst->getCalledFunction()){
          string fn = Fun->getName().str();
          if(fn == "__dp_write" || fn == "__dp_read" || fn == "__dp_alloca"){
            DP_Instrumentation->eraseFromParent();
            ++removedInstrumentations;
          }
        }
      }
    }
    if(DP_hybrid_DEBUG) errs() << "Done with function " << F.getName() << ":\n";
}
    // DPInstrumentationOmission end
    return true;
}

void DiscoPoP::collectDebugInfo()
{
    if (NamedMDNode *CU_Nodes = ThisModule->getNamedMetadata("llvm.dbg.cu"))
    {
        for (unsigned i = 0, e = CU_Nodes->getNumOperands(); i != e; ++i)
        {
            DICompileUnit *CU = cast<DICompileUnit>(CU_Nodes->getOperand(i));
            // DICompileUnit CU(CU_Nodes->getOperand(i));
            auto GVs = CU->getGlobalVariables();
            for (unsigned i = 0, e = GVs.size(); i < e; ++i)
            {
                DIGlobalVariable *DIG = GVs[i]->getVariable();
                if (DIG)
                {
                    GlobalVars.insert(DIG);
                }
            }
        }
    }
}

DIGlobalVariable *DiscoPoP::findDbgGlobalDeclare(GlobalVariable *v)
{
    assert(v && "Global variable cannot be null");
    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it)
    {
        if ((*it)->getDisplayName() == v->getName())
            return *it;
    }
    return NULL;
}

Value *DiscoPoP::getOrInsertVarName(string varName, IRBuilder<> &builder)
{
    Value *vName = NULL;
    map<string, Value *>:: iterator pair = VarNames.find(varName);
    if (pair == VarNames.end())
    {
        vName = builder.CreateGlobalStringPtr(StringRef(varName.c_str()), ".str");
        VarNames[varName] = vName;
    }
    else
    {
        vName = pair->second;
    }
    return vName;
}

Value *DiscoPoP::findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder)
{
    assert(structNode);
    assert(structNode->getOperand(10));
    MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
    if (idx < memberListNodes->getNumOperands())
    {
        assert(memberListNodes->getOperand(idx));
        MDNode *member = cast<MDNode>(memberListNodes->getOperand(idx));
        //return getOrInsertVarName(string(member->getOperand(3)->getName().data()), builder);
        if (member->getOperand(3))
            return getOrInsertVarName(dyn_cast<MDString>(member->getOperand(3))->getString().str(), builder);
    }
    return NULL;
}

Type *DiscoPoP::pointsToStruct(PointerType *PTy)
{
    assert(PTy);
    Type *structType = PTy;
    if (PTy->getTypeID() == Type::PointerTyID)
    {
        while(structType->getTypeID() == Type::PointerTyID)
        {
            structType = cast<PointerType>(structType)->getElementType();
        }
    }
    return structType->getTypeID() == Type::StructTyID ? structType : NULL;
}

Value *DiscoPoP::determineVariableName(Instruction *const I,
                        bool &isGlobalVariable /*=defaultIsGlobalVariableValue*/)
{
    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL)
    {
        return getOrInsertVarName("*", builder);
    }

    if (operand->hasName())
    {
        // we've found a global variable
        if (isa<GlobalVariable>(*operand))
        {
            isGlobalVariable = true;
            DIGlobalVariable *gv = findDbgGlobalDeclare(cast<GlobalVariable>(operand));
            if (gv != NULL)
            {
                // check if metadata for name exists
                string varName = string (gv->getDisplayName().data());
                if (trueVarNamesFromMetadataMap.find(varName) != trueVarNamesFromMetadataMap.end()) {
                    varName = trueVarNamesFromMetadataMap[varName];  // found
                }
                return getOrInsertVarName(varName, builder);
            }
        }
        if (isa<GetElementPtrInst>(*operand))
        {
            GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
            Value *ptrOperand = gep->getPointerOperand();
            PointerType *PTy = cast<PointerType>(ptrOperand->getType());

            // we've found a struct/class
            Type *structType = pointsToStruct(PTy);
            if (structType && gep->getNumOperands() > 2)
            {
                Value *constValue = gep->getOperand(2);
                if (constValue && isa<ConstantInt>(*constValue))
                {
                    ConstantInt *idxPtr = cast<ConstantInt>(gep->getOperand(2));
                    uint64_t memberIdx = *(idxPtr->getValue().getRawData());

                    StructType *STy = cast<StructType>(structType);
                    if(!STy ->isLiteral()){
                        // check if name is overwritten by metadata
                        string strName = structType->getStructName().data();
                        if (trueVarNamesFromMetadataMap.find(strName) != trueVarNamesFromMetadataMap.end()) {
                            strName = trueVarNamesFromMetadataMap[strName];  // found
                        }

                        map<string, MDNode *>::iterator it = Structs.find(strName);
                        if (it != Structs.end())
                        {
                            Value *ret = findStructMemberName(it->second, memberIdx, builder);
                            if (ret)
                                return ret;
                        }
                    }
                }
            }

            // we've found an array
            if (PTy->getElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand))
            {
                return determineVariableName((Instruction *)ptrOperand, isGlobalVariable);
            }
            return determineVariableName((Instruction *)gep, isGlobalVariable);
        }
        // check if name is overwritten by metadata
        string varName = string(operand->getName().data());
        if (trueVarNamesFromMetadataMap.find(varName) != trueVarNamesFromMetadataMap.end()) {
            varName = trueVarNamesFromMetadataMap[varName];  // found
        }
        return getOrInsertVarName(varName, builder);
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand))
    {
        return determineVariableName((Instruction *)(operand), isGlobalVariable);
    }
    // if we cannot determine the name, then return *
    return getOrInsertVarName("*", builder);
}

void DiscoPoP::getTrueVarNamesFromMetadata(Region *TopRegion, Node *root, std::map<string, string>* trueVarNamesFromMetadataMap)
{
    int lid = 0;
    for (Region::block_iterator bb = TopRegion->block_begin(); bb != TopRegion->block_end(); ++bb){
        for(BasicBlock::iterator instruction = (*bb)->begin(); instruction != (*bb)->end(); ++instruction){
            // search for call instructions to @llvm.dbg.declare
            if(isa<CallInst>(instruction)){
                Function *f = (cast<CallInst>(instruction))->getCalledFunction();
                if(f){
                    StringRef funcName = f->getName();
                    if (funcName.find("llvm.dbg.declar") != string::npos) // llvm debug calls
                    {
                        CallInst* call = cast<CallInst>(instruction);
                        // check if @llvm.dbg.declare is called
                        // int cmp_res = dbg_declare.compare(call->getCalledFunction()->getName().str());
                        // if(cmp_res == 0){
                        // call to @llvm.dbg.declare found
                        // extract original and working variable name
                        string SRCVarName;
                        string IRVarName;

                        Metadata *Meta = cast<MetadataAsValue>(call->getOperand(0))->getMetadata();
                        if (isa<ValueAsMetadata>(Meta)){
                            Value *V = cast <ValueAsMetadata>(Meta)->getValue();
                            IRVarName = V->getName().str();
                        }
                        DIVariable *V = cast<DIVariable>(cast<MetadataAsValue>(call->getOperand(1))->getMetadata());
                        SRCVarName = V->getName().str();

                        // add to trueVarNamesFromMetadataMap
                        // overwrite entry if already existing
                        if (trueVarNamesFromMetadataMap->find(IRVarName) == trueVarNamesFromMetadataMap->end()) {
                            // not found
                            trueVarNamesFromMetadataMap->insert(std::pair<string, string>(IRVarName, SRCVarName));
                        } else {
                            // found
                            (*trueVarNamesFromMetadataMap)[IRVarName] = SRCVarName;
                        }
                    }
                }
            }
        }
    }
}

void DiscoPoP::processStructTypes(string const &fullStructName, MDNode *structNode)
{
    assert(structNode && "structNode cannot be NULL");
    DIType *strDes = cast<DIType>(structNode);
    // DIType strDes(structNode);
    assert(strDes->getTag() == dwarf::DW_TAG_structure_type);
    // sometimes it's impossible to get the list of struct members (e.g badref)
    if (structNode->getNumOperands() <= 10 || structNode->getOperand(10) == NULL)
    {
        errs() << "cannot process member list of this struct: \n";
        structNode->dump();
        return;
    }
    Structs[fullStructName] = structNode;

    MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
    for (unsigned i = 0; i < memberListNodes->getNumOperands(); ++i)
    {
        assert(memberListNodes->getOperand(i));
        MDNode *member = cast<MDNode>(memberListNodes->getOperand(i));
        DINode *memberDes = cast<DINode>(member);
        // DIDescriptor memberDes(member);
        if (memberDes->getTag() == dwarf::DW_TAG_member)
        {
            assert(member->getOperand(9));
            MDNode *memberType = cast<MDNode>(member->getOperand(9));
            DIType *memberTypeDes = cast<DIType>(memberType);
            // DIType memberTypeDes(memberType);
            if (memberTypeDes->getTag() == dwarf::DW_TAG_structure_type)
            {
                string fullName = "";
                // try to get namespace
                if (memberType->getNumOperands() > 2 && structNode->getOperand(2) != NULL)
                {
                    MDNode *namespaceNode = cast<MDNode>(structNode->getOperand(2));
                    DINamespace *dins = cast<DINamespace>(namespaceNode);
                    // DINameSpace dins(namespaceNode);
                    fullName = "struct." + string(dins->getName().data()) + "::";
                }
                //fullName += string(memberType->getOperand(3)->getName().data());
                fullName += (dyn_cast<MDString>(memberType->getOperand(3)))->getString();

                if (Structs.find(fullName) == Structs.end())
                    processStructTypes(fullName, memberType);
            }
        }
    }
}


/********** Output functions *********/
string DiscoPoP::xmlEscape(string data) {
  string::size_type pos = 0;
  for (;;) {
    pos = data.find_first_of("\"&<>", pos);
    if (pos == string::npos)
      break;
    string replacement;
    switch (data[pos]) {
    case '\"':
      replacement = "&quot;";
      break;
    case '&':
      replacement = "&amp;";
      break;
    case '<':
      replacement = "&lt;";
      break;
    case '>':
      replacement = "&gt;";
      break;
    default:;
    }
    data.replace(pos, 1, replacement);
    pos += replacement.size();
  };
  return data;
}

void DiscoPoP::secureStream() {
  outOriginalVariables = new std::ofstream();
  outOriginalVariables->open("OriginalVariables.txt", std::ios_base::app);

  outCUs = new std::ofstream();
  outCUs->open("Data.xml", std::ios_base::app);

  outCUIDCounter = new std::ofstream();
  outCUIDCounter->open("DP_CUIDCounter.txt", std::ios_base::out);
}

string DiscoPoP::getLineNumbersString(set<int> LineNumbers) {
  string line = "";
  for (auto li : LineNumbers) {
    std::string temp = ',' + dputil::decodeLID(li);
    if (temp != ",*") {
      if (line == "") {
        line = dputil::decodeLID(li);
      } else {
        line = line + temp;
      }
    }
  }
  return line;
}

string DiscoPoP::getChildrenNodesString(Node *root) {
  string childrenIDs = "";
  int i = 0;
  std::for_each(root->childrenNodes.begin(), root->childrenNodes.end(),
                [&](Node *node) {
                  if (i == 0) {
                    childrenIDs = node->ID;
                    i++;
                  } else {
                    childrenIDs += "," + node->ID;
                  }
                });
  return childrenIDs;
}


void DiscoPoP::printData(Node *root) {
  *outCUs << "<Nodes>" << endl << endl;

  printTree(root, true);

  *outCUs << "</Nodes>" << endl << endl << endl;

  closeOutputFiles();
}

void DiscoPoP::printTree(Node *root, bool isRoot) {
  printNode(root, isRoot);

  std::for_each(root->childrenNodes.begin(), root->childrenNodes.end(),
                [&](Node *node) {
                  if (node->type == nodeTypes::func)
                    isRoot = false;
                  printTree(node, isRoot);
                });
}

void DiscoPoP::printNode(Node *root, bool isRoot) {
  if (root->name.find("llvm")) {
    // if(dputil::decodeLID(root->endLine) == "1:560")
    // errs() << "=-=-=-=-=-=-=-=-=-=-=-=- " <<
    // dputil::decodeLID(root->startLine) << "\n";
    string start = "";
    if (root->type == nodeTypes::loop) {
      start = loopStartLines[root->ID];
    } else {
      start = dputil::decodeLID(root->startLine);
    }
    *outCUs << "\t<Node"
            << " id=\"" << xmlEscape(root->ID) << "\""
            << " type=\"" << root->type << "\""
            << " name=\"" << xmlEscape(root->name) << "\""
            << " startsAtLine = \"" << start << "\""
            << " endsAtLine = \"" << dputil::decodeLID(root->endLine) << "\""
            << ">" << endl;
    *outCUs << "\t\t<childrenNodes>" << getChildrenNodesString(root)
            << "</childrenNodes>" << endl;
    if (root->type == nodeTypes::func || root->type == nodeTypes::dummy) {
      *outCUs << "\t\t<funcArguments>" << endl;
      for (auto ai : root->argumentsList) {
        *outCUs << "\t\t\t<arg type=\"" << xmlEscape(ai.type) << "\""
                << " defLine=\"" << xmlEscape(ai.defLine) << "\">"
                << xmlEscape(ai.name) << "</arg>" << endl;
      }
      *outCUs << "\t\t</funcArguments>" << endl;

      string rlVals = "";
      for (auto rl : root->returnLines) {
        rlVals += dputil::decodeLID(rl) + ", ";
      }
      *outCUs << "\t\t<funcReturnLines>" << rlVals << "</funcReturnLines>"
              << endl;
    }

    if (root->type == nodeTypes::cu) {
      CU *cu = static_cast<CU *>(root);
      *outCUs << "\t\t<BasicBlockID>" << cu->BBID << "</BasicBlockID>" << endl;
      *outCUs << "\t\t<readDataSize>" << cu->readDataSize << "</readDataSize>"
              << endl;
      *outCUs << "\t\t<writeDataSize>" << cu->writeDataSize
              << "</writeDataSize>" << endl;

      *outCUs << "\t\t<instructionsCount>" << cu->instructionsCount
              << "</instructionsCount>" << endl;
      *outCUs << "\t\t<instructionLines count=\""
              << (cu->instructionsLineNumbers).size() << "\">"
              << getLineNumbersString(cu->instructionsLineNumbers)
              << "</instructionLines>" << endl;
      *outCUs << "\t\t<readPhaseLines count=\""
              << (cu->readPhaseLineNumbers).size() << "\">"
              << getLineNumbersString(cu->readPhaseLineNumbers)
              << "</readPhaseLines>" << endl;
      *outCUs << "\t\t<writePhaseLines count=\""
              << (cu->writePhaseLineNumbers).size() << "\">"
              << getLineNumbersString(cu->writePhaseLineNumbers)
              << "</writePhaseLines>" << endl;
      *outCUs << "\t\t<returnInstructions count=\""
              << (cu->returnInstructions).size() << "\">"
              << getLineNumbersString(cu->returnInstructions)
              << "</returnInstructions>" << endl;
      *outCUs << "\t\t<successors>" << endl;
      for (auto sucCUi : cu->successorCUs) {
        *outCUs << "\t\t\t<CU>" << sucCUi << "</CU>" << endl;
      }
      *outCUs << "\t\t</successors>" << endl;

      *outCUs << "\t\t<localVariables>" << endl;
      for (auto lvi : cu->localVariableNames) {
        *outCUs << "\t\t\t<local type=\"" << xmlEscape(lvi.type) << "\""
                << " defLine=\"" << xmlEscape(lvi.defLine) << "\">"
                << xmlEscape(lvi.name) << "</local>" << endl;
      }
      *outCUs << "\t\t</localVariables>" << endl;

      *outCUs << "\t\t<globalVariables>" << endl;
      for (auto gvi : cu->globalVariableNames) {
        *outCUs << "\t\t\t<global type=\"" << xmlEscape(gvi.type) << "\""
                << " defLine=\"" << xmlEscape(gvi.defLine) << "\">"
                << xmlEscape(gvi.name) << "</global>" << endl;
      }
      *outCUs << "\t\t</globalVariables>" << endl;

      *outCUs << "\t\t<callsNode>" << endl;
      for (auto i : (cu->callLineTofunctionMap)) {
        for (auto ii : i.second) {
          *outCUs << "\t\t\t<nodeCalled atLine=\"" << dputil::decodeLID(i.first)
                  << "\">" << ii->ID << "</nodeCalled>" << endl;
          // specifica for recursive fucntions inside loops. (Mo 5.11.2019)
          *outCUs << "\t\t\t\t<recursiveFunctionCall>"
                  << ii->recursiveFunctionCall << "</recursiveFunctionCall>"
                  << endl;
        }
      }
      *outCUs << "\t\t</callsNode>" << endl;
    }

    *outCUs << "\t</Node>" << endl << endl;
  }
}

void DiscoPoP::closeOutputFiles() {

  if (outCUs != NULL && outCUs->is_open()) {
    outCUs->flush();
    outCUs->close();
  }

  if (outOriginalVariables != NULL && outOriginalVariables->is_open()) {
    outOriginalVariables->flush();
    outOriginalVariables->close();
  }
  // delete outCUs;
}
/************** End of output functions *******************/

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
  metadata, ;; Reference to type derived from     // 9   --> get operand at index 9
  metadata, ;; (optional) Name of the Objective C property associated with
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
void DiscoPoP::runOnBasicBlock(BasicBlock &BB)
{
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI)
    {
        if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI))
        {
            assert(DI->getOperand(0));
            //MDNode* node = cast<MDNode>(DI->getOperand(0));
            // llvm.dbg.declare changes from LLVM 3.3 to 3.6.1:
            // LLVM 3.6.1: call @llvm.dbg.declare(metadata %struct.x* %1, metadata !1, metadata !2)
            // LLVM 3.3:   call @llvm.dbg.declare(metadata !{%struct.x* %1}, metadata !1, metadata !2)
            // diff: operand 0 changes from MDNode* to Value*
            if (AllocaInst *alloc = dyn_cast<AllocaInst>(DI->getOperand(0)))
            {
                Type *type = alloc->getAllocatedType();
                Type *structType = type;
                unsigned depth = 0;
                if (type->getTypeID() == Type::PointerTyID)
                {
                    while(structType->getTypeID() == Type::PointerTyID)
                    {
                        structType = cast<PointerType>(structType)->getElementType();
                        ++depth;
                    }
                }
                if (structType->getTypeID() == Type::StructTyID)
                {
                    assert(DI->getOperand(1));
                    // LLVM 3.6.1:
                    // DbgDeclareInst *DI->getOperand(1) ==> MDNode* getVariable()
                    //                *DI->getOperand(2) ==> MDNode* getExpression()
                    // Methods Metadata* getRawVariable() and Metadata* getRawExpression() are listed on
                    // LLVM online document, but do not exist in source code of 3.6.1.
                    MDNode *varDesNode = DI->getVariable();
                    assert(varDesNode->getOperand(5));
                    MDNode *typeDesNode = cast<MDNode>(varDesNode->getOperand(5));
                    MDNode *structNode = typeDesNode;
                    if (type->getTypeID() == Type::PointerTyID)
                    {
                        MDNode *ptr = typeDesNode;
                        for (unsigned i = 0; i < depth; ++i)
                        {
                            assert(ptr->getOperand(9));
                            ptr = cast<MDNode>(ptr->getOperand(9));
                        }
                        structNode = ptr;
                    }
                    DINode *strDes = cast<DINode>(structNode);
                    // DIDescriptor strDes(structNode);
                    // handle the case when we have pointer to struct (or pointer to pointer to struct ...)
                    if (strDes->getTag() == dwarf::DW_TAG_pointer_type)
                    {
                        DINode *ptrDes = strDes;
                        // DIDescriptor* ptrDes = &strDes;
                        do
                        {
                            if (structNode->getNumOperands() < 10)
                                break;
                            assert(structNode->getOperand(9));
                            structNode = cast<MDNode>(structNode->getOperand(9));
                            ptrDes = cast<DINode>(structNode);
                            // ptrDes = new DIDescriptor(structNode);
                        }
                        while (ptrDes->getTag() != dwarf::DW_TAG_structure_type);
                    }

                    if (strDes->getTag() == dwarf::DW_TAG_typedef)
                    {
                        assert(strDes->getOperand(9));
                        structNode = cast<MDNode>(strDes->getOperand(9));
                    }
                    strDes = cast<DINode>(structNode);
                    // strDes = DIDescriptor(structNode);
                    if (strDes->getTag() == dwarf::DW_TAG_structure_type)
                    {
                        string strName(structType->getStructName().data());
                        if (Structs.find(strName) == Structs.end())
                        {
                            processStructTypes(strName, structNode);
                        }
                    }
                }
            }
        }
        // load instruction
        else if (isa<LoadInst>(BI))
        {
            instrumentLoad(cast<LoadInst>(BI));
        }
        // // store instruction
        else if (isa<StoreInst>(BI))
        {
            instrumentStore(cast<StoreInst>(BI));
        }
        // call and invoke
        else if (isaCallOrInvoke(&*BI))
        {
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
            if (F)
            {
                fn = F->getName();
                if (fn.find("__dp_") != string::npos)           // avoid instrumentation calls
                {
                    continue;
                }
                if (fn.find("__clang_") != string::npos)        // clang helper calls
                {
                    continue;
                }
                if (fn.equals("pthread_exit"))
                {
                    // pthread_exit does not return to its caller.
                    // Therefore, we insert DpFuncExit before pthread_exit
                    IRBuilder<> IRBRet(&*BI);
                    ArrayRef< Value * > arguments({ConstantInt::get(Int32, getLID(&*BI, fileID)), ConstantInt::get(Int32, 0)});
                    IRBRet.CreateCall(DpFuncExit, arguments);
                    continue;
                }
                if (fn.equals("exit") || F->doesNotReturn())    // using exit() to terminate program
                {
                    // only insert DpFinalize right before the main program exits
                    insertDpFinalize(&*BI);
                    continue;
                }

            }
            int32_t lid = getLID(&*BI, fileID);
            if (lid > 0)                   // calls on non-user code are not instrumented
            {
                IRBuilder<> IRBCall(&*BI);
                IRBCall.CreateCall(DpCallOrInvoke, ConstantInt::get(Int32, lid));
                if (DP_DEBUG)
                {
                    if (isa<CallInst>(BI))
                    {
                        if (!fn.equals(""))
                            errs() << "calling " << fn << " on " << lid << "\n";
                        else
                            errs() << "calling unknown function on " << lid << "\n";
                    }
                    else
                    {
                        if (!fn.equals(""))
                            errs() << "invoking " << fn << " on " << lid << "\n";
                        else
                            errs() << "invoking unknown function on " << lid << "\n";
                    }
                }
            }
        }
        // return
        else if (isa<ReturnInst>(BI))
        {
            int32_t lid = getLID(&*BI, fileID);
            assert((lid > 0) && "Returning on LID = 0!");

            Function *parent = BB.getParent();
            assert(parent != NULL);
            StringRef fn = parent->getName();

            if (fn.equals("main"))     // returning from main
            {
                insertDpFinalize(&*BI);
            }
            else
            {
                IRBuilder<> IRBRet(&*BI);
                ArrayRef< Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, 0)});
                IRBRet.CreateCall(DpFuncExit, arguments);
            }

            if (DP_DEBUG)
            {
                errs() << fn << " returning on " << lid << "\n";
            }
        }
    }
}

// Instrumentation function inserters.
void DiscoPoP::instrumentLoad(LoadInst *toInstrument)
{

    int32_t lid = getLID(toInstrument, fileID);
    if (lid == 0) return;

    vector<Value *> args;

    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVariableName(toInstrument));

#ifdef SKIP_DUP_INSTR
    //Value* loadAddr = args[1];
    //Type* trackerType = v2->getType();

    //cout << "Creating Load " << uniqueNum;
    Twine name = Twine("L").concat(Twine(uniqueNum));

    GlobalVariable *addrTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,//trackerType
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),//trackerType
                           name);
    GlobalVariable *countTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),
                           name.concat(Twine("count")));
    uniqueNum++;

    //Load current values before instr
    LoadInst *currentAddrTracker = new LoadInst::LoadInst(addrTracker, Twine(), toInstrument);
    LoadInst *currentCount = new LoadInst::LoadInst(countTracker, Twine(), toInstrument);

    //add instr before before
    args.push_back(currentAddrTracker);
    args.push_back(currentCount);
#endif
    CallInst::Create(DpRead, args, "", toInstrument);

#ifdef SKIP_DUP_INSTR
    //Post instrumentation call
    //Create updates
    StoreInst *addrUpdate = new StoreInst::StoreInst(memAddr, addrTracker);
    BinaryOperator::BinaryOperator *incCount =
        BinaryOperator::Create(Instruction::Add,
                               currentCount,
                               ConstantInt::get(Int64, 1)
                              );
    StoreInst *countUpdate = new StoreInst::StoreInst(incCount, countTracker);

    //add updates after before
    addrUpdate->insertAfter(toInstrument);
    incCount->insertAfter(toInstrument);
    countUpdate->insertAfter(incCount);
#endif
}


void DiscoPoP::instrumentStore(StoreInst *toInstrument)
{

    int32_t lid = getLID(toInstrument, fileID);
    if (lid == 0) return;

    vector<Value *> args;
    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVariableName(toInstrument));

#ifdef SKIP_DUP_INSTR
    //Value* storeAddr = args[1];
    //Type* trackerType = v2->getType();

    //cout << "Creating Store " << uniqueNum;
    Twine name = Twine("S").concat(Twine(uniqueNum));

    GlobalVariable *addrTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,//trackerType
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),//trackerType
                           name);
    GlobalVariable *countTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),
                           name.concat(Twine("count")));
    uniqueNum++;

    //Load current values before instr
    LoadInst *currentAddrTracker = new LoadInst::LoadInst(addrTracker, Twine(), toInstrument);
    LoadInst *currentCount = new LoadInst::LoadInst(countTracker, Twine(), toInstrument);

    //add instr before before
    args.push_back(currentAddrTracker);
    args.push_back(currentCount);
#endif

    CallInst::Create(DpWrite, args, "", toInstrument);

#ifdef SKIP_DUP_INSTR
    //Post instrumentation call
    //Create updates
    StoreInst *addrUpdate = new StoreInst::StoreInst(memAddr, addrTracker);
    BinaryOperator::BinaryOperator *incCount =
        BinaryOperator::Create(Instruction::Add,
                               currentCount,
                               ConstantInt::get(Int64, 1)
                              );
    StoreInst *countUpdate = new StoreInst::StoreInst(incCount, countTracker);

    //add updates after before
    addrUpdate->insertAfter(toInstrument);
    incCount->insertAfter(toInstrument);
    countUpdate->insertAfter(incCount);
#endif
}

void DiscoPoP::insertDpFinalize(Instruction *before)
{
    int32_t lid = getLID(before, fileID);
    assert((lid > 0) && "Returning on an invalid LID.");
    IRBuilder<> IRB(before);
    IRB.CreateCall(DpFinalize, ConstantInt::get(Int32, lid));
}

void DiscoPoP::instrumentFuncEntry(Function &F)
{
    BasicBlock &entryBB = F.getEntryBlock();
    int32_t lid = 0;
    int32_t isStart = 0;

    StringRef fn = F.getName();
    if (fn.equals("main"))
        isStart = 1;

    // We always want to insert __dp_func_entry at the beginning
    // of the basic block, but we need the first valid LID to
    // get the entry line of the function.
    for (BasicBlock::iterator BI = entryBB.begin(), EI = entryBB.end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            IRBuilder<> IRB(&*entryBB.begin());
            //NOTE: Changed to arrayref
            ArrayRef< Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, isStart)});
            IRB.CreateCall(DpFuncEntry, arguments);
            if (DP_DEBUG)
            {
                errs() << "DiscoPoP: funcEntry instrumented\n";
            }
            break;
        }
    }
    assert((lid > 0) && "Function entry is not instrumented because LID are all invalid for the entry block.");
}

void DiscoPoP::instrumentLoopEntry(BasicBlock *bb, int32_t id)
{
    BasicBlock *currentBB = bb;
    vector<Value *> args;
    int32_t lid = 0;

    // Take care of the order of instrumentation functions for loop entry
    // and exit. Loop exit must appear before the next loop entry.
    // Usually every loop has a .end block as the exit block, thus the
    // exit of a loop will not be the entry of another loop. The first if
    // check is just in case the blocks are organized in a abnormal way.
    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI)
    {
        if (isa<CallInst>(BI))
        {
            Function *tmpF = (cast<CallInst>(BI))->getCalledFunction();
            StringRef tmpFn = tmpF->getName();
            if (tmpFn.find("__dp_loop_exit") != string::npos)
                continue;
        }
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopEntry, args, "", &*BI);
            break;
        }
    }
    //assert((lid > 0) && "Loop entry is not instrumented because LID are all invalid for the whole basic block.");
}

void DiscoPoP::instrumentLoopExit(BasicBlock *bb, int32_t id)
{
    BasicBlock *currentBB = bb;
    vector<Value *> args;
    int32_t lid = 0;

    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopExit, args, "", &*currentBB->begin()); // always insert to the beiginning
            break;
        }
    }
    //assert((lid > 0) && "Loop exit is not instrumented because LID are all invalid for the whole basic block.");
}
