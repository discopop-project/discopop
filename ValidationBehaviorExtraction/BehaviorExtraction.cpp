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

#include "llvm/Transforms/Instrumentation.h"
#include "llvm/ADT/ilist.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/Analysis/RegionIterator.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "llvm/PassAnalysisSupport.h"
#include "llvm/PassSupport.h"
#include "llvm-c/Core.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Analysis/CallGraph.h"
#include <llvm/IR/DebugLoc.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include "llvm/Analysis/TargetLibraryInfo.h"

#include "DPUtils.h"

#include <stack>
#include <utility>
#include <iomanip>
#include <algorithm>
#include <string.h>
#include <iostream>

using namespace llvm;
using namespace std;
using namespace dputil;

// Command line options
static cl::opt<string> ClInputFile("inputFile", cl::desc("path to input file"), cl::Hidden);
static cl::opt<string> ClOutputFile("outputFile", cl::desc("path to output file"), cl::Hidden);

namespace
{
    struct sharedVarAccess{
        string varName;
        bool read;
        bool write;
        string codeLocation;
        Instruction* parentInstruction;
    };

    struct BBGraphNode{
        BasicBlock* bb;
        list<BBGraphNode> nextBBs;
        list<sharedVarAccess> varAccesses;
    };

    struct relevantSection
    {
        string filePath;
        int startLine;
        int endLine;
        string varName;
    };

    struct BehaviorExtraction : public FunctionPass
    {
        static char ID;
        virtual bool runOnFunction(Function &F);
        StringRef getPassName() const;
        BehaviorExtraction() : FunctionPass(ID) {}
        bool doInitialization(Module &M);
        stack<relevantSection> sections;
        string getClosestCodeLocation(Instruction* inst);
        map<Function*, BBGraphNode> functionToBBGraphRootNodeMap;
        map<BasicBlock*, BBGraphNode> bbToGraphNodeMap;
        string getParentFileNameFromFunction(Function &F);
        list<sharedVarAccess> getSharedVarAccesses(BasicBlock &BB);
        void exportResultsToFile();
        void debugPrintBBGraph(BBGraphNode graphNode);

    }; // end of struct BehaviorExtraction

} // end of anonymous namespace


string BehaviorExtraction::getClosestCodeLocation(Instruction* inst){
    string returnLocation = "-1:-1";
    if(inst){
        Instruction* curInst = inst;
        while(curInst){
            if(curInst->hasMetadata()){
                returnLocation = "" + to_string(curInst->getDebugLoc().getLine()) + ":" + to_string(curInst->getDebugLoc().getCol());
                return returnLocation;
            }
            curInst = curInst->getNextNode();
        }
        return returnLocation;
    }
    else{
        return returnLocation;
    }
}


string BehaviorExtraction::getParentFileNameFromFunction(Function &F){
    string parentFileName = "";
    SmallVector<std::pair<unsigned, MDNode *>, 4> MDs;
    F.getAllMetadata(MDs);
    for (auto &MD : MDs) {
        if (MDNode *N = MD.second) {
            if (auto *subProgram = dyn_cast<DISubprogram>(N)) {
                parentFileName = parentFileName + subProgram->getFile()->getDirectory().str();
                parentFileName = parentFileName + "/";
                parentFileName = parentFileName + subProgram->getFile()->getFilename().str();
                break;
            }
        }
    }
    return parentFileName;
}


