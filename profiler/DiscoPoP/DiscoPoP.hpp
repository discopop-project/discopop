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

#pragma once

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/PassRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"

#if __has_include(<llvm/Transforms/IPO/PassManagerBuilder.h>)
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#endif

#if __has_include(<llvm/Transforms/Instrumentation.h>)
#include <llvm/Transforms/Instrumentation.h>
#endif

#if __has_include(<llvm/Passes/PassBuilder.h>)
#include <llvm/Passes/PassBuilder.h>
#endif

#include "DPUtils.hpp"
#include "utils/profiler_files.hpp"
#include "hybrid_analysis/InstructionDG.hpp"
#include "static_analysis/StaticCalltree.hpp"
#include "static_analysis/StaticCallPathTree.hpp"
#include "static_analysis/static_callpaths.hpp"

#include "Structs.hpp"

#include <algorithm>
#include <cstdlib>
#include <iomanip>
#include <map>
#include <set>
#include <string.h>
#include <unordered_map>
#include <unordered_set>
#include <utility>

#include <sys/stat.h>
#include <sys/types.h>

// The function called by the call or invoke I, looking through pointer casts and aliases, or
// nullptr for an indirect call. Clang emits the complete-object constructor (C1) of a class without
// virtual bases as an alias of the base-object constructor (C2), so `new T(...)` and `T t(...)` call
// an alias, for which CallBase::getCalledFunction returns nullptr.
inline llvm::Function *getCalledFunctionThroughAliases(llvm::Instruction *I) {
  auto *CB = llvm::dyn_cast<llvm::CallBase>(I);
  if (CB == nullptr || CB->getCalledOperand() == nullptr) {
    return nullptr;
  }
  return llvm::dyn_cast<llvm::Function>(CB->getCalledOperand()->stripPointerCastsAndAliases());
}

// the unique instruction id assigned to I (metadata "dp.md.instr.id"), or 0 if it has none
inline int32_t get_dp_instruction_id(llvm::Instruction *I) {
  llvm::MDNode *md = I->getMetadata("dp.md.instr.id");
  if (md == nullptr) {
    return 0;
  }
  std::string id_str = llvm::cast<llvm::MDString>(md->getOperand(0))->getString().str();
  id_str.erase(0, 15); // "dp.md.instr.id:"
  return std::stoi(id_str);
}

#include <stdlib.h>

#include "Globals.hpp"

constexpr bool DP_DEBUG = false;

constexpr bool ClCheckLoopPar = true;
constexpr bool DumpToDot = false;
constexpr bool DP_VERBOSE = false; // prints warning messages
constexpr bool DP_hybrid_DEBUG = false;


/*
// Command line options
static cl::opt<bool> ClCheckLoopPar("dp-loop-par", cl::init(true), cl::desc("Check loop parallelism"), cl::Hidden);

static cl::opt<bool> DumpToDot("dp-omissions-dump-dot", cl::init(false),
                               cl::desc("Generate a .dot representation of the CFG and DG"), cl::Hidden);
*/

class DiscoPoP { // : public ModulePass, public PassInfoMixin<DiscoPoP> {
private:
  // CUGeneration

  std::ofstream outCUs;
  std::ofstream outOriginalVariables;
  // Mohammad 23.12.2020
  std::map<std::string, std::string> loopStartLines;
  // id of the loop node in Data.xml, per llvm::Loop of the function processed last
  // (filled by fillStartEndLineNumbers, read by CFA for loopstate_positions.txt)
  std::map<llvm::Loop *, std::string> loopToPETNodeID;

  // structures to get list of global variables
  std::set<std::string> programGlobalVariablesSet;
  // structures to get actual variable names from llvm replacements
  std::map<std::string, std::string> trueVarNamesFromMetadataMap;

  // CUGeneration end

  // DPInstrumentation
  // Initializations
  void setupDataTypes();

  void setupCallbacks();

  // Helper functions
  bool isaCallOrInvoke(llvm::Instruction *BI);

  bool sanityCheck(llvm::BasicBlock *BB);

  // the LID as the first argument of a callback: a 64 bit constant (the runtime's LID type) holding the
  // 32 bit packed location, i.e. the value the pass has always passed, zero extended
  llvm::Constant *lidConstant(LID lid) { return llvm::ConstantInt::get(Int64, static_cast<uint32_t>(lid)); }

  // LID to report for leaving the loop L through the exit block BB (see CFA)
  LID getLoopExitLID(llvm::BasicBlock *BB, llvm::Loop *L);

  void collectDebugInfo();

  void processStructTypes(std::string const &fullStructName, llvm::MDNode *structNode);

  llvm::DIGlobalVariable *findDbgGlobalDeclare(llvm::GlobalVariable *V);

  llvm::Value *getOrInsertVarName_dynamic(std::string varName, llvm::IRBuilder<> &builder);

  std::string getOrInsertVarName_static(std::string varName, llvm::IRBuilder<> &builder);

  llvm::Value *findStructMemberName(llvm::MDNode *structNode, unsigned idx, llvm::IRBuilder<> &builder);

