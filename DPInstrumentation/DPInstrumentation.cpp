/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2019, Technische Universitaet Darmstadt, Germany
 * Copyright (c) 2012-2015, German Research School for Simulation Sciences GmbH, Juelich/Aachen, Germany
 *
 * This software may be modified and distributed under the terms of
 * a BSD-style license.  See the LICENSE file in the package base
 * directory for details.
 *
 */

#define DEBUG_TYPE "dpop"
//#define SKIP_DUP_INSTR 1

#include "llvm/Transforms/Instrumentation.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/APInt.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "llvm/PassAnalysisSupport.h"
#include "llvm/PassSupport.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"

#include "DPUtils.h"

#include <set>
#include <map>
#include <cstdlib>

#define DP_DEBUG false

using namespace llvm;
using namespace std;
using namespace dputil;

// Command line options
static cl::opt<bool> ClCheckLoopPar("dp-loop-par", cl::init(true),
                                    cl::desc("Check loop parallelism"), cl::Hidden);

namespace
{

    // DiscoPoP: instrument the code in module to find potential parallelism
    class DiscoPoP : public FunctionPass
    {
    public:
        DiscoPoP() : FunctionPass(ID), uniqueNum(1) {};
        ~DiscoPoP();

        StringRef getPassName() const;
        bool runOnFunction(Function &F);
        void runOnBasicBlock(BasicBlock &BB);
        bool doInitialization(Module &M);
        void getAnalysisUsage(AnalysisUsage &Info) const;

        static char ID; // Pass identification, replacement for typeid

    private:
        // Initializations
        void setupDataTypes();
        void setupCallbacks();

        // Helper functions
        bool isaCallOrInvoke(Instruction *BI);
        bool sanityCheck(BasicBlock *BB);
        void collectDebugInfo();
        void processStructTypes(string const &fullStructName, MDNode *structNode);
        DIGlobalVariable *findDbgGlobalDeclare(GlobalVariable *V);
        Value *getOrInsertVarName(string varName, IRBuilder<> &builder);
        Value *findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder);
        Type *pointsToStruct(PointerType *PTy);
        Value *determineVarName(Instruction *const I);

        // Control flow analysis
        void CFA(Function &F, LoopInfo &LI);

        // Callback Inserters
        //void insertDpInit(const vector<Value*> &args, Instruction *before);
        //void insertDpFinalize(Instruction *before);
        void instrumentStore(StoreInst *toInstrument);
        void instrumentLoad(LoadInst *toInstrument);
        void insertDpFinalize(Instruction *before);
        void instrumentFuncEntry(Function &F);
        void instrumentLoopEntry(BasicBlock *bb, int32_t id);
        void instrumentLoopExit(BasicBlock *bb, int32_t id);

        int64_t uniqueNum;

        // Callbacks to run-time library
        Function *DpInit, *DpFinalize;
        Function *DpRead, *DpWrite;
        Function *DpCallOrInvoke;
        Function *DpFuncEntry, *DpFuncExit;
        Function *DpLoopEntry, *DpLoopExit;

        // Basic types
        Type *Void;
        IntegerType *Int32, *Int64;
        PointerType *CharPtr;

        // Control flow analysis
        int32_t loopID;
        int32_t fileID;

        // Output streams
        ofstream ocfg;

        // Export Module M from runOnModule() to the whole structure space
        Module *ThisModule;
        LLVMContext *ThisModuleContext;

        map<string, Value *> VarNames;
        set<DIGlobalVariable *> GlobalVars;
        map<string, MDNode *> Structs;
    };
}  // namespace

char DiscoPoP::ID = 0;

static RegisterPass<DiscoPoP> X("DiscoPoP", "DiscoPoP: finding potential parallelism.", false, false);

static void loadPass(const PassManagerBuilder &Builder, legacy::PassManagerBase &PM)
{
    PM.add(new LoopInfoWrapperPass());
    PM.add(new DiscoPoP());
}

static RegisterStandardPasses DiscoPoPLoader_Ox(PassManagerBuilder::EP_OptimizerLast, loadPass);
static RegisterStandardPasses DiscoPoPLoader_O0(PassManagerBuilder::EP_EnabledOnOptLevel0, loadPass);

