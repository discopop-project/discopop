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

#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

#include "debug_print.hpp"
#include "lid_utils.hpp"
#include "memory/PerfectShadow.hpp"
#include "memory/ShadowMemory.hpp"
#include "timer.hpp"

#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>
#include <vector>

using namespace std;
using namespace dputil;

namespace __dp {

void readRuntimeInfo() {
#ifdef DP_RTLIB_VERBOSE
  cout << "enter readRuntimeInfo\n";
#endif

  ifstream conf(get_exe_dir() + "/dp.conf");
  string line;
  if (conf.is_open()) {
    auto func = [](char c) { return (c == ' '); };
    vector<string> *substrings = nullptr;
    while (getline(conf, line)) {
      substrings = split(line, '=');
      if (substrings->size() == 2) {
        string variable = (*substrings)[0];
        string value = (*substrings)[1];
        variable.erase(std::remove_if(variable.begin(), variable.end(), func), variable.end());
        value.erase(std::remove_if(value.begin(), value.end(), func), value.end());

        int32_t intValue = (int32_t)atoi(value.c_str());
        if (intValue > 0) {
          if (variable.compare("DP_DEBUG") == 0) {
            DP_DEBUG = true;
          } else if (variable.compare("SIG_ELEM_BIT") == 0) {
            SIG_ELEM_BIT = intValue;
          } else if (variable.compare("SIG_NUM_ELEM") == 0) {
            SIG_NUM_ELEM = intValue;
          } else if (variable.compare("SIG_NUM_HASH") == 0) {
            SIG_NUM_HASH = intValue;
          } else if (variable.compare("NUM_WORKERS") == 0) {
            NUM_WORKERS = intValue;
          } else if (variable.compare("FIRST_ACCESS_QUEUE_CHUNKS_PER_WORKER") == 0) {
            FIRST_ACCESS_QUEUE_CHUNKS_PER_WORKER = intValue;
          } else if (variable.compare("SECOND_ACCESS_QUEUE_ELEMENTS_PER_WORKER") == 0) {
            SECOND_ACCESS_QUEUE_ELEMENTS_PER_WORKER = intValue;
          } else if (variable.compare("USE_PERFECT") == 0) {
            USE_PERFECT = intValue != 0;
          }
        }
      }
      substrings->clear();
      delete substrings;
    }
  }
  if (DP_DEBUG) {
    cout << "sig_elem_bit = " << SIG_ELEM_BIT << "\n";
    cout << "sig_num_elem = " << SIG_NUM_ELEM << "\n";
    cout << "sig_num_hash = " << SIG_NUM_HASH << "\n";
    cout << "num_workers  = " << NUM_WORKERS << "\n";
    cout << "faq_chunks_per_worker   = " << FIRST_ACCESS_QUEUE_CHUNKS_PER_WORKER << "\n";
    cout << "saq_elements_per_worker = " << SECOND_ACCESS_QUEUE_ELEMENTS_PER_WORKER << "\n";
    sleep(2);
  }

#ifdef DP_RTLIB_VERBOSE
  cout << "exit readRuntimeInfo\n";
#endif
}

void initParallelization() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("initParallelization");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::INIT_PARALLELIZATION);
#endif

  // initialize global variables
  workers = new pthread_t[NUM_WORKERS];

  // Initialize count of accesses
  numAccesses = new uint64_t[NUM_WORKERS]();

  // bound the memory held by the access queues
  firstAccessQueue.set_max_size((std::size_t)FIRST_ACCESS_QUEUE_CHUNKS_PER_WORKER * NUM_WORKERS);
  secondAccessQueue.set_max_size((std::size_t)SECOND_ACCESS_QUEUE_ELEMENTS_PER_WORKER * NUM_WORKERS);

  // initialize and set thread detached attribute
  finalizeParallelizationCalled = false; // mostly for unit-tests.
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

  // create worker threads to process the firstAccessQueue
  for (int64_t i = 0; i < NUM_WORKERS; ++i) {
    pthread_create(&workers[i], &attr, processFirstAccessQueue, reinterpret_cast<void *>(i));
  }

  // create worker thread to process the secondAccessQueue
  secondAccessQueue_worker_thread = new pthread_t();
  pthread_create(secondAccessQueue_worker_thread, &attr, processSecondAccessQueue,
                 reinterpret_cast<void *>(static_cast<std::intptr_t>(NUM_WORKERS)));

  pthread_attr_destroy(&attr);
}

void initSingleThreadedExecution() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("initSingleThreadedExecution");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_DEPS);
#endif

  if (USE_PERFECT) {
    singleThreadedExecutionSMem = new PerfectShadow2();
  } else {
    singleThreadedExecutionSMem = new ShadowMemory(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  }

  myMap = new depMap();
}

void mergeDeps() {
  allDepsLock.lock();
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::MERGE_DEPS);
#endif

  for (auto &dep : *myMap) {
    // if a lid occurs the first time, operator[] adds its set to the global hash table;
    // otherwise the set that is already there is extended.
    depSet &global_deps = (*allDeps)[dep.first];
    for (auto &d : dep.second) {
      global_deps.insert(d);
    }
  }
  allDepsLock.unlock();
  myMap->clear();
}

void finalizeParallelization() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("finalizeParallelization");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::FINALIZE_PARALLELIZATION);
#endif

  if (DP_DEBUG) {
    cout << "BEGIN: finalize parallelization... \n";
  }

  // push last state of the mainThread_AccessInfoBuffer to the global FirstAccessQueue
  firstAccessQueue.push(mainThread_AccessInfoBuffer);
  mainThread_AccessInfoBuffer = firstAccessQueueChunkBuffer.get_prepared_chunk(FIRST_ACCESS_QUEUE_CHUNK_SIZE);

  // fake signaling: just notify the workers that no more addresses will be
  // collected
  finalizeParallelizationCalled = true;

  // wait for worker threads
  for (int i = 0; i < NUM_WORKERS; ++i) {
    pthread_join(workers[i], nullptr);
}
  pthread_join(*secondAccessQueue_worker_thread, nullptr);

  // delete allocated memory
  delete[] workers;
  delete secondAccessQueue_worker_thread;
  delete[] numAccesses;
  numAccesses = nullptr;

  if (DP_DEBUG) {
    cout << "END: finalize parallelization... \n";
  }
}

void finalizeSingleThreadedExecution() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("finalizeSingleThreadedExecution");
#endif

  if (DP_DEBUG) {
    std::cout << "BEGIN: finalize Single Threaded Execution... \n";
  }

  delete singleThreadedExecutionSMem;
  singleThreadedExecutionSMem = nullptr;
  mergeDeps();
  delete myMap;
  myMap = nullptr;

  if (DP_DEBUG) {
    std::cout << "END: finalize Single Threaded Execution... \n";
  }
}

} // namespace __dp
