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
        // for regular reads / writed, codeLocation and originLocation will be equal.
        // for reads / writes which occur as results of a function call, codeLocation will
        // contain the location of the function call, originLocation will contain
        // the location of the read / write inside the called function.
        pair<unsigned int, unsigned int> codeLocation;
        pair<unsigned int, unsigned int> originLocation;
        Instruction* parentInstruction;
    };

    struct BBGraphNode{
        unsigned int bbIndex;
        BasicBlock* bb;
        list<sharedVarAccess> varAccesses;
        pair<unsigned int, unsigned int> startLocation;
        pair<unsigned int, unsigned int> endLocation;
    };

    struct relevantSection
    {
        unsigned int sectionId;
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
        list<sharedVarAccess> getSharedVarAccesses(BasicBlock &BB, Function &F, bool currentlyInsideRecursion);
        string determineVarName(Instruction *const I);
        Type *pointsToStruct(PointerType *PTy);
        void processStructTypes(string const &fullStructName, MDNode *structNode);
        string findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder);
        void initializeStructs(BasicBlock &BB);
        list<sharedVarAccess> getVarAccessesForFunctionCall(Function* calledFunction, int arg_index, Function &F, bool currentlyInsideRecursion);
        unsigned int nextFreeBBId;
        unsigned int getNextFreeBBId();
        map<string, MDNode *> Structs;

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


void BehaviorExtraction::processStructTypes(string const &fullStructName, MDNode *structNode)
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


Type *BehaviorExtraction::pointsToStruct(PointerType *PTy)
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


string BehaviorExtraction::determineVarName(Instruction *const I)
{
    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL)
    {
        return "##UNKNOWN##";
    }

    if (operand->hasName())
    {   
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
                        string strName(structType->getStructName().data());
                        map<string, MDNode *>::iterator it = Structs.find(strName);
                        if (it != Structs.end())
                        {
                            string ret = findStructMemberName(it->second, memberIdx, builder);
                            return ret;
                        }
                    }
                }
            }

            // we've found an array
            if (PTy->getElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand))
            {
                return determineVarName((Instruction *)ptrOperand);
            }
            return determineVarName((Instruction *)gep);
        }

        // we've found a variable
        return string(operand->getName().data());
        
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand))
    {
        return determineVarName((Instruction *)(operand));
    }
    // if we cannot determine the name, then return Unknown
    return "##UNKNOWN##";
}


