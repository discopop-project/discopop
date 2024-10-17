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

#include "runtimeFunctionsGlobals.hpp"

bool USE_PERFECT = true;

// Shadow memory parameters
std::int32_t SIG_ELEM_BIT = 56;
std::int32_t SIG_NUM_ELEM = 270000;
std::int32_t SIG_NUM_HASH = 2;

std::uint64_t *numAccesses = nullptr;

namespace __dp {

bool DP_DEBUG = false; // debug flag

Timers *timers = nullptr;

std::mutex pthread_compatibility_mutex;

FunctionManager *function_manager = nullptr;
LoopManager *loop_manager = nullptr;
MemoryManager *memory_manager = nullptr;
CallTree *call_tree = nullptr;
// MetaDataQueue *metadata_queue = nullptr;
std::mutex *dependency_metadata_results_mtx = nullptr;
std::unordered_set<DependencyMetadata> *dependency_metadata_results = nullptr;

// hybrid analysis
ReportedBBSet *bbList = nullptr;
stringDepMap *outPutDeps = nullptr;
// end hybrid analysis

std::unordered_map<char *, long> cuec;

bool dpInited = false;         // library initialization flag
bool targetTerminated = false; // whether the target program has returned from main()
// In C++, destructors of global objects can run after main().
// However, when the target program returns from main(), dp
// also frees all the resources. If there are destructors run
// after main(), __dp_func_entry() will be called again, but
// resources are freed, leading to segmentation fault.

// Runtime merging structures
depMap *allDeps = nullptr;

std::ofstream *out = nullptr;

/******* BEGIN: parallelization section *******/
pthread_cond_t *addrChunkPresentConds = nullptr; // condition variables
pthread_mutex_t *addrChunkMutexes = nullptr;     // associated mutexes
pthread_mutex_t allDepsLock;
pthread_t *workers = nullptr; // worker threads

#define XSTR(x) STR(x)
#define STR(x) #x
#ifdef DP_NUM_WORKERS
int32_t NUM_WORKERS = DP_NUM_WORKERS;
#else
int32_t NUM_WORKERS = 3; // default number of worker threads (multiple workers
                         // can potentially lead to non-deterministic results)
#endif

AbstractShadow *singleThreadedExecutionSMem = nullptr; // used if NUM_WORKERS==0

int32_t CHUNK_SIZE = 500;                   // default number of addresses in each chunk
std::queue<AccessInfo *> *chunks = nullptr; // one queue of access info chunks for each worker thread
bool *addrChunkPresent = nullptr;           // addrChunkPresent[thread_id] denotes whether or not a new chunk
                                            // is available for the corresponding thread
AccessInfo **tempAddrChunks = nullptr;      // tempAddrChunks[thread_id] is the temporary chunk to collect
                                            // memory accesses for the corresponding thread
int32_t *tempAddrCount = nullptr;           // tempAddrCount[thread_id] denotes the current number of accesses
                                            // in the temporary chunk
bool stop = false;                          // ONLY set stop to true if no more accessed addresses will
                                            // be collected
thread_local depMap *myMap = nullptr;

// statistics
std::chrono::high_resolution_clock::time_point statistics_profiling_start_time;

/******* END: parallelization section *******/

} // namespace __dp
