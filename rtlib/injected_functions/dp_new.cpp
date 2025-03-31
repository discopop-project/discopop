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

void __dp_new(LID lid, ADDR startAddr, ADDR endAddr, int64_t numBytes) {
  if (!dpInited || targetTerminated) {
    return;
  }

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
  std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("__dp_new");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::NEW);
#endif


  //std::cout << "new: " << dputil::decodeLID(lid) << " : " << std::hex << startAddr << " - " << std::hex << endAddr << " num_bytes: " << numBytes << std::endl;
/*
  if(heap_top_addr){
    if(startAddr > heap_top_addr){
      // increase heap shadow memory size
      heap_top_addr = startAddr + numBytes;
      std::cout << "-> heap_base_addr: " << std::hex << heap_base_addr << std::endl;
      std::cout << "-> heap_top_addr: " << std::hex << heap_top_addr << std::endl;
      std::cout << "-> heap_size: " << ((heap_top_addr - heap_base_addr) >> 3) << std::endl;
      heap_writes->resize(((heap_top_addr - heap_base_addr) >> 3));
      heap_reads->resize(((heap_top_addr - heap_base_addr) >> 3));
    }
    else{
      // clear affected heap shadow memory locations
      std::cout << "-> heap_base_addr: " << std::hex << heap_base_addr << std::endl;
      std::cout << "-> heap_top_addr: " << std::hex << heap_top_addr << std::endl;
      std::cout << "-> heap_size: " << ((heap_top_addr - heap_base_addr) >> 3) << std::endl;
      std::cout << "-> affected offsets: " << ((startAddr - heap_base_addr) >> 3)  << "  -  " << (((startAddr + numBytes) - heap_base_addr) >> 3) << std::endl;
//      std::fill(stack_reads->begin() + ((startAddr - heap_base_addr) >> 3), stack_reads->begin() + (((startAddr + numBytes) - heap_base_addr) >> 3), 0);
//    std::fill(stack_writes->begin() + ((startAddr - heap_base_addr) >> 3), stack_reads->begin() + (((startAddr + numBytes) - heap_base_addr) >> 3), 0);
      std::cout << "-> reset affected locations" << std::endl;
    }
  }
  else{
    heap_base_addr = startAddr;
    heap_top_addr = startAddr + numBytes;
  }
*/
  if(! heap_base_addr){
    heap_base_addr = startAddr;
    //std::cout << "Set heap base addr: " << std::hex << heap_base_addr << std::endl;
  }



#if DP_MEMORY_REGION_DEALIASING
  // calculate endAddr of memory region
  endAddr = startAddr + numBytes;

  // -1 indicates 'on heap'
  std::string allocID = memory_manager->allocate_memory(lid, startAddr, endAddr, numBytes, -1);

  if (DP_DEBUG) {
    cout << "new/malloc: " << dputil::decodeLID(lid) << ", " << allocID << ", " << std::hex << startAddr << " - "
         << std::hex << endAddr;
    printf(" NumBytes: %lld\n", numBytes);
  }
#endif
}
}

} // namespace __dp