  llvm::Type *pointsToStruct(llvm::PointerType *PTy);

  llvm::Value *determineVariableName_dynamic(llvm::Instruction *const I, std::string prefix);

  std::string determineVariableName_static(llvm::Instruction *I, bool &isGlobalVariable /*=defaultIsGlobalVariableValue*/,
                                      bool disable_MetadataMap, std::string prefix);

  void getTrueVarNamesFromMetadata(llvm::Region *TopRegion, Node *root,
                                   std::map<std::string, std::string> *trueVarNamesFromMetadataMap);

  // Control flow analysis
  void CFA(llvm::Function &F, llvm::LoopInfo &LI);

  // Callback Inserters
  // void insertDpFinalize(Instruction *before);
  void instrumentAlloca(llvm::AllocaInst *toInstrument);

  void instrumentNewOrMalloc(llvm::CallBase *toInstrument);
  void instrumentRealloc(llvm::CallBase *toInstrument);
  void instrumentCalloc(llvm::CallBase *toInstrument);
  void instrumentPosixMemalign(llvm::CallBase *toInstrument);

  void instrumentDeleteOrFree(llvm::CallBase *toInstrument);

  void instrumentStore(llvm::StoreInst *toInstrument, int32_t llvm_ir_instruction_id);

  void instrumentLoad(llvm::LoadInst *toInstrument, int32_t llvm_ir_instruction_id);

  void insertDpFinalize(llvm::Instruction *before);

  void instrumentFuncEntry(llvm::Function &F);

  void instrumentLoopEntry(llvm::BasicBlock *bb, int32_t id);

  void instrumentLoopExit(llvm::BasicBlock *bb, int32_t id, llvm::Loop *L);

  int64_t uniqueNum;

  // Callbacks to run-time library
  llvm::FunctionCallee DpFinalize;
  llvm::FunctionCallee DpRead, DpWrite;
  llvm::FunctionCallee DpAlloca, DpNew, DpDelete; //, DpDecl;
  llvm::FunctionCallee DpCallOrInvoke;
  llvm::FunctionCallee DpFuncEntry, DpFuncExit;
  llvm::FunctionCallee DpLoopEntry, DpLoopExit;
  llvm::FunctionCallee DpTakenBranchCounterIncr;

  // Basic types
  llvm::Type *Void;
  llvm::IntegerType *Int8, *Int32, *Int64;
  llvm::PointerType *CharPtr;

  // Control flow analysis
  int32_t loopID;

  // Output streams
  std::ofstream ocfg;

  // Export Module M from runOnModule() to the whole structure space
  llvm::Module *ThisModule;
  llvm::LLVMContext *ThisModuleContext;

  // The __dp_read / __dp_write / __dp_alloca call inserted for a load, store or alloca. The
  // omission analysis erases the ones whose instruction it can predict statically, and it
  // used to find them as the neighbour of that instruction -- which stops being true as soon
  // as anything moves the two apart, and then silently left the call in place. Filled while
  // instrumenting one function, cleared when the next one starts.
  std::map<llvm::Instruction *, llvm::CallInst *> insertedAccessCallbacks;

  std::map<std::string, llvm::Value *> VarNames;
  std::set<llvm::DIGlobalVariable *> GlobalVars;
  std::map<std::string, llvm::MDNode *> Structs;
  // DPInstrumentation end

  // DPInstrumentationOmission
  std::string bbDepString;
  std::string fileName;
  int32_t fid;
  llvm::FunctionCallee ReportBB, ReportBBPair, BBState;
  dputil::VariableNameFinder *VNF;
  int nextFreeStaticMemoryRegionID;

  // DPInstrumentationOmission end

  // InstructionID assignment
  uint32_t unique_llvm_ir_instruction_id;
  uint32_t unique_callpath_state_id;

public:
  DiscoPoP() : uniqueNum(1){}; // : ModulePass(ID), uniqueNum(1){};

  ~DiscoPoP();

  bool runOnModule(llvm::Module &M, llvm::ModuleAnalysisManager &MAM);

  bool runOnFunction(llvm::Function &F, llvm::ModuleAnalysisManager &MAM);

  void runOnBasicBlock(llvm::BasicBlock &BB);

  bool doInitialization(llvm::Module &M);

  bool doFinalization(llvm::Module &M);

  static char ID; // Pass identification, replacement for typeid

  // CUGeneration

  // DiscoPoP Functions
  std::string determineVariableType(llvm::Instruction *I);

  std::string determineVariableDefLine(llvm::Instruction *I);

  void getFunctionReturnLines(llvm::Region *TopRegion, Node *root);

  int32_t get_or_register_loop_id(llvm::Loop* L);

  // functions to get list of global variables

  // functions to get recursive functions (Mo 5.11.2019)
  bool isRecursive(llvm::Function &F, llvm::CallGraph &CG);

  // Populate variable sets global to BB
  void populateGlobalVariablesSet(llvm::Region *TopRegion, std::set<std::string> &globalVariablesSet);

