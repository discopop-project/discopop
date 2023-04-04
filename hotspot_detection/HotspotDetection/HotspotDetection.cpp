#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <filesystem>
#include "llvm/Pass.h"
//#include "llvm/LoopPass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
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
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/PassRegistry.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/CallGraph.h"
#include <set>
#include <map>
#include <cstdlib>

#define DP_DEBUG false

using namespace llvm;
using namespace std;

long int fid = 0;
long int lnid = 0;
long int loopID = 1;
string name;
//std::vector<string> fileNames; 

std::ofstream ofile;
std::ofstream myfile;

int64_t getLID(Instruction* BI)
{
    int64_t lno;
/*
        if (DILocation *Loc = I->getDebugLoc()) { // Here I is an LLVM instruction
          unsigned Line = Loc->getLine();
          StringRef File = Loc->getFilename();
          StringRef Dir = Loc->getDirectory();
          bool ImplicitCode = Loc->isImplicitCode();
        }
*/
    const DebugLoc &location = BI->getDebugLoc();
    if (location)
    {
        lno = BI->getDebugLoc().getLine();
    }
    else
    {
        lno = 0;
    }
    if (lno == 0)
    {
        return 0;
    }
    return lno;
}


bool sanityCheck(BasicBlock *BB)
{
    int64_t lid;
    for (BasicBlock::iterator BI = BB->begin(), EI = BB->end(); BI != EI; ++BI)
    {
        lid = getLID(&*BI);
        if (lid > 0)
        {
            return true;
        }
    }
    errs() << "WARNING: basic block " << BB << " doesn't contain valid LID.\n";
    return false;
}

std::vector<int> SCEVLoopList;
typedef std::vector<Loop*> LoopNest;
typedef std::vector<const Value*> LoopNestBounds;

long int lllid;

long int instrumentedLoops = 0;
int SCEVLoops = 0;

void recLoop(LoopInfo &LI, Function *F, Loop *li, int lvl, ScalarEvolution *se) {
  Loop::block_iterator BB;
  Loop::block_iterator BBb;
  for(BBb = (*li).block_begin(); BBb != (*li).block_end();++BBb)
  {
    BasicBlock *tempb = *BBb;
    bool isLoopH = LI.isLoopHeader(&*tempb);
    if(isLoopH){
      for (BasicBlock::iterator I = (*BBb)->begin(); I != (*BBb)->end(); ++I){
        //if ( I == (*BBb)->end() ){          
          Instruction *tmpI = &*I;
          lllid = getLID(&*tmpI);
        //}
        if (lnid !=0){
          continue;
          }
        if (lnid !=0){
          break;
          }
      }
    break;
    }
  }
  unsigned tripcount = 0;
  unsigned maxtripcount = 0;
  unsigned tripmultiple = 0;
  BasicBlock *exitingblock = (*li).getLoopLatch();
  //if (!exitingblock|| (*li)->isLoopExiting(exitingblock))
    exitingblock = (*li).getExitingBlock();
    if (exitingblock){
      tripcount = (*se).getSmallConstantTripCount((li),exitingblock);
      tripmultiple = (*se).getSmallConstantTripMultiple((li),exitingblock);
      //cnt = se->getConstantTripCount((*li),exitingblock);
      //errs() << "constant trip: " << cnt << "\n";
      //if( tripcount > 0 and tripmultiple > 1){
      errs() << "\tin line " << lllid << ":\n";
      errs() << "\t\ttrip count is " << tripcount <<"\n";
      //errs() << "\t\ttrip multiple is " << tripmultiple <<"\n";

      if (tripcount > 0){
        SCEVLoopList.push_back(lllid);
        SCEVLoops++;
      }

    //}
    }
  vector<Loop*> subLoops = li->getSubLoops();
  Loop::iterator j, f;
  for (j = subLoops.begin(), f = subLoops.end(); j != f; ++j){
    recLoop(LI, F, *j, lvl + 1 , se);
  }
}

fstream fileMappingFile;   
fstream tempfile;


string getFName(Instruction* BI){
  Instruction *tmpI = &*BI;
  if (DILocation *Loc = tmpI->getDebugLoc()) {
    return   Loc->getFilename().str(); 
  }
  else {
    return "FileNameNotFound" ;
  }
  
}

std::map<std::string, int> fileNames;
int FileID = 1;

