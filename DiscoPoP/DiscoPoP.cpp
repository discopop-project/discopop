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

#define DEBUG_TYPE "dpop"
//#define SKIP_DUP_INSTR 1
//#define DEBUG_TYPE "dp-omissions"

#include "DiscoPoP.hpp"

#define DP_DEBUG false
#define DP_VERBOSE false  // prints warning messages
#define DP_hybrid_DEBUG false
#define DP_hybrid_SKIP false  //todo add parameter to disable hybrid dependence analysis on demand.


using namespace llvm;
using namespace std;
using namespace dputil;


StringRef DiscoPoP::getPassName() const {
    return "DiscoPoP";
}

// Initializations
void DiscoPoP::setupDataTypes() {
    Void = const_cast<Type *>(Type::getVoidTy(*ThisModuleContext));
    Int32 = const_cast<IntegerType *>(IntegerType::getInt32Ty(*ThisModuleContext));
    Int64 = const_cast<IntegerType *>(IntegerType::getInt64Ty(*ThisModuleContext));
    CharPtr = const_cast<PointerType *>(Type::getInt8PtrTy(*ThisModuleContext));
}

void DiscoPoP::setupCallbacks() {
    /* function name
     * return value type
     * arg types
     * NULL
     */
    DpInit = ThisModule->getOrInsertFunction("__dp_init",
                                             Void,
                                             Int32, Int32, Int32);

    DpFinalize = ThisModule->getOrInsertFunction("__dp_finalize",
                                                 Void,
                                                 Int32);

    DpRead = ThisModule->getOrInsertFunction("__dp_read",
                                             Void,
#ifdef SKIP_DUP_INSTR
            Int32, Int64, CharPtr, Int64, Int64
#else
                                             Int32, Int64, CharPtr
#endif
    );

    DpWrite = ThisModule->getOrInsertFunction("__dp_write",
                                              Void,
#ifdef SKIP_DUP_INSTR
            Int32, Int64, CharPtr, Int64, Int64
#else
                                              Int32, Int64, CharPtr
#endif
    );

    DpAlloca = ThisModule->getOrInsertFunction("__dp_alloca",
                                                Void,
                           
                                                Int32, CharPtr, Int64, Int64, Int64, Int64
    );

    DpNew = ThisModule->getOrInsertFunction("__dp_new",
                                                Void,
                                                Int32, Int64, Int64, Int64
    );

    DpDelete = ThisModule->getOrInsertFunction("__dp_delete",
                                                Void,
                                                Int32, Int64
    );

    DpCallOrInvoke = ThisModule->getOrInsertFunction("__dp_call",
                                                     Void,
                                                     Int32);

    DpFuncEntry = ThisModule->getOrInsertFunction("__dp_func_entry",
                                                  Void,
                                                  Int32, Int32);

    DpFuncExit = ThisModule->getOrInsertFunction("__dp_func_exit",
                                                 Void,
                                                 Int32, Int32);

    DpLoopEntry = ThisModule->getOrInsertFunction("__dp_loop_entry",
                                                  Void,
                                                  Int32, Int32);

    DpLoopExit = ThisModule->getOrInsertFunction("__dp_loop_exit",
                                                 Void,
                                                 Int32, Int32);
}

bool DiscoPoP::doInitialization(Module &M) {
    if (DP_DEBUG) {
        errs() << "DiscoPoP | 190: init pass DiscoPoP \n";
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
    }
// DPInstrumentation end

// DPInstrumentationOmission
    {
        int bbDepCount = 0;

        ReportBB = M.getOrInsertFunction(
                "__dp_report_bb",
                Void,
                Int32
        );
        ReportBBPair = M.getOrInsertFunction(
                "__dp_report_bb_pair",
                Void,
                Int32,
                Int32
        );
        VNF = new dputil::VariableNameFinder(M);
        int nextFreeStaticMemoryRegionID = 0;
    }
// DPInstrumentationOmission end

    return true;
}

bool DiscoPoP::doFinalization(Module &M) {
    //CUGeneration

    // write the current count of CUs to a file to avoid duplicate CUs.
    if (outCUIDCounter && outCUIDCounter->is_open()) {
        *outCUIDCounter << CUIDCounter;
        outCUIDCounter->flush();
        outCUIDCounter->close();
    }
    // CUGeneration end

    // DPInstrumentationOmission
    for (Function &F: M) {
        if (!F.hasName() || F.getName() != "main")
            continue;
        for (BasicBlock &BB: F) {
            for (Instruction &I: BB) {
                if (CallInst * call_inst = dyn_cast<CallInst>(&I)) {
                    if (Function * Fun = call_inst->getCalledFunction()) {
                        if (Fun->getName() == "__dp_finalize") {
                            IRBuilder<> builder(call_inst);
                            Value *V = builder.CreateGlobalStringPtr(StringRef(bbDepString), ".dp_bb_deps");
                            CallInst::Create(
                                    F.getParent()->getOrInsertFunction("__dp_add_bb_deps", Void, CharPtr),
                                    V,
                                    "",
                                    call_inst
                            );
                        }
                    }
                }
            }
        }
    }
    // DPInstrumentationOmission end

    return true;
}

DiscoPoP::~DiscoPoP() {
    if (ocfg.is_open()) {
        ocfg.flush();
        ocfg.close();
    }
}

void DiscoPoP::getAnalysisUsage(AnalysisUsage &AU) const {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequiredTransitive<RegionInfoPass>();
// NOTE: changed 'LoopInfo' to 'LoopInfoWrapperPass'
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addPreserved<LoopInfoWrapperPass>();
// Get recursive functions called in loops. (Mo 5.11.2019)
    AU.addRequired<CallGraphWrapperPass>();
    AU.setPreservesAll();
}

// CUGeneration

void DiscoPoP::getFunctionReturnLines(Region *TopRegion, Node *root) {
    int lid = 0;
    for (Region::block_iterator bb = TopRegion->block_begin();
         bb != TopRegion->block_end(); ++bb) {
        for (BasicBlock::iterator instruction = (*bb)->begin();
             instruction != (*bb)->end(); ++instruction) {
            if (isa<ReturnInst>(instruction)){
                lid = getLID(&*instruction, fileID);
                if (lid > 0)
                    root->returnLines.insert(lid);
            }
        }
    }
}

