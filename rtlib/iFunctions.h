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

#ifndef _DP_IFUNCTIONS_H_
#define _DP_IFUNCTIONS_H_

//#define SKIP_DUP_INSTR 1

#include <algorithm>
#include <cstdlib>
#include <pthread.h>
#include <queue>
#include <set>
#include <stack>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/syscall.h>
#include "DPUtils.h"
// hybrid analysis
 #include <regex>
 // End HA
namespace __dp
{

    /******* Data structures *******/

    typedef enum
    {
        RAW,
        WAR,
        WAW,
        INIT,
        IIRAW,  // inter-iteration RAW
        IIWAR,  // inter-iteration WAR
        IIWAW   // inter-iteration WAW
    }
    depType;

    typedef enum
    {
        STATIC_BWD = -4,
        SEQ_BWD = -3,
        SEQ_BWD_K = -2,
        RANDOM_BWD = -1,
        RANDOM = 0,
        RANDOM_FWD = 1,
        SEQ_FWD_K = 2,
        SEQ_FWD = 3,
        STATIC_FWD = 4
    } LoopAccessPatternType;

    struct LoopAccessPattern
    {
        LoopAccessPattern(string varName, LoopAccessPatternType basePattern, bool isReadPattern, bool isValid, bool isStrict) :
            varName(varName), patternType(basePattern), isReadPattern(isReadPattern), isValid(isValid), isStrict(isStrict){}

        string varName;
        LoopAccessPatternType patternType;
        bool isReadPattern;
        bool isValid;
        bool isStrict;  // a strict pattern indicates that the same memory address may not be accessed again

        void transition(){
            // perform transition towards RANDOM pattern.
            if(patternType == 0){
                return;
            }
            patternType = LoopAccessPatternType (patternType + ((patternType > 0) ? -1 : 1));
        }
    };

    struct AccessInfo
    {
        AccessInfo(bool isRead, LID lid, char *var, ADDR addr, size_t loopHash, bool skip = false)
            : isRead(isRead), lid(lid), var(var), addr(addr), loopHash(loopHash), skip(skip) {}
        AccessInfo() : lid(0) {}

        bool isRead;
        // hybrid analysis 
        bool skip;
        // End HA
        LID lid;
        char *var;
        ADDR addr;
        size_t loopHash;
        uint32_t loopIteration;

        void prettyPrintLoopCount(){
            uint8_t ct3, ct2, ct1, ct0;
            ct3 = (loopIteration & 0xff000000) >> 24;
            ct2 = (loopIteration & 0x00ff0000) >> 16;
            ct1 = (loopIteration & 0x0000ff00) >> 8;
            ct0 = loopIteration & 0x000000ff;
            uint32_t tmp3 = ct3;
            uint32_t tmp2 = ct2;
            uint32_t tmp1 = ct1;
            uint32_t tmp0 = ct0;
            cout << tmp3 << " " << tmp2 << " " << tmp1 << " " << tmp0;
        }
    };

    // For runtime dependency merging
    struct Dep
    {
        Dep(depType T, LID dep, char *var) : type(T), depOn(dep), var(var) {}

        depType type;
        LID depOn;
        char *var;
    };

    struct compDep
    {
        bool operator()(const Dep &a, const Dep &b) const
        {
            if (a.type < b.type)
            {
                return true;
            }
            else if (a.type == b.type && a.depOn < b.depOn)
            {
                return true;
            }
            // comparison between string is very time-consuming. So just compare variable names
            // according to address (we only need to distinguish them)
            else if (a.type == b.type && a.depOn == b.depOn && ((size_t)a.var < (size_t)b.var))
            {
                return true;
            }

            return false;
        }
    };

    typedef std::set<Dep, compDep> depSet;
    typedef std::unordered_map<LID, depSet *> depMap;
    // Hybrid anaysis
    typedef std::unordered_map<std::string, std::set<std::string>> stringDepMap;
    // End HA

    // For loop tracking
    struct LoopTableEntry
    {
        LoopTableEntry(int32_t l, int32_t id, int32_t c, LID b) : funcLevel(l), loopID(id), count(c), begin(b) {}

        int32_t funcLevel;
        int32_t loopID;
        int32_t count;
        LID begin;

        size_t getHashValue(){
            size_t hashVal = ((((hash<int32_t>()(funcLevel)
                                 ^ (hash<int32_t>()(loopID) << 1)) >> 1)))
//                               ^ (hash<int32_t>()(count) << 1)) >> 1)
                             ^ (hash<LID>()(begin) << 1);
            return hashVal;
        }
    };

//    typedef std::stack<LoopTableEntry> LoopTable;
    struct LoopTable{
        vector<LoopTableEntry> elements;

        bool empty(){ return elements.empty(); }
        int size(){ return elements.size(); }
        LoopTableEntry& top(){ return elements.back(); }
        void push(LoopTableEntry lte){
            elements.push_back(lte);
/*            size_t hashValue;
            if(hashValueStack.size() != 0){
                hashValueStack.top();
            }
            hashValue = (hashValue ^ (lte.getHashValue() << 1) >> 1);
            hashValueStack.push(hashValue);
            cout << "pushed hash: " << hashValueStack.top() << endl;
*/
        }
        void pop(){
            elements.pop_back();
        }

