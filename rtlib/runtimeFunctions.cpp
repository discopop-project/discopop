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

#include "DPUtils.hpp"

#include "../share/include/debug_print.hpp"
#include "../share/include/timer.hpp"
#include "calltree/utils.hpp"
#include "injected_functions/all.hpp"
#include "loop/Makros.hpp"
#include "memory/PerfectShadow.hpp"
#include "memory/ShadowMemory.hpp"
#include "memory/Signature.hpp"

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <list>
#include <mutex>
#include <queue>
#include <set>
#include <sstream>
#include <string>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <unordered_map>
#include <unordered_set>
#include <utility>
// hybrid analysis
#include <regex>
// End HA

#ifdef __linux__ // headers only available on Linux
#include <linux/limits.h>
#include <unistd.h>
#endif

using namespace std;
using namespace dputil;

namespace __dp {

/******* Helper functions *******/

#if DP_CALLTREE_PROFILING
void addDep(depType type, LID curr, LID depOn, const char *var, string AAvar, ADDR addr,
            std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_write_addr_to_call_tree_node_map,
            std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_read_addr_to_call_tree_node_map) {
#else
void addDep(depType type, LID curr, LID depOn, const char *var, string AAvar, ADDR addr) {
#endif

#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ADD_DEP);
#endif

  // hybrid analysis
  if (depOn == 0 && type == WAW)
    type = INIT;
  // End HA

  depType originalType = type;
  int loopIterationOffset = 0;

  // Remove metadata to preserve result correctness and add metadata to `Dep`
  // object

  // register dependency
  depMap::iterator posInDeps = myMap->find(curr);
  if (posInDeps == myMap->end()) {
    depSet *tmp_depSet = new depSet();
    tmp_depSet->insert(Dep(type, depOn, var, AAvar));
    myMap->insert(std::pair<int32_t, depSet *>(curr, tmp_depSet));
  } else {
    posInDeps->second->insert(Dep(type, depOn, var, AAvar));
  }

#if DP_CALLTREE_PROFILING
  // register dependency for call_tree based metadata calculation
  DependencyMetadata dmd;
  switch (type) {
  case RAW:
    // register metadata calculation
    // cout << "Register metadata calculation: RAW " << decodeLID(curr) << " " << decodeLID(depOn) << " " << var << " ("
    // <<  (*thread_private_write_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_write_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ") " << " (" <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ")\n";

    // process directly
    dmd = processQueueElement(MetaDataQueueElement(type, curr, depOn, var, AAvar,
                                                   (*thread_private_read_addr_to_call_tree_node_map)[addr],
                                                   (*thread_private_write_addr_to_call_tree_node_map)[addr]));
    dependency_metadata_results_mtx->lock();
    dependency_metadata_results->insert(dmd);
    dependency_metadata_results_mtx->unlock();

    // metadata_queue->insert(); // optimization potential: do not use copies here!
    break;
  case WAR:
    // update write
    // register metadata calculation
    // cout << "Register metadata calculation: WAR " << decodeLID(curr) << " " << decodeLID(depOn) << " " << var << " ("
    // <<  (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ") " << " (" <<
    // (*thread_private_write_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_write_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ")\n";

    dmd = processQueueElement(MetaDataQueueElement(type, curr, depOn, var, AAvar,
                                                   (*thread_private_write_addr_to_call_tree_node_map)[addr],
                                                   (*thread_private_read_addr_to_call_tree_node_map)[addr]));
    dependency_metadata_results_mtx->lock();
    dependency_metadata_results->insert(dmd);
    dependency_metadata_results_mtx->unlock();
    // metadata_queue->insert(); // optimization potential: do not use copies here!
    break;
  case WAW:
    // register metadata calculation
    // cout << "Register metadata calculation: WAW " << decodeLID(curr) << " " << decodeLID(depOn) << " " << var << " ("
    // <<  (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ") " << " (" <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_loop_or_function_id() << " , " <<
    // (*thread_private_read_addr_to_call_tree_node_map)[addr]->get_iteration_id() << ")\n";
    dmd = processQueueElement(MetaDataQueueElement(type, curr, depOn, var, AAvar,
                                                   (*thread_private_write_addr_to_call_tree_node_map)[addr],
                                                   (*thread_private_write_addr_to_call_tree_node_map)[addr]));
    dependency_metadata_results_mtx->lock();
    dependency_metadata_results->insert(dmd);
    dependency_metadata_results_mtx->unlock();
    // metadata_queue->insert(); // optimization potential: do not use copies here!
    break;
  case INIT:
    break;
  default:
    break;
  }

#endif

  if (DP_DEBUG) {
    cout << "inserted dep [" << decodeLID(curr) << ", ";
    switch (type) {
    case RAW:
      cout << "RAW";
      break;
    case WAR:
      cout << "WAR";
      break;
    case WAW:
      cout << "WAW";
      break;
    case INIT:
      cout << "INIT";
      break;
    default:
      break;
    }
    cout << ", " << decodeLID(depOn) << "] into deps (" << myMap->size() << ")" << endl;
  }
}

// hybrid analysis
void generateStringDepMap() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("generateStringDepMap");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::GENERATE_STRING_DEP_MAP);
#endif