string DiscoPoP::determineVariableDefLine(Instruction *I) {
    string varDefLine{"LineNotFound"};

    bool isGlobal = false;
    string varName = determineVariableName_static(&*I, isGlobal, true);
    // varName = refineVarName(varName);
    varName = (varName.find(".addr") == varName.npos)
              ? varName
              : varName.erase(varName.find(".addr"), 5);
    // varName.erase(varName.find(".addr"), 5);
    // size_t pos = varName.find(".addr");
    // if (pos != varName.npos)
    //     varName.erase(varName.find(".addr"), 5);

    string varType = determineVariableType(&*I);

    if (programGlobalVariablesSet.count(varName)) {
        varDefLine = "GlobalVar";
        // Find definition line of global variables
        GlobalVariable *globalVariable = I->getParent()->getParent()->getParent()->getGlobalVariable(StringRef(varName));
        if(globalVariable){
            MDNode *metadata = globalVariable->getMetadata("dbg");
            if(metadata){
                if(isa<DIGlobalVariableExpression>(metadata)){ 
                    varDefLine = to_string(fileID) + ":" + to_string(cast<DIGlobalVariableExpression>(globalVariable->getMetadata("dbg"))->getVariable()->getLine());
                }
            }
        }
    }

    // Start from the beginning of a function and look for the variable
    Function *F = I->getFunction();
    for (Function::iterator FI = F->begin(), FE = F->end(); FI != FE; ++FI) {
        BasicBlock &BB = *FI;
        for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
            if (DbgDeclareInst * DI = dyn_cast<DbgDeclareInst>(BI)) {

                if (auto *N = dyn_cast<MDNode>(DI->getVariable())) {
                    if (auto *DV = dyn_cast<DILocalVariable>(N)) {
                        if (varType.find("ARRAY") != string::npos ||
                            varType.find("STRUCT") != string::npos) {
                            if (DV->getName() == varName) {
                                varDefLine = to_string(fileID) + ":" + to_string(DV->getLine());
                                break;
                            }
                        } else {
                            string vn = "----";
                            bool isGlobal;
                            AllocaInst *AI = dyn_cast_or_null<AllocaInst>(DI->getAddress());
                            if (AI) {
                                for (User *U: AI->users()) {
                                    if (StoreInst * SI = dyn_cast<StoreInst>(U)) {
                                        vn = determineVariableName_static(&*SI, isGlobal, true);
                                        break;
                                    } else if (LoadInst * LI = dyn_cast<LoadInst>(U)) {
                                        vn = determineVariableName_static(&*LI, isGlobal, true);
                                        break;
                                    }
                                }
                                if (vn == varName || vn == varName + ".addr") {
                                    varDefLine =
                                            to_string(fileID) + ":" + to_string(DV->getLine());
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return varDefLine;
}


string DiscoPoP::determineVariableType(Instruction *I) {
    string s = "";
    string type_str;
    int index = isa<StoreInst>(I) ? 1 : 0;
    raw_string_ostream rso(type_str);
    (*((I->getOperand(index))->getType())).print(rso);

    Value *operand = I->getOperand(index);

    if (operand->hasName()) {
        if (isa<GetElementPtrInst>(*operand)) {
            GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
            Value *ptrOperand = gep->getPointerOperand();
            PointerType *PTy = cast<PointerType>(ptrOperand->getType());
            // we've found a struct/class
            Type *structType = pointsToStruct(PTy);
            if (structType && gep->getNumOperands() > 2) {
                s = "STRUCT,";
            }

            // we've found an array
            if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID)
            {
                s = "ARRAY,";
            }
            else{
                // check if previous instruction is a GEP as well. If so, an Array has been found (e.g. double**)
                Value* prevInst = cast<Instruction>(gep)->getOperand(0);
                if(isa<GetElementPtrInst>(prevInst)){
                    s = "ARRAY,";
                }
                else if(prevInst->getType()->isPointerTy()){
                    s = "ARRAY,";
                }
            }
        }
    }

    s = s + rso.str();
    return s;
}

// recieves the region and outputs all variables and variables crossing basic
// block boundaries in the region.
void DiscoPoP::populateGlobalVariablesSet(Region *TopRegion,
                                          set <string> &globalVariablesSet) {

    map < string, BasicBlock * > variableToBBMap;
    bool isGlobalVariable;
    for (Region::block_iterator bb = TopRegion->block_begin();
         bb != TopRegion->block_end(); ++bb) {
        for (BasicBlock::iterator instruction = (*bb)->begin();
             instruction != (*bb)->end(); ++instruction) {
            if (isa<LoadInst>(instruction) || isa<StoreInst>(instruction) ||
                isa<CallInst>(instruction)) {

                // NOTE: changed 'instruction' to '&*instruction'
                string varName = determineVariableName_static(&*instruction, isGlobalVariable, false);

                if (isGlobalVariable) // add it if it is a global variable in the program
                {
                    programGlobalVariablesSet.insert(varName);
                }

                if (variableToBBMap.find(varName) != variableToBBMap.end()) {
                    // this var has already once recordded. check for bb id
                    if (variableToBBMap[varName] != *bb) {
                        // global variable found. Insert into the globalVariablesSet
                        globalVariablesSet.insert(varName);
                    }
                } else {
                    // record usage of the variable.
                    variableToBBMap.insert(pair<string, BasicBlock *>(varName, *bb));
                }
            }
        }
    }
}

void DiscoPoP::createCUs(Region *TopRegion, set <string> &globalVariablesSet,
                         vector<CU *> &CUVector,
                         map <string, vector<CU *>> &BBIDToCUIDsMap,
                         Node *root, LoopInfo &LI) {
    const DataLayout *DL =
            &ThisModule->getDataLayout(); // used to get data size of variables,
    // pointers, structs etc.
    Node *currentNode = root;
    CU *cu;
    int lid;
    string varName;
    bool isGlobalVar = false;
    string varType;
    set <string> suspiciousVariables;
    string basicBlockName;

    map < Loop * , Node * > loopToNodeMap;

    for (Region::block_iterator bb = TopRegion->block_begin();
         bb != TopRegion->block_end(); ++bb) {

        // Get the closest loop where bb lives in.
        // (loop == NULL) if bb is not in any loop.
        Loop *loop = LI.getLoopFor(*bb);
        if (loop) {
            // if bb is in a loop and if we have already created a node for that loop,
            // assign it to currentNode.
            if (loopToNodeMap.find(loop) != loopToNodeMap.end()) {
                currentNode = loopToNodeMap[loop];
            }
                // else, create a new Node for the loop, add it as children of currentNode
                // and add it to the map.
            else {
                Node *n = new Node;
                n->type = nodeTypes::loop;
                n->parentNode = currentNode;
                currentNode->childrenNodes.push_back(n);

                loopToNodeMap[loop] = n;
                currentNode = n;
            }
        } else {
            // end of loops. go to the parent of the loop. may have to jump several
            // nodes in case of nested loops
            for (map<Loop *, Node *>::iterator it = loopToNodeMap.begin();
                 it != loopToNodeMap.end(); it++)
                if (it->second ==
                    currentNode) // current node found in loop map jump to its parent.
                {
                    currentNode = currentNode->parentNode;
                    it = loopToNodeMap
                            .begin(); // search the whole map again for current node
                    if (it->second == currentNode) // due to it++ we need to check first
                        // element of map ourself
                        currentNode = currentNode->parentNode;
                }
        }

        cu = new CU;

        if (bb->getName().size() == 0)
            bb->setName(cu->ID);

        cu->BBID = bb->getName().str();
        cu->BB = *bb;
        currentNode->childrenNodes.push_back(cu);
        vector < CU * > basicBlockCUVector;
        basicBlockCUVector.push_back(cu);
        BBIDToCUIDsMap.insert(
                pair < string, vector < CU * >> (bb->getName(), basicBlockCUVector));
        DILocalScope* scopeBuffer = NULL;

        for (BasicBlock::iterator instruction = (*bb)->begin();
             instruction != (*bb)->end(); ++instruction) {
            // NOTE: 'instruction' --> '&*instruction'
            lid = getLID(&*instruction, fileID);
            basicBlockName = bb->getName().str();

            // Do not allow to combine Instructions from different scopes in the source code.
            if((&*instruction)->getDebugLoc()){
                if ((&*instruction)->getDebugLoc()->getScope() != scopeBuffer){
                    // scopes are not equal

                    int scopeIsParentOfBuffer = 0;
                    if(scopeBuffer){
                        scopeIsParentOfBuffer = (&*instruction)->getDebugLoc()->getScope() == scopeBuffer->getScope();
                    }

                    if(scopeIsParentOfBuffer){
                        // allow a combination of two CU's if the second scope is the parent of the first scope
                    }
                    else{
                        // create a new CU. Do not allow to combine Instructions from different scopes in the source code.

                        // create new CU if the old one contains any instruction
                        if ((! cu->readPhaseLineNumbers.empty()) || (! cu->writePhaseLineNumbers.empty()) || (! cu->returnInstructions.empty())) {
                            cu->startLine = *(cu->instructionsLineNumbers.begin());
                            cu->endLine = *(cu->instructionsLineNumbers.rbegin());

                            cu->basicBlockName = basicBlockName;
                            CUVector.push_back(cu);
                            suspiciousVariables.clear();
                            CU *temp =
                                    cu; // keep current CU to make a reference to the successor CU
                            cu = new CU;

                            cu->BBID = bb->getName().str();
                            cu->BB = *bb;

                            currentNode->childrenNodes.push_back(cu);
                            temp->successorCUs.push_back(cu->ID);
                            BBIDToCUIDsMap[bb->getName().str()].push_back(cu);
                        }
                    }
                    // update scopeBuffer
                        scopeBuffer = (&*instruction)->getDebugLoc()->getScope();
                }
            }


            if (lid > 0) {
                cu->instructionsLineNumbers.insert(lid);
                cu->instructionsCount++;
                // find return instructions
                if (isa<ReturnInst>(instruction)) {
                    cu->returnInstructions.insert(lid);
                }
                    // find branches to return instructions, i.e. return statements
                else if (isa<BranchInst>(instruction)) {
                    if ((cast<BranchInst>(instruction))->isUnconditional()) {
                        if ((cast<BranchInst>(instruction))->getNumSuccessors() == 1) {
                            BasicBlock *successorBB =
                                    (cast<BranchInst>(instruction))->getSuccessor(0);
                            for (BasicBlock::iterator innerInstruction = successorBB->begin();
                                 innerInstruction != successorBB->end(); ++innerInstruction) {
                                if (isa<ReturnInst>(innerInstruction)) {
                                    cu->returnInstructions.insert(lid);
                                    break;
                                }
                            }
                        }
                    }
                }
                if (isa<StoreInst>(instruction)) {
                    // get size of data written into memory by this store instruction
                    Value *operand = instruction->getOperand(1);
                    Type *Ty = operand->getType();
                    unsigned u = DL->getTypeSizeInBits(Ty);
                    cu->writeDataSize += u;
                    varName = determineVariableName_static(&*instruction, isGlobalVar, false);
                    varType = determineVariableType(&*instruction);
                    suspiciousVariables.insert(varName);
                    if (lid > 0)
                        cu->writePhaseLineNumbers.insert(lid);
                } else if (isa<LoadInst>(instruction)) {
                    // get size of data read from memory by this load instruction
                    Type *Ty = instruction->getType();
                    unsigned u = DL->getTypeSizeInBits(Ty);
                    cu->readDataSize += u;
                    varName = determineVariableName_static(&*instruction, isGlobalVar, false);
                    if (suspiciousVariables.count(varName)) {
                        // VIOLATION OF CAUTIOUS PROPERTY
                        // it is a load instruction which read the value of a global
                        // variable.
                        // This global variable has already been stored previously.
                        // A new CU should be created here.
                        cu->readPhaseLineNumbers.erase(lid);
                        cu->writePhaseLineNumbers.erase(lid);
                        cu->instructionsLineNumbers.erase(lid);
                        cu->instructionsCount--;
                        if (cu->instructionsLineNumbers.empty()) {
                            //cu->removeCU();
                            cu->startLine = -1;
                            cu->endLine = -1;
                        } else {
                            cu->startLine = *(cu->instructionsLineNumbers.begin());
                            cu->endLine = *(cu->instructionsLineNumbers.rbegin());
                        }
                        cu->basicBlockName = basicBlockName;
                        CUVector.push_back(cu);
                        suspiciousVariables.clear();
                        CU *temp =
                                cu; // keep current CU to make a reference to the successor CU
                        cu = new CU;

                        cu->BBID = bb->getName().str();
                        cu->BB = *bb;

                        currentNode->childrenNodes.push_back(cu);
                        temp->successorCUs.push_back(cu->ID);
                        BBIDToCUIDsMap[bb->getName().str()].push_back(cu);
                        if (lid > 0) {
                            cu->readPhaseLineNumbers.insert(lid);
                            cu->instructionsLineNumbers.insert(lid);
                        }
                    } else {
                        if (globalVariablesSet.count(varName) ||
                            programGlobalVariablesSet.count(varName)) {
                            if (lid > 0)
                                cu->readPhaseLineNumbers.insert(lid);
                        }
                    }
                }
                else if (isa<CallInst>(instruction)){
                    // get the name of the called function and check if a FileIO function is called
                    CallInst *ci = cast<CallInst>(instruction);
                    set<string> IOFunctions {"fopen", "fopen_s", "freopen", "freopen_s", "fclose", "fflush", "setbuf",
                                             "setvbuf", "fwide", "fread", "fwrite", "fgetc", "getc", "fgets", "fputc",
                                             "putc", "fputs", "getchar", "gets", "gets_s", "putchar", "puts", "ungetc",
                                             "fgetwc", "getwc", "fgetws", "fputwc", "putwc", "fputws", "getwchar",
                                             "putwchar", "ungetwc", "scanf", "fscanf", "sscanf", "scanf_s", "fscanf_s",
                                             "sscanf_s", "vscanf", "vfscanf", "vsscanf", "vscanf_s", "vfscanf_s",
                                             "vsscanf_s", "printf", "fprintf", "sprintf", "snprintf", "printf_s",
                                             "fprintf_s", "sprintf_s", "snprintf_s", "vprintf", "vfprintf", "vsprintf",
                                             "vsnprintf", "vprintf_s", "vfprintf_s", "vsprintf_s", "vsnprintf_s",
                                             "wscanf", "fwscanf", "swscanf", "wscanf_s", "fwscanf_s", "swscanf_s",
                                             "vwscanf", "vfwscanf", "vswscanf", "vwscanf_s", "vfwscanf_s", "vswscanf_s",
                                             "wprintf", "fwprintf", "swprintf", "wprintf_s", "wprintf_s", "swprintf_s",
                                             "snwprintf_s", "vwprintf", "vfwprintf", "vswprintf", "vwprintf_s",
                                             "vfwprintf_s", "vswprintf_s", "vsnwprintf_s", "ftell", "fgetpos", "fseek",
                                             "fsetpos", "rewind", "clearerr", "feof", "ferror", "perror", "remove",
                                             "rename", "tmpfile", "tmpfile_s", "tmpnam", "tmpnam_s",
                                             "__isoc99_fscanf"};
                    if(ci){
                        if(ci->getCalledFunction()){
                            if(ci->getCalledFunction()->hasName()){
                                if(find(IOFunctions.begin(), IOFunctions.end(), ci->getCalledFunction()->getName().str()) != IOFunctions.end()){
                                    // Called function performs FileIO
                                    cu->performsFileIO = true;
                                }
                            }

                        }
                    }
                }
            }
        }
        if (cu->instructionsLineNumbers.empty()) {
            //cu->removeCU();
            cu->startLine = -1;
            cu->endLine = -1;
        } else {
            cu->startLine = *(cu->instructionsLineNumbers.begin());
            cu->endLine = *(cu->instructionsLineNumbers.rbegin());
        }

        cu->basicBlockName = basicBlockName;
        CUVector.push_back(cu);
        suspiciousVariables.clear();

        // check for call instructions in current basic block
        for (BasicBlock::iterator instruction = (*bb)->begin();
             instruction != (*bb)->end(); ++instruction) {
            // Note: Don't create nodes for library functions (c++/llvm).
            LID lid = getLID(&*instruction, fileID);
            if (lid > 0) {
                if (isa<CallInst>(instruction)) {
                    CallInst* ci = cast<CallInst>(instruction);
                    Function *f = ci->getCalledFunction();
                    // TODO: DO the same for Invoke inst

                    string lid;
                    if(f) {
                        Function::iterator FI = f->begin();
                        bool externalFunction = true;
                        for (Function::iterator FI = f->begin(), FE = f->end(); FI != FE;
                             ++FI) {
                            externalFunction = false;
                            auto tempBI = FI->begin();
                            if (DebugLoc dl = tempBI->getDebugLoc()) {
                                lid = to_string(dl->getLine());
                            } else {
                                if (tempBI->getFunction()->getSubprogram())
                                    lid = to_string(
                                            tempBI->getFunction()->getSubprogram()->getLine());
                                else {
                                    lid = "LineNotFound";
                                }
                            }
                            break;
                        }
                        if (externalFunction)
                            continue;
                    }
                    else{
                        lid = "LineNotFound";
                    }

                    Node *n = new Node;
                    n->type = nodeTypes::dummy;
                    // For ordinary function calls, F has a name.
                    // However, sometimes the function being called
                    // in IR is encapsulated by "bitcast()" due to
                    // the way of compiling and linking. In this way,
                    // getCalledFunction() method returns NULL.
                    // Also, getName() returns NULL if this is an indirect function call.
                    if (f) {
                        n->name = f->getName().str();

                        // @Zia: This for loop appeared after the else part. For some
                        // function calls, the value of f is null. I guess that is why you
                        // have checked if f is not null here. Anyway, I (Mohammad) had to
                        // bring the for loop inside to avoid the segmentation fault. If you
                        // think it is not appropriate, find a solution for it. 14.2.2016
                        for (Function::arg_iterator it = f->arg_begin(); it != f->arg_end();
                             it++) {
                            string type_str;
                            raw_string_ostream rso(type_str);
                            (it->getType())->print(rso);
                            Type *variableType = it->getType();
                            while(variableType->isPointerTy()){
                                variableType = variableType->getPointerElementType();
                            }
                            Variable v(string(it->getName()), rso.str(), lid, true, true, to_string(variableType->getScalarSizeInBits()/8));
                            n->argumentsList.push_back(v);
                        }
                    } else // get name of the indirect function which is called
                    {
                        Value *v = (cast<CallInst>(instruction))->getCalledOperand();
                        Value *sv = v->stripPointerCasts();
                        n->name = sv->getName().str();
                    }

                    // Recursive functions
                    CallGraphWrapperPass *CGWP = &(getAnalysis<CallGraphWrapperPass>());
                    if (isRecursive(*f, CGWP->getCallGraph())) {
                        int lid = getLID(&*instruction, fileID);
                        n->recursiveFunctionCall =
                                n->name + " " + dputil::decodeLID(lid) + ",";
                    }

                    vector < CU * > BBCUsVector = BBIDToCUIDsMap[bb->getName().str()];
                    // locate the CU where this function call belongs
                    for (auto i: BBCUsVector) {
                        int lid = getLID(&*instruction, fileID);
                        if (lid >= i->startLine && lid <= i->endLine) {
                            i->instructionsLineNumbers.insert(lid);
                            i->childrenNodes.push_back(n);
                            i->callLineTofunctionMap[lid].push_back(n);
                            break;
                        }
                    }
                }
            }
        }
    }
}

void DiscoPoP::fillCUVariables(Region *TopRegion,
                               set <string> &globalVariablesSet,
                               vector<CU *> &CUVector,
                               map <string, vector<CU *>> &BBIDToCUIDsMap) {
    int lid;
    string varName, varType, varDefLine;
    bool isGlobalVar = false;
    // Changed TerminatorInst to Instuction
    const Instruction *TInst;
    string successorBB;

    for (Region::block_iterator bb = TopRegion->block_begin();
         bb != TopRegion->block_end(); ++bb) {
        CU *lastCU = BBIDToCUIDsMap[bb->getName().str()]
                .back(); // get the last CU in the basic block
        // get all successor basic blocks for bb
        TInst = bb->getTerminator();
        for (unsigned i = 0, nSucc = TInst->getNumSuccessors(); i < nSucc; ++i) {
            // get the name of successor basicBlock
            successorBB = TInst->getSuccessor(i)->getName().str();
            // get the first CU of the successor basicBlock and record its ID in
            // current CU's successorCUs
            lastCU->successorCUs.push_back(BBIDToCUIDsMap[successorBB].front()->ID);
        }

        auto bbCU = BBIDToCUIDsMap[bb->getName().str()].begin();
        for (BasicBlock::iterator instruction = (*bb)->begin();
             instruction != (*bb)->end(); ++instruction) {
            if (isa<LoadInst>(instruction) || isa<StoreInst>(instruction)) {
                // NOTE: changed 'instruction' to '&*instruction'
                lid = getLID(&*instruction, fileID);
                if (lid == 0)
                    continue;
                // NOTE: changed 'instruction' to '&*instruction', next 2 lines
                varName = determineVariableName_static(&*instruction, isGlobalVar, false);
                varType = determineVariableType(&*instruction);

                int index = isa<StoreInst>(&*instruction) ? 1 : 0;
                Type *variableType = (&*instruction)->getOperand(index)->getType();
                while(variableType->isPointerTy()){
                    variableType = variableType->getPointerElementType();
                }

                string varSizeInBytes = to_string(variableType->getScalarSizeInBits()/8);
                
                varDefLine = determineVariableDefLine(&*instruction);

                bool readAccess = isa<LoadInst>(instruction);
                bool writeAccess = isa<StoreInst>(instruction);

                Variable v(varName, varType, varDefLine, readAccess, writeAccess, varSizeInBytes);

                if (lid > (*bbCU)->endLine) {
                    bbCU = next(bbCU, 1);
                }
                if (globalVariablesSet.count(varName) ||
                    programGlobalVariablesSet.count(varName)) {
                    (*bbCU)->globalVariableNames.insert(v);
                } else {
                    (*bbCU)->localVariableNames.insert(v);
                }
            }
        }
    }
}

void DiscoPoP::findStartEndLineNumbers(Node *root, int &start, int &end) {
    if (root->type == nodeTypes::cu) {
        if (start == -1 || start > root->startLine) {
            start = root->startLine;
        }

        if (end < root->endLine) {
            end = root->endLine;
        }
    }

    for (auto i: root->childrenNodes) {
        findStartEndLineNumbers(i, start, end);
    }
}

void DiscoPoP::fillStartEndLineNumbers(Node *root, LoopInfo &LI) {
    if (root->type != nodeTypes::cu) {
        int start = -1, end = -1;

        if (root->type == nodeTypes::loop) {
            for (auto i: root->childrenNodes) {
                if (i->type == nodeTypes::cu) {
                    Loop *loop = LI.getLoopFor(i->BB);
                    DebugLoc dl = loop->getStartLoc();
                    LID lid = 0;
                    lid = (fileID << LIDSIZE) + dl->getLine();
                    loopStartLines[root->ID] = dputil::decodeLID(lid);
                    break;
                }
            }
        }
        findStartEndLineNumbers(root, start, end);

        root->startLine = start;
        root->endLine = end;
    }

    for (auto i: root->childrenNodes) {
        fillStartEndLineNumbers(i, LI);
    }
}

void DiscoPoP::initializeCUIDCounter() {
    std::string CUCounterFile = "DP_CUIDCounter.txt";
    if (dputil::fexists(CUCounterFile)) {
        std::fstream inCUIDCounter(CUCounterFile, std::ios_base::in);;
        inCUIDCounter >> CUIDCounter;
        inCUIDCounter.close();
    }
}

bool DiscoPoP::isRecursive(Function &F, CallGraph &CG) {
    auto callNode = CG[&F];
    for (unsigned i = 0; i < callNode->size(); i++) {
        if ((*callNode)[i]->getFunction() == &F)
            return true;
    }
    return false;
}

// CUGeneration end

// DPReduction

// iterates over all functions in the module and calls 'instrument_function'
// on suitable ones
void DiscoPoP::instrument_module(llvm::Module *module, map <string, string> *trueVarNamesFromMetadataMap) {
    for (llvm::Module::iterator func_it = module->begin();
         func_it != module->end(); ++func_it) {
        llvm::Function *func = &(*func_it);
        std::string fn_name = func->getName().str();
        if (func->isDeclaration() || (strcmp(fn_name.c_str(), "NULL") == 0) ||
            fn_name.find("llvm") != std::string::npos ||
            inlinedFunction(func)) {
            continue;
        }
        instrument_function(func, trueVarNamesFromMetadataMap);
    }
}

bool DiscoPoP::inlinedFunction(Function *F) {
    for (Function::iterator FI = F->begin(), FE = F->end(); FI != FE; ++FI) {
        for (BasicBlock::iterator BI = FI->begin(), E = FI->end(); BI != E; ++BI) {
            if (DbgDeclareInst * DI = dyn_cast<DbgDeclareInst>(BI)) {
                if (DI->getDebugLoc()->getInlinedAt())
                    return true;
            }
        }
    }
    return false;
}

// iterates over all loops in a function and calls 'instrument_loop' for each
// one
void DiscoPoP::instrument_function(llvm::Function *function, map <string, string> *trueVarNamesFromMetadataMap) {

    // get the corresponding file id
    unsigned file_id = dp_reduction_get_file_id(function);
    if (file_id == 0) {
        return;
    }

    llvm::LoopInfo &loop_info = getAnalysis<llvm::LoopInfoWrapperPass>(*function).getLoopInfo();

    for (auto loop_it = loop_info.begin(); loop_it != loop_info.end();
         ++loop_it) {
        instrument_loop(*function, file_id, *loop_it, loop_info, trueVarNamesFromMetadataMap);
    }
}

// Goes through all instructions in a loop and determines if they might be
// suitable for reduction.
// An entry is added to the 'loops_' vector and for each suitable instruction,
// an entry is added to the 'instructions_' vector.
void DiscoPoP::instrument_loop(Function &F, int file_id, llvm::Loop *loop, LoopInfo &LI,
                               map <string, string> *trueVarNamesFromMetadataMap) {

    auto loc = loop->getStartLoc();
    if (!dp_reduction_loc_exists(loc)) {
        return;
    }

    auto basic_blocks = loop->getBlocks();
    if (basic_blocks.size() < 3) {
        return;
    }

    // add an entry to the 'loops_' vector
    loop_info_t loop_info;
    loop_info.line_nr_ = loc.getLine();
    loop_info.file_id_ = file_id;
    loop_info.first_body_instr_ = &(*basic_blocks[1]->begin());

    std::string loopEndLine = dp_reduction_CFA(F, loop, file_id);
    loop_info.end_line = loopEndLine;
    loop_info.function_name = string((basic_blocks[1]->getParent()->getName()));
    loops_.push_back(loop_info);

    // call 'instrument_loop' on all its subloops
    auto const sub_loops = loop->getSubLoops();
    for (auto loop_it = sub_loops.begin(); loop_it != sub_loops.end();
         ++loop_it) {
        instrument_loop(F, file_id, *loop_it, LI, trueVarNamesFromMetadataMap);
    }

    // The key corresponds to the variable that is loaded / stored.
    // The value points to the actual load / store instruction.
    std::map < llvm::Value * , llvm::Instruction * > load_instructions;
    std::map < llvm::Value * , llvm::Instruction * > store_instructions;

    // Scan all instructions in the loop's basic blocks to find the load and
    // store instructions.
    for (size_t i = 0; i < basic_blocks.size(); ++i) {
        llvm::BasicBlock *const bb = basic_blocks[i];

        std::string bb_name = bb->getName().str();
        if ((std::strncmp("for.inc", bb_name.c_str(), 7) == 0) ||
            (std::strncmp("for.cond", bb_name.c_str(), 8) == 0)) {
            continue;
        }

        for (auto instr_it = bb->begin(); instr_it != bb->end(); ++instr_it) {
            llvm::Instruction *instr = &(*instr_it);

            auto opcode = instr->getOpcode();
            if (opcode != llvm::Instruction::Store &&
                opcode != llvm::Instruction::Load) {
                continue;
            }

            // Add an entry to the corresponding map or invalidate an already
            // existing entry, if the same instruction is executed on multiple
            // lines.
            llvm::Value *operand = dp_reduction_get_var(instr);
            if (operand) {
                std::map < llvm::Value * , llvm::Instruction * > *map_ptr =
                                                   (opcode == llvm::Instruction::Store) ? &store_instructions
                                                                                        : &load_instructions;
                if (!map_ptr->insert(std::make_pair(operand, instr)).second) {
                    if ((*map_ptr)[operand]) {
                        llvm::DebugLoc new_loc = instr->getDebugLoc();
                        llvm::DebugLoc old_loc = (*map_ptr)[operand]->getDebugLoc();

                        if (!dp_reduction_loc_exists(new_loc) || !dp_reduction_loc_exists(old_loc)) {
                            (*map_ptr)[operand] = nullptr;
                        } else if (new_loc.getLine() != old_loc.getLine()) {
                            (*map_ptr)[operand] = nullptr;
                        }
                    }
                }
            }
        }
    }

    // only keep the instructions that satisfy the following conditions :
    // - a variable that is read must also be written in the loop
    // - a variable must not be read or written more than once
    // - the store instruction comes after the load instruction
    std::vector <instr_info_t> candidates;
    for (auto it = load_instructions.begin(); it != load_instructions.end();
         ++it) {
        if (!it->second) continue;

        auto it2 = store_instructions.find(it->first);
        if (it2 != store_instructions.end() && it2->second) {
            llvm::DebugLoc load_loc = it->second->getDebugLoc();
            llvm::DebugLoc store_loc = it2->second->getDebugLoc();
            if (!dp_reduction_loc_exists(load_loc) || !dp_reduction_loc_exists(store_loc)) continue;
            if (load_loc.getLine() > store_loc.getLine()) continue;
            if (load_loc.getLine() == loop_info.line_nr_ || store_loc.getLine() == loop_info.line_nr_) continue;

            if (loop_info.end_line == "LOOPENDNOTFOUND") {
                errs() << "WARNING: Loop end not found! File: " << file_id << " Function: " << F.getName()
                       << " Start line: " << loop_info.start_line << "\n";
                continue;
            }
            if (loop_info.line_nr_ > std::stoul(loop_info.end_line))
                continue;

            //Check if both load and store insts belong to the loop
            if (load_loc.getLine() < loop_info.line_nr_ || load_loc.getLine() > std::stoul(loop_info.end_line))
                continue;
            if (store_loc.getLine() < loop_info.line_nr_ ||
                store_loc.getLine() > std::stoul(loop_info.end_line))
                continue;

            if (it->first->hasName()) {
                instr_info_t info;
                info.var_name_ = dp_reduction_determineVariableName(it->second, trueVarNamesFromMetadataMap);
                info.loop_line_nr_ = loop_info.line_nr_;
                info.file_id_ = file_id;
                info.store_inst_ = llvm::dyn_cast<llvm::StoreInst>(it2->second);
                info.load_inst_ = llvm::dyn_cast<llvm::LoadInst>(it->second);

                candidates.push_back(info);
            }
        }
    }

    // now check if the variables are part of a reduction operation
    for (auto candidate: candidates) {
        int index = isa<StoreInst>(candidate.load_inst_) ? 1 : 0;
        string varNameLoad = "LOAD";
        string varTypeLoad = "SCALAR";
        llvm::DebugLoc loc = (candidate.load_inst_)->getDebugLoc();

        varNameLoad = dp_reduction_determineVariableName(candidate.load_inst_, trueVarNamesFromMetadataMap);
        varTypeLoad = dp_reduction_determineVariableType(candidate.load_inst_);

        if (llvm::isa<llvm::GetElementPtrInst>(candidate.load_inst_->getOperand(index))) {
            if (varTypeLoad.find("ARRAY,") == std::string::npos ||
                varNameLoad.find(".addr") == std::string::npos ||
                varTypeLoad.find("**") != std::string::npos) {
                continue;
            } else if (varTypeLoad.find("ARRAY,") != std::string::npos ||
                       varNameLoad.find(".addr") != std::string::npos ||
                       varTypeLoad.find("STRUCT,") != std::string::npos ||
                       varTypeLoad.find("**") != std::string::npos) {
                llvm::Instruction *load_instr = nullptr;
                llvm::Instruction *instr =
                        dp_reduction_get_reduction_instr(candidate.store_inst_, &load_instr);
                if (instr) {
                    candidate.load_inst_ = llvm::cast<llvm::LoadInst>(load_instr);
                    candidate.operation_ = dp_reduction_get_char_for_opcode(instr);
                } else {
                    continue;
                }
            }
        } else {
            if (varTypeLoad.find("ARRAY,") != std::string::npos ||
                varNameLoad.find(".addr") != std::string::npos ||
                varTypeLoad.find("STRUCT,") != std::string::npos ||
                varTypeLoad.find("**") != std::string::npos) {
                llvm::Instruction *load_instr = nullptr;
                llvm::Instruction *instr =
                        dp_reduction_get_reduction_instr(candidate.store_inst_, &load_instr);
                if (instr) {
                    candidate.load_inst_ = llvm::cast<llvm::LoadInst>(load_instr);
                    candidate.operation_ = dp_reduction_get_char_for_opcode(instr);
                } else {
                    // We should ignore store instructions that are not associated with a load
                    // e.g., pbvc[i] = c1s;
                    continue;
                }
            } else {
                llvm::Instruction *load_instr = nullptr;
                llvm::Instruction *instr =
                        dp_reduction_get_reduction_instr(candidate.store_inst_, &load_instr);
                if (instr) {
                    candidate.load_inst_ = llvm::cast<llvm::LoadInst>(load_instr);
                    candidate.operation_ = dp_reduction_get_char_for_opcode(instr);
                } else {
                    // We want to find max or min reduction operations
                    // We want to find the basicblock that contains the load instruction
                    // Then, we traverse the whole function to check if the reduction operation is > or <
                    BasicBlock *BB = (candidate.load_inst_)->getParent();
                    string bbName = BB->getName().str();

                    // Ignore loops. Only look for conditional blocks
                    if (bbName.find("if") != std::string::npos ||
                        bbName.find("for") != std::string::npos) {
                        // e.g. in lulesh.cc: "if (domain.vdov(indx) != Real_t(0.)) { if ( dtf < dtcourant_tmp ) { dtcourant_tmp = dtf ; courant_elem  = indx ; }}"

                        // check if loaded value is used in the store instruction to prevent "false positives"
                        if(check_value_usage(candidate.store_inst_->getValueOperand(), cast<Value>(candidate.load_inst_))){
                            candidate.operation_ = '>';
                        }
                        else{
                            continue;
                        }                  
                    } else {
                        continue;
                    }
                }
            }
        }
        instructions_.push_back(candidate);
    }
}

bool DiscoPoP::check_value_usage(llvm::Value *parentValue, llvm::Value *searchedValue){
    // Return true, if searchedValue is used within the computation of parentValue
    if(parentValue == searchedValue){
        return true;
    }

    // check operands recursively, if parentValue is not a constant yet
    if(isa<Constant>(parentValue)){
        return false;
    }
    llvm::Instruction* parentInstruction = cast<Instruction>(parentValue);
    for(int idx = 0; idx < parentInstruction->getNumOperands(); idx++){
        if(check_value_usage(parentInstruction->getOperand(idx), searchedValue)){
            return true;
        }
    }
    
    return false;
    
}


bool DiscoPoP::dp_reduction_init_util(std::string fmap_path) {
    std::ifstream fmap_file;
    fmap_file.open(fmap_path.c_str());
    if(fmap_file.fail()) {
        std::cout << "Opening FileMapping failed: " << strerror(errno) << "\n";
    }
    if (!fmap_file.is_open()) {
        return false;
    }

    std::string line;
    while (std::getline(fmap_file, line)) {
        char filename[512] = {'\0'};
        int file_id = 0;

        int cnt = sscanf(line.c_str(), "%d\t%s", &file_id, filename);
        if (cnt == 2) {

            path_to_id_.emplace(std::string(filename), file_id);
        }
    }

    fmap_file.close();

    return true;
}

unsigned DiscoPoP::dp_reduction_get_file_id(llvm::Function *func) {
    unsigned file_id = 0;

    // get the filepath of this function
    char abs_path[PATH_MAX] = {'\0'};
    for (auto bb_it = func->begin(); bb_it != func->end(); ++bb_it) {
        for (auto instr_it = bb_it->begin(); instr_it != bb_it->end(); ++instr_it) {
            llvm::MDNode *node = instr_it->getMetadata("dbg");
            if (!node) continue;

            llvm::DILocation *di_loc = llvm::dyn_cast<llvm::DILocation>(node);
            llvm::StringRef filename = di_loc->getFilename();
            llvm::StringRef directory = di_loc->getDirectory();

            char *success =
                    realpath((directory.str() + "/" + filename.str()).c_str(), abs_path);
            if (!success) {
                realpath(filename.str().c_str(), abs_path);
            }

            break;
        }
        if (abs_path[0] != '\0') break;
    }

    if (abs_path[0] != '\0') {
        auto it = path_to_id_.find(std::string(abs_path));
        if (it != path_to_id_.end()) {
            file_id = it->second;
        } else {
        }
    }

    return file_id;
}

// finds the previous use of 'val'
llvm::Instruction *DiscoPoP::dp_reduction_get_prev_use(llvm::Instruction *instr, llvm::Value *val) {
    if (!instr) return nullptr;

    auto instr_users = val->users();
    bool instr_found = false;
    for (auto user: instr_users) {
        if (!llvm::isa<llvm::Instruction>(user)) {
            continue;
        }
        llvm::Instruction *usr_instr = llvm::cast<llvm::Instruction>(user);

        if (instr_found) {
            return usr_instr;
        } else if (usr_instr == instr) {
            instr_found = true;
            continue;
        }
    }
    return llvm::dyn_cast<llvm::Instruction>(val);
}

llvm::Value *DiscoPoP::dp_reduction_get_var_rec(llvm::Value *val) {
    if (!val) return nullptr;

    if (llvm::isa<llvm::AllocaInst>(val) ||
        llvm::isa<llvm::GlobalVariable>(val)) {
        return val;
    }
    if (llvm::isa<llvm::GetElementPtrInst>(val)) {
        llvm::GetElementPtrInst *elem_ptr_instr =
                llvm::cast<llvm::GetElementPtrInst>(val);

        // struct member reductions are not supported by OpenMP
        llvm::Value *points_to = dp_reduction_points_to_var(elem_ptr_instr);
        llvm::AllocaInst *a_instr = llvm::dyn_cast<llvm::AllocaInst>(points_to);
        llvm::Type *type =
                (a_instr) ? a_instr->getAllocatedType() : points_to->getType();
        if (type->isStructTy()) {
            return nullptr;
        }

        return dp_reduction_get_var_rec(elem_ptr_instr->getPointerOperand());
    }
    if (llvm::isa<llvm::LoadInst>(val)) {
        llvm::LoadInst *load_instr = llvm::cast<llvm::LoadInst>(val);
        return dp_reduction_get_var_rec(load_instr->getOperand(0));
    }

    return nullptr;
}

// Get the value that is stored or loaded by a store / load instruction.
llvm::Value *DiscoPoP::dp_reduction_get_var(llvm::Instruction *instr) {
    unsigned index = (llvm::isa<llvm::LoadInst>(instr)) ? 0 : 1;
    return dp_reduction_get_var_rec(instr->getOperand(index));
}

// Retrieves the reduction operation for the operand that is stored by the
// 'store_instr' (if such a reduction operation exists).
// The parameter 'load_instr' will point to the load instruction that actually
// loads the value (if such a load instruction exists).
llvm::Instruction *DiscoPoP::dp_reduction_get_reduction_instr(
        llvm::Instruction *store_instr, llvm::Instruction **load_instr) {
    // find the reduction operation for the source operand of the 'store_instr'
    llvm::Instruction *reduction_instr =
            dp_reduction_find_reduction_instr(store_instr->getOperand(0));
    if (!reduction_instr) {
        return nullptr;
    }
    // Now find the destination address of the store instruction.
    // After that, search the load instruction that loads this value and store a
    // pointer to it in 'load_instr'.
    llvm::Value *store_dst = dp_reduction_get_var_rec(store_instr->getOperand(1));
    if (store_dst) {
        std::vector<char> reduction_operations;
        *load_instr =
                dp_reduction_get_load_instr(store_dst, reduction_instr, reduction_operations);
        // { *, / } > { +, - } > { & } > { ^ } > { | }
        if (reduction_operations.size() > 1) {
            int order = dp_reduction_get_op_order(reduction_operations[0]);
            for (size_t i = 1; i != reduction_operations.size(); ++i) {
                int order_i = dp_reduction_get_op_order(reduction_operations[i]);
                if (order_i > order) {
                    *load_instr = nullptr;
                    return nullptr;
                }
            }
        }
        if (*load_instr) {
            return reduction_instr;
        }
    }

    return nullptr;
}

int DiscoPoP::dp_reduction_get_op_order(char c) {
    if (c == '*' || c == '/') return 5;
    if (c == '+' || c == '-') return 4;
    if (c == '&') return 3;
    if (c == '^') return 2;
    if (c == '|') return 1;
    return 0;
}

Type *DiscoPoP::dp_reduction_pointsToStruct(PointerType *PTy) {
    assert(PTy);
    Type *structType = PTy;
    if (PTy->getTypeID() == Type::PointerTyID) {
        while (structType->getTypeID() == Type::PointerTyID) {
            structType = cast<PointerType>(structType)->getPointerElementType();
        }
    }
    return structType->getTypeID() == Type::StructTyID ? structType : NULL;
}

string DiscoPoP::findStructMemberName_static(MDNode *structNode, unsigned idx, IRBuilder<> &builder) {
    assert(structNode);
    assert(structNode->getOperand(10));
    MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
    if (idx < memberListNodes->getNumOperands()) {
        assert(memberListNodes->getOperand(idx));
        MDNode *member = cast<MDNode>(memberListNodes->getOperand(idx));
        if (member->getOperand(3)) {
            getOrInsertVarName_static(dyn_cast<MDString>(member->getOperand(3))->getString().str(), builder);
            return dyn_cast<MDString>(member->getOperand(3))->getString().str();
        }
    }
    return NULL;
}

// returns the value that the GetElementPtrInst ultimately points to
llvm::Value *DiscoPoP::dp_reduction_points_to_var(llvm::GetElementPtrInst *instr) {
    llvm::Value *points_to = nullptr;
    while (instr) {
        points_to = instr->getPointerOperand();
        instr = llvm::dyn_cast<llvm::GetElementPtrInst>(points_to);
    }
    return points_to;
}


// Finds the load instruction that actually loads the value from the address
// 'load_val'.
llvm::Instruction *DiscoPoP::dp_reduction_get_load_instr(llvm::Value *load_val,
                                                         llvm::Instruction *cur_instr,
                                                         std::vector<char> &reduction_operations) {
    if (!load_val || !cur_instr) return nullptr;
    if (llvm::isa<llvm::LoadInst>(cur_instr)) {
        // Does the current instruction already load the value from the correct
        // address? If that is the case, return it.
        llvm::Value *val = cur_instr->getOperand(0);
        if (val == load_val) return cur_instr;

        // The current instruction does not load the value from the address of
        // 'load_val'. But it might load the value from a variable where 'load_val'
        // is stored in, so find the previous use of the source operand.
        llvm::Instruction *prev_use = dp_reduction_get_prev_use(cur_instr, val);
        if (prev_use) {
            if (llvm::isa<llvm::StoreInst>(prev_use)) {
                return dp_reduction_get_load_instr(load_val, prev_use, reduction_operations);
            } else if (llvm::isa<llvm::GetElementPtrInst>(prev_use)) {
                llvm::GetElementPtrInst *ptr_instr =
                        llvm::cast<llvm::GetElementPtrInst>(prev_use);
                llvm::Value *points_to = dp_reduction_points_to_var(ptr_instr);
                if (points_to == load_val) {
                    return cur_instr;
                } else {
                    bool found = static_cast<bool>(dp_reduction_get_load_instr(
                            load_val, llvm::dyn_cast<llvm::Instruction>(points_to),
                            reduction_operations));
                    return (found) ? cur_instr : nullptr;
                }
            } else {
                bool found = static_cast<bool>(
                        dp_reduction_get_load_instr(load_val, prev_use, reduction_operations));
                return (found) ? cur_instr : nullptr;
            }
        } else {
            return nullptr;
        }
    }

    unsigned opcode = cur_instr->getOpcode();
    char c = dp_reduction_get_char_for_opcode(cur_instr);
    if (c != ' ') {
        reduction_operations.push_back(c);
    }

    // The current instruction is not a load instruction. Follow the operands
    // of the current instruction recursively until the desired load instruction
    // is reached.
    llvm::Instruction *result = nullptr;
    for (unsigned int i = 0; i != cur_instr->getNumOperands(); ++i) {
        llvm::Value *operand = cur_instr->getOperand(i);
        if (llvm::isa<llvm::Instruction>(operand)) {
            result = dp_reduction_get_load_instr(load_val, llvm::cast<llvm::Instruction>(operand),
                                                 reduction_operations);
            if (result) {
                break;
            }
        }
    }

    if (!result && c != ' ') {
        reduction_operations.pop_back();
    }

    return result;
}

// returns the reduction instruction where 'val' is the operand if it can find
// such an operation
llvm::Instruction *DiscoPoP::dp_reduction_find_reduction_instr(llvm::Value *val) {
    if (!val || !llvm::isa<llvm::Instruction>(val)) {
        return nullptr;
    }
    llvm::Instruction *instr = llvm::cast<llvm::Instruction>(val);
    unsigned opcode = instr->getOpcode();
    char c = dp_reduction_get_char_for_opcode(instr);
    if (c != ' ') {
        return instr;
    } else if (opcode == llvm::Instruction::Load) {
        llvm::Instruction *prev_use =
                dp_reduction_get_prev_use(instr, instr->getOperand(0));
        return dp_reduction_find_reduction_instr(prev_use);
    } else if (opcode == llvm::Instruction::Store) {
        return dp_reduction_find_reduction_instr(instr->getOperand(0));
    }
    // enter recursion if the instruction has only a single operand to accomodate for type conversions etc.
    if(instr->getNumOperands() == 1){
        // unpack instruction
        return dp_reduction_find_reduction_instr(instr->getOperand(0));
    }
    // no reduction instruction found
    return nullptr;
}

string DiscoPoP::dp_reduction_determineVariableName(Instruction *I, map <string, string> *trueVarNamesFromMetadataMap) {

    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL) {
        string retVal = getOrInsertVarName_static("", builder);
        if (trueVarNamesFromMetadataMap->find(retVal) == trueVarNamesFromMetadataMap->end()) {
            return retVal;  // not found
        } else {
            return (*trueVarNamesFromMetadataMap)[retVal];  // found
        }
    }

    if (operand->hasName()) {
        //// we've found a global variable
        if (isa<GlobalVariable>(*operand)) {
            string retVal = string(operand->getName());
            if (trueVarNamesFromMetadataMap->find(retVal) == trueVarNamesFromMetadataMap->end()) {
                return retVal;  // not found
            } else {
                return (*trueVarNamesFromMetadataMap)[retVal];  // found
            }
        }
        if (isa<GetElementPtrInst>(*operand)) {
            GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
            Value *ptrOperand = gep->getPointerOperand();
            PointerType *PTy = cast<PointerType>(ptrOperand->getType());

            // we've found a struct/class
            Type *structType = dp_reduction_pointsToStruct(PTy);
            if (structType && gep->getNumOperands() > 2) {
                Value *constValue = gep->getOperand(2);
                if (constValue && isa<ConstantInt>(*constValue)) {
                    ConstantInt *idxPtr = cast<ConstantInt>(gep->getOperand(2));
                    uint64_t memberIdx = *(idxPtr->getValue().getRawData());
                    if (!(cast<StructType>(structType))->isLiteral()) {
                        string strName(structType->getStructName().data());
                        map<string, MDNode *>::iterator it = Structs.find(strName);
                        if (it != Structs.end()) {
                            std::string ret = findStructMemberName_static(it->second, memberIdx, builder);
                            if (ret.size() > 0) {
                                string retVal = ret;
                                if (trueVarNamesFromMetadataMap->find(retVal) == trueVarNamesFromMetadataMap->end()) {
                                    return retVal;  // not found
                                } else {
                                    return (*trueVarNamesFromMetadataMap)[retVal];  // found
                                }
                            } else {
                                string retVal = getOrInsertVarName_static("", builder);
                                if (trueVarNamesFromMetadataMap->find(retVal) == trueVarNamesFromMetadataMap->end()) {
                                    return retVal;  // not found
                                } else {
                                    return (*trueVarNamesFromMetadataMap)[retVal];  // found
                                }
                            }
                        }
                    }
                }
            }

            // we've found an array
            if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand)) {
                return dp_reduction_determineVariableName((Instruction *) ptrOperand, trueVarNamesFromMetadataMap);
            }
            return dp_reduction_determineVariableName((Instruction *) gep, trueVarNamesFromMetadataMap);
        }
        string retVal = string(operand->getName().data());
        if (trueVarNamesFromMetadataMap->find(retVal) == trueVarNamesFromMetadataMap->end()) {
            return retVal;  // not found
        } else {
            return (*trueVarNamesFromMetadataMap)[retVal];  // found
        }
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand)) {
        return dp_reduction_determineVariableName((Instruction * )(operand), trueVarNamesFromMetadataMap);
    }
    // if we cannot determine the name, then return *
    return "*";
}

string DiscoPoP::dp_reduction_determineVariableType(Instruction *I) {
    string s = "";
    string type_str;
    int index = isa<StoreInst>(I) ? 1 : 0;
    raw_string_ostream rso(type_str);
    (*((I->getOperand(index))->getType())).print(rso);

    Value *operand = I->getOperand(index);

    if (operand->hasName()) {
        if (isa<GetElementPtrInst>(*operand)) {
            GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
            Value *ptrOperand = gep->getPointerOperand();
            PointerType *PTy = cast<PointerType>(ptrOperand->getType());
            // we've found a struct/class
            Type *structType = dp_reduction_pointsToStruct(PTy);
            if (structType && gep->getNumOperands() > 2) {
                s = "STRUCT,";
            }
            // we've found an array
            if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID) {
                s = "ARRAY,";
            }
            else{
                // check if previous instruction is a GEP aswell. If so, an Array has been found (e.g. double**)
                Value* prevInst = cast<Instruction>(gep)->getOperand(0);
                if(isa<GetElementPtrInst>(prevInst)){
                    s = "ARRAY,";
                }
                else if(prevInst->getType()->isPointerTy()){
                    s = "ARRAY,";
                }
            }
        }
    }

    s = s + rso.str();
    return s;
}

std::string DiscoPoP::dp_reduction_CFA(Function &F, llvm::Loop *L, int file_id) {
    std::string lid = "LOOPENDNOTFOUND";
    SmallVector < BasicBlock * , 8 > ExitBlocks;
    for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB) {
        BasicBlock *tmpBB = &*BB;
        ExitBlocks.clear();

        // Get the closest loop where tmpBB lives in.
        // (L == NULL) if tmpBB is not in any loop.

        // Check if tmpBB is the loop header (.cond) block.
        if (L != NULL) {
            StringRef loopType = tmpBB->getName().split('.').first;

            // If tmpBB is the header block, get the exit blocks of the loop.
            if (L->hasDedicatedExits()) {
                // loop exits are in canonical form
                L->getUniqueExitBlocks(ExitBlocks);
            } else {
                // loop exits are NOT in canonical form
                L->getExitBlocks(ExitBlocks);
            }

            if (ExitBlocks.size() == 0) {
                continue;
            }

            // When loop has break statement inside, exit blocks may contain
            // the if-else block containing the break. Since we always want
            // to find the real exit (.end) block, we need to check the
            // successors of the break statement(s).
            SmallVector < BasicBlock * , 4 > RealExitBlocks;

            for (SmallVectorImpl<BasicBlock *>::iterator EI = ExitBlocks.begin(), END = ExitBlocks.end();
                 EI != END; ++EI) {
                StringRef exitType = (*EI)->getName().split('.').first;
                if (exitType.equals(loopType) && ((*EI)->getName().find("end") != string::npos) &&
                    (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), *EI) == RealExitBlocks.end())) {
                    RealExitBlocks.push_back(*EI);
                } else {
                    // Changed TerminatorInst to Instruction
                    Instruction *TI = (*EI)->getTerminator();
                    assert(TI != NULL && "Exit block is not well formed!");
                    unsigned int numSucc = TI->getNumSuccessors();
                    for (unsigned int i = 0; i < numSucc; ++i) {
                        BasicBlock *succ = TI->getSuccessor(i);
                        exitType = succ->getName().split('.').first;
                        if (exitType.equals(loopType) && (succ->getName().find("end") != string::npos) &&
                            (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), succ) == RealExitBlocks.end())) {
                            RealExitBlocks.push_back(succ);
                        }
                    }
                }
            }

            if (RealExitBlocks.size() == 0) {
                continue;
            }

            // Check if entry block and exit block(s) have valid LID.
            bool hasValidExit = false;
            for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                 EI != END; ++EI) {
                hasValidExit = dp_reduction_sanityCheck(*EI, file_id);
                if (hasValidExit == true)
                    break;
            }

            if (hasValidExit) {
                for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                     EI != END; ++EI) {
                    BasicBlock *currentBB = *EI;
                    vector < Value * > args;
                    LID lid = 0;

                    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI) {
                        lid = dp_reduction_getLID(&*BI, file_id);
                        uint64_t ulid = (uint64_t) lid;
                        if (ulid != 0) {
                            return to_string(ulid % 16384);
                        }
                    }
                }
            }
        }
    }
    if (lid == "LOOPENDNOTFOUND") {
        if (MDNode * LoopID = L->getLoopID()) {
            DebugLoc Start;
            // We use the first DebugLoc in the header as the start location of the loop
            // and if there is a second DebugLoc in the header we use it as end location
            // of the loop.
            bool foundEnd = false;
            for (unsigned i = 1, ie = LoopID->getNumOperands(); i < ie; ++i) {
                if (DILocation * DIL = dyn_cast<DILocation>(LoopID->getOperand(i))) {
                    if (!Start) {
                        if (foundEnd) {
                            lid = to_string(DebugLoc(DIL)->getLine());

                            break;
                        } else {
                            foundEnd = true;
                        }
                    }
                }
            }

        }
    }
    return lid;
}