  void createCUs(llvm::Region *TopRegion, std::set<std::string> &globalVariablesSet, std::vector<CU *> &CUVector,
                 std::map<std::string, std::vector<CU *>> &BBIDToCUIDsMap, Node *root, llvm::LoopInfo &LI, llvm::ModuleAnalysisManager &MAM);

  void createTakenBranchInstrumentation(llvm::Region *TopRegion, std::map<std::string, std::vector<CU *>> &BBIDToCUIDsMap);

  bool isInstrumentedFunction(llvm::Function &F);
  // determineFileID, cached per function of the current module (the lookup walks the function and
  // resolves its file path)
  int32_t getCachedFileID(llvm::Function &F);
  std::unordered_map<const llvm::Function *, int32_t> file_id_cache;
  void assign_instruction_ids_to_dp_reduction_functions(llvm::Module &M);
  void update_argument_instruction_ids(llvm::Module &M);
  void instrument_landing_pads(llvm::Module &M);

  void fillCUVariables(llvm::Region *TopRegion, std::set<std::string> &globalVariablesSet, std::vector<CU *> &CUVector,
                       std::map<std::string, std::vector<CU *>> &BBIDToCUIDsMap);

  void fillStartEndLineNumbers(Node *root, llvm::LoopInfo &LI);

  void findStartEndLineNumbers(Node *root, LID &start, LID &end);

  // Output function
  void initializeCUIDCounter();
  void initializeBBDepCounter();
  void initializeInstructionIDCounter();
  void initializeCallpathStateIDCounter();

  std::string xmlEscape(std::string data);

  void secureStream();

  std::string getLineNumbersString(std::set<LID> LineNumbers);

  std::string getChildrenNodesString(Node *node);

  // void printOriginalVariables(set<string> &originalVariablesSet);
  void printData(Node *node);

  void printTree(Node *node, bool isRoot);

  void printNode(Node *node, bool isRoot);

  void closeOutputFiles();
  // CUGeneration end

  // DPReduction

  void instrument_module(llvm::Module *module, std::map<std::string, std::string> *trueVarNamesFromMetadataMap, llvm::ModuleAnalysisManager &mam);
  bool inlinedFunction(llvm::Function *F);
  void instrument_function(llvm::Function *function, std::map<std::string, std::string> *trueVarNamesFromMetadataMap, llvm::LoopInfo &loop_info);
  void instrument_loop(llvm::Function &F, int file_id, llvm::Loop *loop, llvm::LoopInfo &LI,
                       std::map<std::string, std::string> *trueVarNamesFromMetadataMap);
  std::string dp_reduction_CFA(llvm::Function &F, llvm::Loop *loop, int file_id);
  std::string dp_reduction_determineVariableName(llvm::Instruction *I, std::map<std::string, std::string> *trueVarNamesFromMetadataMap);
  std::string dp_reduction_determineVariableType(llvm::Instruction *I);
  llvm::Instruction *dp_reduction_get_reduction_instr(llvm::Instruction *store_instr, llvm::Instruction **load_instr);
  llvm::Instruction *dp_reduction_find_reduction_instr(llvm::Value *val);
  llvm::Instruction *dp_reduction_get_load_instr(llvm::Value *load_val, llvm::Instruction *cur_instr,
                                                 std::vector<char> &reduction_operations);
  llvm::Value *dp_reduction_points_to_var(llvm::GetElementPtrInst *instr);
  llvm::Value *dp_reduction_get_var(llvm::Instruction *instr);
  llvm::Value *dp_reduction_get_var_rec(llvm::Value *val);
  llvm::Instruction *dp_reduction_get_prev_use(llvm::Instruction *instr, llvm::Value *val);
  inline bool dp_reduction_loc_exists(llvm::DebugLoc const &loc) { return static_cast<bool>(loc); }
  unsigned dp_reduction_get_file_id(llvm::Function *func);
  bool dp_reduction_init_util(std::string fmap_path);
  char dp_reduction_get_char_for_opcode(llvm::Instruction *instr); //} // namespace
  int dp_reduction_get_op_order(char c);
  llvm::Type *dp_reduction_pointsToStruct(llvm::PointerType *PTy);
  std::string findStructMemberName_static(llvm::MDNode *structNode, unsigned idx, llvm::IRBuilder<> &builder);
  bool dp_reduction_sanityCheck(llvm::BasicBlock *BB, int file_id);
  LID dp_reduction_getLID(llvm::Instruction *BI, int32_t &fileID);
  void dp_reduction_insert_functions();
  bool check_value_usage(llvm::Value *parentValue, llvm::Value *searchedValue);
  std::ofstream reduction_file;
  std::ofstream loop_counter_file;
  std::ofstream instructionID_to_lineID_file;
  std::vector<loop_info_t> loops_;
  std::vector<instr_info_t> instructions_;
  std::map<std::string, int> path_to_id_;
  std::map<llvm::Loop*, int> loop_to_id;
  // per loop id of the current module: id of its loop node in Data.xml and its start
  // location (file_id:line), as written to loopstate_positions.txt
  std::map<int32_t, LoopIdentity> loop_id_to_identity;

  // DPReduction end

}; // end of class DiscoPoP
