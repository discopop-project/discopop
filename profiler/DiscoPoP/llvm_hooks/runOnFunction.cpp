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

#include "DiscoPoP.hpp"

using namespace llvm;
using namespace std;
using namespace dputil;

// Returns true if runOnFunction instruments F, i.e. F reports its entry and exit to the runtime.
// Calls to functions without instrumentation must not update the callpath state (see
// runOnBasicBlock): the runtime would wait for the callee's __dp_func_exit forever.
bool DiscoPoP::isInstrumentedFunction(Function &F) {
  if (F.isDeclaration()) {
    return false;
  }

  std::string dp_project_dir(dputil::getEnvOrDefault("DP_PROJECT_ROOT_DIR", "/"));

  SmallVector<std::pair<unsigned, MDNode *>, 4> MDs;
  F.getAllMetadata(MDs);
  bool funcDefinedInProject = false;
  for (auto &MD : MDs) {
    if (MDNode *N = MD.second) {
      if (auto *subProgram = dyn_cast<DISubprogram>(N)) {
        std::string fullFileName = "";
        if (subProgram->getDirectory().str().length() > 0) {
          fullFileName += subProgram->getDirectory().str();
          fullFileName += "/";
        }
        fullFileName += subProgram->getFilename().str();
        if (fullFileName.find(dp_project_dir) != string::npos) // function defined inside project
        {
          funcDefinedInProject = true;
        }
      }
    }
  }
  if (!funcDefinedInProject) {
    return false;
  }

  StringRef funcName = F.getName();
  // Avoid functions we don't want to instrument
  if (funcName.find("llvm.") != string::npos) // llvm debug calls
  {
    return false;
  }
  if (funcName.find("__dp_") != string::npos) // instrumentation calls
  {
    return false;
  }
  if (funcName.find("__cx") != string::npos) // c++ init calls
  {
    return false;
  }
  if (funcName.find("__clang") != string::npos) // clang helper calls
  {
    return false;
  }
  if (funcName.find("_GLOBAL_") != string::npos) // global init calls (c++)
  {
    return false;
  }
  if (funcName.find("pthread_") != string::npos) {
    return false;
  }

  return getCachedFileID(F) != 0;
}

int32_t DiscoPoP::getCachedFileID(Function &F) {
  auto pos = file_id_cache.find(&F);
  if (pos != file_id_cache.end()) {
    return pos->second;
  }
  int32_t file_id = 0;
  determineFileID(F, file_id);
  file_id_cache[&F] = file_id;
  return file_id;
}

// The pass processes a function in four stages, in this order. None of them can run on its own,
// or for all functions before the next one starts:
//  1. buildCUGraph: the CU graph of the uninstrumented function (the calls inserted later would
//     split its CUs). It renames the unnamed basic blocks to CU ids, which CFA reads.
//  2. instrumentFunction: CFA needs the ids of the loop nodes of the CU graph. Inserts the
//     callbacks and assigns the instruction ids (dp.md.instr.id) in one walk over the function;
//     the loop and function entry calls are inserted before it, so they get ids, too.
//  3. writeCUGraph: Data.xml names the instruction ids of the calls.
//  4. runHybridAnalysis: needs the instruction ids and the inserted access callbacks (it erases
//     those of the accesses it predicts statically). Its own instructions are inserted after the
//     walk, so they get no ids.
// State kept across functions makes the order of the functions matter as well:
// trueVarNamesFromMetadataMap grows per function (and the hybrid analysis adds an empty name for
// locals without a debug record, which later functions then use), so does
// programGlobalVariablesSet, and the loop ids are assigned in this order. No stage changes the
// control flow graph, so the analyses taken from MAM (LoopInfo, RegionInfo, DominatorTree) stay
// valid and are never invalidated; the reduction pass relies on getting the same llvm::Loop
// objects, as its loop ids are registered per llvm::Loop.
bool DiscoPoP::runOnFunction(Function &F, ModuleAnalysisManager &MAM) {
  if (DP_DEBUG) {
    errs() << "pass DiscoPoP: run pass on function " << F.getName().str() << "\n";
  }

  // avoid instrumenting functions which are defined outside the scope of the
  // project, as well as helper and instrumentation functions
  if (!isInstrumentedFunction(F)) {
    return false;
  }

  FunctionCUGraph graph;
  // Created before fileID is set below: the ID of the function node holds the file id of the
  // function processed before (0 for the first one), as it always did in Data.xml.
  graph.root = new Node;

  fileID = getCachedFileID(F);

  // only instrument functions belonging to project source files
  if (!fileID)
    return false;

  buildCUGraph(F, MAM, graph);
  instrumentFunction(F, MAM, graph);
  writeCUGraph(graph);
  return runHybridAnalysis(F, MAM);
}