  for (auto &dline : *allDeps) {
    if (dline.first) {
      string lid = decodeLID(dline.first);
      set<string> lineDeps;
      for (auto &d : *(dline.second)) {
        string dep = "";
        switch (d.type) {
        case RAW:
          dep += "RAW";
          break;
        case WAR:
          dep += "WAR";
          break;
        case WAW:
          dep += "WAW";
          break;
        case INIT:
          dep += "INIT";
          break;
        default:
          break;
        }

        dep += ' ' + decodeLID(d.depOn);
        dep += "|" + string(d.var);
        dep += "(" + string(d.AAvar) + ")";

        lineDeps.insert(dep);
      }

      if (outPutDeps->count(lid) == 0) {
        (*outPutDeps)[lid] = lineDeps;
      } else {
        (*outPutDeps)[lid].insert(lineDeps.begin(), lineDeps.end());
      }
      delete dline.second;
    }
  }
}

void outputDeps() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("outputDeps");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::OUTPUT_DEPS);
#endif

  for (auto pair : *outPutDeps) {
    *out << pair.first << " NOM ";
    for (auto dep : pair.second) {
      *out << ' ' << dep;
    }
    *out << endl;
  }
}
// End HA

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
          } else if (variable.compare("CHUNK_SIZE") == 0) {
            CHUNK_SIZE = intValue;
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
    cout << "chunk_size   = " << CHUNK_SIZE << "\n";
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
  addrChunkPresentConds = new pthread_cond_t[NUM_WORKERS];
  addrChunkMutexes = new pthread_mutex_t[NUM_WORKERS];

  chunks = new queue<AccessInfo *>[NUM_WORKERS];
  addrChunkPresent = new bool[NUM_WORKERS];
  tempAddrChunks = new AccessInfo *[NUM_WORKERS];
  tempAddrCount = new int32_t[NUM_WORKERS];
  workers = new pthread_t[NUM_WORKERS];

  // Initialize count of accesses
  numAccesses = new uint64_t[NUM_WORKERS]();

  // initialize and set thread detached attribute
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
  pthread_mutex_init(&allDepsLock, NULL);

  // create worker threads and set default value for temp variables
  for (int64_t i = 0; i < NUM_WORKERS; ++i) {
    addrChunkPresent[i] = false;
    tempAddrCount[i] = 0;
    tempAddrChunks[i] = new AccessInfo[CHUNK_SIZE];
    pthread_mutex_init(&addrChunkMutexes[i], NULL);
    pthread_cond_init(&addrChunkPresentConds[i], NULL);
    pthread_create(&workers[i], &attr, analyzeDeps, (void *)i);
  }

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
    singleThreadedExecutionSMem = new PerfectShadow(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  } else {
    singleThreadedExecutionSMem = new ShadowMemory(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  }

  myMap = new depMap();
}

string getMemoryRegionIdFromAddr(string fallback, ADDR addr) {
#if DP_MEMORY_REGION_DEALIASING
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::GET_MEMORY_REGION_ID_FROM_ADDR);
#endif

  return fallback + '-' + memory_manager->get_memory_region_id(addr, fallback);
#else
  return fallback;
#endif
}

void mergeDeps() {
  depSet *tmp_depSet = nullptr; // pointer to the current processing set of dps
  depMap::iterator globalPos;   // position of the current processing lid in allDeps

  pthread_mutex_lock(&allDepsLock);
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::MERGE_DEPS);
#endif

  for (auto &dep : *myMap) {
    // if a lid occurs the first time, then add it in to the global hash table.
    // Otherwise just take the associated set of dps.
    globalPos = allDeps->find(dep.first);
    if (globalPos == allDeps->end()) {
      tmp_depSet = new depSet();
      (*allDeps)[dep.first] = tmp_depSet;
    } else {
      tmp_depSet = globalPos->second;
    }

    // merge the associated set with current lid into the global hash table
    for (auto &d : *(dep.second)) {
      tmp_depSet->insert(d);
    }
  }

  pthread_mutex_unlock(&allDepsLock);
}

