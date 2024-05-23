/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include "iFunctionsGlobals.hpp"

bool USE_PERFECT = true;

// Shadow memory parameters
std::int32_t SIG_ELEM_BIT = 56;
std::int32_t SIG_NUM_ELEM = 270000;
std::int32_t SIG_NUM_HASH = 2;

std::uint64_t *numAccesses = nullptr;

namespace __dp {

bool DP_DEBUG = false; // debug flag

Timers* timers = nullptr;

std::mutex pthread_compatibility_mutex;

// hybrid analysis
ReportedBBSet *bbList = nullptr;
stringDepMap *outPutDeps = nullptr;
// end hybrid analysis 

std::int64_t nextFreeMemoryRegionId = 1; // 0 is reserved as the identifier for "no region" in the MemoryRegionTree

/// (LID, identifier, startAddr, endAddr, numBytes, numElements)
std::vector<std::tuple<LID, std::string, std::int64_t, std::int64_t, std::int64_t, std::int64_t>>::iterator lastHitIterator;
std::vector<std::tuple<LID, std::string, std::int64_t, std::int64_t, std::int64_t, std::int64_t>> *allocatedMemoryRegions = nullptr;

bool dpInited = false; // library initialization flag
bool targetTerminated = false; // whether the target program has returned from main()
// In C++, destructors of global objects can run after main().
// However, when the target program returns from main(), dp
// also frees all the resources. If there are destructors run
// after main(), __dp_func_entry() will be called again, but
// resources are freed, leading to segmentation fault.

// Runtime merging structures
depMap *allDeps = nullptr;

LoopTable *loopStack = nullptr;    // loop stack tracking
LoopRecords *loops = nullptr;      // loop merging
CallStack *callStack = nullptr;    // call stack profiling
BGNFuncList *beginFuncs = nullptr; // function entries
ENDFuncList *endFuncs = nullptr;   // function returns
std::ofstream *out = nullptr;
std::ofstream *outInsts = nullptr;
std::stack<std::pair<ADDR, ADDR>> *stackAddrs = nullptr; // track stack adresses for entered functions
ScopeManager *scopeManager = nullptr;

LID lastCallOrInvoke = 0;
LID lastProcessedLine = 0;
std::int32_t FuncStackLevel = 0;

MemoryRegionTree *allocatedMemRegTree = nullptr;

ADDR smallestAllocatedADDR = std::numeric_limits<std::int64_t>::max();
ADDR largestAllocatedADDR = std::numeric_limits<std::int64_t>::min();

unsigned long funcCallCounter = 0; // overflow is not critical here 


/******* BEGIN: parallelization section *******/
pthread_cond_t *addrChunkPresentConds = nullptr; // condition variables
pthread_mutex_t *addrChunkMutexes = nullptr;     // associated mutexes
pthread_mutex_t allDepsLock;
pthread_t *workers = nullptr; // worker threads

#define XSTR(x) STR(x)
#define STR(x) #x
#ifdef DP_NUM_WORKERS
#pragma message "Profiler: set NUM_WORKERS to " XSTR(DP_NUM_WORKERS)
int32_t NUM_WORKERS = DP_NUM_WORKERS;
#else
int32_t NUM_WORKERS = 3; // default number of worker threads (multiple workers
                         // can potentially lead to non-deterministic results)
#endif
#pragma message "Profiler: set NUM_WORKERS to " XSTR(NUM_WORKERS)
extern Shadow* singleThreadedExecutionSMem = nullptr; // used if NUM_WORKERS==0
int32_t CHUNK_SIZE = 500; // default number of addresses in each chunk
std::queue<AccessInfo *> *chunks =
    nullptr; // one queue of access info chunks for each worker thread
bool *addrChunkPresent =
    nullptr; // addrChunkPresent[thread_id] denotes whether or not a new chunk
             // is available for the corresponding thread
AccessInfo **tempAddrChunks =
    nullptr; // tempAddrChunks[thread_id] is the temporary chunk to collect
             // memory accesses for the corresponding thread
int32_t *tempAddrCount =
    nullptr; // tempAddrCount[thread_id] denotes the current number of accesses
             // in the temporary chunk
bool stop = false; // ONLY set stop to true if no more accessed addresses will
                   // be collected
thread_local depMap *myMap = nullptr;

/******* END: parallelization section *******/

} // namespace __dp