        size_t getHashValue(){
            size_t hashValue = 0;
            for(LoopTableEntry lte : elements){
                hashValue = ((hashValue << 1) ^ (lte.getHashValue() << 1) >> 1);
            }
            return hashValue;
//            if(hashValueStack.size() == 0)
 //               return 0;
 //           return hashValueStack.top();
        }

        void prettyPrintLoopCount(uint32_t loopIteration){
            uint8_t ct3, ct2, ct1, ct0;
            ct3 = (loopIteration & 0xff000000) >> 24;
            ct2 = (loopIteration & 0x00ff0000) >> 16;
            ct1 = (loopIteration & 0x0000ff00) >> 8;
            ct0 = loopIteration & 0x000000ff;
            uint32_t tmp3 = ct3;
            uint32_t tmp2 = ct2;
            uint32_t tmp1 = ct1;
            uint32_t tmp0 = ct0;
            cout << tmp3 << " " << tmp2 << " " << tmp1 << " " << tmp0;
        }

        uint32_t getLoopIteration(){
            // loop iterations are encoded as 8-bit unsigned integers
            uint32_t loopIterations = 0xFFFFFFFF;
            // loop iteration 255 is regarded as invalid and ignored
            if(elements.size() == 0){
                return loopIterations;
            }
            // only 4 nested loops are considered
            if(elements.size() > 4){
                return loopIterations;
            }
            // first loop iteration which is considered is 0.
            // last loop iteration which is considered is 254
            uint8_t buffer = 0;
            for(int i=0;i<elements.size(); i++){
                LoopTableEntry lte_buffer = elements[i];
                if(lte_buffer.count > 254){
                    buffer = 255;
                }
                else{
                    buffer = lte_buffer.count;
                }
                // shift value before combining with buffer.
                // required because default value is set to 255 instead of 0.
                loopIterations = loopIterations << 8;
                loopIterations |= buffer;
            }
            return loopIterations;
        }

    };

    // For loop merging
    // Assumption: no more than one loops can begin at the same line
    struct LoopRecord
    {
        LoopRecord(LID e, int32_t t, int32_t n) : end(e), total(t), nEntered(n) {}

        LID end;
        int32_t total;
        int32_t nEntered;
    };

    typedef std::unordered_map<LID, LoopRecord *> LoopRecords;

    // For function merging
    // 1) when two BGN func are identical

    typedef std::unordered_map<LID, std::set<LID>*> BGNFuncList;

    // Hybrid analysis
    typedef std::set<int32_t> ReportedBBSet;
    typedef std::set<std::string> ReportedBBPairSet;
    // End HA
    // 2) when two END func are identical

    typedef std::set<LID> ENDFuncList;

    /******* Helper functions *******/

    void addDep(depType type, LID curr, LID depOn, char *var);
    void outputDeps();
    void outputLoops();
    void outputFuncs();
    void readRuntimeInfo();
    void initParallelization();
    void mergeDeps();
    void *analyzeDeps(void *arg);
    void addAccessInfo(bool isRead, LID lid, char *var, ADDR addr);
    void finalizeParallelization();

    /******* Instrumentation functions *******/
    extern "C" {
#ifdef SKIP_DUP_INSTR
        void __dp_read(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count);
        void __dp_write(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count);
        // hybrid analysis
        void __dp_decl(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count);
        void __dp_alloca(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count);
        // End HA
#else
        void __dp_read(LID lid, ADDR addr, char *var);
        void __dp_write(LID lid, ADDR addr, char *var);
        // hybrid analysis
        void __dp_decl(LID lid, ADDR addr, char *var);
        void __dp_alloca(LID lid, ADDR addr, char *var);
        // End HA
#endif
        // hybrid analysis
        void __dp_report_bb(int32_t bbIndex);
        void __dp_report_bb_pair(int32_t counter, int32_t bbIndex);
        void __dp_add_bb_deps(char* depStringPtr);
        // End HA
        void __dp_finalize(LID lid);
        void __dp_call(LID lid);
        void __dp_func_entry(LID lid, int32_t isStart);
        void __dp_func_exit(LID lid, int32_t isExit);
        void __dp_loop_entry(LID lid, int32_t loopID);
        void __dp_loop_exit(LID lid, int32_t loopID);
    }
} // namespace __dp
#endif


namespace std {
    using namespace __dp;

    // define hash functions
    template <>
    struct hash<LoopTableEntry>
    {
        std::size_t operator()(const LoopTableEntry& lte) const
        {
            return ((((hash<int32_t>()(lte.funcLevel)
                       ^ (hash<int32_t>()(lte.loopID) << 1)) >> 1)
                     ^ (hash<int32_t>()(lte.count) << 1)) >> 1)
                   ^ (hash<LID>()(lte.begin) << 1);
        }
    };
}