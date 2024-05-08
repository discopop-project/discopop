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

#include "iFunctions.hpp"
#include "iFunctionsGlobals.hpp"

#include "DPUtils.hpp"

#include "loop/Makros.hpp"
#include "memory/perfect_shadow.hpp"
#include "memory/shadow.hpp"
#include "memory/signature.hpp"
#include "injected_functions/all.hpp"
#include "../share/include/debug_print.hpp"
#include "../share/include/timer.hpp"

#include <cstdio>
#include <limits>
#include <list>
#include <mutex>
#include <string>
#include <algorithm>
#include <cstdlib>
#include <queue>
#include <set>
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

void addDep(depType type, LID curr, LID depOn, char *var, string AAvar,
            bool isStackAccess, ADDR addr, bool addrIsFirstWrittenInScope,
            bool positiveScopeChangeOccuredSinceLastAccess) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ADD_DEP);
#endif
  
  // hybrid analysis
  if (depOn == 0 && type == WAW)
    type = INIT;
  // End HA

  depType originalType = type;
  int loopIterationOffset = 0;

  std::vector<depTypeModifier> identifiedDepTypes;
  bool dependencyRegistered = false;
  // Compare metadata (Loop ID's and Loop Iterations) from LID's if loop id's
  // are overwritten (not 0xFF anymore) and check for intra-iteration
  // dependencies Intra-Iteration dependency exists, if LoopId's and Iteration
  // Id's are equal
  if (unpackLIDMetadata_getLoopID(curr) != (LID)0xFF &&
      unpackLIDMetadata_getLoopID(depOn) != (LID)0xFF) {
    if (unpackLIDMetadata_getLoopID(curr) ==
        unpackLIDMetadata_getLoopID(depOn)) {

      // determine iteration count offset in case a new loop has been entered
      // between curr and depOn
      loopIterationOffset = checkLIDMetadata_getLoopIterationValidity_0(curr) +
                            checkLIDMetadata_getLoopIterationValidity_1(curr) +
                            checkLIDMetadata_getLoopIterationValidity_2(curr) -
                            checkLIDMetadata_getLoopIterationValidity_0(depOn) -
                            checkLIDMetadata_getLoopIterationValidity_1(depOn) -
                            checkLIDMetadata_getLoopIterationValidity_2(depOn);

      if (loopIterationOffset == 0) {

        if (checkLIDMetadata_getLoopIterationValidity_0(curr) &&
            checkLIDMetadata_getLoopIterationValidity_0(depOn)) {
          if (checkLIDMetadata_getLoopIterationValidity_1(curr) &&
              checkLIDMetadata_getLoopIterationValidity_1(depOn)) {
            if (checkLIDMetadata_getLoopIterationValidity_2(curr) &&
                checkLIDMetadata_getLoopIterationValidity_2(depOn)) {
              // loop 0+1+2 valid
              if (unpackLIDMetadata_getLoopIteration_2(curr) ==
                  unpackLIDMetadata_getLoopIteration_2(depOn)) {
                identifiedDepTypes.push_back(II_2);
                dependencyRegistered = true;

                if (unpackLIDMetadata_getLoopIteration_1(curr) ==
                    unpackLIDMetadata_getLoopIteration_1(depOn)) {
                  identifiedDepTypes.push_back(II_1);
                  if (unpackLIDMetadata_getLoopIteration_0(curr) ==
                      unpackLIDMetadata_getLoopIteration_0(depOn)) {
                    identifiedDepTypes.push_back(II_0);
                  }
                }
              }
            } else {
              // loop 0+1 valid
              if (unpackLIDMetadata_getLoopIteration_1(curr) ==
                  unpackLIDMetadata_getLoopIteration_1(depOn)) {
                identifiedDepTypes.push_back(II_1);
                dependencyRegistered = true;
                if (unpackLIDMetadata_getLoopIteration_0(curr) ==
                    unpackLIDMetadata_getLoopIteration_0(depOn)) {
                  identifiedDepTypes.push_back(II_0);
                }
              }
            }
          } else {
            // loop 0 valid
            if (unpackLIDMetadata_getLoopIteration_0(curr) ==
                unpackLIDMetadata_getLoopIteration_0(depOn)) {
              identifiedDepTypes.push_back(II_0);
              dependencyRegistered = true;
            }
          }
        } else {
          // no loop valid
        }

      } else if (loopIterationOffset == 1) {
        // check outer loop
        if ((unpackLIDMetadata_getLoopIteration_2(curr) ==
             unpackLIDMetadata_getLoopIteration_1(depOn)) &&
            checkLIDMetadata_getLoopIterationValidity_2(curr) &&
            checkLIDMetadata_getLoopIterationValidity_1(depOn)) {
          // II 2
          identifiedDepTypes.push_back(II_2);
          dependencyRegistered = true;
        }
        // check second loop
        else if ((unpackLIDMetadata_getLoopIteration_1(curr) ==
                  unpackLIDMetadata_getLoopIteration_0(depOn)) &&
                 checkLIDMetadata_getLoopIterationValidity_1(curr) &&
                 checkLIDMetadata_getLoopIterationValidity_0(depOn)) {
          // II 1
          identifiedDepTypes.push_back(II_1);
          dependencyRegistered = true;
        }
      } else if (loopIterationOffset == 2) {
        // check outer loop
        if ((unpackLIDMetadata_getLoopIteration_2(curr) ==
             unpackLIDMetadata_getLoopIteration_0(depOn)) &&
            checkLIDMetadata_getLoopIterationValidity_2(curr) &&
            checkLIDMetadata_getLoopIterationValidity_0(depOn)) {
          // II 2
          identifiedDepTypes.push_back(II_2);
          dependencyRegistered = true;
        }
      } else if (loopIterationOffset == -2) {
        // example: depOn inside an inner loop, curr happens after this inner
        // loop
        if ((unpackLIDMetadata_getLoopIteration_0(curr) ==
             unpackLIDMetadata_getLoopIteration_2(depOn)) &&
            checkLIDMetadata_getLoopIterationValidity_0(curr) &&
            checkLIDMetadata_getLoopIterationValidity_2(depOn)) {
          // II 0
          identifiedDepTypes.push_back(II_0);
          dependencyRegistered = true;
        }
      } else if (loopIterationOffset == -1) {
        // check second loop
        if ((unpackLIDMetadata_getLoopIteration_1(curr) ==
             unpackLIDMetadata_getLoopIteration_2(depOn)) &&
            checkLIDMetadata_getLoopIterationValidity_1(curr) &&
            checkLIDMetadata_getLoopIterationValidity_2(depOn)) {
          // II 1
          identifiedDepTypes.push_back(II_1);
          dependencyRegistered = true;
          // check first loop
          if ((unpackLIDMetadata_getLoopIteration_0(curr) ==
               unpackLIDMetadata_getLoopIteration_1(depOn)) &&
              checkLIDMetadata_getLoopIterationValidity_0(curr) &&
              checkLIDMetadata_getLoopIterationValidity_1(depOn)) {
            // II 0
            identifiedDepTypes.push_back(II_0);
            dependencyRegistered = true;
          }
        }
        // check first loop
        else {
          if ((unpackLIDMetadata_getLoopIteration_0(curr) ==
               unpackLIDMetadata_getLoopIteration_1(depOn)) &&
              checkLIDMetadata_getLoopIterationValidity_0(curr) &&
              checkLIDMetadata_getLoopIterationValidity_1(depOn)) {
            // II 0
            identifiedDepTypes.push_back(II_0);
            dependencyRegistered = true;
          }
        }
      }
    }
  }

  if (!dependencyRegistered) {
    // register dependency with original type
    identifiedDepTypes.push_back(NOM);
  }

  // Remove metadata to preserve result correctness and add metadata to `Dep`
  // object
  LID dbg_curr = curr;   // for printing only
  LID dbg_depOn = depOn; // for printing only

  curr &= 0x00000000FFFFFFFF;
  depOn &= 0x00000000FFFFFFFF;

  std::vector<std::pair<Dep, LID>> dependenciesToBeRegistered;
  dependenciesToBeRegistered.reserve(identifiedDepTypes.size());

  for (depTypeModifier dtm : identifiedDepTypes) {
    depType modified_type = type;
    bool print_debug_info = false;
    switch (dtm) {
    case NOM:
      // keep modified_type = type
      // print_debug_info = true;
      break;
    case II_0: {
      switch (type) {
      case RAW:
        modified_type = RAW_II_0;
        break;
      case WAR:
        modified_type = WAR_II_0;
        break;
      case WAW:
        modified_type = WAW_II_0;
        break;
      case INIT:
        break;
      default:
        break;
      }
    } break;
    case II_1: {
      switch (type) {
      case RAW:
        modified_type = RAW_II_1;
        break;
      case WAR:
        modified_type = WAR_II_1;
        break;
      case WAW:
        modified_type = WAW_II_1;
        break;
      case INIT:
        break;
      default:
        break;
      }
    } break;
    case II_2: {
      switch (type) {
      case RAW:
        modified_type = RAW_II_2;
        break;
      case WAR:
        modified_type = WAR_II_2;
        break;
      case WAW:
        modified_type = WAW_II_2;
        break;
      case INIT:
        break;
      default:
        break;
      }
    } break;
    default:
      break;
    }

    if (isStackAccess &&
        (modified_type == WAR || modified_type == RAW ||
         modified_type == WAW) &&
        addrIsFirstWrittenInScope &&
        positiveScopeChangeOccuredSinceLastAccess) {
      // IGNORE ACCESS
    } else {
      // register dependency
      dependenciesToBeRegistered.emplace_back(Dep(modified_type, depOn, var, AAvar), curr);
    }

    if (print_debug_info) {
      cout << "AddDep: CURR: " << decodeLID(curr)
           << "  DepOn: " << decodeLID(dbg_depOn) << "  LoopIDS: " << hex
           << unpackLIDMetadata_getLoopID(dbg_curr) << ";" << hex
           << unpackLIDMetadata_getLoopID(dbg_depOn) << "\n";
      cout << "  Var: " << var << "\n";
      cout << "  Loop Iterations(curr): " << hex
           << unpackLIDMetadata_getLoopIteration_0(dbg_curr) << ";" << hex
           << unpackLIDMetadata_getLoopIteration_1(dbg_curr) << ";" << hex
           << unpackLIDMetadata_getLoopIteration_2(dbg_curr) << "\n";
      cout << "  Loop Iterations(depOn): " << hex
           << unpackLIDMetadata_getLoopIteration_0(dbg_depOn) << ";" << hex
           << unpackLIDMetadata_getLoopIteration_1(dbg_depOn) << ";" << hex
           << unpackLIDMetadata_getLoopIteration_2(dbg_depOn) << "\n";
      cout << "  Valid(cur): "
           << checkLIDMetadata_getLoopIterationValidity_0(dbg_curr) << ";"
           << checkLIDMetadata_getLoopIterationValidity_1(dbg_curr) << ";"
           << checkLIDMetadata_getLoopIterationValidity_2(dbg_curr) << ";\n";
      cout << "  Valid(dep): "
           << checkLIDMetadata_getLoopIterationValidity_0(dbg_depOn) << ";"
           << checkLIDMetadata_getLoopIterationValidity_1(dbg_depOn) << ";"
           << checkLIDMetadata_getLoopIterationValidity_2(dbg_depOn) << ";\n";
      cout << "  LoopIterationOffset: " << to_string(loopIterationOffset)
           << "\n";
      cout << "  orig.type: " << originalType << "\n";
      cout << "  final.type: " << modified_type << "\n\n";
    }
  }

  // register dependencies
  for (std::pair<Dep, LID> pair : dependenciesToBeRegistered) {
    depMap::iterator posInDeps = myMap->find(pair.second);
    if (posInDeps == myMap->end()) {
      depSet *tmp_depSet = new depSet();
      tmp_depSet->insert(Dep(pair.first.type, pair.first.depOn, pair.first.var,
                             pair.first.AAvar));
      myMap->insert(std::pair<int32_t, depSet *>(pair.second, tmp_depSet));
    } else {
      posInDeps->second->insert(Dep(pair.first.type, pair.first.depOn,
                                    pair.first.var, pair.first.AAvar));
    }

    if (DP_DEBUG) {
      cout << "inserted dep [" << decodeLID(pair.second) << ", ";
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
      cout << ", " << decodeLID(pair.first.depOn) << "] into deps ("
           << myMap->size() << ")" << endl;
    }
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
        case RAW_II_0:
          dep += "RAW_II_0";
          break;
        case WAR_II_0:
          dep += "WAR_II_0";
          break;
        case WAW_II_0:
          dep += "WAW_II_0";
          break;
        case RAW_II_1:
          dep += "RAW_II_1";
          break;
        case WAR_II_1:
          dep += "WAR_II_1";
          break;
        case WAW_II_1:
          dep += "WAW_II_1";
          break;
        case RAW_II_2:
          dep += "RAW_II_2";
          break;
        case WAR_II_2:
          dep += "WAR_II_2";
          break;
        case WAW_II_2:
          dep += "WAW_II_2";
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

void outputLoops() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("outputLoops");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::OUTPUT_LOOPS);
#endif
  
  loop_manager->output(*out);
}

