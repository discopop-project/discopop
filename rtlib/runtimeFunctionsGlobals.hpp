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

#pragma once

#include "../share/include/timer.hpp"
#include "runtimeFunctionsTypes.hpp"
#include "memory/AbstractShadow.hpp"
#include "calltree/CallTree.hpp"
#include "calltree/DependencyMetadata.hpp"

#include <pthread.h>

#include <cstdint>
#include <fstream>
#include <list>
#include <mutex>
#include <queue>
#include <stack>
#include <string>
#include <tuple>
#include <unordered_map>
#include <utility>

extern bool USE_PERFECT;

// Shadow memory parameters
extern std::int32_t SIG_ELEM_BIT;
extern std::int32_t SIG_NUM_ELEM;
extern std::int32_t SIG_NUM_HASH;

extern std::uint64_t *numAccesses;

namespace __dp {

extern bool DP_DEBUG; // debug flag

extern Timers *timers;

extern std::mutex pthread_compatibility_mutex;

extern FunctionManager *function_manager;
extern LoopManager *loop_manager;
extern MemoryManager *memory_manager;
extern CallTree *call_tree;
//extern MetaDataQueue * metadata_queue;
extern std::mutex* dependency_metadata_results_mtx;
extern std::unordered_set<DependencyMetadata>* dependency_metadata_results;

// hybrid analysis
extern ReportedBBSet *bbList;
extern stringDepMap *outPutDeps;
// end hybrid analysis

extern std::unordered_map<char *, long> cuec;

extern bool dpInited;         // library initialization flag
extern bool targetTerminated; // whether the target program has returned from main()
// In C++, destructors of global objects can run after main().
// However, when the target program returns from main(), dp
// also frees all the resources. If there are destructors run
// after main(), __dp_func_entry() will be called again, but
// resources are freed, leading to segmentation fault.

// Runtime merging structures
extern depMap *allDeps;

extern std::ofstream *out;

extern pthread_cond_t *addrChunkPresentConds; // condition variables
extern pthread_mutex_t *addrChunkMutexes;     // associated mutexes
extern pthread_mutex_t allDepsLock;
extern pthread_t *workers; // worker threads

extern AbstractShadow *singleThreadedExecutionSMem;

extern int32_t NUM_WORKERS;

extern int32_t CHUNK_SIZE;               // default number of addresses in each chunk
extern std::queue<AccessInfo *> *chunks; // one queue of access info chunks for each worker thread
extern bool *addrChunkPresent;           // addrChunkPresent[thread_id] denotes whether or not a
                                         // new chunk is available for the corresponding thread

extern AccessInfo **tempAddrChunks; // tempAddrChunks[thread_id] is the temporary chunk to
                                    // collect memory accesses for the corresponding thread
extern int32_t *tempAddrCount;      // tempAddrCount[thread_id] denotes the current
                                    // number of accesses in the temporary chunk
extern bool stop;                   // ONLY set stop to true if no more accessed addresses will
                                    // be collected
extern thread_local depMap *myMap;

} // namespace __dp
