#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <filesystem>
#include "llvm/Pass.h"
// #include "llvm/LoopPass.h"
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
#include "llvm/Support/FileSystem.h"
#include "llvm/IR/CFG.h"
#include <set>
#include <map>
#include <cstdlib>


#include <sys/stat.h>
#include <sys/types.h>

#define DP_DEBUG false

using namespace llvm;
using namespace std;

long int fid = 0;
long int lnid = 0;
long int loopID = 1;
string name;
// std::vector<string> fileNames;

std::ofstream ofile;
std::ofstream myfile;

int64_t getLID(Instruction *BI)
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
typedef std::vector<Loop *> LoopNest;
typedef std::vector<const Value *> LoopNestBounds;

long int lllid;

long int instrumentedLoops = 0;
int SCEVLoops = 0;

void recLoop(LoopInfo &LI, Function *F, Loop *li, int lvl, ScalarEvolution *se)
{
  Loop::block_iterator BB;
  Loop::block_iterator BBb;
  for (BBb = (*li).block_begin(); BBb != (*li).block_end(); ++BBb)
  {
    BasicBlock *tempb = *BBb;
    bool isLoopH = LI.isLoopHeader(&*tempb);
    if (isLoopH)
    {
      for (BasicBlock::iterator I = (*BBb)->begin(); I != (*BBb)->end(); ++I)
      {
        Instruction *tmpI = &*I;
        lllid = getLID(&*tmpI);
        if (lnid != 0)
        {
          continue;
        }
        if (lnid != 0)
        {
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
  // if (!exitingblock|| (*li)->isLoopExiting(exitingblock))
  exitingblock = (*li).getExitingBlock();
  if (exitingblock)
  {
    tripcount = (*se).getSmallConstantTripCount((li), exitingblock);
    tripmultiple = (*se).getSmallConstantTripMultiple((li), exitingblock);

    if (tripcount > 0)
    {
      SCEVLoopList.push_back(lllid);
      SCEVLoops++;
    }

  }
  vector<Loop *> subLoops = li->getSubLoops();
  Loop::iterator j, f;
  for (j = subLoops.begin(), f = subLoops.end(); j != f; ++j)
  {
    recLoop(LI, F, *j, lvl + 1, se);
  }
}

fstream fileMappingFile;
fstream tempfile;

string getFName(Instruction *BI)
{
  Instruction *tmpI = &*BI;
  
  if (tmpI->getModule())
  {
      llvm::SmallString<128> FileNameVec = StringRef(tmpI->getModule()->getSourceFileName());
      llvm::sys::fs::make_absolute(FileNameVec);
      return FileNameVec.str().str();
  }
  else
  {
    return "FileNameNotFound";
  }
}

std::map<std::string, int> fileNames;
int FileID = 1;

void addFileName(string name)
{
  string tmp(getenv("DOT_DISCOPOP"));
  tmp += "/FileMapping.txt";
  fileMappingFile.open(tmp.data(), std::ios_base::app);
  fileMappingFile << name << "\n";
  fileMappingFile.close();
  return;
}


int getFileID(string name)
{
  int tempfid = 1;

  string fileMappingPath(getenv("DOT_DISCOPOP"));
  fileMappingPath += "/FileMapping.txt";
  fileMappingFile.open(fileMappingPath.data(), ios::in);
  if (fileMappingFile)
  {
    string tp;
    while (getline(fileMappingFile, tp))
    {
      std::string id = tp.substr(0, tp.find("\t"));
      std::string file_name = tp.substr(tp.find("\t") + 1);
      if (file_name == name){
        return stoi(id);
      }
      tempfid++;
    }
    fileMappingFile.close();

    fileMappingFile.open(fileMappingPath.data(), std::ios_base::app);
    fileMappingFile << tempfid << "\t" << name << "\n";
    fileMappingFile.close();
    return 0;
  }
  else
  {
    fileMappingFile.open(fileMappingPath.data(), std::ios_base::app);
    fileMappingFile << tempfid << "\t" << name << "\n";
    fileMappingFile.close();
    return 0;
  }
}

long int UID = 0;

namespace
{

  struct HotspotPass : public FunctionPass
  {
    static char ID;
    HotspotPass() : FunctionPass(ID) {}

    void getAnalysisUsage(AnalysisUsage &AU) const override
    {
      AU.addRequired<LoopInfoWrapperPass>();
      AU.addRequired<ScalarEvolutionWrapperPass>();
    }

    virtual bool doInitialization(Module &M)
    {
      // prepare environment variables
      char const * tmp = getenv("DOT_DISCOPOP");
      if(tmp == NULL){
          // DOT_DISCOPOP needs to be initialized
          setenv("DOT_DISCOPOP", ".discopop", 1);
      }

      // prepare .discopop directory if not present
      struct stat st1 = {0};
      if (stat(getenv("DOT_DISCOPOP"), &st1) == -1){
          mkdir(getenv("DOT_DISCOPOP"), 0777);
      }
      // prepare hotspot_detection directory if not present
      struct stat st3 = {0};
      string tmp2(getenv("DOT_DISCOPOP"));
      tmp2 += "/hotspot_detection";
      if (stat(tmp2.data(), &st3) == -1){
          mkdir(tmp2.data(), 0777);
      }
      // prepare hotspot_detection/private directory if not present
      struct stat st4 = {0};
      string tmp3(getenv("DOT_DISCOPOP"));
      tmp3 += "/hotspot_detection/private";
      if (stat(tmp3.data(), &st4) == -1){
          mkdir(tmp3.data(), 0777);
      }

      
      string tmp4 = tmp3 + "/temp.txt";
      tempfile.open(tmp4.data(), ios::in);
      if (tempfile.is_open())
      {
        errs() << "Temp file openned!\n";
        string tpp;
        string lastid;
        while (getline(tempfile, tpp))
        {
          lastid = tpp;
        }
        UID = std::stoi(lastid);
      }
      else
      {
        errs() << "Temp file not exist!\n";
      }
      tempfile.close();
      errs() << "UID is: " << UID << '\n';
      return false;
    }

    virtual bool runOnFunction(Function &F)
    {
      errs() << "In a function called " << F.getName() << "\n";

      LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();

      Type *Void;
      IntegerType *Int32, *Int64;
      PointerType *CharPtr;
      LLVMContext *ThisModuleContext;
      Module *ThisModule;

      LLVMContext &Ctx = F.getContext();
      Void = Type::getVoidTy(Ctx);
      Int32 = Type::getInt32Ty(Ctx);
      Int64 = Type::getInt64Ty(Ctx);

      auto hd_init = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_init", Void);
      auto fstart = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_function_start", Void, Int64);
      auto fend = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_function_end", Void, Int64);
      auto lbstart = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_loop_body_start", Void, Int64);
      auto lentry = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_loop_entry", Void, Int64);
      auto lend = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_loop_end", Void, Int64);
      auto printFunc = F.getParent()->getOrInsertFunction(
          "__hotspot_detection_printOut", Void);

      //------------scev analysis
      // ScalarEvolution *se = &getAnalysis<ScalarEvolutionWrapperPass>().getSE();
      // for (LoopInfo::iterator li = LI.begin(), LE = LI.end(); li!= LE; ++li){
      //  recLoop(LI, &F, *li, 1, se);
      //}

      // Avoid functions we don't want to instrument
      if (F.getName().find("llvm.") != string::npos)    // llvm debug calls
      {
          return false;
      }
      if (F.getName().find("__dp_") != string::npos)       // instrumentation calls
      {
          return false;
      }
      if (F.getName().find("__cx") != string::npos)        // c++ init calls
      {
          return false;
      }
      if (F.getName().find("__clang") != string::npos)     // clang helper calls
      {
          return false;
      }
      if (F.getName().find("_GLOBAL_") != string::npos)    // global init calls (c++)
      {
          return false;
      }
      if (F.getName().find("pthread_") != string::npos) {
          return false;
      }


      SmallVector<BasicBlock *, 8> ExitBlocks;
      for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
      {
        BasicBlock *tmpBB = &*BB;
        bool isLoop = LI.isLoopHeader(&*BB);
        if (isLoop)
        {
          for (BasicBlock::iterator I = (*BB).begin(); I != (*BB).end(); ++I)
          {
            Instruction *tmpI = &*I;
            lnid = getLID(&*tmpI);
            name = getFName(&*tmpI);
            if (lnid != 0)
            {
              continue;
            }
          }
          int file_ID = getFileID(name);

          while (file_ID == 0)
          {
            file_ID = getFileID(name);
          }

          if (lnid > 0)
          {
            int level = LI.getLoopDepth(&*BB);
            BB++;
            UID++;

            string tmp(getenv("DOT_DISCOPOP"));
            tmp += "/hotspot_detection/private/cs_id.txt";
            ofile.open(tmp.data(), std::ios_base::app);
            ofile << UID << " "
                  << "loop"
                  << " " << lnid << " " << file_ID << "\n";
            ofile.close();
            /*
            // Create call at the beginning of the loops body
            IRBuilder<> IRB(&*BB->begin());
            IRB.CreateCall(lbstart, ConstantInt::get(Int64, UID));
            */

            BB--;
            BB--;
            IRBuilder<> IRB3(&*BB->rbegin());
            IRB3.CreateCall(lentry, ConstantInt::get(Int64, UID));
            BB++;
            BB++;


            // add call to loop_entry
            for (auto it = pred_begin(&*BB); it != pred_end(&*BB); ++it)
            {
              BasicBlock* Pred1 = *it;
              errs() << "CURRENT BB 1: " << Pred1->getName() << "\n";
              // predecessor is for.cond
              for (auto it2 = pred_begin(Pred1); it2 != pred_end(Pred1); ++it2)
              {
                BasicBlock *Pred2 = *it2;
                // if name of predecessor_2 does not contain for.inc, we have found an entry point into the loop
                errs() << "CURRENT BB 2: " << Pred2->getName() << "\n";
                if (! (Pred2->getName().find("for.inc") != std::string::npos)) {
                  if (! (Pred2->getName().find("while.body") != std::string::npos)) {
                    errs() << "found loop entry point: " << Pred2->getName() << '\n';
                    //IRBuilder<> IRB2(&*Pred2->rbegin());
                    //IRB2.CreateCall(lentry, ConstantInt::get(Int64, UID));
                  }
                }
              } 
            }

            // if(!(std::find(SCEVLoopList.begin(), SCEVLoopList.end(), lnid)!=SCEVLoopList.end())){
            //  if it is not founded by the SCEV, instrument this loop
            // }

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

            // assert((RealExitBlocks.size() == 1) && "Loop has more than one real exit block!");
            if (RealExitBlocks.size() == 0)
            {
              errs() << "WARNING: loop at " << tmpBB << " is ignored: exit blocks are not well formed.\n";
              continue;
            }
            bool hasValidEntry = sanityCheck(tmpBB);
            bool hasValidExit = false;
            for (SmallVectorImpl<BasicBlock *>::iterator EI = RealExitBlocks.begin(), END = RealExitBlocks.end();
                 EI != END; ++EI)
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
                   EI != END; ++EI)
              {
                BasicBlock *endBB = *EI;
                IRBuilder<> IRB(&*endBB->begin());
                IRB.CreateCall(lend, ConstantInt::get(Int64, UID));
                // todo: warning: 
                // If the call to loop_end is inserted into the return BB, and
                // returning from before the loop is possible,
                // the calculated counters and thus reported runtimes of the loop might
                // not be accurate in case of recursive functions!
                //  Example:
                /*  void func6(int n){
                    if ( n < 1){
                        return;
                    }
                    for (int j=0; j<10 ; j++){
                        func6(n-1);
                    }
                    int i = 0;  // ADDING A DUMMY INSTRUCTION AVOIDS THE ISSUE
                  }*/
              }
              ++loopID;
              //++UID;
            }
          }
        }
      }
      DISubprogram *dis = F.getSubprogram();
      Function::iterator BB = F.begin();
      for (BasicBlock::iterator I = (*BB).begin(); I != (*BB).end(); ++I)
      {
        Instruction *tmpI = &*I;
        lnid = getLID(&*tmpI);
        name = getFName(&*tmpI);
        if (lnid != 0)
        {
          continue;
        }
        if (lnid != 0)
        {
          break;
        }
      }
      int file_ID = getFileID(name);
      while (file_ID == 0)
      {
        file_ID = getFileID(name);
      }

      long int fun_ln = dis->getScopeLine();

      if (fun_ln > 0)
      {
        fid++;
        UID++;
        string tmp(getenv("DOT_DISCOPOP"));
        tmp += "/hotspot_detection/private/cs_id.txt";
        ofile.open(tmp.data(), std::ios_base::app);
        string funn = string(F.getName());
        ofile << UID << " "
              << "func"
              << " " << fun_ln << " " << file_ID << " " << funn << "\n";
        ofile.close();
        IRBuilder<> IRB(&*BB->begin());
        IRB.CreateCall(fstart, ConstantInt::get(Int64, UID));
        Function::iterator BB1 = F.begin();

        StringRef fn = F.getName();

        // create call to __hd__init to main function
        if (fn == "main"){ // inside main function
          Function::iterator BB = F.begin();
          IRBuilder<> init_builder(&*BB->begin());
          init_builder.CreateCall(hd_init);
        }
          


        for (Function::iterator BB = F.begin(), BE = F.end(); BB != BE; ++BB)
        {
          for (auto &I : *BB)
          {
            BasicBlock *tmpBB = &*BB;
            if (isa<ReturnInst>(I))
            {
              IRBuilder<> builder(&*BB->rbegin());
              builder.CreateCall(fend, ConstantInt::get(Int64, UID));
            }
          }
          for (auto &I : *BB)
          {
            BasicBlock *tmpBB = &*BB;

            
            if (fn.equals("main")) // inside main function
            {
              if (isa<ReturnInst>(I)) // returning from main
              {
                // try{
                IRBuilder<> builder(&*BB->rbegin());
                builder.CreateCall(printFunc);
                //}
                // catch(std::exception &e){
                //  errs() << e.what() << "\n" ;
                //}
              }
            }
          }
        }
      }
      return false;
    }

    virtual bool doFinalization(Module &M)
    {
      errs() << "number of instrumented loops: " << instrumentedLoops << "\n";
      string tmp(getenv("DOT_DISCOPOP"));
      tmp += "/hotspot_detection/private/temp.txt";
      tempfile.open(tmp.data(), std::ios_base::app);
      tempfile << UID << "\n";
      tempfile.close();
      return false;
    }
  };
}

char HotspotPass::ID = 0;

// Automatically enable the pass.
// http://adriansampson.net/blog/clangpass.html

/*
static void registerSkeletonPass(const PassManagerBuilder &,
                         legacy::PassManagerBase &PM) {
  PM.add(new HotspotPass());
}
static RegisterStandardPasses
  RegisterMyPass(PassManagerBuilder::EP_EarlyAsPossible,
                 registerSkeletonPass);

*/

static RegisterPass<HotspotPass> X("HotspotDetection", "Records runtimes of loops and functions",
                                    false /* Only looks at CFG */,
                                    false /* Analysis Pass */);

static RegisterStandardPasses Y(
    PassManagerBuilder::EP_EarlyAsPossible,
    [](const PassManagerBuilder &Builder,
       legacy::PassManagerBase &PM)
    { PM.add(new HotspotPass()); });