void outputFuncs() {  
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("outputFunc");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::OUTPUT_FUNCS);
#endif

  function_manager->output_functions(*out);
}

void outputAllocations() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("outputAllocations");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::OUTPUT_ALLOCATIONS);
#endif

  const auto prepare_environment = [](){
      // prepare environment variables
    const char *discopop_env = getenv("DOT_DISCOPOP");
    if (discopop_env == NULL) {

      // DOT_DISCOPOP needs to be initialized
      setenv("DOT_DISCOPOP", ".discopop", 1);
      discopop_env = ".discopop";
    }

    auto discopop_profiler_str = std::string(discopop_env) + "/profiler";
    setenv("DOT_DISCOPOP_PROFILER", discopop_profiler_str.data(), 1);

    return discopop_profiler_str + "/memory_regions.txt";
  };
  const auto path = prepare_environment();

  auto allocationsFileStream = ofstream(path, ios::out);
  memory_manager->output_memory_regions(allocationsFileStream);
}

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
        variable.erase(std::remove_if(variable.begin(), variable.end(), func),
                       variable.end());
        value.erase(std::remove_if(value.begin(), value.end(), func),
                    value.end());

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

string getMemoryRegionIdFromAddr(string fallback, ADDR addr) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::GET_MEMORY_REGION_ID_FROM_ADDR);
#endif

  const auto return_value = fallback + "-" + memory_manager->get_memory_region_id(fallback, addr);
  return return_value;
}