FunctionPass *createDiscoPoPPass()
{
    if (DP_DEBUG)
    {
        errs() << "create DiscoPoP \n";
    }
    initializeLoopInfoWrapperPassPass(*PassRegistry::getPassRegistry());
    return new DiscoPoP();
}

StringRef DiscoPoP::getPassName() const
{
    return "DiscoPoP";
}

// Initializations
void DiscoPoP::setupDataTypes()
{
    Void = const_cast<Type *>(Type::getVoidTy(*ThisModuleContext));
    Int32 = const_cast<IntegerType *>(IntegerType::getInt32Ty(*ThisModuleContext));
    Int64 = const_cast<IntegerType *>(IntegerType::getInt64Ty(*ThisModuleContext));
    CharPtr = const_cast<PointerType *>(Type::getInt8PtrTy(*ThisModuleContext));
}

void DiscoPoP::setupCallbacks()
{
    /* function name
     * return value type
     * arg types
     * NULL
     */
    DpInit = cast<Function>(ThisModule->getOrInsertFunction("__dp_init",
                            Void,
                            Int32, Int32, Int32));

    DpFinalize = cast<Function>(ThisModule->getOrInsertFunction("__dp_finalize",
                                Void,
                                Int32));

    DpRead = cast<Function>(ThisModule->getOrInsertFunction("__dp_read",
                            Void,
#ifdef SKIP_DUP_INSTR
                            Int32, Int64, CharPtr, Int64, Int64
#else
                            Int32, Int64, CharPtr
#endif
                            ));

    DpWrite = cast<Function>(ThisModule->getOrInsertFunction("__dp_write",
                             Void,
#ifdef SKIP_DUP_INSTR
                             Int32, Int64, CharPtr, Int64, Int64
#else
                             Int32, Int64, CharPtr
#endif
                             ));

    DpCallOrInvoke = cast<Function>(ThisModule->getOrInsertFunction("__dp_call",
                                    Void,
                                    Int32));

    DpFuncEntry = cast<Function>(ThisModule->getOrInsertFunction("__dp_func_entry",
                                 Void,
                                 Int32, Int32));

    DpFuncExit = cast<Function>(ThisModule->getOrInsertFunction("__dp_func_exit",
                                Void,
                                Int32, Int32));

    DpLoopEntry = cast<Function>(ThisModule->getOrInsertFunction("__dp_loop_entry",
                                 Void,
                                 Int32, Int32));

    DpLoopExit = cast<Function>(ThisModule->getOrInsertFunction("__dp_loop_exit",
                                Void,
                                Int32, Int32));
}

bool DiscoPoP::doInitialization(Module &M)
{
    if (DP_DEBUG)
    {
        errs() << "DiscoPoP | 190: init pass DiscoPoP \n";
    }
    // Export M to the outside
    ThisModule = &M;
    ThisModuleContext = &(M.getContext());

    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it)
    {
        GlobalVars.erase(it);
        // delete (*it);
    }
    
    GlobalVars.clear();
    Structs.clear();
    collectDebugInfo();

    // Initialize variables needed
    setupDataTypes();
    setupCallbacks();

    // Check loop parallelism?
    if (ClCheckLoopPar)
    {
        if (DP_DEBUG)
        {
            errs() << "check loop parallelism \n";
        }
        loopID = 0;
        //ocfg.open("CFG.txt", std::ios::out);
    }
    else
    {
        loopID = -1;
    }
    return true;
}

DiscoPoP::~DiscoPoP()
{
    if (ocfg.is_open())
    {
        ocfg.flush();
        ocfg.close();
    }
}

void DiscoPoP::getAnalysisUsage(AnalysisUsage &Info) const
{
    Info.addRequired<LoopInfoWrapperPass>();
}

//Helper functions
bool DiscoPoP::isaCallOrInvoke(Instruction *BI)
{
    return (BI != NULL) && ((isa<CallInst>(BI) && (!isa<DbgDeclareInst>(BI))) || isa<InvokeInst>(BI));
}