// Encode the fileID and line number of BI as LID.
// This is needed to support multiple files in a project.
LID DiscoPoP::dp_reduction_getLID(Instruction *BI, int32_t &fileID) {
    int32_t lno;

    const DebugLoc &location = BI->getDebugLoc();
    if (location) {
        lno = BI->getDebugLoc().getLine();
    } else {
        lno = 0;
    }

    if (lno == 0) {
        return 0;
    }
    LID lid = lno;
    return lid;
}

bool DiscoPoP::dp_reduction_sanityCheck(BasicBlock *BB, int file_id) {
    LID lid;
    for (BasicBlock::iterator BI = BB->begin(), EI = BB->end(); BI != EI; ++BI) {
        lid = dp_reduction_getLID(&*BI, file_id);
        if (lid > 0) {
            return true;
        }
    }
    return false;
}

// returns a char describing the opcode, e.g. '+' for Add or FAdd
// switches + and - if a negative constant is added or subtracted
//(mainly used to support -- as reduction operation, might be implemented as 'add -1')
char DiscoPoP::dp_reduction_get_char_for_opcode(llvm::Instruction* instr) {
    unsigned opcode = instr->getOpcode();

    if (opcode == llvm::Instruction::Add || opcode == llvm::Instruction::FAdd){
        bool operand_is_negative_constant = false;
        if(instr->getNumOperands() >= 1){
            Value* rhs_value = instr->getOperand(1);
            if(isa<ConstantInt>(rhs_value)){
                operand_is_negative_constant = cast<ConstantInt>(rhs_value)->isNegative();
            }
        }

        if(operand_is_negative_constant)
            return '-';
        else
            return '+';

    }
    if (opcode == llvm::Instruction::Sub || opcode == llvm::Instruction::FSub){
        bool operand_is_negative_constant = false;
        if(instr->getNumOperands() >= 1){
            Value* rhs_value = instr->getOperand(1);
            if(isa<ConstantInt>(rhs_value)){
                operand_is_negative_constant = cast<ConstantInt>(rhs_value)->isNegative();
            }
        }

        if (operand_is_negative_constant)
            return '+';
        else
            return '-';
    }
    if (opcode == llvm::Instruction::Mul || opcode == llvm::Instruction::FMul)
        return '*';
    if (opcode == llvm::Instruction::And) return '&';
    if (opcode == llvm::Instruction::Or) return '|';
    if (opcode == llvm::Instruction::Xor) return '^';
    return ' ';
}