// CUGeneration
void DiscoPoP::buildCUGraph(Function &F, ModuleAnalysisManager &MAM, FunctionCUGraph &graph) {
  /********************* Initialize root values ***************************/
  graph.root->name = F.getName().str();
  graph.root->type = nodeTypes::func;

  // Get list of arguments for this function and store them in root.
  // NOTE: changed the way we get the arguments
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
    Variable v(it->getName().str(), rso.str(), to_string(fileID) + ":" + lid, true, true);
    graph.root->argumentsList.push_back(v);
  }
  /********************* End of initialize root values
   * ***************************/

  llvm::FunctionAnalysisManager &fam = MAM.getResult<FunctionAnalysisManagerModuleProxy>(*ThisModule).getManager();
  llvm::LoopInfo &LI = fam.getResult<llvm::LoopAnalysis>(F);
  //LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();


  // get the top level region

  //RIpass = &getAnalysis<RegionInfoPass>(F);
  //RI = &(RIpass->getRegionInfo());
  //RegionInfoPass *RIpass;
  llvm::RegionInfo &RI = fam.getResult<llvm::RegionInfoAnalysis>(F);

  Region *TopRegion = RI.getTopLevelRegion();

  getTrueVarNamesFromMetadata(TopRegion, graph.root, &trueVarNamesFromMetadataMap);

  getFunctionReturnLines(TopRegion, graph.root);

  populateGlobalVariablesSet(TopRegion, graph.globalVariables);

  createCUs(TopRegion, graph.globalVariables, graph.CUs, graph.BBIDToCUs, graph.root, LI, MAM);

  // inserts calls, but only after createCUs has seen the function without them
  if (DP_BRANCH_TRACKING) {
    createTakenBranchInstrumentation(TopRegion, graph.BBIDToCUs);
  }

  fillCUVariables(TopRegion, graph.globalVariables, graph.CUs, graph.BBIDToCUs);

  fillStartEndLineNumbers(graph.root, LI, graph.loopToPETNodeID);

  secureStream();

  // printOriginalVariables(originalVariablesSet);

  /*printData(root);

  for (auto i : CUVector) {
    delete (i);
  }*/
}
// CUGeneration end

// DPInstrumentation
void DiscoPoP::instrumentFunction(Function &F, ModuleAnalysisManager &MAM, const FunctionCUGraph &graph) {
  // Check loop parallelism?
  if (ClCheckLoopPar) {
    llvm::FunctionAnalysisManager &fam = MAM.getResult<FunctionAnalysisManagerModuleProxy>(*ThisModule).getManager();
    llvm::LoopInfo &LI = fam.getResult<llvm::LoopAnalysis>(F);
    //LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();
    CFA(F, LI, graph.loopToPETNodeID);
  }

  // Instrument the entry of the function.
  // Each function entry is instrumented, and the first
  // executed function will initialize shadow memory.
  // See the definition of __dp_func_entry() for detail.
  instrumentFuncEntry(F);

  // Traverse all instructions, collect loads/stores/returns, check for calls.
  insertedAccessCallbacks.clear();
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    runOnBasicBlock(BB);
  }

  if (DP_DEBUG) {
    errs() << "pass DiscoPoP: finished function\n";
  }
}
// DPInstrumentation end

// Print CU Graph
void DiscoPoP::writeCUGraph(FunctionCUGraph &graph) {
  printData(graph.root);

  for (auto i : graph.CUs) {
    delete (i);
  }
}
// Print CU Graph end
