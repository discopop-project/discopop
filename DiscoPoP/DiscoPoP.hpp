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

#ifndef DISCOPOP_H
#define DISCOPOP_H

#include "llvm/Transforms/Instrumentation.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/APInt.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/InitializePasses.h"

#include "DPUtils.h"
#include "InstructionDG.hpp"

#include <cstdlib>
#include <algorithm>
#include <iomanip>
#include <map>
#include <set>
#include <string.h>
#include <utility>

#define DP_DEBUG false

using namespace llvm;
using namespace std;
using namespace dputil;

// Command line options
static cl::opt<bool> ClCheckLoopPar("dp-loop-par", cl::init(true),
                                    cl::desc("Check loop parallelism"), cl::Hidden);

static cl::opt<bool> DumpToDot(
  "dp-omissions-dump-dot", cl::init(false),
  cl::desc("Generate a .dot representation of the CFG and DG"), cl::Hidden
);

namespace {

STATISTIC(totalInstrumentations, "Total DP-Instrumentations");
STATISTIC(removedInstrumentations, "Disregarded DP-Instructions");

// CUGeneration

static unsigned int CUIDCounter;
static bool defaultIsGlobalVariableValue;
int32_t fileID;

typedef struct Variable_struct {
  string name;
  string type;
  string defLine;
  string isArray;

  Variable_struct(const Variable_struct &other)
      : name(other.name), type(other.type), defLine(other.defLine) {}

  Variable_struct(string n, string t, string d)
      : name(n), type(t), defLine(d) {}

  // We have a set of this struct. The set doesn't know how to order the
  // elements.
  inline bool operator<(const Variable_struct &rhs) const {
    return name < rhs.name;
  }

  inline bool operator>(const Variable_struct &rhs) const {
    return name > rhs.name;
  }

} Variable;

enum nodeTypes { cu, func, loop, dummy } type;

typedef struct Node_struct {
  string ID;
  nodeTypes type;
  int startLine;
  int endLine;
  BasicBlock *BB;

  // Only for func type
  string name;
  vector<Variable> argumentsList;
  set<int> returnLines;

  vector<Node_struct *> childrenNodes;
  Node_struct *parentNode;

  // isRecursive function (Mo 5.11.2019)
  string recursiveFunctionCall = "";

  Node_struct() {
    ID = to_string(fileID) + ":" + to_string(CUIDCounter++);
    parentNode = NULL;
    BB = NULL;
  }
} Node;

typedef struct CU_struct : Node_struct {

  string BBID; // BasicBlock Id where the CU appears in

  unsigned readDataSize;  // number of bytes read from memory by the cu
  unsigned writeDataSize; // number of bytes written into memory during the cu
  unsigned instructionsCount;

  // basic block id & successor basic blocks for control dependence
  vector<string> successorCUs; // keeps IDs of control dependent CUs
  string basicBlockName;

  set<int> instructionsLineNumbers;
  set<int> readPhaseLineNumbers;
  set<int> writePhaseLineNumbers;
  set<int> returnInstructions;

  set<Variable> localVariableNames;
  set<Variable> globalVariableNames;

  // Map to record function call line numbers
  map<int, vector<Node *>> callLineTofunctionMap;

  CU_struct() {
    type = nodeTypes::cu;
    readDataSize = 0;
    writeDataSize = 0;
    instructionsCount = 0;
    // BB = NULL;
  }

  void removeCU() {
    CUIDCounter--; // if a CU does not contain any instruction, e.g. entry
                   // basic blocks, then remove it.
  }

} CU;
class DiscoPoP : public ModulePass {
private:

// CUGeneration

  ofstream *outCUs;
  ofstream *outOriginalVariables;
  ofstream *outCUIDCounter;
  // Mohammad 23.12.2020
  map<string, string> loopStartLines;

  // structures to get list of global variables
  set<string> programGlobalVariablesSet;
  // structures to get actual variable names from llvm replacements
  map<string, string> trueVarNamesFromMetadataMap;

  RegionInfoPass *RIpass;
  RegionInfo *RI;
// CUGeneration end

// DPInstrumentation
  // Initializations
  void setupDataTypes();
  void setupCallbacks();

  // Helper functions
  bool isaCallOrInvoke(Instruction *BI);
  bool sanityCheck(BasicBlock *BB);
  void collectDebugInfo();
  void processStructTypes(string const &fullStructName, MDNode *structNode);
  DIGlobalVariable *findDbgGlobalDeclare(GlobalVariable *V);
  Value *getOrInsertVarName(string varName, IRBuilder<> &builder);
  Value *findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder);
  Type *pointsToStruct(PointerType *PTy);
  Value *determineVariableName(Instruction *const I,
                  bool &isGlobalVariable = defaultIsGlobalVariableValue);
  void getTrueVarNamesFromMetadata(Region *TopRegion, Node *root,
                                    std::map<string, string>* trueVarNamesFromMetadataMap);

