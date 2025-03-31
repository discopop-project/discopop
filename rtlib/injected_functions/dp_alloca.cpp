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
#include "../DPUtils.hpp"

#include "../runtimeFunctionsGlobals.hpp"

#include "../../share/include/debug_print.hpp"
#include "../../share/include/timer.hpp"

#include <cstdint>
#include <iostream>
#include <mutex>
#include <set>
#include <string>

using namespace std;

namespace __dp {

/******* Instrumentation function *******/
extern "C" {

void __dp_alloca(LID lid, char *var, ADDR startAddr, ADDR endAddr, int64_t numBytes, int64_t numElements) {
  if (!dpInited || targetTerminated) {
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("__dp_alloca");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ALLOCA);
#endif

/*  std::cout << "alloca: " << dputil::decodeLID(lid) << " : " << std::hex << startAddr << " - " << std::hex << endAddr << " num_bytes: " << numBytes << std::endl;
  if(stack_top_addr){
    if(startAddr < stack_top_addr){
      // increase stack shadow memory size
      stack_top_addr = startAddr;
      std::cout << "-> stack_base_addr: " << std::hex <<  stack_base_addr << std::endl;
      std::cout << "-> stack_top_addr: " << std::hex << stack_top_addr << std::endl;
      std::cout << "-> stack_size: " << ((stack_base_addr - stack_top_addr) >> 3) << std::endl;
      stack_writes->resize(((stack_base_addr - stack_top_addr) >> 3));
      stack_reads->resize(((stack_base_addr - stack_top_addr) >> 3));
    }
    else{
      // clear affected stack shadow memory locations
      std::cout << "-> affected offsets: " << stack_base_addr - endAddr  << "  -  " << stack_base_addr - startAddr << std::endl;
      std::fill(stack_reads->begin() + ((stack_base_addr - endAddr) >> 3), stack_reads->begin() + ((stack_base_addr - startAddr) >> 3), 0);
      std::fill(stack_writes->begin() + ((stack_base_addr - endAddr) >> 3), stack_reads->begin() + ((stack_base_addr - startAddr) >> 3), 0);
      std::cout << "-> reset affected locations" << std::endl;
    }
  }
  else{
    stack_base_addr = startAddr;
    stack_top_addr = startAddr;
  }
*/
  if(! stack_base_addr){
    stack_base_addr = startAddr;
    //std::cout << "Set stack base addr: " << std::hex << stack_base_addr << std::endl;
  }

#if DP_MEMORY_REGION_DEALIASING
#if DP_STACK_ACCESS_DETECTION
  // create entry to list of allocatedMemoryRegions
  const std::string allocId = memory_manager->allocate_stack_memory(lid, startAddr, endAddr, numBytes, numElements);
#else
  const std::string allocId = memory_manager->allocate_memory(lid, startAddr, endAddr, numBytes, numElements);
#endif
  // std::cout << "alloca: " << var << " (" << allocId << ") @ " <<
  // dputil::decodeLID(lid) << " : " << std::hex << startAddr << " - " <<
  // std::hex << endAddr << " -> #allocations: " <<
  // memory_manager->get_number_allocations() << "\n";
#ifdef DP_DEBUG
  cout << "alloca: " << var << " (" << allocId << ") @ " << dputil::decodeLID(lid) << " : " << std::hex << startAddr
       << " - " << std::hex << endAddr << " -> #allocations: " << memory_manager->get_number_allocations() << "\n";
#endif
#endif
}
}

} // namespace __dp