void addFileName(string name){
  fileMappingFile.open("file_mapping.txt",std::ios_base::app);
  fileMappingFile << name << "\n";
  fileMappingFile.close();
  return;
}


int getFileID(string name){
 
  int tempfid = 0;
  int realfid = 0;

  fileMappingFile.open("file_mapping.txt",ios::in);
  if (fileMappingFile){  
    string tp;
    while(getline(fileMappingFile, tp)){ 
      //errs() << std::stoi(tp) << "\n";
      tempfid++;
      if(tp == name){
        realfid = tempfid;
        return realfid; 
        //break;
      }
    }
    fileMappingFile.close();

    fileMappingFile.open("file_mapping.txt",std::ios_base::app);
    fileMappingFile << name << "\n";
    fileMappingFile.close();
    return 0;
  }
  else { 
    fileMappingFile.open("file_mapping.txt",std::ios_base::app);
    fileMappingFile << name << "\n";
    fileMappingFile.close();
    return 0;
  }
}

long int UID = 0 ; 

namespace {

  struct SkeletonPass : public FunctionPass {
    static char ID;
    SkeletonPass() : FunctionPass(ID) {}
  void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.addRequired<LoopInfoWrapperPass>();
      AU.addRequired<ScalarEvolutionWrapperPass>();
    }

    virtual bool doInitialization(Module &M){ 
      //int xx = 0 ;       
      tempfile.open("temp.txt",ios::in);
      if (tempfile.is_open()){ 
        errs() << "Temp file openned!\n" ;
        string tpp;
        string lastid;
        while(getline(tempfile, tpp)){ 
          //errs() << std::stoi(tp) << "\n";
          lastid = tpp ;     
        }   
        //errs() << "Result: " << lastid << '\n';
        UID = std::stoi( lastid ) ;
      }
      else{
        //int xx = 0; 
        errs() << "Temp file not exist!\n" ;
      }
      tempfile.close();
      //UID = UID + xx;
      errs() << "UID is: " << UID << '\n';
   // }
    return false;
    
    }


    virtual bool runOnFunction(Function &F) {
      errs() << "\n In a function called " << F.getName() << "\n";

    LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();;
  
    Type *Void;
    IntegerType *Int32, *Int64;
    PointerType *CharPtr;
    LLVMContext *ThisModuleContext;
    Module *ThisModule;
    
    LLVMContext& Ctx = F.getContext();
    Void = Type::getVoidTy(Ctx);
    Int32 = Type::getInt32Ty(Ctx);
    Int64 = Type::getInt64Ty(Ctx);

    auto fstart = F.getParent()->getOrInsertFunction(
      "start", Void, Int64);
    auto fend = F.getParent()->getOrInsertFunction(
      "end", Void, Int64);
    auto printFunc = F.getParent()->getOrInsertFunction(
      "printOut", Void);

    //------------scev analysis
    //ScalarEvolution *se = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();
    //for (LoopInfo::iterator li = LI.begin(), LE = LI.end(); li!= LE; ++li){
    //  recLoop(LI, &F, *li, 1, se);   
    //}



if(string(F.getName()) == "__clang_call_terminate"){
return false;
}

SmallVector<BasicBlock *, 8> ExitBlocks;
    for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
    {
        BasicBlock *tmpBB = &*BB;
        BasicBlock *tmpBB1 = &*BB;
        bool isLoop = LI.isLoopHeader(&*BB);
        //if(!isLoop){}
        if(isLoop)
        { 
          //loopid++;
          for (BasicBlock::iterator I = (*BB).begin(); I != (*BB).end(); ++I)
          {
            Instruction *tmpI = &*I;
            lnid = getLID(&*tmpI);
            break;
          }
          

        for (BasicBlock::iterator I = (*BB).begin(); I != (*BB).end(); ++I){
        //if ( I == (*BBb)->end() ){          
          Instruction *tmpI = &*I;
          lnid = getLID(&*tmpI);
          name = getFName(&*tmpI);
        //}
        if (lnid !=0){
          continue;
          }
        if (lnid !=0){
          break;
          }
        }
        int file_ID = getFileID(name);

        while(file_ID == 0){
          //addFileName(name);
          file_ID = getFileID(name);
        }

if (lnid > 0 ){
          int level = LI.getLoopDepth(&*BB);
          BB++;
          UID++;
          ofile.open("cs_id.txt",std::ios_base::app);
          ofile << UID << " " << "loop" <<  " " << lnid << " " <<  file_ID << "\n";
          ofile.close();
          IRBuilder<> IRB(&*BB->begin());
          IRB.CreateCall(fstart, ConstantInt::get(Int64, UID));

          //if(!(std::find(SCEVLoopList.begin(), SCEVLoopList.end(), lnid)!=SCEVLoopList.end())){
          // if it is not founded by the SCEV, instrument this loop
          //errs() << " if SCEV loop at " << lnid << "\n";
          //errs() << "Loop at line " << lnid << " instrumented\n" ;
          //}

          instrumentedLoops++;

        }

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
              BasicBlock::iterator I = (*BB).begin();
              Instruction *tmpI = &*I;
              lnid = getLID(&*tmpI);
                for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                        EI != END; ++ EI)
                {
                    BasicBlock *endBB = *EI;
                    IRBuilder<> IRB(&*endBB->rbegin());
                    IRB.CreateCall(fend, ConstantInt::get(Int64, UID));                   
                }
                ++loopID;
                //++UID;
            }
        }
    }
    }