list<sharedVarAccess> BehaviorExtraction::getSharedVarAccesses(BasicBlock &BB, Function &F, bool currentlyInsideRecursion=false){
    list<sharedVarAccess> resultList;

    for(auto &inst : BB.getInstList()){
        if(isa<CallInst>(inst)){
            CallInst *ci = cast<CallInst>(&inst);
            if(ci->getCalledFunction()){
                if (ci->getCalledFunction()->getName().equals("__dp_write")) {
                    // next instruction is a store
                    sharedVarAccess access;
                    access.name = determineVarName(ci->getNextNode());
                    access.mode = "w";
                    access.codeLocation = getClosestCodeLocation(ci);
                    access.originLocation = access.codeLocation;
                    access.parentInstruction = &inst;
                    resultList.push_back(access);
                }
                else if (ci->getCalledFunction()->getName().equals("__dp_read")) {
                    // next instruction is a load
                    sharedVarAccess access;
                    access.name = determineVarName(ci->getNextNode());
                    access.mode = "r";
                    access.codeLocation = getClosestCodeLocation(ci);
                    access.originLocation = access.codeLocation;
                    access.parentInstruction = &inst;
                    resultList.push_back(access);
                }
                else if (ci->getCalledFunction()->getName().equals("__dp_call")) {
                    // next instruction is a function call
                    // check if recursive of regular function call
                    CallInst *call = cast<CallInst>(ci->getNextNode());
                    if(call->getCalledFunction()){
                        // iterate over call arguments
                        int position = 0;

                        for(auto arg = call->arg_begin(); arg != call->arg_end(); ++arg){
                            string argName;
                            // exclude constants
                            if(isa<Constant>(arg->get())){
                                // constant used as argument
                                argName = "##UNKNOWN##";
                            }
                            else{
                                // argument is not a constant
                                argName = determineVarName(cast<Instruction>(arg->get()));
                            }
                            if(argName.compare("##UNKNOWN##") != 0){
                                // argument has a known name
                                // errs() << "\tArg " << position <<" : " << argName << "\n";
                                list<sharedVarAccess> accessesFromCall;
                                // check if recursive function call
                                if(call->getCalledFunction() == &F){
                                    // recursion
                                    // check if already inside recursion
                                    if(!currentlyInsideRecursion){
                                        // go into recursion
                                        accessesFromCall = getVarAccessesForFunctionCall(call->getCalledFunction(), position, F, true);
                                    }
                                    // else: ignore recursive call

                                }
                                else {
                                    // no recursion
                                    accessesFromCall = getVarAccessesForFunctionCall(call->getCalledFunction(), position, F, false);
                                }
                                // append gathered accesses to result List, effectively inlining the called functions' results
                                for(sharedVarAccess sva : accessesFromCall){
                                    // overwrite argument name from withing called function with var name used in the function call
                                    // this step also resolves: var.addr to var
                                    // errs() << "\t\tmatching: " << sva.name << " -> " << argName << "\n";
                                    // errs() << "\t\t\tmode: " << sva.mode << "\n";
                                    sva.name = argName;
                                    // overwrite code location with location of function call
                                    sva.codeLocation = getClosestCodeLocation(ci);
                                    resultList.push_back(sva);
                                }
                            }
                            position++;
                        }
                    }
                }
            }
        }
    }
    // todo include function calls
    return resultList;
}


// returns a list of read an write accesses for the argument at the given index of calledFunction
// recursively constructs a list for subsequent function calls.
// TODO: could get costly, caching required
// TODO: support recursive function calls -> add recursion condition
list<sharedVarAccess> BehaviorExtraction::getVarAccessesForFunctionCall(Function* calledFunction, int argIndex, Function &F, bool currentlyInsideRecursion)
{
    list<sharedVarAccess> accesses;
    // get argument
    string argName = std::next(calledFunction->arg_begin(), argIndex)->getName().str();
    string argPtrName = argName + ".addr";

    // check for accesses to the argument
    for(auto &BB : calledFunction->getBasicBlockList()){
        list<sharedVarAccess> bbAccesses = getSharedVarAccesses(BB, *calledFunction, currentlyInsideRecursion);
        // filter bbAccesses for argName / argPtrName
        for(sharedVarAccess sva : bbAccesses){
            if(sva.name.compare(argName) == 0 || sva.name.compare(argPtrName) == 0){
                // access to arg, append entry to accesses
                sharedVarAccess access;
                access.name = sva.name;
                access.mode = "c" + sva.mode;
                access.codeLocation = sva.codeLocation;
                access.originLocation = sva.originLocation;
                access.parentInstruction = sva.parentInstruction;
                accesses.push_back(access);
            }
        }
    }
    return accesses;
}


string BehaviorExtraction::findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder)
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
            return dyn_cast<MDString>(member->getOperand(3))->getString();
    }
    return "##UNKNOWN##";
}