list<sharedVarAccess> BehaviorExtraction::getSharedVarAccesses(BasicBlock &BB){
    list<sharedVarAccess> resultList;

    for(auto &inst : BB.getInstList()){
        // option 1: single layer array access (getelementptr + ptrtoint + [__dp_read | __dp_write])
        // check if inst is getelementptr
        if(isa<GetElementPtrInst>(&inst)) {
            GetElementPtrInst *gepinst = cast<GetElementPtrInst>(&inst);
            // check if gepinst.next is ptrtoint
            if (isa<PtrToIntInst>(gepinst->getNextNode())) {
                PtrToIntInst *ptrinst = cast<PtrToIntInst>(gepinst->getNextNode());
                // check if next instruction is call to __dp_write or __dp_read
                if (ptrinst->getNextNode()) {
                    if (isa<CallInst>(ptrinst->getNextNode())) {
                        CallInst *ci = cast<CallInst>(ptrinst->getNextNode());
                        if (ci->getCalledFunction()->getName().equals("__dp_write")) {
                            // get line number of call from next instruction
                            // next instruction is call to __dp_write
                            if (gepinst->getPointerOperand()->hasName()) {
                                errs() << "next: __dp_write to ARR: " << gepinst->getPointerOperand()->getName()
                                       << " at " << getClosestCodeLocation(ci) << "\n";
                                sharedVarAccess access;
                                access.varName = gepinst->getPointerOperand()->getName();
                                access.read = false;
                                access.write = true;
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            } else {
                                errs() << "next: __dp_write: \n";
                                sharedVarAccess access;
                                access.varName = "##UNKNOWN##";
                                access.read = false;
                                access.write = true;
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            }

                        } else if (ci->getCalledFunction()->getName().equals("__dp_read")) {
                            // next instruction is call to __dp_read
                            if(gepinst->getPointerOperand()->hasName()){
                                errs() << "next: __dp_read to ARR: " << gepinst->getPointerOperand()->getName()
                                       << " at " << getClosestCodeLocation(ci) << "\n";
                                sharedVarAccess access;
                                access.varName = gepinst->getPointerOperand()->getName();
                                access.read = true;
                                access.write = false;
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            } else{
                                errs() << "next: __dp_read\n";
                                sharedVarAccess access;
                                access.varName = "##UNKNOWN##";
                                access.read = true;
                                access.write = false;
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            }
                        }
                    }
                }
            }
        }

        else

            // option 2: direct variable access (ptrtoint + [__dp_read | __dp_write])
            // check if inst is ptrtoint
        if(isa<PtrToIntInst>(&inst)){
            PtrToIntInst* ptrinst = cast<PtrToIntInst>(&inst);
            // check if next instruction is call to __dp_write or __dp_read
            if(inst.getNextNode()){
                if(isa<CallInst>(inst.getNextNode())){
                    CallInst* ci = cast<CallInst>(inst.getNextNode());
                    if(ci->getCalledFunction()->getName().equals("__dp_write")){
                        // next instruction is call to __dp_write
                        if(ptrinst->getPointerOperand()->hasName()){
                            errs() << "next: __dp_write to var: " << ptrinst->getPointerOperand()->getName()
                                   << " at " << getClosestCodeLocation(ci) << "\n";
                            sharedVarAccess access;
                            access.varName = ptrinst->getPointerOperand()->getName();
                            access.read = false;
                            access.write = true;
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                        else{
                            errs() << "next: __dp_write to var: \n";
                            sharedVarAccess access;
                            access.varName = "##UNKNOWN##";
                            access.read = false;
                            access.write = true;
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }

                    }
                    else if (ci->getCalledFunction()->getName().equals("__dp_read")){
                        // next instruction is call to __dp_read
                        if(ptrinst->getPointerOperand()->hasName()){
                            errs() << "next: __dp_read to var: " << ptrinst->getPointerOperand()->getName()
                                   << " at " << getClosestCodeLocation(ci) << "\n";
                            sharedVarAccess access;
                            access.varName = ptrinst->getPointerOperand()->getName();
                            access.read = true;
                            access.write = false;
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                        else{
                            errs() << "next: __dp_read\n";
                            sharedVarAccess access;
                            access.varName = "##UNKNOWN##";
                            access.read = true;
                            access.write = false;
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                    }
                }
            }
        }
    }
    return resultList;
}


bool BehaviorExtraction::runOnFunction(Function &F)
{
    string parentFileName = getParentFileNameFromFunction(F);

    // initialize bbToGraphNodeMap
    for(auto &BB : F.getBasicBlockList()){
        BBGraphNode graphNode;
        pair<BasicBlock*, BBGraphNode> p(&BB, graphNode);
        bbToGraphNodeMap.insert(p);
    }

    for(auto &BB : F.getBasicBlockList()){
        errs() << "BB\n";

        // construct BBGraphNode for current BB
        BBGraphNode graphNode;
        graphNode.bb = &BB;
        graphNode.varAccesses = getSharedVarAccesses(BB);
        for(auto successorBB: successors(&BB)){
            errs() << "\tsucc\n";
            graphNode.nextBBs.push_back(bbToGraphNodeMap.at(successorBB));
        }
        errs() << "\t-> len(nextBBs): " << graphNode.nextBBs.size() << "\n";

        // set function entrypoint if necessary
        BasicBlock* x = &(F.getEntryBlock());
        if(&BB == x){
            pair<Function*, BBGraphNode> p(&F, graphNode);
            functionToBBGraphRootNodeMap.insert(p);
        }

    }

    // DEBUG
    //debugPrintBBGraph(bbToGraphNodeMap(&(F.getBasicBlockList().front())));
    // ! DEBUG

    ofstream outputFile(ClOutputFile);
    outputFile << "Hello from LLVM!\n";
    outputFile.close();

    return false;
}

void BehaviorExtraction::debugPrintBBGraph(BBGraphNode graphNode){
    errs() << "NEW NODE\n";
    errs() << "\tnextBBs: " << graphNode.nextBBs.size() << "\n";
    errs() << "\tShared var accesses: ";
    for(auto sva : graphNode.varAccesses){
        if(sva.write){
            errs() << "W:" << sva.varName << "@" << sva.codeLocation << " ";
        }
        else{
            errs() << "R:" << sva.varName << "@" << sva.codeLocation << " ";
        }
    }
    errs() << "\n";
    for(auto succ : graphNode.nextBBs){
        errs() << "FOR\n";
        debugPrintBBGraph(succ);
    }
}


// todo construct BB block graph
// todo append shared var R/W information to BB blocks
// todo remove empty BB blocks, which are not part of any branching (combine with previous node)
// todo remove branched sections, if no R/W information is contained


void BehaviorExtraction::exportResultsToFile(){
    // todo;
}


char BehaviorExtraction::ID = 0;

static RegisterPass<BehaviorExtraction> X("BehaviorExtraction", "BehaviorExtraction: determine computation units.", false, false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM)
{
    PM.add(new LoopInfoWrapperPass());
    PM.add(new RegionInfoPass());
    PM.add(new BehaviorExtraction());
}

static RegisterStandardPasses BehaviorExtractionLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses BehaviorExtractionLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

FunctionPass *createBehaviorExtractionPass()
{

    initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
    initializeRegionInfoPassPass(*PassRegistry::getPassRegistry());
    return new BehaviorExtraction();
}

bool BehaviorExtraction::doInitialization(Module &M){
    errs() << "Initialization  -  Read Input file to stack\n";
    // read input file
    ifstream inputFile(ClInputFile);
    string line;
    string columnDelimiter = ";";
    while(getline(inputFile, line)){
        // store line contents on sections-stack
        string tmp[4];
        string token;
        int counter = 0;
        size_t pos = 0;
        while ((pos = line.find(columnDelimiter)) != std::string::npos) {
            token = line.substr(0, pos);
            line.erase(0, pos + columnDelimiter.length());
            tmp[counter] = token;
            counter++;
        }
        struct relevantSection curSection;
        curSection.filePath = tmp[0];
        curSection.startLine = stoi(tmp[1]);
        curSection.endLine = stoi(tmp[2]);
        curSection.varName = tmp[3];
        sections.push(curSection);
    }
    inputFile.close();

    errs() << "Initialization finished.\n";
}

// todo tread only relevantSections
// todo treat function calls inside relevant section as "inlined"

StringRef BehaviorExtraction::getPassName() const
{
    return "BehaviorExtraction";
}
