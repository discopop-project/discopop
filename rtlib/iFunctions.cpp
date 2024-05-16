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
#include "perfect_shadow.hpp"
#include "shadow.hpp"
#include "signature.hpp"
#include "functions/all.hpp"
#include "DPUtils.hpp"
#include "MemoryRegionTree.hpp"
#include "scope.hpp"
#include "../share/include/timer.hpp"

#include "iFunctionsGlobals.hpp"

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
  timers->start(TimerRegion::ADD_DEP);
  
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

  timers->stop_and_add(TimerRegion::ADD_DEP);
}

// hybrid analysis
void generateStringDepMap() {
  timers->start(TimerRegion::GENERATE_STRING_DEP_MAP);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter generateStringDepMap\n";
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
#ifdef DP_RTLIB_VERBOSE
  cout << "enter generateStringDepMap\n";
#endif

  timers->stop_and_add(TimerRegion::GENERATE_STRING_DEP_MAP);
}

void outputDeps() {
  timers->start(TimerRegion::OUTPUT_DEPS);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter outputDeps\n";
#endif
  for (auto pair : *outPutDeps) {
    *out << pair.first << " NOM ";
    for (auto dep : pair.second) {
      *out << ' ' << dep;
    }
    *out << endl;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit outputDeps\n";
#endif

  timers->stop_and_add(TimerRegion::OUTPUT_DEPS);
}
// End HA

void outputLoops() {
  timers->start(TimerRegion::OUTPUT_LOOPS);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter outputLoops\n";
#endif
  assert((loops != nullptr) && "Loop map is not available!");
  for (auto &loop : *loops) {
    *out << decodeLID(loop.first) << " BGN loop ";
    *out << loop.second->total << ' ';
    *out << loop.second->nEntered << ' ';
    *out << static_cast<int32_t>(loop.second->total / loop.second->nEntered)
         << ' ';
    *out << loop.second->maxIterationCount << endl;
    *out << decodeLID(loop.second->end) << " END loop" << endl;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit outputLoops\n";
#endif

  timers->stop_and_add(TimerRegion::OUTPUT_LOOPS);
}

void outputFuncs() {
  timers->start(TimerRegion::OUTPUT_FUNCS);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter outputFunc\n";
#endif
  assert(beginFuncs != nullptr && endFuncs != nullptr &&
         "Function maps are not available!");
  for (auto &func_begin : *beginFuncs) {
    for (auto fb : *(func_begin.second)) {
      *out << decodeLID(func_begin.first) << " BGN func ";
      *out << decodeLID(fb) << endl;
    }
  }

  for (auto fe : *endFuncs) {
    *out << decodeLID(fe) << " END func" << endl;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit outputFunc\n";
#endif

  timers->stop_and_add(TimerRegion::OUTPUT_FUNCS);
}

void outputAllocations() {
  timers->start(TimerRegion::OUTPUT_ALLOCATIONS);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter outputAllocations\n";
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
  for (const auto& memoryRegion : *allocatedMemoryRegions) {
    const auto lid = get<0>(memoryRegion);
    const auto& id = get<1>(memoryRegion);
    const auto num_bytes = get<4>(memoryRegion);

    decodeLID(lid, allocationsFileStream);
    allocationsFileStream << ' ' << id << ' ' << num_bytes << endl;
  }
  
#ifdef DP_RTLIB_VERBOSE
  cout << "exit outputAllocations\n";
#endif
  timers->stop_and_add(TimerRegion::OUTPUT_ALLOCATIONS);
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
  timers->start(TimerRegion::INIT_PARALLELIZATION);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter initParallelization\n";
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
#ifdef DP_RTLIB_VERBOSE
  cout << "exit initParallelization\n";
#endif

  timers->stop_and_add(TimerRegion::INIT_PARALLELIZATION);
}

string getMemoryRegionIdFromAddr(string fallback, ADDR addr) {
  timers->start(TimerRegion::GET_MEMORY_REGION_ID_FROM_ADDR);
  
  // use tree
  const auto return_value = fallback + "-" +
         allocatedMemRegTree->get_memory_region_id(fallback, addr);

  timers->stop_and_add(TimerRegion::GET_MEMORY_REGION_ID_FROM_ADDR);
  return return_value;

  /*// check if accessed addr in knwon range. If not, return fallback
  immediately if(addr >= smallestAllocatedADDR && addr <= largestAllocatedADDR){
      // FOR NOW, ONLY SEARCH BACKWARDS TO FIND THE LATEST ALLOCA ENTRY IN CASE
  MEMORY ADDRESSES ARE REUSED if(allocatedMemoryRegions->size() != 0){
          // search backwards in the list
          auto bw_it = allocatedMemoryRegions->end();
          bw_it--;
          bool search_backwards = true;

          while(true){
              if(*bw_it == allocatedMemoryRegions->front()){
                  search_backwards = false;
              }
              if(get<2>(*bw_it) <= addr && get<3>(*bw_it) >= addr){
                  lastHitIterator = bw_it;
                  return get<1>(*bw_it);
              }

              if(search_backwards){
                  bw_it--;
              }
              else{
                  break;
              }
          }
      }

  }

  return fallback;
  */
}

void addAccessInfo(bool isRead, LID lid, char *var, ADDR addr) {
  timers->start(TimerRegion::ADD_ACCESS_INFO);
  
#ifdef DP_RTLIB_VERBOSE
  cout << "enter addAccessInfo\n";
#endif
  int64_t workerID =
      ((addr - (addr % 4)) % (NUM_WORKERS * 4)) / 4; // implicit "floor"
  numAccesses[workerID]++;
  AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
  current.isRead = isRead;
  current.lid = lid;
  current.var = var;
  current.AAvar = getMemoryRegionIdFromAddr(var, addr);
  current.addr = addr;
  // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop
  // iteration count as valid, last 7 bits for loop iteration) last 8 bits are
  // sufficient, since metadata is only used to check for different iterations,
  // not exact values. first 32 bits of current.lid are reserved for metadata
  // and thus empty
  if (loopStack->size() > 0) {
    if (loopStack->size() == 1) {
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id

      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
    } else if (loopStack->size() == 2) {
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id
      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(1).count & 0x7F))
                                   << 40); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000800000000000; // mark loop count valid
    } else {                                     // (loopStack->size() >= 3)
      current.lid = current.lid | (((LID)(loopStack->first().loopID & 0xFF))
                                   << 56); // add masked loop id
      current.lid = current.lid | (((LID)(loopStack->top().count & 0x7F))
                                   << 48); // add masked loop count
      current.lid =
          current.lid | (LID)0x0080000000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(1).count & 0x7F))
                                   << 40); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000800000000000; // mark loop count valid
      current.lid = current.lid | (((LID)(loopStack->topMinusN(2).count & 0x7F))
                                   << 32); // add masked loop count
      current.lid =
          current.lid | (LID)0x0000008000000000; // mark loop count valid
    }
  } else {
    // mark loopID as invalid (0xFF to allow 0 as valid loop id)
    current.lid = current.lid | (((LID)0xFF) << 56);
  }

  if (tempAddrCount[workerID] == CHUNK_SIZE) {
    pthread_mutex_lock(&addrChunkMutexes[workerID]);
    addrChunkPresent[workerID] = true;
    chunks[workerID].push(tempAddrChunks[workerID]);
    pthread_cond_signal(&addrChunkPresentConds[workerID]);
    pthread_mutex_unlock(&addrChunkMutexes[workerID]);
    tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
    tempAddrCount[workerID] = 0;
  }
