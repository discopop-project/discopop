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

/*
 #include "DiscoPoP.hpp"

char DiscoPoP::ID = 0;

static RegisterPass<DiscoPoP> X("DiscoPoP", "DiscoPoP: finding potential parallelism.", false, false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM) {
  PM.add(new LoopInfoWrapperPass());
  PM.add(new DiscoPoP());
}

static RegisterStandardPasses DiscoPoPLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses DiscoPoPLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

ModulePass *createDiscoPoPPass() {
  if (DP_DEBUG) {
    errs() << "create DiscoPoP \n";
  }
  initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
  return new DiscoPoP();
}


*/


#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <iostream>
#include "DiscoPoP.hpp"
using namespace llvm;


namespace {

struct DiscoPoP_new_PM_adaptor : public PassInfoMixin<DiscoPoP_new_PM_adaptor> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    errs() << "Running DiscoPoP pass on Function: " + F.getName().str()  + " \n";
    //const ModuleAnalysisManager &MAM = AM.getResult<ModuleAnalysisManagerFunctionProxy>(F).getManager();
    return PreservedAnalyses::all();
  }

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
    errs() << "Running DiscoPoP pass on Module: \n";
    //const ModuleAnalysisManager &MAM = AM.getResult<ModuleAnalysisManagerFunctionProxy>(F).getManager();
    DiscoPoP().runOnModule(M, MAM);
    return PreservedAnalyses::all();
  }
};

} // end anonymous namespace



PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    PB.registerPipelineEarlySimplificationEPCallback(
        [&](ModulePassManager &MPM, auto) {
          MPM.addPass(createModuleToFunctionPassAdaptor(DiscoPoP_new_PM_adaptor()));
          MPM.addPass(DiscoPoP_new_PM_adaptor());
          return true;
        });
  };

  return {LLVM_PLUGIN_API_VERSION, "discopop_new_pm_adaptor", "0.0.1", callback};
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}
