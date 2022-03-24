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

#ifndef _DP_UTIL_H_
#define _DP_UTIL_H_

#include "llvm/Support/CommandLine.h"
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

#include <stdint.h>
#include <string>
#include <sstream>
#include <stdexcept>
#include <iostream>   // std::cerr
#include <fstream>
#include <vector>
#include <utility>
#include <unistd.h>
#include <assert.h>

#define LIDSIZE 14       // Number of bits for holding LID
#define MAXLNO 16384     // Maximum number of lines in a single file. Has to be 2^LIDSIZE.

typedef int32_t LID;
typedef int64_t ADDR;
using namespace std;
using namespace llvm;

extern cl::opt<string> FileMappingPath;
namespace dputil
{

    inline string decodeLID(int32_t lid)
    {
        if (lid == 0)
            return "*";

        stringstream ss;
        uint32_t ulid = (uint32_t)lid;
        ss << (ulid >> LIDSIZE) << ":" << ulid % MAXLNO;
        return ss.str();
    }

    inline vector<string> *split(string input, char delim)
    {
        vector<string> *substrings = new vector<string>();
        istringstream inputStringStream(input);
        string sub;

        while(getline(inputStringStream, sub, delim))
        {
            substrings->push_back(sub);
        }

        return substrings;
    }

    inline bool fexists(const string &filename)
    {
        ifstream ifile(filename.c_str());

        if(ifile.fail())
            return false;
        else
            return true;
    }

    int32_t getFileID(string fileMapping, string fullPathName);

    int32_t getLID(Instruction *BI, int32_t &fileID);

    void determineFileID(Function &F, int32_t &fileID);

    string get_exe_dir();

    class VariableNameFinder{
        private:
            map<string, vector<string>> StructMemberMap;
        public:
            VariableNameFinder(Module &M);
    
            string getVarName(Value const *V);
    };

} // namespace
#endif