// return true if 'operand' is an operand of the instruction 'instr'
bool DiscoPoP::dp_reduction_is_operand(llvm::Instruction *instr, llvm::Value *operand) {
    unsigned num_operands = instr->getNumOperands();
    for (unsigned i = 0; i < num_operands; ++i) {
        if (instr->getOperand(i) == operand) return true;
    }
    return false;
}

// Inserts calls to allow for dynamic analysis of the loops.
void DiscoPoP::dp_reduction_insert_functions() {

    // insert function calls to monitor the variable's load and store operations
    for (auto const &instruction: instructions_) {
        int store_line = instruction.store_inst_->getDebugLoc().getLine();

        // output information about the reduction variables
        *reduction_file << " FileID : " << instruction.file_id_;
        *reduction_file << " Loop Line Number : " << instruction.loop_line_nr_;
        *reduction_file << " Reduction Line Number : " << to_string(store_line);
        *reduction_file << " Variable Name : " << instruction.var_name_;
        *reduction_file << " Operation Name : " << instruction.operation_ << "\n";
    }

    // insert function calls to monitor loop iterations
    std::ofstream loop_metadata_file;
    loop_metadata_file.open("loop_meta.txt");
    int loop_id = 1;
    llvm::Type* loop_incr_fn_arg_type = llvm::Type::getInt32Ty(*ctx_);
    llvm::ArrayRef<llvm::Type*> loop_incr_fn_args(loop_incr_fn_arg_type);
    llvm::FunctionType* loop_incr_fn_type = llvm::FunctionType::get(
            llvm::Type::getVoidTy(*ctx_), loop_incr_fn_args, false);
    FunctionCallee incr_loop_counter_callee = module_->getOrInsertFunction("incr_loop_counter", loop_incr_fn_type);

    for (auto const& loop_info : loops_) {
        llvm::Value* val =
                llvm::ConstantInt::get(llvm::Type::getInt32Ty(*ctx_), loop_id);
        llvm::ArrayRef<llvm::Value*> args(val);
        llvm::CallInst::Create(incr_loop_counter_callee, args, "",
                               loop_info.first_body_instr_);
        loop_metadata_file << loop_info.file_id_ << " ";
        loop_metadata_file << loop_id++ << " ";
        loop_metadata_file << loop_info.line_nr_ << "\n";
    }
    loop_metadata_file.close();

    // add a function to output the final data
    // loop_counter_output
    llvm::FunctionType* output_fn_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(*ctx_), false);
    FunctionCallee loop_counter_output_callee = module_->getOrInsertFunction("loop_counter_output", output_fn_type);
    llvm::Function* main_fn = module_->getFunction("main");
    if (main_fn) {
        for (auto it = llvm::inst_begin(main_fn); it != llvm::inst_end(main_fn);
             ++it) {
            if (llvm::isa<llvm::ReturnInst>(&(*it))) {
                llvm::IRBuilder<> ir_builder(&(*it));
                ir_builder.CreateCall(loop_counter_output_callee);
                break;
            }
        }
    } else {
        llvm::errs() << "Error : Could not find a main function\n";
    }
}