bool DiscoPoP::sanityCheck(BasicBlock *BB)
{
    int32_t lid;
    for (BasicBlock::iterator BI = BB->begin(), EI = BB->end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0)
        {
            return true;
        }
    }
    errs() << "WARNING: basic block " << BB << " doesn't contain valid LID.\n";
    return false;
}

// Control-flow analysis functions

void DiscoPoP::CFA(Function &F, LoopInfo &LI)
{
    SmallVector<BasicBlock *, 8> ExitBlocks;
    for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
    {
        BasicBlock *tmpBB = &*BB;
        ExitBlocks.clear();

        // Get the closest loop where tmpBB lives in.
        // (L == NULL) if tmpBB is not in any loop.
        Loop *L = LI.getLoopFor(tmpBB);

        // Check if tmpBB is the loop header (.cond) block.
        if (L != NULL && LI.isLoopHeader(tmpBB))
        {
            StringRef loopType = tmpBB->getName().split('.').first;
            if (DP_DEBUG)
            {
                errs() << "loop [" << loopType << "] header: " << tmpBB->getName() << "\n";
            }

            // If tmpBB is the header block, get the exit blocks of the loop.
            if (L->hasDedicatedExits())
            {
                // loop exits are in canonical form
                L->getUniqueExitBlocks(ExitBlocks);
            }
            else
            {
                // loop exits are NOT in canonical form
                L->getExitBlocks(ExitBlocks);
            }

            if (ExitBlocks.size() == 0)
            {
                errs() << "WARNING: loop at " << tmpBB << " is ignored: exit BB not found.\n";
                continue;
            }

            // When loop has break statement inside, exit blocks may contain
            // the if-else block containing the break. Since we always want
            // to find the real exit (.end) block, we need to check the
            // successors of the break statement(s).
            SmallVector<BasicBlock *, 4> RealExitBlocks;
            if (DP_DEBUG)
            {
                errs() << "loop exits:";
            }
            for (SmallVectorImpl<BasicBlock *>::iterator EI = ExitBlocks.begin(), END = ExitBlocks.end();
                    EI != END; ++EI)
            {
                StringRef exitType = (*EI)->getName().split('.').first;
                if (exitType.equals(loopType) && ((*EI)->getName().find("end") != string::npos) &&
                        (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), *EI) == RealExitBlocks.end()))
                {
                    RealExitBlocks.push_back(*EI);
                    if (DP_DEBUG)
                    {
                        errs() << " " << (*EI)->getName();
                    }
                }
                else
                {
		    // Changed TerminatorInst to Instruction
                    Instruction *TI = (*EI)->getTerminator();
                    assert(TI != NULL && "Exit block is not well formed!");
                    unsigned int numSucc = TI->getNumSuccessors();
                    for (unsigned int i = 0; i < numSucc; ++i)
                    {
                        BasicBlock *succ = TI->getSuccessor(i);
                        exitType = succ->getName().split('.').first;
                        if (exitType.equals(loopType) && (succ->getName().find("end") != string::npos) &&
                                (std::find(RealExitBlocks.begin(), RealExitBlocks.end(), succ) == RealExitBlocks.end()))
                        {
                            RealExitBlocks.push_back(succ);
                            if (DP_DEBUG)
                            {
                                errs() << " " << succ->getName();
                            }
                        }
                    }
                }
            }
            if (DP_DEBUG)
            {
                errs() << "\n";
            }

            //assert((RealExitBlocks.size() == 1) && "Loop has more than one real exit block!");
            if (RealExitBlocks.size() == 0)
            {
                errs() << "WARNING: loop at " << tmpBB << " is ignored: exit blocks are not well formed.\n";
                continue;
            }

            // Check if entry block and exit block(s) have valid LID.
            bool hasValidEntry = sanityCheck(tmpBB);
            bool hasValidExit = false;
            for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                    EI != END; ++ EI)
            {
                hasValidExit = sanityCheck(*EI);
                if (hasValidExit == true)
                    break;
            }

            if (hasValidEntry && hasValidExit)
            {
                // Instrument loop header block.
                instrumentLoopEntry(tmpBB, loopID);

                // Instrument loop exit block(s).
                for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                        EI != END; ++ EI)
                {
                    instrumentLoopExit(*EI, loopID);
                }
                ++loopID;
            }
        }
    }
}