  // Control flow analysis
  void CFA(Function &F, LoopInfo &LI);

  // Callback Inserters
  //void insertDpInit(const vector<Value*> &args, Instruction *before);
  //void insertDpFinalize(Instruction *before);
  void instrumentStore(StoreInst *toInstrument);
  void instrumentLoad(LoadInst *toInstrument);
  void insertDpFinalize(Instruction *before);
  void instrumentFuncEntry(Function &F);
  void instrumentLoopEntry(BasicBlock *bb, int32_t id);
  void instrumentLoopExit(BasicBlock *bb, int32_t id);

  int64_t uniqueNum;

  // Callbacks to run-time library
  FunctionCallee DpInit, DpFinalize;
  FunctionCallee DpRead, DpWrite;
  FunctionCallee DpCallOrInvoke;
  FunctionCallee DpFuncEntry, DpFuncExit;
  FunctionCallee DpLoopEntry, DpLoopExit;

  // Basic types
  Type *Void;
  IntegerType *Int32, *Int64;
  PointerType *CharPtr;

  // Control flow analysis
  int32_t loopID;

  // Output streams
  ofstream ocfg;

  // Export Module M from runOnModule() to the whole structure space
  Module *ThisModule;
  LLVMContext *ThisModuleContext;

  map<string, Value *> VarNames;
  set<DIGlobalVariable *> GlobalVars;
  map<string, MDNode *> Structs;
// DPInstrumentation end

// DPInstrumentationOmission
  int bbDepCount;
  string bbDepString;
  string fileName;
  int32_t fid;
  FunctionCallee ReportBB, ReportBBPair;
  dputil::VariableNameFinder *VNF;
// DPInstrumentationOmission end

public:
  DiscoPoP() : ModulePass(ID), uniqueNum(1) {};
  ~DiscoPoP();

  StringRef getPassName() const;
  bool runOnModule(Module &M);
  bool runOnFunction(Function &F);
  void runOnBasicBlock(BasicBlock &BB);
  bool doInitialization(Module &M);
  bool doFinalization(Module &M);
  void getAnalysisUsage(AnalysisUsage &Info) const;

  static char ID; // Pass identification, replacement for typeid

// CUGeneration

  // DiscoPoP Functions
  string determineVariableType(Instruction *I);
  string determineVariableDefLine(Instruction *I);
  void getFunctionReturnLines(Region *TopRegion, Node *root);

  // functions to get list of global variables
  void collectGlobalVariables();

  // functions to get recursive functions (Mo 5.11.2019)
  bool isRecursive(Function &F, CallGraph &CG);

  // Populate variable sets global to BB
  void populateGlobalVariablesSet(Region *TopRegion,
                                  set<string> &globalVariablesSet);
  void createCUs(Region *TopRegion, set<string> &globalVariablesSet,
                 vector<CU *> &CUVector,
                 map<string, vector<CU *>> &BBIDToCUIDsMap, Node *root,
                 LoopInfo &LI);
  void fillCUVariables(Region *TopRegion, set<string> &globalVariablesSet,
                       vector<CU *> &CUVector,
                       map<string, vector<CU *>> &BBIDToCUIDsMap);
  void fillStartEndLineNumbers(Node *root, LoopInfo &LI);
  void findStartEndLineNumbers(Node *root, int &start, int &end);

  // Output function
  void initializeCUIDCounter();
  string xmlEscape(string data);
  void secureStream();
  string getLineNumbersString(set<int> LineNumbers);
  string getChildrenNodesString(Node *node);
  // void printOriginalVariables(set<string> &originalVariablesSet);
  void printData(Node *node);
  void printTree(Node *node, bool isRoot);
  void printNode(Node *node, bool isRoot);
  void closeOutputFiles();
// CUGeneration end

}; // end of class DiscoPoP
} // namespace

char DiscoPoP::ID = 0;

static RegisterPass<DiscoPoP> X("DiscoPoP", "DiscoPoP: finding potential parallelism.", false, false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM)
{
    PM.add(new LoopInfoWrapperPass());
    PM.add(new DiscoPoP());
}

static RegisterStandardPasses DiscoPoPLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses DiscoPoPLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

ModulePass *createDiscoPoPPass()
{
    if (DP_DEBUG)
    {
        errs() << "create DiscoPoP \n";
    }
    initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
    return new DiscoPoP();
}


#endif /*DISCOPOP_H*/