// DPReduction end

//Helper functions
bool DiscoPoP::isaCallOrInvoke(Instruction *BI) {
    return (BI != NULL) && ((isa<CallInst>(BI) && (!isa<DbgDeclareInst>(BI))) || isa<InvokeInst>(BI));
}

bool DiscoPoP::sanityCheck(BasicBlock *BB) {
    LID lid;
    for (BasicBlock::iterator BI = BB->begin(), EI = BB->end(); BI != EI; ++BI) {
        lid = getLID(&*BI, fileID);
        if (lid > 0) {
            return true;
        }
    }
    if(DP_VERBOSE) {
        errs() << "WARNING: basic block " << BB << " doesn't contain valid LID.\n";
    }
    return false;
}

// Control-flow analysis functions

void DiscoPoP::CFA(Function &F, LoopInfo &LI) {
    SmallVector < BasicBlock * , 8 > ExitBlocks;
    for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB) {
        BasicBlock *tmpBB = &*BB;
        ExitBlocks.clear();

        // Get the closest loop where tmpBB lives in.
        // (L == NULL) if tmpBB is not in any loop.
        Loop *L = LI.getLoopFor(tmpBB);

        // Check if tmpBB is the loop header (.cond) block.
        if (L != NULL && LI.isLoopHeader(tmpBB)) {
            StringRef loopType = tmpBB->getName().split('.').first;
            if (DP_DEBUG) {
                errs() << "loop [" << loopType << "] header: " << tmpBB->getName() << "\n";
            }

            // If tmpBB is the header block, get the exit blocks of the loop.
            if (L->hasDedicatedExits()) {
                // loop exits are in canonical form
                L->getUniqueExitBlocks(ExitBlocks);
            } else {
                // loop exits are NOT in canonical form
                L->getExitBlocks(ExitBlocks);
            }

            if (ExitBlocks.size() == 0) {
                errs() << "WARNING: loop at " << tmpBB << " is ignored: exit BB not found.\n";
                continue;
            }

            // When loop has break statement inside, exit blocks may contain
            // the if-else block containing the break. Since we always want
            // to find the real exit (.end) block, we need to check the
            // successors of the break statement(s).
            SmallVector < BasicBlock * , 4 > RealExitBlocks;
            if (DP_DEBUG) {
                errs() << "loop exits:";
            }
            for (SmallVectorImpl<BasicBlock *>::iterator EI = ExitBlocks.begin(), END = ExitBlocks.end();
                 EI != END; ++EI) {
                StringRef exitType = (*EI)->getName().split('.').first;
                if (exitType.equals(loopType) && ((*EI)->getName().find("end") != string::npos) &&
                    (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), *EI) == RealExitBlocks.end())) {
                    RealExitBlocks.push_back(*EI);
                    if (DP_DEBUG) {
                        errs() << " " << (*EI)->getName();
                    }
                } else {
                    // Changed TerminatorInst to Instruction
                    Instruction *TI = (*EI)->getTerminator();
                    assert(TI != NULL && "Exit block is not well formed!");
                    unsigned int numSucc = TI->getNumSuccessors();
                    for (unsigned int i = 0; i < numSucc; ++i) {
                        BasicBlock *succ = TI->getSuccessor(i);
                        exitType = succ->getName().split('.').first;
                        if (exitType.equals(loopType) && (succ->getName().find("end") != string::npos) &&
                            (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), succ) == RealExitBlocks.end())) {
                            RealExitBlocks.push_back(succ);
                            if (DP_DEBUG) {
                                errs() << " " << succ->getName();
                            }
                        }
                    }
                }
            }
            if (DP_DEBUG) {
                errs() << "\n";
            }

            //assert((RealExitBlocks.size() == 1) && "Loop has more than one real exit block!");
            if (RealExitBlocks.size() == 0) {
                if(DP_VERBOSE) {
                    errs() << "WARNING: loop at " << tmpBB << " is ignored: exit blocks are not well formed.\n";
                }
                continue;
            }

            // Check if entry block and exit block(s) have valid LID.
            bool hasValidEntry = sanityCheck(tmpBB);
            bool hasValidExit = false;
            for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                 EI != END; ++EI) {
                hasValidExit = sanityCheck(*EI);
                if (hasValidExit == true)
                    break;
            }

            if (hasValidEntry && hasValidExit) {
                // Instrument loop header block.
                instrumentLoopEntry(tmpBB, loopID);

                // Instrument loop exit block(s).
                for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                     EI != END; ++EI) {
                    instrumentLoopExit(*EI, loopID);
                }
                ++loopID;
            }
        }
    }
}

// pass get invoked here
bool DiscoPoP::runOnModule(Module &M) {
    //cout << "MODULE " << M.getName().str() << "\n";
    long counter = 0;
    //cout << "\tFUNCTION:\n";
    for (Function &F: M) {
        /*
            string to_be_printed = "\t(" + to_string(++counter) + " / " + to_string(M.size()) + ") -- " + F.getName().str();
            while(to_be_printed.size() < 100){
                to_be_printed += " ";
            }
            cout << to_be_printed + "\r";
        */
        runOnFunction(F);
    }

    //cout << "\n\tFunctions Done.\n";

    // DPReduction
    module_ = &M;
    ctx_ = &module_->getContext();

    reduction_file = new std::ofstream();
    reduction_file->open("reduction.txt", std::ios_base::app);

    loop_counter_file = new std::ofstream();
    loop_counter_file->open("loop_counter_output.txt", std::ios_base::app);

    bool success = dp_reduction_init_util(FileMappingPath);
    if (!success) {
        llvm::errs() << "could not find the FileMapping file: " << FileMappingPath << "\n";
        return false;
    }

    instrument_module(&M, &trueVarNamesFromMetadataMap);

    dp_reduction_insert_functions();

    if (reduction_file != NULL && reduction_file->is_open()) {
        reduction_file->flush();
        reduction_file->close();
    }

    if (loop_counter_file != NULL && loop_counter_file->is_open()) {
        loop_counter_file->flush();
        loop_counter_file->close();
    }
    // End DPReduction
    return true;
}