// pass get invoked here
bool DiscoPoP::runOnFunction(Function &F)
{
    if (DP_DEBUG)
    {
        errs() << "pass DiscoPoP: run pass on function\n";
    }

    StringRef funcName = F.getName();
    // Avoid functions we don't want to instrument
    if (funcName.find("llvm.dbg") != string::npos)    // llvm debug calls
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
    if (funcName.find("pthread_") != string::npos)
    {
        return false;
    }

    determineFileID(F, fileID);
    
    // only instrument functions belonging to project source files
    if (!fileID)
        return false;

    // Check loop parallelism?
    if (ClCheckLoopPar)
    {
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
        CFA(F, LI);
    }

    // Instrument the entry of the function.
    // Each function entry is instrumented, and the first
    // executed function will initialize shadow memory.
    // See the definition of __dp_func_entry() for detail.
    instrumentFuncEntry(F);

    // Traverse all instructions, collect loads/stores/returns, check for calls.
    for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI)
    {
        BasicBlock &BB = *FI;
        runOnBasicBlock(BB);
    }

    if (DP_DEBUG)
    {
        errs() << "pass DiscoPoP: finished function\n";
    }
    return true;
}

void DiscoPoP::collectDebugInfo()
{
    if (NamedMDNode *CU_Nodes = ThisModule->getNamedMetadata("llvm.dbg.cu"))
    {
        for (unsigned i = 0, e = CU_Nodes->getNumOperands(); i != e; ++i)
        {
            DICompileUnit *CU = cast<DICompileUnit>(CU_Nodes->getOperand(i));
            // DICompileUnit CU(CU_Nodes->getOperand(i));
            auto GVs = CU->getGlobalVariables();
            for (unsigned i = 0, e = GVs.size(); i < e; ++i)
            {
                DIGlobalVariable *DIG = GVs[i]->getVariable();
                if (DIG)
                {
                    GlobalVars.insert(DIG);
                }
            }
        }
    }
}

DIGlobalVariable *DiscoPoP::findDbgGlobalDeclare(GlobalVariable *v)
{
    assert(v && "Global variable cannot be null");
    for (set<DIGlobalVariable *>::iterator it = GlobalVars.begin(); it != GlobalVars.end(); ++it)
    {
        if ((*it)->getDisplayName() == v->getName())
            return *it;
    }
    return NULL;
}

Value *DiscoPoP::getOrInsertVarName(string varName, IRBuilder<> &builder)
{
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

Value *DiscoPoP::findStructMemberName(MDNode *structNode, unsigned idx, IRBuilder<> &builder)
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
            return getOrInsertVarName(dyn_cast<MDString>(member->getOperand(3))->getString(), builder);
    }
    return NULL;
}

Type *DiscoPoP::pointsToStruct(PointerType *PTy)
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

Value *DiscoPoP::determineVarName(Instruction *const I)
{
    assert(I && "Instruction cannot be NULL \n");
    int index = isa<StoreInst>(I) ? 1 : 0;
    Value *operand = I->getOperand(index);

    IRBuilder<> builder(I);

    if (operand == NULL)
    {
        return getOrInsertVarName("*", builder);
    }

    if (operand->hasName())
    {
        // we've found a global variable
        if (isa<GlobalVariable>(*operand))
        {
            DIGlobalVariable *gv = findDbgGlobalDeclare(cast<GlobalVariable>(operand));
            if (gv != NULL)
            {
                return getOrInsertVarName(string (gv->getDisplayName().data()), builder);
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
            if (PTy->getElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand))
            {
                return determineVarName((Instruction *)ptrOperand);
            }
            return determineVarName((Instruction *)gep);
        }
        return getOrInsertVarName(string(operand->getName().data()), builder);
    }

    if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand))
    {
        return determineVarName((Instruction *)(operand));
    }
    // if we cannot determine the name, then return *
    return getOrInsertVarName("*", builder);
}