#if DP_CALLTREE_PROFILING
void analyzeSingleAccess(
    __dp::AbstractShadow *SMem, __dp::AccessInfo &access,
    std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_write_addr_to_call_tree_node_map,
    std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_read_addr_to_call_tree_node_map) {
#else
void analyzeSingleAccess(__dp::AbstractShadow *SMem, __dp::AccessInfo &access) {
#endif

  // analyze data dependences
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_SINGLE_ACCESS);
#endif

  if (access.isRead) {
    // hybrid analysis
    if (access.skip) {
      SMem->insertToRead(access.addr, access.lid);
#if DP_CALLTREE_PROFILING
      // cout << "Acc1 " << access.addr << " " << access.call_tree_node_ptr << "\n";
      (*thread_private_read_addr_to_call_tree_node_map)[access.addr] = access.call_tree_node_ptr;
      // cout << "Access read succ\n";
#endif
      return;
    }
    // End HA
    sigElement lastWrite = SMem->testInWrite(access.addr);
    if (lastWrite != 0) {
      // RAW
      SMem->insertToRead(access.addr, access.lid);
#if DP_CALLTREE_PROFILING
      // cout << "Acc2 " << access.addr << " " << access.call_tree_node_ptr << "\n";
      (*thread_private_read_addr_to_call_tree_node_map)[access.addr] = access.call_tree_node_ptr;
      // cout << "Access read succ\n";
#endif
#if DP_CALLTREE_PROFILING
      addDep(RAW, access.lid, lastWrite, access.var, access.AAvar, access.addr,
             thread_private_write_addr_to_call_tree_node_map, thread_private_read_addr_to_call_tree_node_map);
#else
      addDep(RAW, access.lid, lastWrite, access.var, access.AAvar, access.addr);
#endif
    }

  } else {
    sigElement lastWrite = SMem->insertToWrite(access.addr, access.lid);
#if DP_CALLTREE_PROFILING
    // cout << "Acc3 " << access.addr << " " << access.call_tree_node_ptr << "\n";
    // cout << "Acc3-0: " << write_addr_to_call_tree_node_map << "\n";

    // cout << "Acc3-2 " << write_addr_to_call_tree_node_map << "\n";

    (*thread_private_write_addr_to_call_tree_node_map)[access.addr] = access.call_tree_node_ptr;
    // cout << "Access write succ\n";
#endif
    if (lastWrite == 0) {
      // INIT
#if DP_CALLTREE_PROFILING
      addDep(INIT, access.lid, 0, access.var, access.AAvar, access.addr,
             thread_private_write_addr_to_call_tree_node_map, thread_private_read_addr_to_call_tree_node_map);
#else
      addDep(INIT, access.lid, 0, access.var, access.AAvar, access.addr);
#endif
    } else {
      sigElement lastRead = SMem->testInRead(access.addr);
      if (lastRead != 0) {
        // WAR
#if DP_CALLTREE_PROFILING
        addDep(WAR, access.lid, lastRead, access.var, access.AAvar, access.addr,
               thread_private_write_addr_to_call_tree_node_map, thread_private_read_addr_to_call_tree_node_map);
#else
        addDep(WAR, access.lid, lastRead, access.var, access.AAvar, access.addr);
#endif
        // Clear intermediate read ops
        SMem->insertToRead(access.addr, 0);
#if DP_CALLTREE_PROFILING
        // cout << "Acc4 " << access.addr << " " << access.call_tree_node_ptr << "\n";
        (*thread_private_read_addr_to_call_tree_node_map)[access.addr] = access.call_tree_node_ptr;
        // cout << "Access read succ\n";
#endif
      } else {
        // WAW
#if DP_CALLTREE_PROFILING
        addDep(WAW, access.lid, lastWrite, access.var, access.AAvar, access.addr,
               thread_private_write_addr_to_call_tree_node_map, thread_private_read_addr_to_call_tree_node_map);
#else
        addDep(WAW, access.lid, lastWrite, access.var, access.AAvar, access.addr);
#endif
      }
    }
  }
}