DISubprogram *dis = F.getSubprogram() ;
Function::iterator BB = F.begin();
for (BasicBlock::iterator I = (*BB).begin(); I != (*BB).end(); ++I){        
          Instruction *tmpI = &*I;
          lnid = getLID(&*tmpI);
          name = getFName(&*tmpI);
        if (lnid !=0){
          continue;
          }
        if (lnid !=0){
          break;
          }
}
        int file_ID = getFileID(name);
        while(file_ID == 0){
          //addFileName(name);
          file_ID = getFileID(name);
        }


long int fun_ln = dis->getScopeLine() ;

if (fun_ln > 0){
fid++;
UID++;
ofile.open("cs_id.txt",std::ios_base::app);
string funn = string(F.getName());
ofile << UID << " " << "func" <<  " " << fun_ln << " " <<  file_ID << " " << funn << "\n";
ofile.close();
IRBuilder<> IRB(&*BB->begin());
IRB.CreateCall(fstart, ConstantInt::get(Int64, UID));
Function::iterator BB1 = F.begin();


for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
    {
      for (auto& I : *BB){
          BasicBlock *tmpBB = &*BB;
          if (isa<ReturnInst>(I)){
                    IRBuilder<> builder(&*BB->rbegin());
                    builder.CreateCall(fend, ConstantInt::get(Int64, UID));
                }
  }
        for (auto& I : *BB){  
          BasicBlock *tmpBB = &*BB;

          StringRef fn = F.getName();
          if (fn.equals("main"))     // returning from main
            {

                if (isa<ReturnInst>(I)){
                  //try{
                    IRBuilder<> builder(&*BB->rbegin());
                    builder.CreateCall(printFunc);
                  //}
                  //catch(std::exception &e){
                  //  errs() << e.what() << "\n" ;
                  //}
               
                }
            }

        }
   }



}
      return false;
    }


    virtual bool doFinalization(Module &M){
      errs() << "number of instrumented loops: " << instrumentedLoops << "\n" ;   
      //errs() << "number of ScalarEvolution bounded loops: " << SCEVLoops << "\n";
      //for(std::size_t i = 0; i < fileNames.size(); ++i) {
      //  errs() << i << " " << fileNames[i] << "\n";
        //errs() << SCEVLoopList[i] << "\n";
      //}
      //errs() << "file name is " << fileNames[0] << "\n" ;

      tempfile.open("temp.txt",std::ios_base::app);
      tempfile << UID << "\n";
      tempfile.close();
      return false;
    }
  };
}

char SkeletonPass::ID = 0;


// Automatically enable the pass.
// http://adriansampson.net/blog/clangpass.html

/*
static void registerSkeletonPass(const PassManagerBuilder &,
                         legacy::PassManagerBase &PM) {
  PM.add(new SkeletonPass());
}
static RegisterStandardPasses
  RegisterMyPass(PassManagerBuilder::EP_EarlyAsPossible,
                 registerSkeletonPass);

*/


static RegisterPass<SkeletonPass> X("SkeletonPass", "Hello",
                             false /* Only looks at CFG */,
                             true /* Analysis Pass */);

static RegisterStandardPasses Y(
    PassManagerBuilder::EP_EarlyAsPossible,
    [](const PassManagerBuilder &Builder,
       legacy::PassManagerBase &PM) { PM.add(new SkeletonPass()); });