void DiscoPoP::processStructTypes(string const &fullStructName, MDNode *structNode)
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
void DiscoPoP::runOnBasicBlock(BasicBlock &BB)
{
    for (BasicBlock::iterator BI = BB.begin(), E = BB.end(); BI != E; ++BI)
    {
        if (DbgDeclareInst *DI = dyn_cast<DbgDeclareInst>(BI))
        {
            assert(DI->getOperand(0));
            //MDNode* node = cast<MDNode>(DI->getOperand(0));
            // llvm.dbg.declare changes from LLVM 3.3 to 3.6.1:
            // LLVM 3.6.1: call @llvm.dbg.declare(metadata %struct.x* %1, metadata !1, metadata !2)
            // LLVM 3.3:   call @llvm.dbg.declare(metadata !{%struct.x* %1}, metadata !1, metadata !2)
            // diff: operand 0 changes from MDNode* to Value*
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
                    // LLVM 3.6.1:
                    // DbgDeclareInst *DI->getOperand(1) ==> MDNode* getVariable()
                    //                *DI->getOperand(2) ==> MDNode* getExpression()
                    // Methods Metadata* getRawVariable() and Metadata* getRawExpression() are listed on
                    // LLVM online document, but do not exist in source code of 3.6.1.
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
        // load instruction
        else if (isa<LoadInst>(BI))
        {
            instrumentLoad(cast<LoadInst>(BI));
        }
        // // store instruction
        else if (isa<StoreInst>(BI))
        {
            instrumentStore(cast<StoreInst>(BI));
        }
        // call and invoke
        else if (isaCallOrInvoke(&*BI))
        {
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
            if (F)
            {
                fn = F->getName();
                if (fn.find("__dp_") != string::npos)           // avoid instrumentation calls
                {
                    continue;
                }
                if (fn.find("__clang_") != string::npos)        // clang helper calls
                {
                    continue;
                }
                if (fn.equals("pthread_exit"))
                {
                    // pthread_exit does not return to its caller.
                    // Therefore, we insert DpFuncExit before pthread_exit
                    IRBuilder<> IRBRet(&*BI);
                    ArrayRef< Value * > arguments({ConstantInt::get(Int32, getLID(&*BI, fileID)), ConstantInt::get(Int32, 0)});
                    IRBRet.CreateCall(DpFuncExit, arguments);
                    continue;
                }
                if (fn.equals("exit") || F->doesNotReturn())    // using exit() to terminate program
                {
                    // only insert DpFinalize right before the main program exits
                    insertDpFinalize(&*BI);
                    continue;
                }

            }
            int32_t lid = getLID(&*BI, fileID);
            if (lid > 0)                   // calls on non-user code are not instrumented
            {
                IRBuilder<> IRBCall(&*BI);
                IRBCall.CreateCall(DpCallOrInvoke, ConstantInt::get(Int32, lid));
                if (DP_DEBUG)
                {
                    if (isa<CallInst>(BI))
                    {
                        if (!fn.equals(""))
                            errs() << "calling " << fn << " on " << lid << "\n";
                        else
                            errs() << "calling unknown function on " << lid << "\n";
                    }
                    else
                    {
                        if (!fn.equals(""))
                            errs() << "invoking " << fn << " on " << lid << "\n";
                        else
                            errs() << "invoking unknown function on " << lid << "\n";
                    }
                }
            }
        }
        // return
        else if (isa<ReturnInst>(BI))
        {
            int32_t lid = getLID(&*BI, fileID);
            assert((lid > 0) && "Returning on LID = 0!");

            Function *parent = BB.getParent();
            assert(parent != NULL);
            StringRef fn = parent->getName();

            if (fn.equals("main"))     // returning from main
            {
                insertDpFinalize(&*BI);
            }
            else
            {
                IRBuilder<> IRBRet(&*BI);
                ArrayRef< Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, 0)});
                IRBRet.CreateCall(DpFuncExit, arguments);
            }

            if (DP_DEBUG)
            {
                errs() << fn << " returning on " << lid << "\n";
            }
        }
    }
}

