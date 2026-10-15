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

#include "lid_utils.hpp"
#include "timer.hpp"

#include <iostream>

using namespace std;
using namespace dputil;

namespace __dp {

void addDep(depType type, LID curr, LID depOn, const char *var, std::int64_t AAvar, ADDR /*addr*/) {

#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ADD_DEP);
#endif

  // hybrid analysis
  if (depOn == 0 && type == WAW) {
    type = INIT;
}
  // End HA

  // Remove metadata to preserve result correctness and add metadata to `Dep`
  // object

  // register dependency. operator[] creates the set when the lid is seen for the first time.
  (*myMap)[curr].insert(Dep(type, depOn, var, AAvar));


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

void analyzeSingleAccess(__dp::AbstractShadow *SMem, __dp::AccessInfo &access) {

  // analyze data dependences
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::ANALYZE_SINGLE_ACCESS);
#endif


  if (access.isRead) {
    // hybrid analysis
    if (access.skip) {
      SMem->insertToRead(access.addr, access.lid);
      return;
    }
    // End HA
    sigElement lastWrite = SMem->testInWrite(access.addr);
    // Every read, not only the ones that turn out to be RAWs: a read that found no earlier write
    // is still the read a later write has to come after, and leaving it out of the shadow made
    // that WAR depend on whether the read happened to open a chunk.
    SMem->insertToRead(access.addr, access.lid);
    if (lastWrite != 0 && lastWrite != 1) {
      // RAW
      addDep(RAW, access.lid, lastWrite, access.var, access.AAvar, access.addr);
    }

  } else {
    sigElement lastWrite = SMem->insertToWrite(access.addr, access.lid);
    if (access.skip) {
      return;
    }
    sigElement lastRead = SMem->testInRead(access.addr);
    if (lastWrite == 0 || lastWrite == 1) {
      // INIT
      addDep(INIT, access.lid, 0, access.var, access.AAvar, access.addr);
      // A read that came before this write is a WAR no matter whether a write came before it as
      // well. Asking only in the branch below used to lose those dependencies -- and the chunked
      // analysis made that the common case rather than a corner case, because every chunk starts
      // from an empty shadow, so "no earlier write" there only means "none in this chunk".
      if (lastRead != 0 && lastRead != 1) {
        addDep(WAR, access.lid, lastRead, access.var, access.AAvar, access.addr);
        // Clear intermediate read ops
        SMem->insertToRead(access.addr, 0);
      }
    } else {
      if (lastRead != 0 && lastRead != 1) {
        // WAR
        addDep(WAR, access.lid, lastRead, access.var, access.AAvar, access.addr);
        // Clear intermediate read ops
        SMem->insertToRead(access.addr, 0);
      } else {
        // WAW
        addDep(WAW, access.lid, lastWrite, access.var, access.AAvar, access.addr);
      }
    }
  }
}

void analyzeSingleAccessOnMainThread(__dp::AccessInfo &access) {
  analyzeSingleAccess(singleThreadedExecutionSMem, access);
}

} // namespace __dp