bool DiscoPoP::runOnFunction(Function &F) {
    if (DP_DEBUG) {
        errs() << "pass DiscoPoP: run pass on function\n";
    }

    StringRef funcName = F.getName();
    // Avoid functions we don't want to instrument
    if (funcName.find("llvm.") != string::npos)    // llvm debug calls
    {
        return false;
    }
    if (funcName.find("__dp_") != string::npos)       // instrumentation calls
    {
        return false;
    }
    if (funcName.find("__cx") != string::npos)        // c++ init calls
    {
        return false;
    }
    if (funcName.find("__clang") != string::npos)     // clang helper calls
    {
        return false;
    }
    if (funcName.find("_GLOBAL_") != string::npos)    // global init calls (c++)
    {
        return false;
    }
    if (funcName.find("pthread_") != string::npos) {
        return false;
    }

    vector < CU * > CUVector;
    set <string> globalVariablesSet; // list of variables which appear in more than
    // one basic block
    map <string, vector<CU *>> BBIDToCUIDsMap;

    determineFileID(F, fileID);

    // only instrument functions belonging to project source files
    if (!fileID)
        return false;

    // CUGeneration
    {
        /********************* Initialize root values ***************************/
        Node *root = new Node;
        root->name = F.getName().str();
        root->type = nodeTypes::func;

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
            Type *variableType = it->getType();
            while(variableType->isPointerTy()){
                variableType = variableType->getPointerElementType();
            }
            Variable v(it->getName().str(), rso.str(), to_string(fileID) + ":" + lid, true, true, to_string(variableType->getScalarSizeInBits()/8));
            root->argumentsList.push_back(v);
        }
        /********************* End of initialize root values
         * ***************************/
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();

        // get the top level region
        RIpass = &getAnalysis<RegionInfoPass>(F);
        RI = &(RIpass->getRegionInfo());
        Region *TopRegion = RI->getTopLevelRegion();

        getTrueVarNamesFromMetadata(TopRegion, root, &trueVarNamesFromMetadataMap);

        getFunctionReturnLines(TopRegion, root);

        populateGlobalVariablesSet(TopRegion, globalVariablesSet);

        createCUs(TopRegion, globalVariablesSet, CUVector, BBIDToCUIDsMap, root, LI);

        fillCUVariables(TopRegion, globalVariablesSet, CUVector, BBIDToCUIDsMap);

        fillStartEndLineNumbers(root, LI);

        secureStream();

        // printOriginalVariables(originalVariablesSet);

        printData(root);

        for (auto i: CUVector) {
            delete (i);
        }
    }
    // CUGeneration end

    // DPInstrumentation
    {
        // Check loop parallelism?
        if (ClCheckLoopPar) {
            LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(F).getLoopInfo();
            CFA(F, LI);
        }

        // Instrument the entry of the function.
        // Each function entry is instrumented, and the first
        // executed function will initialize shadow memory.
        // See the definition of __dp_func_entry() for detail.
        instrumentFuncEntry(F);

        // Traverse all instructions, collect loads/stores/returns, check for calls.
        for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
            BasicBlock &BB = *FI;
            runOnBasicBlock(BB);
        }

        if (DP_DEBUG) {
            errs() << "pass DiscoPoP: finished function\n";
        }
    }
    // DPInstrumentation end

    // DPInstrumentationOmission
    {
        if (F.getInstructionCount() == 0) return false;
        if (DP_hybrid_SKIP) return true;
        if (DP_hybrid_DEBUG) errs() << "\n---------- Omission Analysis on " << F.getName() << " ----------\n";

        DebugLoc dl;
        Value *V;

        set < Instruction * > omittableInstructions;

        set < Value * > staticallyPredictableValues;
        // Get local values (variables)
        for (Instruction &I: F.getEntryBlock()) {
            if (AllocaInst * AI = dyn_cast<AllocaInst>(&I)) {
                staticallyPredictableValues.insert(AI);
            }
        }
        for (BasicBlock &BB: F) {
            for (Instruction &I: BB) {
                // Remove from staticallyPredictableValues those which are passed to other functions (by ref/ptr)
                if (CallInst * call_inst = dyn_cast<CallInst>(&I)) {
                    if (Function * Fun = call_inst->getCalledFunction()) {
                        if (Fun->getName() == "__dp_write" || Fun->getName() == "__dp_read" ||
                            Fun->getName() == "__dp_alloca") {
                            ++totalInstrumentations;
                        }
                        for (uint i = 0; i < call_inst->getNumOperands() - 1; ++i) {
                            V = call_inst->getArgOperand(i);
                            std::set<Value *>::iterator it = staticallyPredictableValues.find(V);
                            if (it != staticallyPredictableValues.end()) {
                                staticallyPredictableValues.erase(V);
                                if (DP_hybrid_DEBUG) errs() << VNF->getVarName(V) << "\n";
                            }
                        }
                    }
                }
                // Remove values from locals if dereferenced
                if (isa<StoreInst>(I)) {
                    V = I.getOperand(0);
                    for (Value *w: staticallyPredictableValues) {
                        if (w == V) {
                            staticallyPredictableValues.erase(V);
                        }
                    }
                }
            }
        }

        // assign static memory region IDs to statically predictable values and thus dependencies
        unordered_map<string, pair<string, string>> staticValueNameToMemRegIDMap;  // <SSA variable name>: (original variable name, statically assigned MemReg ID)
        bool tmpIsGlobal;
        long next_id;
        string llvmIRVarName;
        string originalVarName;
        string staticMemoryRegionID;
        for(auto V: staticallyPredictableValues){
            next_id = nextFreeStaticMemoryRegionID++;
            llvmIRVarName = VNF->getVarName(V);
            // Note: Using variables names as keys is only possible at this point, since the map is created for each function individually.
            // Thus, we can rely on the SSA properties of LLVM IR and can assume that e.g. scoping is handled by LLVM and destinct variable names are introduced.
            originalVarName = trueVarNamesFromMetadataMap[llvmIRVarName];
            if(originalVarName.size() == 0){
                // no original variable name could be identified using the available metadata. Fall back to the LLVM IR name of the value.
                originalVarName = llvmIRVarName;
            }
            staticMemoryRegionID = "S" + to_string(next_id);
            staticValueNameToMemRegIDMap[llvmIRVarName] = pair<string, string>(originalVarName, staticMemoryRegionID);
        }

        if (DP_hybrid_DEBUG) {
            errs() << "--- Local Values ---\n";
            for (auto V: staticallyPredictableValues) {
                errs() << VNF->getVarName(V) << "\n";
            }
        }

        // Perform the SPA dependence analysis
        int32_t fid;
        determineFileID(F, fid);
        map < BasicBlock * , set < string >> conditionalBBDepMap;
        map < BasicBlock * , map < BasicBlock *, set < string>>> conditionalBBPairDepMap;

        auto &DT = getAnalysis<DominatorTreeWrapperPass>(F).getDomTree();
        InstructionCFG CFG(VNF, F);
        InstructionDG DG(VNF, &CFG, fid);

        for (auto edge: DG.getEdges()) {
            Instruction *Src = edge->getSrc()->getItem();
            Instruction *Dst = edge->getDst()->getItem();

            V = Src->getOperand(isa<StoreInst>(Src) ? 1 : 0);
            if (isa<AllocaInst>(Dst)) V = dyn_cast<Value>(Dst);

            if (staticallyPredictableValues.find(V) == staticallyPredictableValues.end())
                continue;

            if (Src != Dst && DT.dominates(Dst, Src)) {
                if (!conditionalBBDepMap.count(Src->getParent())) {
                    set <string> tmp;
                    conditionalBBDepMap[Src->getParent()] = tmp;
                }
                conditionalBBDepMap[Src->getParent()].insert(DG.edgeToDPDep(edge, staticValueNameToMemRegIDMap));
            } else {
                if (!conditionalBBPairDepMap.count(Dst->getParent())) {
                    map < BasicBlock * , set < string >> tmp;
                    conditionalBBPairDepMap[Dst->getParent()] = tmp;
                }
                if (!conditionalBBPairDepMap[Dst->getParent()].count(Src->getParent())) {
                    set <string> tmp;
                    conditionalBBPairDepMap[Dst->getParent()][Src->getParent()] = tmp;
                }
                conditionalBBPairDepMap[Dst->getParent()][Src->getParent()].insert(DG.edgeToDPDep(edge, staticValueNameToMemRegIDMap));
            }
            omittableInstructions.insert(Src);
            omittableInstructions.insert(Dst);
        }

        // Omit SPA instructions with no dependences
        for (auto node: DG.getInstructionNodes()) {
            if (!isa<StoreInst>(node->getItem()) && !!isa<LoadInst>(node->getItem())) continue;
            V = node->getItem()->getOperand(isa<StoreInst>(node->getItem()) ? 1 : 0);
            if (!DG.getInEdges(node).size() && !DG.getOutEdges(node).size() &&
                staticallyPredictableValues.find(V) != staticallyPredictableValues.end())
                omittableInstructions.insert(node->getItem());
        }

        // Add observation of execution of single basic blocks
        for (auto pair: conditionalBBDepMap) {
            // Insert call to reportbb
            Instruction *insertionPoint = pair.first->getTerminator();
            if (isa<ReturnInst>(pair.first->getTerminator())) {
                insertionPoint = insertionPoint->getPrevNonDebugInstruction();
            }
            auto CI = CallInst::Create(
                    ReportBB,
                    ConstantInt::get(Int32, bbDepCount),
                    "",
                    insertionPoint
            );

            // ---- Insert deps into string ----
            if (bbDepCount)
                bbDepString += "/";
            bool first = true;
            bbDepString += to_string(bbDepCount) + "=";
            for (auto dep: pair.second) {
                if (!first)
                    bbDepString += ",";
                bbDepString += dep;
                first = false;
            }
            // ---------------------------------
            ++bbDepCount;
        }

        // Add observation of in-order execution of pairs of basic blocks
        for (auto pair1: conditionalBBPairDepMap) {
            // Alloca and init semaphore var for BB
            auto AI = new AllocaInst(Int32, 0, "__dp_bb",
                                     F.getEntryBlock().getFirstNonPHI()->getNextNonDebugInstruction());
            new StoreInst(ConstantInt::get(Int32, 0), AI, false, AI->getNextNonDebugInstruction());

            for (auto pair2: pair1.second) {
                // Insert check for semaphore
                Instruction *insertionPoint = pair2.first->getTerminator();
                if (isa<ReturnInst>(pair2.first->getTerminator()))
                    insertionPoint = insertionPoint->getPrevNonDebugInstruction();

                auto LI = new LoadInst(Int32, AI, Twine(""), false, insertionPoint);
                ArrayRef < Value * > arguments({LI, ConstantInt::get(Int32, bbDepCount)});
                CallInst::Create(
                        ReportBBPair,
                        arguments,
                        "",
                        insertionPoint
                );

                // ---- Insert deps into string ----
                if (bbDepCount)
                    bbDepString += "/";
                bbDepString += to_string(bbDepCount);
                bbDepString += "=";
                bool first = true;
                for (auto dep: pair2.second) {
                    if (!first)
                        bbDepString += ",";
                    bbDepString += dep;
                    first = false;
                }
                // ----------------------------------
                ++bbDepCount;
            }
            // Insert semaphore update to true
            new StoreInst(ConstantInt::get(Int32, 1), AI, false, pair1.first->getTerminator());
        }

        if (DumpToDot) {
            CFG.dumpToDot(fileName + "_" + string(F.getName()) + ".CFG.dot");
            DG.dumpToDot(fileName + "_" + string(F.getName()) + ".DG.dot");
        }

        if (DP_hybrid_DEBUG) {
            errs() << "--- Conditional BB Dependences:\n";
            for (auto pair: conditionalBBDepMap) {
                errs() << pair.first->getName() << ":\n";
                for (auto s: pair.second) {
                    errs() << "\t" << s << "\n";
                }
            }

            errs() << "--- Conditional BB-Pair Dependences:\n";
            for (auto pair1: conditionalBBPairDepMap) {
                for (auto pair2: pair1.second) {
                    errs() << pair1.first->getName() << "-";
                    errs() << pair2.first->getName() << ":\n";
                    for (auto s: pair2.second)
                        errs() << "\t" << s << "\n";
                }
            }
        }

        if (DP_hybrid_DEBUG) {
            errs() << "--- Program Instructions:\n";
            for (BasicBlock &BB: F) {
                for (Instruction &I: BB) {
                    if (!isa<StoreInst>(I) && !isa<LoadInst>(I) && !isa<AllocaInst>(I))
                        continue;
                    errs() << "\t" << (isa<StoreInst>(I) ? "Write " : (isa<AllocaInst>(I) ? "Alloca " : "Read "))
                           << " | ";
                    if (dl = I.getDebugLoc()) {
                        errs() << dl.getLine() << "," << dl.getCol();
                    } else {
                        errs() << F.getSubprogram()->getLine() << ",*";
                    }
                    errs() << " | ";
                    V = I.getOperand(isa<StoreInst>(I) ? 1 : 0);
                    if (isa<AllocaInst>(I)) {
                        V = dyn_cast<Value>(&I);
                    }
                    errs() << VNF->getVarName(V);

                    if (omittableInstructions.find(&I) != omittableInstructions.end()) {
                        errs() << " | OMITTED";
                    }
                    errs() << "\n";
                }
            }
        }

        // Remove omittable instructions from profiling
        Instruction *DP_Instrumentation;
        for (Instruction *I: omittableInstructions) {
            if (isa<AllocaInst>(I)) {
                DP_Instrumentation = I->getNextNode()->getNextNode();
            } else {
                DP_Instrumentation = I->getPrevNode();
            }

            if (!DP_Instrumentation)
                continue;
            if (CallInst * call_inst = dyn_cast<CallInst>(DP_Instrumentation)) {
                if (Function * Fun = call_inst->getCalledFunction()) {
                    string fn = Fun->getName().str();
                    if (fn == "__dp_write" || fn == "__dp_read" || fn == "__dp_alloca") {
                        DP_Instrumentation->eraseFromParent();
                        ++removedInstrumentations;
                    }
                }
            }
        }

        // Report statically identified dependencies

        staticDependencyFile = new std::ofstream();
        staticDependencyFile->open("static_dependencies.txt", std::ios_base::app);

        for (auto pair: conditionalBBDepMap) {
                for (auto s: pair.second) {
                    *staticDependencyFile << s << "\n";
                }
        }
        staticDependencyFile->flush();
        staticDependencyFile->close();

        if (DP_hybrid_DEBUG) errs() << "Done with function " << F.getName() << ":\n";
    }
    // DPInstrumentationOmission end
    return true;
}

void DiscoPoP::collectDebugInfo() {
    if (NamedMDNode * CU_Nodes = ThisModule->getNamedMetadata("llvm.dbg.cu")) {
        for (unsigned i = 0, e = CU_Nodes->getNumOperands(); i != e; ++i) {
            DICompileUnit *CU = cast<DICompileUnit>(CU_Nodes->getOperand(i));
            auto GVs = CU->getGlobalVariables();
            for (unsigned i = 0, e = GVs.size(); i < e; ++i) {
                DIGlobalVariable *DIG = GVs[i]->getVariable();
                if (DIG) {
                    GlobalVars.insert(DIG);
                }
            }
        }
    }
}

DIGlobalVariable *DiscoPoP::findDbgGlobalDeclare(GlobalVariable *v) {
    assert(v && "Global variable cannot be null");
    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it) {
        if ((*it)->getDisplayName() == v->getName())
            return *it;
    }
    return NULL;
}

string DiscoPoP::getOrInsertVarName_static(string varName, IRBuilder<> &builder)
{
    Value *valName = NULL;
    std::string vName = varName;
    map<string, Value *>::iterator pair = VarNames.find(varName);
    if (pair == VarNames.end())
    {
        valName = builder.CreateGlobalStringPtr(StringRef(varName.c_str()), ".str");

        VarNames[varName] = valName;
    }
    else
    {
        vName = pair->first;
    }

    return vName;
}


Value *DiscoPoP::getOrInsertVarName_dynamic(string varName, IRBuilder<> &builder)
{
    // 26.08.2022 Lukas
    // update varName with original varName from Metadata
    if (trueVarNamesFromMetadataMap.find(varName) == trueVarNamesFromMetadataMap.end()) {
        // not found, do nothing
    } else {
        // found, update varName
        varName = trueVarNamesFromMetadataMap[varName];
    }

    Value *vName = NULL;
    map<string, Value *>:: iterator pair = VarNames.find(varName);
    if (pair == VarNames.end())
    {
        vName = builder.CreateGlobalStringPtr(StringRef(varName.c_str()), ".str");
        VarNames[varName] = vName;
    }
    else
    {
        vName = pair->second;
    }
    return vName;
}


Value *DiscoPoP::findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder) {
    assert(structNode);
    assert(structNode->getOperand(10));
    MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
    if (idx < memberListNodes->getNumOperands()) {
        assert(memberListNodes->getOperand(idx));
        MDNode *member = cast<MDNode>(memberListNodes->getOperand(idx));
        if (member->getOperand(3)) {
            return getOrInsertVarName_dynamic(dyn_cast<MDString>(member->getOperand(3))->getString().str(), builder);
        }
    }
    return NULL;
}

Type *DiscoPoP::pointsToStruct(PointerType *PTy) {
    assert(PTy);
    Type *structType = PTy;
    if (PTy->getTypeID() == Type::PointerTyID) {
        while (structType->getTypeID() == Type::PointerTyID) {
            structType = cast<PointerType>(structType)->getElementType();
        }
    }
    return structType->getTypeID() == Type::StructTyID ? structType : NULL;
}

string DiscoPoP::determineVariableName_static(Instruction *I, bool &isGlobalVariable /*=defaultIsGlobalVariableValue*/, bool disable_MetadataMap)
{

    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL)
    {
        string retVal = getOrInsertVarName_static("", builder);
        if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
            return retVal;  // not found
        } else {
            return trueVarNamesFromMetadataMap[retVal];  // found
        }
    }

    if (operand->hasName())
    {
        //// we've found a global variable
        if (isa<GlobalVariable>(*operand))
        {
            //MOHAMMAD ADDED THIS FOR CHECKING
            isGlobalVariable = true;
            string retVal = string(operand->getName());
            if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
                return retVal;  // not found
            } else {
                return trueVarNamesFromMetadataMap[retVal];  // found
            }
        }
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
                    if (!(cast<StructType>(structType))->isLiteral())
                    {
                        string strName(structType->getStructName().data());
                        map<string, MDNode *>::iterator it = Structs.find(strName);
                        if (it != Structs.end())
                        {
                            std::string ret = findStructMemberName_static(it->second, memberIdx, builder);
                            if (ret.size() > 0)
                            {
                                string retVal = ret;
                                if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
                                    return retVal;  // not found
                                } else {
                                    return trueVarNamesFromMetadataMap[retVal];  // found
                                }
                            }
                            else
                            {
                                string retVal = getOrInsertVarName_static("", builder);
                                if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
                                    return retVal;  // not found
                                } else {
                                    return trueVarNamesFromMetadataMap[retVal];  // found
                                }
                            //return ret;
                            }
                        }
                    }
                }
            }

            // we've found an array
            if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand))
            {
                return determineVariableName_static((Instruction *)ptrOperand, isGlobalVariable, false);
            }
            return determineVariableName_static((Instruction *)gep, isGlobalVariable, false);
        }
        string retVal = string(operand->getName().data());
        if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
            return retVal;  // not found
        } else {
            return trueVarNamesFromMetadataMap[retVal];  // found
        }
        //return getOrInsertVarName(string(operand->getName().data()), builder);
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand))
    {
        return determineVariableName_static((Instruction *)(operand), isGlobalVariable, false);
    }
    // if we cannot determine the name, then return *
    return ""; //getOrInsertVarName("*", builder);
}


   Value *DiscoPoP::determineVariableName_dynamic(Instruction *const I)
{
    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL)
    {
        return getOrInsertVarName_dynamic("*", builder);
    }

    if (operand->hasName())
    {
        // we've found a global variable
        if (isa<GlobalVariable>(*operand))
        {
            DIGlobalVariable *gv = findDbgGlobalDeclare(cast<GlobalVariable>(operand));
            if (gv != NULL)
            {
                return getOrInsertVarName_dynamic(string (gv->getDisplayName().data()), builder);
            }
        }
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
                            Value *ret = findStructMemberName(it->second, memberIdx, builder);
                            if (ret)
                                return ret;
                        }
                    }
                }
            }

            // we've found an array
            if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand))
            {
                return determineVariableName_dynamic((Instruction *)ptrOperand);
            }
            return determineVariableName_dynamic((Instruction *)gep);
        }
        return getOrInsertVarName_dynamic(string(operand->getName().data()), builder);
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand))
    {
        return determineVariableName_dynamic((Instruction *)(operand));
    }
    if (isa<AllocaInst>(I)){
        return getOrInsertVarName_dynamic(I->getName().str(), builder);
    }
    // if we cannot determine the name, then return *
    return getOrInsertVarName_dynamic("*", builder);
}


