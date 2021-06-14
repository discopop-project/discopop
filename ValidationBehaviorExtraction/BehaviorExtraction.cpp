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
        string name;
        string mode;
        pair<unsigned int, unsigned int> codeLocation;
        Instruction* parentInstruction;
    };

    struct BBGraphNode{
        unsigned int bbIndex;
        BasicBlock* bb;
        list<sharedVarAccess> varAccesses;
    };

    struct relevantSection
    {
        string filePath;
        unsigned int startLine;
        unsigned int endLine;
        string varName;
    };

    struct BehaviorExtraction : public FunctionPass
    {
        static char ID;
        virtual bool runOnFunction(Function &F);
        StringRef getPassName() const;
        BehaviorExtraction() : FunctionPass(ID) {}
        bool doInitialization(Module &M);
        list<relevantSection> sections;
        pair<int, int> getClosestCodeLocation(Instruction* inst);
        map<BasicBlock*, BBGraphNode> bbToGraphNodeMap;
        string getParentFileNameFromFunction(Function &F);
        list<sharedVarAccess> getSharedVarAccesses(BasicBlock &BB);
        unsigned int nextFreeBBId;
        unsigned int getNextFreeBBId();

    }; // end of struct BehaviorExtraction

} // end of anonymous namespace


unsigned int BehaviorExtraction::getNextFreeBBId(){
    unsigned int tmp = nextFreeBBId;
    nextFreeBBId++;
    return tmp;
}


pair<int, int> BehaviorExtraction::getClosestCodeLocation(Instruction* inst){
    pair<int, int> returnLocation(-1, -1);
    if(inst){
        Instruction* curInst = inst;
        while(curInst){
            if(curInst->hasMetadata()){
                returnLocation = pair<int, int>(curInst->getDebugLoc().getLine(), curInst->getDebugLoc().getCol());
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
                                // dp write to array with known name
                                sharedVarAccess access;
                                access.name = gepinst->getPointerOperand()->getName();
                                access.mode = "w";
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            } else {
                                // dp write to array with unknown name
                                sharedVarAccess access;
                                access.name = "##UNKNOWN##";
                                access.mode = "w";
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            }

                        } else if (ci->getCalledFunction()->getName().equals("__dp_read")) {
                            // next instruction is call to __dp_read
                            if(gepinst->getPointerOperand()->hasName()){
                                // dp read from array with known name
                                sharedVarAccess access;
                                access.name = gepinst->getPointerOperand()->getName();
                                access.mode = "r";
                                access.codeLocation = getClosestCodeLocation(ci);
                                access.parentInstruction = &inst;
                                resultList.push_back(access);
                            } else{
                                // dp read from array with unknown name
                                sharedVarAccess access;
                                access.name = "##UNKNOWN##";
                                access.mode = "r";
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
                            // dp write to var with known name
                            sharedVarAccess access;
                            access.name = ptrinst->getPointerOperand()->getName();
                            access.mode = "w";
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                        else{
                            // dp write to var with unknown name
                            sharedVarAccess access;
                            access.name = "##UNKNOWN##";
                            access.mode = "w";
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }

                    }
                    else if (ci->getCalledFunction()->getName().equals("__dp_read")){
                        // next instruction is call to __dp_read
                        if(ptrinst->getPointerOperand()->hasName()){
                            // dp read from var with known name
                            sharedVarAccess access;
                            access.name = ptrinst->getPointerOperand()->getName();
                            access.mode = "r";
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                        else{
                            // dp read from var with unknown name
                            sharedVarAccess access;
                            access.name = "##UNKNOWN##";
                            access.mode = "r";
                            access.codeLocation = getClosestCodeLocation(ci);
                            access.parentInstruction = &inst;
                            resultList.push_back(access);
                        }
                    }
                }
            }
        }

        // todo include function calls
    }
    return resultList;
}


bool BehaviorExtraction::runOnFunction(Function &F)
{
    string parentFileName = getParentFileNameFromFunction(F);

    // initialize bbToGraphNodeMap
    for(auto &BB : F.getBasicBlockList()){
        BBGraphNode graphNode;
        graphNode.bbIndex = getNextFreeBBId();
        pair<BasicBlock*, BBGraphNode> p(&BB, graphNode);
        bbToGraphNodeMap.insert(p);
    }

    // open output file
    ofstream outputFile(ClOutputFile);

    // fill output file
    outputFile << "function:" << F.getName().str() << "\n";
    outputFile << "fileName:" << parentFileName << "\n";

    for(auto &BB : F.getBasicBlockList()){
        // construct BBGraphNode for current BB
        BBGraphNode graphNode = bbToGraphNodeMap.at(&BB);
        outputFile << "bbIndex:" << graphNode.bbIndex << "\n";
        graphNode.bb = &BB;
        graphNode.varAccesses = getSharedVarAccesses(BB);
        for(auto successorBB: successors(&BB)){
            outputFile << "successor:" << bbToGraphNodeMap.at(successorBB).bbIndex << "\n";
        }

        // add var accesses and function calls to output file
        for(auto sva : graphNode.varAccesses){
            // only report operation, if it is inside of a relevant section
            for(auto section : sections){
                if(parentFileName.compare(section.filePath) == 0){
                    if(sva.name.compare(section.varName) == 0){
                        if(sva.codeLocation.first >= section.startLine && sva.codeLocation.first <= section.endLine){
                            outputFile << "operation:" << sva.mode << ":" << sva.name << ":" << sva.codeLocation.first
                                       << ":" << sva.codeLocation.second << "\n";
                        }
                    }
                }
            }
        }

        // set function entrypoint if necessary
        BasicBlock* x = &(F.getEntryBlock());
        if(&BB == x){
            outputFile << "functionEntryBB:" << graphNode.bbIndex << "\n";
        }

    }

    outputFile.close();

    return false;
}

// todo in python: remove empty BB blocks, which are not part of any branching (combine with previous node)
// todo in python: remove branched sections, if no R/W information is contained


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
    //set first bb id to 0;
    nextFreeBBId = 0;

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
        sections.push_back(curSection);
    }
    inputFile.close();
}

// todo only consider relevantSections
// todo treat function calls inside relevant section as "inlined"

StringRef BehaviorExtraction::getPassName() const
{
    return "BehaviorExtraction";
}