void addAccessInfo(bool isRead, LID lid, char *var, ADDR addr) {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("addAccessInfo");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ADD_ACCESS_INFO);
#endif
  
  int64_t workerID =
      ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
  numAccesses[workerID]++;
  AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
  current.isRead = isRead;
  current.lid = loop_manager->update_lid(lid);
  current.var = var;
  current.AAvar = getMemoryRegionIdFromAddr(var, addr);
  current.addr = addr;

  if (tempAddrCount[workerID] == CHUNK_SIZE) {
    pthread_mutex_lock(&addrChunkMutexes[workerID]);
    addrChunkPresent[workerID] = true;
    chunks[workerID].push(tempAddrChunks[workerID]);
    pthread_cond_signal(&addrChunkPresentConds[workerID]);
    pthread_mutex_unlock(&addrChunkMutexes[workerID]);
    tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
    tempAddrCount[workerID] = 0;
  }
}

void mergeDeps() {  
  depSet *tmp_depSet = nullptr; // pointer to the current processing set of dps
  depMap::iterator globalPos; // position of the current processing lid in allDeps

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

void* analyzeDeps(void *arg) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_DEPS);
#endif
  
  int64_t id = (int64_t)arg;
  Shadow *SMem;
  if (USE_PERFECT) {
    SMem = new PerfectShadow(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  } else {
    SMem = new ShadowMemory(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
  }
  myMap = new depMap();
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

        if (access.isRead) {
          // hybrid analysis
          if (access.skip) {
            SMem->insertToRead(access.addr, access.lid);
            continue;
          }
          // End HA
          sigElement lastWrite = SMem->testInWrite(access.addr);
          if (lastWrite != 0) {
            // RAW
            SMem->insertToRead(access.addr, access.lid);
            addDep(RAW, access.lid, lastWrite, access.var, access.AAvar,
                   access.isStackAccess, access.addr,
                   access.addrIsFirstWrittenInScope,
                   access.positiveScopeChangeOccuredSinceLastAccess);
          }
        } else {
          sigElement lastWrite = SMem->insertToWrite(access.addr, access.lid);
          if (lastWrite == 0) {
            // INIT
            addDep(INIT, access.lid, 0, access.var, access.AAvar,
                   access.isStackAccess, access.addr,
                   access.addrIsFirstWrittenInScope,
                   access.positiveScopeChangeOccuredSinceLastAccess);
          } else {
            sigElement lastRead = SMem->testInRead(access.addr);
            if (lastRead != 0) {
              // WAR
              addDep(WAR, access.lid, lastRead, access.var, access.AAvar,
                     access.isStackAccess, access.addr,
                     access.addrIsFirstWrittenInScope,
                     access.positiveScopeChangeOccuredSinceLastAccess);
              // Clear intermediate read ops
              SMem->insertToRead(access.addr, 0);
            } else {
              // WAW
              addDep(WAW, access.lid, lastWrite, access.var, access.AAvar,
                     access.isStackAccess, access.addr,
                     access.addrIsFirstWrittenInScope,
                     access.positiveScopeChangeOccuredSinceLastAccess);
            }
          }
        }
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

void clearStackAccesses(ADDR stack_lower_bound, ADDR stack_upper_bound) {
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::CLEAR_STACK_ACCESSES);
#endif

  for (ADDR addr : memory_manager->getCurrentScope().get_first_write()) {
    int64_t workerID =
        ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
    // cleanup reads
    AccessInfo &cleanupReadCurrent =
        tempAddrChunks[workerID][tempAddrCount[workerID]++];
    cleanupReadCurrent.addr = addr;
    cleanupReadCurrent.lid = 0;
    cleanupReadCurrent.isRead = true;

    if (tempAddrCount[workerID] == CHUNK_SIZE) {
      pthread_mutex_lock(&addrChunkMutexes[workerID]);
      addrChunkPresent[workerID] = true;
      chunks[workerID].push(tempAddrChunks[workerID]);
      pthread_cond_signal(&addrChunkPresentConds[workerID]);
      pthread_mutex_unlock(&addrChunkMutexes[workerID]);
      tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
      tempAddrCount[workerID] = 0;
    }
    // cleanup writes
    AccessInfo &cleanupWriteCurrent =
        tempAddrChunks[workerID][tempAddrCount[workerID]++];
    cleanupWriteCurrent.addr = addr;
    cleanupWriteCurrent.lid = 0;
    cleanupWriteCurrent.isRead = false;

    if (tempAddrCount[workerID] == CHUNK_SIZE) {
      pthread_mutex_lock(&addrChunkMutexes[workerID]);
      addrChunkPresent[workerID] = true;
      chunks[workerID].push(tempAddrChunks[workerID]);
      pthread_cond_signal(&addrChunkPresentConds[workerID]);
      pthread_mutex_unlock(&addrChunkMutexes[workerID]);
      tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
      tempAddrCount[workerID] = 0;
    }
  }
}

} // namespace __dp