#ifdef DP_RTLIB_VERBOSE
  cout << "exit addAccessInfo\n";
#endif

  timers->stop_and_add(TimerRegion::ADD_ACCESS_INFO);
}

void mergeDeps() {  
  depSet *tmp_depSet = nullptr; // pointer to the current processing set of dps
  depMap::iterator globalPos; // position of the current processing lid in allDeps

  pthread_mutex_lock(&allDepsLock);
  timers->start(TimerRegion::MERGE_DEPS);

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
  
  timers->stop_and_add(TimerRegion::MERGE_DEPS);
  pthread_mutex_unlock(&allDepsLock);
}

void *analyzeDeps(void *arg) {
  timers->start(TimerRegion::ANALYZE_DEPS);
  
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
        timers->start(TimerRegion::ANALYZE_DEPS_INNER);
        access = accesses[i];

        if (access.isRead) {
          // hybrid analysis
          if (access.skip) {
            SMem->insertToRead(access.addr, access.lid);
            timers->stop_and_add(TimerRegion::ANALYZE_DEPS_INNER);
            continue;
          }
          // End HA
          sigElement lastWrite = SMem->testInWrite(access.addr);
          if (lastWrite != 0) {
            // RAW
            SMem->insertToRead(access.addr, access.lid);
            addDep(RAW, access.lid, lastWrite, access.var, access.AAvar,
                   access.isStackAccess, access.addr,
                   access.addrIsOwnedByScope,
                   access.positiveScopeChangeOccuredSinceLastAccess);
          }
        } else {
          sigElement lastWrite = SMem->insertToWrite(access.addr, access.lid);
          if (lastWrite == 0) {
            // INIT
            addDep(INIT, access.lid, 0, access.var, access.AAvar,
                   access.isStackAccess, access.addr,
                   access.addrIsOwnedByScope,
                   access.positiveScopeChangeOccuredSinceLastAccess);
          } else {
            sigElement lastRead = SMem->testInRead(access.addr);
            if (lastRead != 0) {
              // WAR
              addDep(WAR, access.lid, lastRead, access.var, access.AAvar,
                     access.isStackAccess, access.addr,
                     access.addrIsOwnedByScope,
                     access.positiveScopeChangeOccuredSinceLastAccess);
              // Clear intermediate read ops
              SMem->insertToRead(access.addr, 0);
            } else {
              // WAW
              addDep(WAW, access.lid, lastWrite, access.var, access.AAvar,
                     access.isStackAccess, access.addr,
                     access.addrIsOwnedByScope,
                     access.positiveScopeChangeOccuredSinceLastAccess);
            }
          }
        }
        timers->stop_and_add(TimerRegion::ANALYZE_DEPS_INNER);
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

  timers->stop_and_add(TimerRegion::ANALYZE_DEPS);
  pthread_exit(NULL);
}

void finalizeParallelization() {
  timers->start(TimerRegion::FINALIZE_PARALLELIZATION);

#ifdef DP_RTLIB_VERBOSE
  cout << "enter finalizeParallelization\n";
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
#ifdef DP_RTLIB_VERBOSE
  cout << "exit finalizeParallelization\n";
#endif

  timers->stop_and_add(TimerRegion::FINALIZE_PARALLELIZATION);
}

void clearStackAccesses(ADDR stack_lower_bound, ADDR stack_upper_bound) {
  timers->start(TimerRegion::CLEAR_STACK_ACCESSES);

  for (ADDR addr : scopeManager->getCurrentScope().get_first_write()) {
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

  timers->stop_and_add(TimerRegion::CLEAR_STACK_ACCESSES);
}

} // namespace __dp