// Instrumentation function inserters.
void DiscoPoP::instrumentLoad(LoadInst *toInstrument)
{

    int32_t lid = getLID(toInstrument, fileID);
    if (lid == 0) return;

    vector<Value *> args;

    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVarName(toInstrument));

#ifdef SKIP_DUP_INSTR
    //Value* loadAddr = args[1];
    //Type* trackerType = v2->getType();

    //cout << "Creating Load " << uniqueNum;
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


void DiscoPoP::instrumentStore(StoreInst *toInstrument)
{

    int32_t lid = getLID(toInstrument, fileID);
    if (lid == 0) return;

    vector<Value *> args;
    args.push_back(ConstantInt::get(Int32, lid));

    Value *memAddr = PtrToIntInst::CreatePointerCast(toInstrument->getPointerOperand(),
                     Int64, "", toInstrument);
    args.push_back(memAddr);

    args.push_back(determineVarName(toInstrument));

#ifdef SKIP_DUP_INSTR
    //Value* storeAddr = args[1];
    //Type* trackerType = v2->getType();

    //cout << "Creating Store " << uniqueNum;
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

void DiscoPoP::insertDpFinalize(Instruction *before)
{
    int32_t lid = getLID(before, fileID);
    assert((lid > 0) && "Returning on an invalid LID.");
    IRBuilder<> IRB(before);
    IRB.CreateCall(DpFinalize, ConstantInt::get(Int32, lid));
}

void DiscoPoP::instrumentFuncEntry(Function &F)
{
    BasicBlock &entryBB = F.getEntryBlock();
    int32_t lid = 0;
    int32_t isStart = 0;

    StringRef fn = F.getName();
    if (fn.equals("main"))
        isStart = 1;

    // We always want to insert __dp_func_entry at the beginning
    // of the basic block, but we need the first valid LID to
    // get the entry line of the function.
    for (BasicBlock::iterator BI = entryBB.begin(), EI = entryBB.end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            IRBuilder<> IRB(&*entryBB.begin());
            //NOTE: Changed to arrayref
            ArrayRef< Value * > arguments({ConstantInt::get(Int32, lid), ConstantInt::get(Int32, isStart)});
            IRB.CreateCall(DpFuncEntry, arguments);
            if (DP_DEBUG)
            {
                errs() << "DiscoPoP: funcEntry instrumented\n";
            }
            break;
        }
    }
    assert((lid > 0) && "Function entry is not instrumented because LID are all invalid for the entry block.");
}

void DiscoPoP::instrumentLoopEntry(BasicBlock *bb, int32_t id)
{
    BasicBlock *currentBB = bb;
    vector<Value *> args;
    int32_t lid = 0;

    // Take care of the order of instrumentation functions for loop entry
    // and exit. Loop exit must appear before the next loop entry.
    // Usually every loop has a .end block as the exit block, thus the
    // exit of a loop will not be the entry of another loop. The first if
    // check is just in case the blocks are organized in a abnormal way.
    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI)
    {
        if (isa<CallInst>(BI))
        {
            Function *tmpF = (cast<CallInst>(BI))->getCalledFunction();
            StringRef tmpFn = tmpF->getName();
            if (tmpFn.find("__dp_loop_exit") != string::npos)
                continue;
        }
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopEntry, args, "", &*BI);
            break;
        }
    }
    //assert((lid > 0) && "Loop entry is not instrumented because LID are all invalid for the whole basic block.");
}

void DiscoPoP::instrumentLoopExit(BasicBlock *bb, int32_t id)
{
    BasicBlock *currentBB = bb;
    vector<Value *> args;
    int32_t lid = 0;

    for (BasicBlock::iterator BI = currentBB->begin(), EI = currentBB->end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI, fileID);
        if (lid > 0 && !isa<PHINode>(BI))
        {
            args.push_back(ConstantInt::get(Int32, lid));
            args.push_back(ConstantInt::get(Int32, id));
            CallInst::Create(DpLoopExit, args, "", &*currentBB->begin()); // always insert to the beiginning
            break;
        }
    }
    //assert((lid > 0) && "Loop exit is not instrumented because LID are all invalid for the whole basic block.");
}
