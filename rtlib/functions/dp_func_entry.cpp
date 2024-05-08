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

#include "../DPTypes.hpp"

#include "../iFunctionsGlobals.hpp"
#include "../iFunctions.hpp"

#include "../../share/include/timer.hpp"

#include <linux/limits.h>

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

using namespace std;

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_func_entry(LID lid, int32_t isStart) {
  if (targetTerminated) {
    // prevent deleting generated results after the main function has been exited.
    // This might happen, e.g., if a destructor of a global struct is called after exiting the main function.
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  cout << "enter __dp_func_entry\n";
#endif

  const auto dp_inited_previous = dpInited;
  if (dp_inited_previous) {
#ifdef DP_INTERNAL_TIMER
    timers->start(TimerRegion::FUNC_ENTRY);
#endif
  }

  if (!dpInited) {
    // This part should be executed only once.
    readRuntimeInfo();
    timers = new Timers();

    memory_manager = new MemoryManager();

    loopStack = new LoopTable();
    loops = new LoopRecords();
    beginFuncs = new BGNFuncList();
    endFuncs = new ENDFuncList();
    out = new ofstream();

    // TEST
    // stackAddrs = new std::stack<std::pair<ADDR, ADDR>>();
    // scopeManager = new ScopeManager();
    // !TEST

    // hybrid analysis
    allDeps = new depMap();
    outPutDeps = new stringDepMap();
    bbList = new ReportedBBSet();
    // End HA
    
    memory_manager->allocate_dummy_region();

#ifdef __linux__
    // try to get an output file name w.r.t. the target application
    // if it is not available, fall back to "Output.txt"
    char *selfPath = new char[PATH_MAX];
    if (selfPath != nullptr) {
      if (readlink("/proc/self/exe", selfPath, PATH_MAX - 1) == -1) {
        delete[] selfPath;
        selfPath = nullptr;
        out->open("Output.txt", ios::out);
      }
      // out->open(string(selfPath) + "_dep.txt", ios::out);  # results in the
      // old <prog>_dep.txt
      //  prepare environment variables
      char const *tmp = getenv("DOT_DISCOPOP");
      if (tmp == NULL) {
        // DOT_DISCOPOP needs to be initialized
        setenv("DOT_DISCOPOP", ".discopop", 1);
      }
      std::string tmp_str(getenv("DOT_DISCOPOP"));
      setenv("DOT_DISCOPOP_PROFILER", (tmp_str + "/profiler").data(), 1);
      std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
      tmp2 += "/dynamic_dependencies.txt";

      out->open(tmp2.data(), ios::out);
    }
#else
    out->open("Output.txt", ios::out);
#endif
    assert(out->is_open() && "Cannot open a file to output dependences.\n");

    if (DP_DEBUG) {
      cout << "DP initialized at LID " << std::dec << dputil::decodeLID(lid) << endl;
    }
    dpInited = true;
    initParallelization();
  } else if (targetTerminated) {
    if (DP_DEBUG) {
      cout << "Entering function LID " << std::dec << dputil::decodeLID(lid);
      cout << " but target program has returned from main(). Destructors?"
           << endl;
    }
  } else {
    // Process ordinary function call/invoke.
    assert((lastCallOrInvoke != 0 || lastProcessedLine != 0) &&
           "Error: lastCalledFunc == lastProcessedLine == 0");
    if (lastCallOrInvoke == 0)
      lastCallOrInvoke = lastProcessedLine;
    ++FuncStackLevel;

    if (DP_DEBUG) {
      cout << "Entering function LID " << std::dec << dputil::decodeLID(lid) << endl;
      cout << "Function stack level = " << std::dec << FuncStackLevel << endl;
    }
    BGNFuncList::iterator func = beginFuncs->find(lastCallOrInvoke);
    if (func == beginFuncs->end()) {
      set<LID> *tmp = new set<LID>();
      tmp->insert(lid);
      beginFuncs->insert(pair<LID, set<LID> *>(lastCallOrInvoke, tmp));
    } else {
      func->second->insert(lid);
    }
  }

  // TEST
  memory_manager->enter_new_function();
  memory_manager->enterScope("function", lid);
  // !TEST

  if (isStart)
    *out << "START " << dputil::decodeLID(lid) << endl;

  // Reset last call tracker
  lastCallOrInvoke = 0;

#ifdef DP_INTERNAL_TIMER
  if (dp_inited_previous) {
    timers->stop_and_add(TimerRegion::FUNC_ENTRY);
  }
#endif
#ifdef DP_RTLIB_VERBOSE
  std::cout << "exit __dp_func_entry\n";
#endif
}

}

} // namespace __dp
