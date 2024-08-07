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

bool DiscoPoP::doInitialization(Module &M) {
  if (DP_DEBUG) {
    errs() << "DiscoPoP | 190: init pass DiscoPoP \n";
  }

  // prepare environment variables
  char const *tmp = getenv("DOT_DISCOPOP");
  if (tmp == NULL) {
    // DOT_DISCOPOP needs to be initialized
    setenv("DOT_DISCOPOP", ".discopop", 1);
  }
  std::string tmp_str(getenv("DOT_DISCOPOP"));
  setenv("DOT_DISCOPOP_PROFILER", (tmp_str + "/profiler").data(), 1);

  // prepare .discopop directory if not present
  struct stat st1 = {0};
  if (stat(getenv("DOT_DISCOPOP"), &st1) == -1) {
    mkdir(getenv("DOT_DISCOPOP"), 0777);
  }
  // prepare profiler directory if not present
  struct stat st2 = {0};
  if (stat(getenv("DOT_DISCOPOP_PROFILER"), &st2) == -1) {
    mkdir(getenv("DOT_DISCOPOP_PROFILER"), 0777);
  }

  // prepare target directory if not present
  char const *tmp2 = getenv("DP_PROJECT_ROOT_DIR");
  if (tmp2 == NULL) {
    // DP_PROJECT_ROOT_DIR needs to be initialized
    std::cerr << "\nWARNING: No value for DP_PROJECT_ROOT_DIR found. \n";
    std::cerr << "         As a result, library functions might be "
                 "instrumented which can lead to\n";
    std::cerr << "         increased profiling times and unexpected behavior.\n";
    std::cerr << "         Please consider to specify the environment variable "
                 "and rebuild.\n";
    std::cerr << "         "
                 "https://discopop-project.github.io/discopop/setup/"
                 "environment_variables/\n\n";
    // define fallback
    setenv("DP_PROJECT_ROOT_DIR", "/", 1);
  }

  // CUGeneration
  {
    CUIDCounter = 0;
    defaultIsGlobalVariableValue = false;
    ThisModule = &M;
    outCUIDCounter = NULL;

    initializeCUIDCounter();

    for (Module::global_iterator I = ThisModule->global_begin(); I != ThisModule->global_end(); I++) {
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

    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it) {
      GlobalVars.erase(it);
    }

    GlobalVars.clear();
    Structs.clear();
    collectDebugInfo();

    // Initialize variables needed
    setupDataTypes();
    setupCallbacks();

    // Check loop parallelism?
    if (ClCheckLoopPar) {
      if (DP_DEBUG) {
        errs() << "check loop parallelism \n";
      }
      loopID = 0;
    } else {
      loopID = -1;
    }

    // PerfoGraph compatibility
    unique_llvm_ir_instruction_id = 1;
  }
  // DPInstrumentation end

  // DPInstrumentationOmission
  {
    bbDepCount = 0;

    initializeBBDepCounter();

    ReportBB = M.getOrInsertFunction("__dp_report_bb", Void, Int32);
    ReportBBPair = M.getOrInsertFunction("__dp_report_bb_pair", Void, Int32, Int32);
    VNF = new dputil::VariableNameFinder(M);
    int nextFreeStaticMemoryRegionID = 0;
  }
  // DPInstrumentationOmission end

  return true;
}