void DiscoPoP::getTrueVarNamesFromMetadata(Region *TopRegion, Node *root,
                                           std::map <string, string> *trueVarNamesFromMetadataMap) {
    int lid = 0;
    for (Region::block_iterator bb = TopRegion->block_begin(); bb != TopRegion->block_end(); ++bb) {
        for (BasicBlock::iterator instruction = (*bb)->begin(); instruction != (*bb)->end(); ++instruction) {
            // search for call instructions to @llvm.dbg.declare
            if (isa<CallInst>(instruction)) {
                Function *f = (cast<CallInst>(instruction))->getCalledFunction();
                if (f) {
                    StringRef funcName = f->getName();
                    if (funcName.find("llvm.dbg.declare") != string::npos) // llvm debug calls
                    {
                        CallInst *call = cast<CallInst>(instruction);
                        // check if @llvm.dbg.declare is called
                        // int cmp_res = dbg_declare.compare(call->getCalledFunction()->getName().str());
                        // if(cmp_res == 0){
                        // call to @llvm.dbg.declare found
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

void DiscoPoP::processStructTypes(string const &fullStructName, MDNode *structNode) {
    assert(structNode && "structNode cannot be NULL");
    DIType *strDes = cast<DIType>(structNode);
    assert(strDes->getTag() == dwarf::DW_TAG_structure_type);
    // sometimes it's impossible to get the list of struct members (e.g badref)
    if (structNode->getNumOperands() <= 10 || structNode->getOperand(10) == NULL) {
        errs() << "cannot process member list of this struct: \n";
        structNode->dump();
        return;
    }
    Structs[fullStructName] = structNode;

    MDNode *memberListNodes = cast<MDNode>(structNode->getOperand(10));
    for (unsigned i = 0; i < memberListNodes->getNumOperands(); ++i) {
        assert(memberListNodes->getOperand(i));
        MDNode *member = cast<MDNode>(memberListNodes->getOperand(i));
        DINode *memberDes = cast<DINode>(member);
        // DIDescriptor memberDes(member);
        if (memberDes->getTag() == dwarf::DW_TAG_member) {
            assert(member->getOperand(9));
            MDNode *memberType = cast<MDNode>(member->getOperand(9));
            DIType *memberTypeDes = cast<DIType>(memberType);
            // DIType memberTypeDes(memberType);
            if (memberTypeDes->getTag() == dwarf::DW_TAG_structure_type) {
                string fullName = "";
                // try to get namespace
                if (memberType->getNumOperands() > 2 && structNode->getOperand(2) != NULL) {
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


/********** Output functions *********/
string DiscoPoP::xmlEscape(string data) {
    string::size_type pos = 0;
    for (;;) {
        pos = data.find_first_of("\"&<>", pos);
        if (pos == string::npos)
            break;
        string replacement;
        switch (data[pos]) {
            case '\"':
                replacement = "&quot;";
                break;
            case '&':
                replacement = "&amp;";
                break;
            case '<':
                replacement = "&lt;";
                break;
            case '>':
                replacement = "&gt;";
                break;
            default:;
        }
        data.replace(pos, 1, replacement);
        pos += replacement.size();
    };
    return data;
}

void DiscoPoP::secureStream() {
    outOriginalVariables = new std::ofstream();
    outOriginalVariables->open("OriginalVariables.txt", std::ios_base::app);

    outCUs = new std::ofstream();
    outCUs->open("Data.xml", std::ios_base::app);

    outCUIDCounter = new std::ofstream();
    outCUIDCounter->open("DP_CUIDCounter.txt", std::ios_base::out);
}

string DiscoPoP::getLineNumbersString(set<int> LineNumbers) {
    string line = "";
    for (auto li: LineNumbers) {
        std::string temp = ',' + dputil::decodeLID(li);
        if (temp != ",*") {
            if (line == "") {
                line = dputil::decodeLID(li);
            } else {
                line = line + temp;
            }
        }
    }
    return line;
}

string DiscoPoP::getChildrenNodesString(Node *root) {
    string childrenIDs = "";
    int i = 0;
    std::for_each(root->childrenNodes.begin(), root->childrenNodes.end(),
                  [&](Node *node) {
                      if (i == 0) {
                          childrenIDs = node->ID;
                          i++;
                      } else {
                          childrenIDs += "," + node->ID;
                      }
                  });
    return childrenIDs;
}


void DiscoPoP::printData(Node *root) {
    *outCUs << "<Nodes>" << endl << endl;

    printTree(root, true);

    *outCUs << "</Nodes>" << endl << endl << endl;

    closeOutputFiles();
}

void DiscoPoP::printTree(Node *root, bool isRoot) {
    printNode(root, isRoot);

    std::for_each(root->childrenNodes.begin(), root->childrenNodes.end(),
                  [&](Node *node) {
                      if (node->type == nodeTypes::func) {
                          isRoot = false;
                      }
                      printTree(node, isRoot);
                  });
}

void DiscoPoP::printNode(Node *root, bool isRoot) {
    if (root->name.find("llvm")) {
        string start = "";
        if (root->type == nodeTypes::loop) {
            start = loopStartLines[root->ID];
        } else {
            start = dputil::decodeLID(root->startLine);
        }
        *outCUs << "\t<Node"
                << " id=\"" << xmlEscape(root->ID) << "\""
                << " type=\"" << root->type << "\""
                << " name=\"" << xmlEscape(root->name) << "\""
                << " startsAtLine = \"" << start << "\""
                << " endsAtLine = \"" << dputil::decodeLID(root->endLine) << "\""
                << ">" << endl;
        *outCUs << "\t\t<childrenNodes>" << getChildrenNodesString(root)
                << "</childrenNodes>" << endl;
        if (root->type == nodeTypes::func || root->type == nodeTypes::dummy) {
            *outCUs << "\t\t<funcArguments>" << endl;
            for (auto ai: root->argumentsList) {
                *outCUs << "\t\t\t<arg type=\"" << xmlEscape(ai.type) << "\""
                        << " defLine=\"" << xmlEscape(ai.defLine) << "\""
                        << " sizeInByte=\"" << ai.sizeInBytes << "\""
                        << " accessMode=\"" << (ai.readAccess ? "R" : "") << (ai.writeAccess ? "W" : "")
                        << "\">"
                        << xmlEscape(ai.name) << "</arg>" << endl;
            }
            *outCUs << "\t\t</funcArguments>" << endl;

            string rlVals = "";
            for (auto rl: root->returnLines) {
                rlVals += dputil::decodeLID(rl) + ", ";
            }
            *outCUs << "\t\t<funcReturnLines>" << rlVals << "</funcReturnLines>"
                    << endl;
        }

        if (root->type == nodeTypes::cu) {
            CU *cu = static_cast<CU *>(root);
            *outCUs << "\t\t<BasicBlockID>" << cu->BBID << "</BasicBlockID>" << endl;
            *outCUs << "\t\t<readDataSize>" << cu->readDataSize << "</readDataSize>"
                    << endl;
            *outCUs << "\t\t<writeDataSize>" << cu->writeDataSize
                    << "</writeDataSize>" << endl;
            *outCUs << "\t\t<performsFileIO>" << cu->performsFileIO
                    << "</performsFileIO>" << endl;

            *outCUs << "\t\t<instructionsCount>" << cu->instructionsCount
                    << "</instructionsCount>" << endl;
            *outCUs << "\t\t<instructionLines count=\""
                    << (cu->instructionsLineNumbers).size() << "\">"
                    << getLineNumbersString(cu->instructionsLineNumbers)
                    << "</instructionLines>" << endl;
            *outCUs << "\t\t<readPhaseLines count=\""
                    << (cu->readPhaseLineNumbers).size() << "\">"
                    << getLineNumbersString(cu->readPhaseLineNumbers)
                    << "</readPhaseLines>" << endl;
            *outCUs << "\t\t<writePhaseLines count=\""
                    << (cu->writePhaseLineNumbers).size() << "\">"
                    << getLineNumbersString(cu->writePhaseLineNumbers)
                    << "</writePhaseLines>" << endl;
            *outCUs << "\t\t<returnInstructions count=\""
                    << (cu->returnInstructions).size() << "\">"
                    << getLineNumbersString(cu->returnInstructions)
                    << "</returnInstructions>" << endl;
            *outCUs << "\t\t<successors>" << endl;
            for (auto sucCUi: cu->successorCUs) {
                *outCUs << "\t\t\t<CU>" << sucCUi << "</CU>" << endl;
            }
            *outCUs << "\t\t</successors>" << endl;

            *outCUs << "\t\t<localVariables>" << endl;
            for (auto lvi: cu->localVariableNames) {
                *outCUs << "\t\t\t<local type=\"" << xmlEscape(lvi.type) << "\""
                        << " defLine=\"" << xmlEscape(lvi.defLine) << "\""
                        << " sizeInByte=\"" << lvi.sizeInBytes << "\""
                        << " accessMode=\"" << (lvi.readAccess ? "R" : "") << (lvi.writeAccess ? "W" : "")
                        << "\">"
                        << xmlEscape(lvi.name) << "</local>" << endl;
            }
            *outCUs << "\t\t</localVariables>" << endl;

            *outCUs << "\t\t<globalVariables>" << endl;
            for (auto gvi: cu->globalVariableNames) {
                *outCUs << "\t\t\t<global type=\"" << xmlEscape(gvi.type) << "\""
                        << " defLine=\"" << xmlEscape(gvi.defLine) << "\""
                        << " sizeInByte=\"" << gvi.sizeInBytes << "\""
                        << " accessMode=\"" << (gvi.readAccess ? "R" : "") << (gvi.writeAccess ? "W" : "")
                        << "\">"
                        << xmlEscape(gvi.name) << "</global>" << endl;
            }
            *outCUs << "\t\t</globalVariables>" << endl;

            *outCUs << "\t\t<callsNode>" << endl;
            for (auto i: (cu->callLineTofunctionMap)) {
                for (auto ii: i.second) {
                    *outCUs << "\t\t\t<nodeCalled atLine=\"" << dputil::decodeLID(i.first)
                            << "\">" << ii->ID << "</nodeCalled>" << endl;
                    // specifica for recursive fucntions inside loops. (Mo 5.11.2019)
                    *outCUs << "\t\t\t\t<recursiveFunctionCall>"
                            << ii->recursiveFunctionCall << "</recursiveFunctionCall>"
                            << endl;
                }
            }
            *outCUs << "\t\t</callsNode>" << endl;
        }

        *outCUs << "\t</Node>" << endl << endl;
    }
}

void DiscoPoP::closeOutputFiles() {

    if (outCUs != NULL && outCUs->is_open()) {
        outCUs->flush();
        outCUs->close();
    }

    if (outOriginalVariables != NULL && outOriginalVariables->is_open()) {
        outOriginalVariables->flush();
        outOriginalVariables->close();
    }

    if(outCUIDCounter != NULL && outCUIDCounter->is_open()){
        outCUIDCounter->flush();
        outCUIDCounter->close();
    }
    // delete outCUs;
}
/************** End of output functions *******************/

/* metadata format in LLVM IR:
!5 = metadata !{
  i32,      ;; Tag (see below)  // DW_TAG_pointer_type:     0
  metadata, ;; Reference to context  // 1
  metadata, ;; Name (may be "" for anonymous types) // 2
  metadata, ;; Reference to file where defined (may be NULL) // 3
  i32,      ;; Line number where defined (may be 0) // 4
  i64,      ;; Size in bits // 5
  i64,      ;; Alignment in bits // 6
  i64,      ;; Offset in bits // 7
  i32,      ;; Flags to encode attributes, e.g. private // 8
  metadata, ;; Reference to type derived from     // 9   --> get operand at index 9
  metadata, ;; (optional) Name of the Objective C property associated with
            ;; Objective-C an ivar, or the type of which this
            ;; pointer-to-member is pointing to members of.
  metadata, ;; (optional) Name of the Objective C property getter selector.
  metadata, ;; (optional) Name of the Objective C property setter selector.
  i32       ;; (optional) Objective C property attributes.
}

A real case would be:
!2 = metadata !{
  i32 524307,        ;; Tag   // 0
  metadata !1,       ;; Context // 1
  metadata !"Color", ;; Name // 2
  metadata !1,       ;; Compile unit // 3
  i32 1,             ;; Line number // 4
  i64 96,            ;; Size in bits // 5
  i64 32,            ;; Align in bits // 6
  i64 0,             ;; Offset in bits // 7
  i32 0,             ;; Flags // 8
  null,              ;; Derived From // 9
  metadata !3,       ;; Elements // 10 --> list of elements
  i32 0              ;; Runtime Language
}
*/
// TODO: atomic variables
void DiscoPoP::runOnBasicBlock(BasicBlock &BB) {
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI) {
        if (DbgDeclareInst * DI = dyn_cast<DbgDeclareInst>(BI)) {
            assert(DI->getOperand(0));
            if (AllocaInst * alloc = dyn_cast<AllocaInst>(DI->getOperand(0))) {
                Type *type = alloc->getAllocatedType();
                Type *structType = type;
                unsigned depth = 0;
                if (type->getTypeID() == Type::PointerTyID) {
                    while (structType->getTypeID() == Type::PointerTyID) {
                        structType = cast<PointerType>(structType)->getElementType();
                        ++depth;
                    }
                }
                if (structType->getTypeID() == Type::StructTyID) {
                    assert(DI->getOperand(1));
                    MDNode *varDesNode = DI->getVariable();
                    assert(varDesNode->getOperand(5));
                    MDNode *typeDesNode = cast<MDNode>(varDesNode->getOperand(5));
                    MDNode *structNode = typeDesNode;
                    if (type->getTypeID() == Type::PointerTyID) {
                        MDNode *ptr = typeDesNode;
                        for (unsigned i = 0; i < depth; ++i) {
                            assert(ptr->getOperand(9));
                            ptr = cast<MDNode>(ptr->getOperand(9));
                        }
                        structNode = ptr;
                    }
                    DINode *strDes = cast<DINode>(structNode);
                    // DIDescriptor strDes(structNode);
                    // handle the case when we have pointer to struct (or pointer to pointer to struct ...)
                    if (strDes->getTag() == dwarf::DW_TAG_pointer_type) {
                        DINode *ptrDes = strDes;
                        do {
                            if (structNode->getNumOperands() < 10)
                                break;
                            assert(structNode->getOperand(9));
                            structNode = cast<MDNode>(structNode->getOperand(9));
                            ptrDes = cast<DINode>(structNode);
                        } while (ptrDes->getTag() != dwarf::DW_TAG_structure_type);
                    }

                    if (strDes->getTag() == dwarf::DW_TAG_typedef) {
                        assert(strDes->getOperand(9));
                        structNode = cast<MDNode>(strDes->getOperand(9));
                    }
                    strDes = cast<DINode>(structNode);
                    if (strDes->getTag() == dwarf::DW_TAG_structure_type) {
                        string strName(structType->getStructName().data());
                        if (Structs.find(strName) == Structs.end()) {
                            processStructTypes(strName, structNode);
                        }
                    }
                }
            }
        }
            // alloca instruction
        else if (isa<AllocaInst>(BI)) {
            AllocaInst *AI = cast<AllocaInst>(BI);

            // if the option is set, check if the AllocaInst is static at the entry block of
            // a function and skip it's instrumentation.
            // This leads to a strong improvement of the profiling time if a lot of function
            // calls are used, but results in a worse accurracy.
            // As the default, the accurate profiling is used.
            // Effectively, this check disables the instrumentation of allocas which belong to function parameters.

            if(DP_MEMORY_PROFILING_SKIP_FUNCTION_ARGUMENTS){
                if(! AI->isStaticAlloca()){
                    // only instrument non-static alloca instructions
                    instrumentAlloca(AI);
                }
            }
            else{
                // instrument every alloca instruction
                instrumentAlloca(AI);
            }

            
        }
            // load instruction
        else if (isa<LoadInst>(BI)) {
            instrumentLoad(cast<LoadInst>(BI));
        }
            // // store instruction
        else if (isa<StoreInst>(BI)) {
            instrumentStore(cast<StoreInst>(BI));
        }
            // call and invoke
        else if (isaCallOrInvoke(&*BI)) {
            Function *F;
            if (isa<CallInst>(BI))
                F = (cast<CallInst>(BI))->getCalledFunction();
            else if (isa<InvokeInst>(BI))
                F = (cast<InvokeInst>(BI))->getCalledFunction();

            // For ordinary function calls, F has a name.
            // However, sometimes the function being called
            // in IR is encapsulated by "bitcast()" due to
            // the way of compiling and linking. In this way,
            // getCalledFunction() method returns NULL.
            StringRef fn = "";
            if (F) {
                fn = F->getName();
                if (fn.find("__dp_") != string::npos)           // avoid instrumentation calls
                {
                    continue;
                }
                if (fn.find("__clang_") != string::npos)        // clang helper calls
                {
                    continue;
                }
                if (fn.equals("pthread_exit")) {
                    // pthread_exit does not return to its caller.
                    // Therefore, we insert DpFuncExit before pthread_exit
                    IRBuilder<> IRBRet(&*BI);
                    ArrayRef < Value * >
                    arguments({ConstantInt::get(Int32, getLID(&*BI, fileID)), ConstantInt::get(Int32, 0)});
                    IRBRet.CreateCall(DpFuncExit, arguments);
                    continue;
                }
                if (fn.equals("exit") || F->doesNotReturn())    // using exit() to terminate program
                {
                    // only insert DpFinalize right before the main program exits
                    insertDpFinalize(&*BI);
                    continue;
                }
                if (fn.equals("_Znam") || fn.equals("_Znwm") || fn.equals("malloc"))
                {
                    if(isa<CallInst>(BI)){
                        instrumentNewOrMalloc(cast<CallInst>(BI));
                    }
                    else if(isa<InvokeInst>(BI)){
                        instrumentNewOrMalloc(cast<InvokeInst>(BI));
                    }
                    continue;
                }
                if (fn.equals("_ZdlPv") || fn.equals("free"))
                {
                    instrumentDeleteOrFree(cast<CallBase>(BI));
                    continue;
                }

            }
            LID lid = getLID(&*BI, fileID);
            if (lid > 0)                   // calls on non-user code are not instrumented
            {
                IRBuilder<> IRBCall(&*BI);
                IRBCall.CreateCall(DpCallOrInvoke, ConstantInt::get(Int32, lid));
                if (DP_DEBUG) {
                    if (isa<CallInst>(BI)) {
                        if (!fn.equals(""))
                            errs() << "calling " << fn << " on " << lid << "\n";
                        else
                            errs() << "calling unknown function on " << lid << "\n";
                    } else {
                        if (!fn.equals(""))
                            errs() << "invoking " << fn << " on " << lid << "\n";
                        else
                            errs() << "invoking unknown function on " << lid << "\n";
                    }
                }
            }
        }
            // return
        else if (isa<ReturnInst>(BI)) {
            LID lid = getLID(&*BI, fileID);
            assert((lid > 0) && "Returning on LID = 0!");

            Function *parent = BB.getParent();
            assert(parent != NULL);
            StringRef fn = parent->getName();

            if (fn.equals("main"))     // returning from main
            {
                insertDpFinalize(&*BI);
            } else {
                IRBuilder<> IRBRet(&*BI);
                ArrayRef < Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, 0)});
                IRBRet.CreateCall(DpFuncExit, arguments);
            }

            if (DP_DEBUG) {
                errs() << fn << " returning on " << lid << "\n";
            }
        }
    }
}

// Instrumentation function inserters.
void DiscoPoP::instrumentAlloca(AllocaInst *toInstrument) {
    LID lid = getLID(toInstrument, fileID);
    if (lid == 0)
        return;

    // NOTE: manual memory management using malloc etc. not covered yet!


    IRBuilder<> IRB(toInstrument->getNextNode());

    vector < Value * > args;
    args.push_back(ConstantInt::get(Int32, lid));
    args.push_back(determineVariableName_dynamic(toInstrument));

    bool isGlobal;
    //Value *startAddr = PtrToIntInst::CreatePointerCast(toInstrument, Int64, "", toInstrument->getNextNonDebugInstruction());
    Value *startAddr = IRB.CreatePtrToInt(toInstrument, Int64, "");
    args.push_back(startAddr);

    Value *endAddr = startAddr;
    uint64_t elementSizeInBytes = toInstrument->getAllocatedType()->getScalarSizeInBits() / 8;
    Value *numElements = toInstrument->getOperand(0);
    if(toInstrument->isArrayAllocation()){
        // endAddr = startAddr + allocated size
        endAddr = IRB.CreateAdd(startAddr, IRB.CreateIntCast(numElements, Int64, true));
    }
    else if(toInstrument->getAllocatedType()->isArrayTy()){
        // unpack potentially multidimensional allocations

        Type *typeToParse = toInstrument->getAllocatedType();
        Type *elementType;

        uint64_t tmp_numElements = 1;

        // unpack multidimensional allocations
        while(typeToParse->isArrayTy()){
            // extract size from current dimension and multiply to numElements
            tmp_numElements *= cast<ArrayType>(typeToParse)->getNumElements();
            // proceed one dimension
            typeToParse = typeToParse->getArrayElementType();
        }
        // typeToParse now contains the element type
        elementType = typeToParse;

        // allocated size = Element size in Bytes * Number of elements
        elementSizeInBytes = elementType->getScalarSizeInBits() / 8;

        // endAddr = startAddr + allocated size
        numElements = ConstantInt::get(Int64, tmp_numElements);
        endAddr = IRB.CreateAdd(startAddr, IRB.CreateIntCast(numElements, Int64, true));
    }

    args.push_back(endAddr);
    args.push_back(IRB.CreateMul(IRB.CreateIntCast(numElements, Int64, true), ConstantInt::get(Int64, elementSizeInBytes)));
    args.push_back(IRB.CreateIntCast(numElements, Int64, true));
    IRB.CreateCall(DpAlloca, args, "");
}   

void DiscoPoP::instrumentNewOrMalloc(CallBase *toInstrument) {
    // add instrumentation for new instructions or calls to malloc
    LID lid = getLID(toInstrument, fileID);
    if(lid == 0)
        return;

    // Determine correct placement for the call to __dp_new
    Instruction* nextInst;
    if(isa<CallInst>(toInstrument)){
        nextInst = toInstrument->getNextNonDebugInstruction();
    }
    else if(isa<InvokeInst>(toInstrument)){
        // Invoke instructions are always located at the end of a basic block.
        // Invoke instructions may throw errors, in which case the successor is a "landing pad" basic block.
        // If no error is thrown, the control flow is resumed at a "normal destination" basic block.
        // Set the first instruction of the normal destination as nextInst in order to add the Instrumentation at the correct location.
        nextInst = cast<InvokeInst>(toInstrument)->getNormalDest()->getFirstNonPHIOrDbg();
    }

    IRBuilder<> IRB(nextInst);

    vector < Value * > args;
    args.push_back(ConstantInt::get(Int32, lid));

    Value* startAddr = PtrToIntInst::CreatePointerCast(toInstrument, Int64, "", nextInst);
    Value* endAddr = startAddr;
    Value* numBytes = toInstrument->getArgOperand(0);

    args.push_back(startAddr);
    args.push_back(endAddr);  // currently unused
    args.push_back(numBytes);

    IRB.CreateCall(DpNew, args, "");
}

void DiscoPoP::instrumentDeleteOrFree(CallBase *toInstrument) {
    // add instrumentation for delete instructions or calls to free
    LID lid = getLID(toInstrument, fileID);
    if(lid == 0)
        return;
    IRBuilder<> IRB(toInstrument->getNextNonDebugInstruction());

    vector < Value * > args;
    args.push_back(ConstantInt::get(Int32, lid));


    Value* startAddr = PtrToIntInst::CreatePointerCast(toInstrument->getArgOperand(0), Int64, "", toInstrument->getNextNode());

    args.push_back(startAddr);

    IRB.CreateCall(DpDelete, args, "");
}


void DiscoPoP::instrumentLoad(LoadInst *toInstrument) {

    LID lid = getLID(toInstrument, fileID);
    if (lid == 0)
        return;

    vector < Value * > args;

    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                                                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVariableName_dynamic(toInstrument));

#ifdef SKIP_DUP_INSTR
    Twine name = Twine("L").concat(Twine(uniqueNum));

    GlobalVariable *addrTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,//trackerType
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),//trackerType
                           name);
    GlobalVariable *countTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),
                           name.concat(Twine("count")));
    uniqueNum++;

    //Load current values before instr
    LoadInst *currentAddrTracker = new LoadInst::LoadInst(addrTracker, Twine(), toInstrument);
    LoadInst *currentCount = new LoadInst::LoadInst(countTracker, Twine(), toInstrument);

    //add instr before before
    args.push_back(currentAddrTracker);
    args.push_back(currentCount);
#endif
    CallInst::Create(DpRead, args, "", toInstrument);

#ifdef SKIP_DUP_INSTR
    //Post instrumentation call
    //Create updates
    StoreInst *addrUpdate = new StoreInst::StoreInst(memAddr, addrTracker);
    BinaryOperator::BinaryOperator *incCount =
        BinaryOperator::Create(Instruction::Add,
                               currentCount,
                               ConstantInt::get(Int64, 1)
                              );
    StoreInst *countUpdate = new StoreInst::StoreInst(incCount, countTracker);

    //add updates after before
    addrUpdate->insertAfter(toInstrument);
    incCount->insertAfter(toInstrument);
    countUpdate->insertAfter(incCount);
#endif
}


void DiscoPoP::instrumentStore(StoreInst *toInstrument) {

    LID lid = getLID(toInstrument, fileID);
    if (lid == 0) return;

    vector < Value * > args;
    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                                                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVariableName_dynamic(toInstrument));

#ifdef SKIP_DUP_INSTR
    Twine name = Twine("S").concat(Twine(uniqueNum));

    GlobalVariable *addrTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,//trackerType
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),//trackerType
                           name);
    GlobalVariable *countTracker =
        new GlobalVariable(*this->ThisModule,
                           Int64,
                           false,
                           GlobalVariable::PrivateLinkage,
                           Constant::getNullValue(Int64),
                           name.concat(Twine("count")));
    uniqueNum++;

    //Load current values before instr
    LoadInst *currentAddrTracker = new LoadInst::LoadInst(addrTracker, Twine(), toInstrument);
    LoadInst *currentCount = new LoadInst::LoadInst(countTracker, Twine(), toInstrument);

    //add instr before before
    args.push_back(currentAddrTracker);
    args.push_back(currentCount);