void *analyzeDeps(void *arg) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_DEPS);
#endif

  int64_t id = (int64_t)arg;
  AbstractShadow *SMem;
  if (USE_PERFECT) {
    SMem = new PerfectShadow(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  } else {
    SMem = new ShadowMemory(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  }
  myMap = new depMap();
#if DP_CALLTREE_PROFILING
  std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_write_addr_to_call_tree_node_map =
      new std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>>();
  std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>> *thread_private_read_addr_to_call_tree_node_map =
      new std::unordered_map<ADDR, std::shared_ptr<CallTreeNode>>();
#endif
  bool isLocked = false;
  while (true) {
    if (!isLocked)
      pthread_mutex_lock(&addrChunkMutexes[id]);

    while (!addrChunkPresent[id]) {
      pthread_cond_wait(&addrChunkPresentConds[id], &addrChunkMutexes[id]);
    }
    isLocked = true;

    if (chunks[id].size()) {
      // take a chunk of memory accesses from the queue
      AccessInfo *accesses = chunks[id].front();
      chunks[id].pop();

      // unlock the mutex so that the master thread can add more chunks
      pthread_mutex_unlock(&addrChunkMutexes[id]);
      isLocked = false;
      AccessInfo access;

      // analyze data dependences
      for (unsigned short i = 0; i < CHUNK_SIZE; ++i) {

        access = accesses[i];
#if DP_CALLTREE_PROFILING
        analyzeSingleAccess(SMem, access, thread_private_write_addr_to_call_tree_node_map,
                            thread_private_read_addr_to_call_tree_node_map);
#else
        analyzeSingleAccess(SMem, access);
#endif
      }

      // delete the current chunk at the end
      if (accesses) {
        delete[] accesses;
      }
    }

    if (!isLocked) {
      pthread_mutex_lock(&addrChunkMutexes[id]);
      isLocked = true;
    }

    // if current chunk is empty and no more addresses will be collected (stop =
    // true) then exits . Otherwise continues to wait for new chunks
    if (chunks[id].size() == 0) {
      if (stop) {
        break;
      } else {
        addrChunkPresent[id] = false;
      }
    }
  }

  delete SMem;
#if DP_CALLSTACK_PROFILING
  delete thread_private_write_addr_to_call_tree_node_map;
  delete thread_private_read_addr_to_call_tree_node_map;
#endif
  pthread_mutex_unlock(&addrChunkMutexes[id]);
  mergeDeps();

  if (DP_DEBUG) {
    cout << "thread " << id << " exits... \n";
  }

  pthread_exit(NULL);
  return nullptr;
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

  // fake signaling: just notify the workers that no more addresses will be
  // collected
  for (int i = 0; i < NUM_WORKERS; ++i) {
    pthread_mutex_lock(&addrChunkMutexes[i]);
    stop = true;
    addrChunkPresent[i] = true;
    if (0 < tempAddrCount[i]) {
      chunks[i].push(tempAddrChunks[i]);
    }
    pthread_cond_signal(&addrChunkPresentConds[i]);
    pthread_mutex_unlock(&addrChunkMutexes[i]);
  }

  if (DP_DEBUG) {
    for (int i = 0; i < NUM_WORKERS; ++i) {
      cout << chunks[i].size() << "\n";
    }
  }

  // wait for worker threads
  for (int i = 0; i < NUM_WORKERS; ++i)
    pthread_join(workers[i], NULL);

#if DP_CALLTREE_PROFILING
    // metadata_queue->blocking_finalize_queue();
#endif

  // destroy mutexes and condition variables
  for (int i = 0; i < NUM_WORKERS; ++i) {
    pthread_mutex_destroy(&addrChunkMutexes[i]);
    pthread_cond_destroy(&addrChunkPresentConds[i]);
  }

  // delete allocated memory
  delete[] chunks;
  delete[] tempAddrCount;
  delete[] tempAddrChunks;
  delete[] workers;

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
  mergeDeps();

  if (DP_DEBUG) {
    std::cout << "END: finalize Single Threaded Execution... \n";
  }
}

#if DP_STACK_ACCESS_DETECTION
void clearStackAccesses(ADDR stack_lower_bound, ADDR stack_upper_bound) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::CLEAR_STACK_ACCESSES);
#endif

  const auto &current_scope = memory_manager->getCurrentScope();
  const auto &writes = current_scope.get_first_write();
  for (ADDR addr : writes) {
    // cleanup reads
    __dp_read(0, addr, "");
    // cleanup writes
    __dp_write(0, addr, "");
  }
}
#endif

} // namespace __dp