void BehaviorExtraction::initializeStructs(BasicBlock &BB){
    for(BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI){
        if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI))
        {
            assert(DI->getOperand(0));
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
    }
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

    // initialize Structs
    for(auto &BB : F.getBasicBlockList()){
        initializeStructs(BB);
    }

    // check if function is contained in scoped file
    bool function_in_scoped_file = false;
    for(auto section : sections) {
        if (parentFileName.compare(section.filePath) == 0) {
            function_in_scoped_file = true;
            break;
        }
    }
    if(!function_in_scoped_file){
        return false;
    }

    // open output file
    ofstream outputFile(ClOutputFile, std::ios_base::app);
    // fill output file
    outputFile << "function:" << F.getName().str() << "\n";
    outputFile << "fileName:" << parentFileName << "\n";
    outputFile.close();

    // get shared var accesses
    for(auto &BB : F.getBasicBlockList()){
        ofstream tmpOutputFile(ClOutputFile, std::ios_base::app);
        // construct BBGraphNode for current BB
        BBGraphNode graphNode = bbToGraphNodeMap.at(&BB);
        graphNode.bb = &BB;
        graphNode.varAccesses = getSharedVarAccesses(BB, F);
        graphNode.startLocation = getClosestCodeLocation(cast<Instruction>(unwrap(LLVMGetFirstInstruction(wrap(&BB)))));
        graphNode.endLocation = getClosestCodeLocation(cast<Instruction>(unwrap(LLVMGetLastInstruction(wrap(&BB)))));
        // check if BB is inside scope
        list<unsigned int> bb_in_sections;
        for(auto section : sections){
            if(graphNode.startLocation.first >= section.startLine && graphNode.endLocation.first <= section.endLine){
                // errs() << "section: " << section.startLine << " -- " << section.endLine << "\n";
                // errs() << "graphNode: " << graphNode.startLocation.first << ":" << graphNode.startLocation.second << " -- " << graphNode.endLocation.first << ":" << graphNode.endLocation.second << "\n";
                bb_in_sections.push_back(section.sectionId);
            }
        }
        if(bb_in_sections.size() == 0){
            continue;
        }
        tmpOutputFile << "bbIndex:" << graphNode.bbIndex << "\n";
        tmpOutputFile << "bbName:" << LLVMGetBasicBlockName(wrap(&BB)) << "\n";
        tmpOutputFile << "bbStart:" << graphNode.startLocation.first << ":" << graphNode.startLocation.second << "\n";
        tmpOutputFile << "bbEnd:" << graphNode.endLocation.first << ":" << graphNode.endLocation.second << "\n";
        for(unsigned int sid : bb_in_sections){
            tmpOutputFile << "inSection:" << sid << "\n";
        }

        // report successors to output file
        for(auto successorBB: successors(&BB)){
            tmpOutputFile << "successor:" << bbToGraphNodeMap.at(successorBB).bbIndex << "\n";
        }
        // add var accesses and function calls to output file
        for(auto sva : graphNode.varAccesses){
            // errs() << "SVA: " << sva.codeLocation.first << ":" << sva.codeLocation.second << "; " << sva.originLocation.first << ":" << sva.originLocation.second << "; " << sva.mode << "; " << sva.name << ";\n";
            // only report operation, if it is inside of a relevant section
            for(auto section : sections){
                    if(sva.name.compare(section.varName) == 0){
                        if(sva.codeLocation.first >= section.startLine && sva.codeLocation.first <= section.endLine){
                            tmpOutputFile << "operation:" << section.sectionId << ":" << sva.mode << ":" << sva.name << ":" << sva.codeLocation.first
                                       << ":" << sva.codeLocation.second << ":" <<  sva.originLocation.first << ":" << sva.originLocation.second << "\n";
                        }
                    }

            }
        }

        // set function entrypoint if necessary
        BasicBlock* x = &(F.getEntryBlock());
        if(&BB == x){
            tmpOutputFile << "functionEntryBB:" << graphNode.bbIndex << "\n";
        }
        tmpOutputFile.close();
    }

    

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
    // clear Structs
    Structs.clear();

    // set first bb id to 0;
    nextFreeBBId = 0;

    // read input file
    ifstream inputFile(ClInputFile);
    string line;
    string columnDelimiter = ";";
    while(getline(inputFile, line)){
        // store line contents on sections-stack
        string tmp[5];
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
        curSection.sectionId = stoi(tmp[1]);
        curSection.startLine = stoi(tmp[2]);
        curSection.endLine = stoi(tmp[3]);
        curSection.varName = tmp[4];
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