#endif

    CallInst::Create(DpWrite, args, "", toInstrument);

#ifdef SKIP_DUP_INSTR
    //Post instrumentation call
    //Create updates
    StoreInst *addrUpdate = new StoreInst::StoreInst(memAddr, addrTracker);
    BinaryOperator::BinaryOperator *incCount =
        BinaryOperator::Create(Instruction::Add,
                               currentCount,
                               ConstantInt::get(Int64, 1)
                              );
    StoreInst *countUpdate = new StoreInst::StoreInst(incCount, countTracker);

    //add updates after before
    addrUpdate->insertAfter(toInstrument);
    incCount->insertAfter(toInstrument);
    countUpdate->insertAfter(incCount);
#endif
}

void DiscoPoP::insertDpFinalize(Instruction *before) {
    LID lid = getLID(before, fileID);
    assert((lid > 0) && "Returning on an invalid LID.");
    IRBuilder<> IRB(before);
    IRB.CreateCall(DpFinalize, ConstantInt::get(Int32, lid));
}

void DiscoPoP::instrumentFuncEntry(Function &F) {
    BasicBlock &entryBB = F.getEntryBlock();
    LID lid = 0;
    int32_t isStart = 0;

    StringRef fn = F.getName();
    if (fn.equals("main")){
        isStart = 1;

        // insert 'allocations' of global variables
        Instruction *insertBefore = &*entryBB.begin();

        auto tmp_end = F.getParent()->getGlobalList().end();
        tmp_end--;  // necessary, since the list of Globals is modified when e.g. new strings are created.
        for(auto Global_it = F.getParent()->getGlobalList().begin(); Global_it != tmp_end; Global_it++){
            // ignore globals which make use of "Appending Linkage", since they are system internal
            // and do not behave like regular values. An example for such a value is @llvm.global_ctors
            if (cast<GlobalVariable>(&*Global_it)->hasAppendingLinkage()){
                continue;
            }

            IRBuilder<> IRB(insertBefore->getNextNode());

            vector < Value * > args;
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(getOrInsertVarName_dynamic(Global_it->getName().str(), IRB));

            bool isGlobal;
            //Value *startAddr = PtrToIntInst::CreatePointerCast(toInstrument, Int64, "", toInstrument->getNextNonDebugInstruction());
            Value *startAddr = IRB.CreatePtrToInt(cast<Value>(&*Global_it), Int64, "");
            args.push_back(startAddr);
            
            Value *endAddr = startAddr;
            uint64_t numElements = 1;
            uint64_t allocatedSize = Global_it->getValueType()->getScalarSizeInBits();
            if(Global_it->getValueType()->isArrayTy()){
                // unpack potentially multidimensional allocations
                Type *typeToParse = Global_it->getValueType();
                Type *elementType;

                // unpack multidimensional allocations
                while(typeToParse->isArrayTy()){
                    // extract size from current dimension and multiply to numElements
                    numElements *= cast<ArrayType>(typeToParse)->getNumElements();
                    // proceed one dimension
                    typeToParse = typeToParse->getArrayElementType();
                }
                // typeToParse now contains the element type
                elementType = typeToParse;

                // allocated size = Element size in Bytes * Number of elements
                auto elementSizeInBytes = elementType->getScalarSizeInBits() / 8;
                allocatedSize = elementSizeInBytes * numElements;

                // endAddr = startAddr + allocated size
                endAddr = IRB.CreateAdd(startAddr, ConstantInt::get(Int64, allocatedSize));
            }

            args.push_back(endAddr);
            args.push_back(ConstantInt::get(Int64, allocatedSize));
            args.push_back(ConstantInt::get(Int64, numElements));
            IRB.CreateCall(DpAlloca, args, "");
        }
    }

    // We always want to insert __dp_func_entry at the beginning
    // of the basic block, but we need the first valid LID to
    // get the entry line of the function.
    for (BasicBlock::iterator BI = entryBB.begin(), EI = entryBB.end(); BI != EI; ++BI) {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI)) {
            IRBuilder<> IRB(&*entryBB.begin());
            //NOTE: Changed to arrayref
            ArrayRef < Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, isStart)});
            IRB.CreateCall(DpFuncEntry, arguments);
            if (DP_DEBUG) {
                errs() << "DiscoPoP: funcEntry instrumented\n";
            }
            break;
        }
    }
    assert((lid > 0) && "Function entry is not instrumented because LID are all invalid for the entry block.");
}

void DiscoPoP::instrumentLoopEntry(BasicBlock *bb, int32_t id) {
    BasicBlock *currentBB = bb;
    vector < Value * > args;
    LID lid = 0;

    // Take care of the order of instrumentation functions for loop entry
    // and exit. Loop exit must appear before the next loop entry.
    // Usually every loop has a .end block as the exit block, thus the
    // exit of a loop will not be the entry of another loop. The first if
    // check is just in case the blocks are organized in a abnormal way.
    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI) {
        if (isa<CallInst>(BI)) {
            Function *tmpF = (cast<CallInst>(BI))->getCalledFunction();
            StringRef tmpFn = tmpF->getName();
            if (tmpFn.find("__dp_loop_exit") != string::npos)
                continue;
        }
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI)) {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopEntry, args, "", &*BI);
            break;
        }
    }
    //assert((lid > 0) && "Loop entry is not instrumented because LID are all invalid for the whole basic block.");
}

void DiscoPoP::instrumentLoopExit(BasicBlock *bb, int32_t id) {
    BasicBlock *currentBB = bb;
    vector < Value * > args;
    LID lid = 0;

    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI) {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI)) {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopExit, args, "", &*currentBB->begin()); // always insert to the beiginning
            break;
        }
    }
}
