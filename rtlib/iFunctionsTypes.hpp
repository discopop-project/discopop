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

#include "DPTypes.hpp"

#include "memory/MemoryManager.hpp"

#include <cstdint>
#include <unordered_map>
#include <set>
#include <string>
#include <vector>

namespace __dp {
    /******* Data structures *******/

typedef enum {
  RAW,
  WAR,
  WAW,
  INIT,
  RAW_II_0,
  RAW_II_1,
  RAW_II_2,
  WAR_II_0,
  WAR_II_1,
  WAR_II_2,
  WAW_II_0,
  WAW_II_1,
  WAW_II_2,
  // .._II_x to represent inter-iteration dependencies by loop level in case of
  // nested loops
} depType;

typedef enum {
  NOM,
  II_0,
  II_1,
  II_2 // NOM -> Normal
} depTypeModifier;

struct AccessInfo {
  AccessInfo(bool isRead, LID lid, char *var, std::string AAvar, ADDR addr,
             bool skip = false)
      : isRead(isRead), lid(lid), var(var), AAvar(AAvar), addr(addr),
        skip(skip) {}

  AccessInfo() : lid(0) {}

  bool isRead;
  // hybrid analysis
  bool skip;
  // End HA
  LID lid;
  char *var;
  std::string AAvar; // name of allocated variable -> "Anti Aliased Variable"
  ADDR addr;
  bool isStackAccess = false;
  bool addrIsFirstWrittenInScope = false;
  bool positiveScopeChangeOccuredSinceLastAccess = false;
};

// For runtime dependency merging
struct Dep {
  Dep(depType T, LID dep, char *var, std::string AAvar)
      : type(T), depOn(dep), var(var), AAvar(AAvar) {}

  depType type;
  LID depOn;
  char *var;
  std::string AAvar;
};

struct compDep {
  bool operator()(const Dep &a, const Dep &b) const {
    if (a.type < b.type) {
      return true;
    } else if (a.type == b.type && a.depOn < b.depOn) {
      return true;
    }
    // comparison between string is very time-consuming. So just compare
    // variable names according to address (we only need to distinguish them)
    else if (a.type == b.type && a.depOn == b.depOn &&
             ((size_t)a.var < (size_t)b.var)) {
      return true;
    }

    return false;
  }
};

typedef std::set<Dep, compDep> depSet;
typedef std::unordered_map<LID, depSet *> depMap;
// Hybrid anaysis
typedef std::unordered_map<std::string, std::set<std::string>> stringDepMap;
// End HA

// For loop tracking
struct LoopTableEntry {
  LoopTableEntry(std::int32_t l, std::int32_t id, std::int32_t c, LID b)
      : funcLevel(l), loopID(id), count(c), begin(b) {}

  std::int32_t funcLevel;
  std::int32_t loopID;
  std::int32_t count;
  LID begin;
};

// typedef std::stack <LoopTableEntry> LoopTable;
struct LoopTable {
  LoopTable(){};

  std::vector<LoopTableEntry> contents;

  inline LoopTableEntry &top() { return contents.back(); }

  inline LoopTableEntry &first() { return contents[0]; }

  inline LoopTableEntry &topMinusN(std::size_t n) {
    return contents[contents.size() - 1 - n];
  }

  inline void pop() { contents.pop_back(); }

  inline bool empty() { return contents.empty(); }

  inline void push(LoopTableEntry newElement) {
    contents.push_back(newElement);
  }

  inline std::size_t size() { return contents.size(); }
};

// For loop merging
// Assumption: no more than one loops can begin at the same line
struct LoopRecord {
  LoopRecord(LID e, std::int32_t t, std::int32_t n) : end(e), total(t), nEntered(n) {}

  LID end;
  std::int32_t total;
  std::int32_t maxIterationCount =
      0; // maximum iterations executed during a single loop entry
  std::int32_t nEntered;
};

typedef std::unordered_map<LID, LoopRecord *> LoopRecords;

// For function merging
// 1) when two BGN func are identical

typedef std::unordered_map<LID, std::set<LID> *> BGNFuncList;

// Hybrid analysis
typedef std::set<std::uint32_t> ReportedBBSet;
typedef std::set<std::string> ReportedBBPairSet;
// End HA
// 2) when two END func are identical

typedef std::set<LID> ENDFuncList;
} // namespace __dp

#define unpackLIDMetadata_getLoopID(lid) (lid >> 56)
#define unpackLIDMetadata_getLoopIteration_0(lid) ((lid >> 48) & 0x7F)
#define unpackLIDMetadata_getLoopIteration_1(lid) ((lid >> 40) & 0x7F)
#define unpackLIDMetadata_getLoopIteration_2(lid) ((lid >> 32) & 0x7F)
#define checkLIDMetadata_getLoopIterationValidity_0(lid)                       \
  ((lid & 0x0080000000000000) >> 55)
#define checkLIDMetadata_getLoopIterationValidity_1(lid)                       \
  ((lid & 0x0000800000000000) >> 47)
#define checkLIDMetadata_getLoopIterationValidity_2(lid)                       \
  ((lid & 0x0000008000000000) >> 39)

// issue a warning if DP_PTHREAD_COMPATIBILITY_MODE is enabled
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
#warning                                                                       \
    "DP_PTHREAD_COMPATIBILITY_MODE enabled! This may have negative implications on the profiling time."
#endif
