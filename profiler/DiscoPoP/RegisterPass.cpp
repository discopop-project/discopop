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

#include "llvm/Config/llvm-config.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#if LLVM_VERSION_MAJOR >= 22
#include "llvm/Plugins/PassPlugin.h"
#else
#include "llvm/Passes/PassPlugin.h"
#endif
#include <iostream>

#include "llvm/Support/raw_ostream.h"

#include "DiscoPoP.hpp"
using llvm::createModuleToFunctionPassAdaptor;
using llvm::errs;
using llvm::Function;
using llvm::FunctionAnalysisManager;
using llvm::Module;
using llvm::ModuleAnalysisManager;
using llvm::ModulePassManager;
using llvm::OptimizationLevel;
using llvm::PassBuilder;
using llvm::PassInfoMixin;
using llvm::PassPluginLibraryInfo;
using llvm::PreservedAnalyses;
using llvm::ThinOrFullLTOPhase;

namespace {

struct DiscoPoPNewPmAdaptor : public PassInfoMixin<DiscoPoPNewPmAdaptor> {
  PreservedAnalyses run(Function& f, FunctionAnalysisManager& /*FAM*/) {
    errs() << "Running DiscoPoP pass on Function: " + f.getName().str() + " \n";
    // const ModuleAnalysisManager &MAM = AM.getResult<ModuleAnalysisManagerFunctionProxy>(F).getManager();
    return PreservedAnalyses::all();
  }

  PreservedAnalyses run(Module& m, ModuleAnalysisManager& mam) {
    errs() << "Running DiscoPoP pass on Module: \n";
    // const ModuleAnalysisManager &MAM = AM.getResult<ModuleAnalysisManagerFunctionProxy>(F).getManager();
    DiscoPoP().RunOnModule(m, mam);
    return PreservedAnalyses::none();
  }
};

}  // end anonymous namespace

PassPluginLibraryInfo GetPassPluginInfo() {
  const auto callback = [](PassBuilder& pb) {
#if LLVM_VERSION_MAJOR >= 20
    pb.registerPipelineEarlySimplificationEPCallback(
        [&](ModulePassManager& mpm, OptimizationLevel, ThinOrFullLTOPhase) {
          mpm.addPass(createModuleToFunctionPassAdaptor(DiscoPoPNewPmAdaptor()));
          mpm.addPass(DiscoPoPNewPmAdaptor());
          return true;
        });
#else
    pb.registerPipelineEarlySimplificationEPCallback([&](ModulePassManager& mpm, OptimizationLevel) {
      mpm.addPass(createModuleToFunctionPassAdaptor(DiscoPoPNewPmAdaptor()));
      mpm.addPass(DiscoPoPNewPmAdaptor());
      return true;
    });
#endif
  };

  return {LLVM_PLUGIN_API_VERSION, "discopop_new_pm_adaptor", "0.0.1", callback};
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() { return GetPassPluginInfo(); }
