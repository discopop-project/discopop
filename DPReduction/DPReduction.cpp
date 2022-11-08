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

#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>

#include "llvm/ADT/StringRef.h"
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
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/InitializePasses.h"

#include "../DiscoPoP/DPReductionUtils.hpp"
#include "DPUtils.hpp"

using namespace llvm;
using namespace std;
using namespace dputil;


struct DPReduction : public llvm::ModulePass {
    static char ID;

    DPReduction() : ModulePass(ID) {}

    virtual bool runOnModule(llvm::Module &M) override;

    void getAnalysisUsage(llvm::AnalysisUsage &Info) const override;














    void getTrueVarNamesFromMetadata(Module &M, map <string, string> *trueVarNamesFromMetadataMap);

    map<string, MDNode *> Structs;
    map<string, Value *> VarNames;


    void create_function_bindings();



    StringRef getPassName() const override;
    std::map<int, llvm::Instruction *> loop_to_instr_;

    std::map <string, string> trueVarNamesFromMetadataMap;

    llvm::Function *add_instr_fn_;
    llvm::Function *add_ptr_instr_fn_;
    llvm::Function *loop_incr_fn_;
    llvm::Function *output_fn_;

    llvm::LLVMContext *ctx_;
    llvm::Module *module_;
};

// == LLVM setup ===============================================================
char DPReduction::ID = 0;
static llvm::RegisterPass <DPReduction> X("DPReduction", "Identify reduction variables", false,
                                          false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM) {
    PM.add(new LoopInfoWrapperPass());
    PM.add(new DPReduction());
}

static RegisterStandardPasses DPReductionLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses DPReductionLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

ModulePass *createDPReductionPass() {

    initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
    initializeRegionInfoPassPass(*PassRegistry::getPassRegistry());
    return new DPReduction();
}

StringRef DPReduction::getPassName() const {
    return "DPReduction";
}

// == Options ==================================================================
static llvm::cl::opt <std::string> fmap_file(
        "fm-path", llvm::cl::desc("<file mapping file>"), llvm::cl::Required);

// == Implementation ===========================================================

void DPReduction::getTrueVarNamesFromMetadata(Module &M, map <string, string> *trueVarNamesFromMetadataMap) {
    for (Function &F: M) {
        for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
            BasicBlock &BB = *FI;

            for (BasicBlock::iterator instruction = BB.begin(); instruction != BB.end(); ++instruction) {
                // search for call instructions to @llvm.dbg.declare
                if (isa<CallInst>(instruction)) {
                    Function *f = (cast<CallInst>(instruction))->getCalledFunction();
                    if (f) {
                        StringRef funcName = f->getName();
                        if (funcName.find("llvm.dbg.declar") != string::npos) // llvm debug calls
                        {
                            CallInst *call = cast<CallInst>(instruction);
                            // extract original and working variable name
                            string SRCVarName;
                            string IRVarName;

                            Metadata *Meta = cast<MetadataAsValue>(call->getOperand(0))->getMetadata();
                            if (isa<ValueAsMetadata>(Meta)) {
                                Value *V = cast<ValueAsMetadata>(Meta)->getValue();
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
}

















void DPReduction::getAnalysisUsage(llvm::AnalysisUsage &Info) const {
    Info.addRequired<llvm::LoopInfoWrapperPass>();
}

