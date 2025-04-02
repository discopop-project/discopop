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

#include "functions/FunctionManager.hpp"
#include "loop/LoopManager.hpp"
#include "memory/MemoryManager.hpp"

#if DP_CALLTREE_PROFILING
#include "calltree/CallTreeNode.hpp"
#endif

#include <cstdint>
#include <set>
#include <string>
#include <unordered_map>
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
  AccessInfo(bool isRead, LID lid, char *var, std::string AAvar, ADDR addr, bool skip = false)
      : isRead(isRead), lid(lid), var(var), AAvar(AAvar), addr(addr), skip(skip) {
#if DP_CALLTREE_PROFILING
    call_tree_node_ptr = nullptr;
    calculate_dependency_metadata = true;
#endif
  }

  AccessInfo() : isRead(false), lid(0), var(""), AAvar(""), addr(0), skip(false) {
#if DP_CALLTREE_PROFILING
    call_tree_node_ptr = nullptr;
    calculate_dependency_metadata = true;
#endif
  }

  bool isRead;
  // hybrid analysis
  bool skip;
  // End HA
  LID lid;
  const char *var;
  std::string AAvar; // name of allocated variable -> "Anti Aliased Variable"
  ADDR addr;
#if DP_CALLTREE_PROFILING
  shared_ptr<CallTreeNode> call_tree_node_ptr;
  bool calculate_dependency_metadata;
#endif
};

// For runtime dependency merging
struct Dep {
  Dep(depType T, LID dep, const char *var, std::string AAvar) : type(T), depOn(dep), var(var), AAvar(AAvar) {}

  depType type;
  LID depOn;
  const char *var;
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
    else if (a.type == b.type && a.depOn == b.depOn && ((size_t)a.var < (size_t)b.var)) {
      return true;
    }

    return false;
  }
};

struct eqDep {
  bool operator()(const Dep &a, const Dep &b) const {
    if (a.type != b.type) {
      return false;
    }
    if (a.depOn != b.depOn) {
      return false;
    }
    // comparison between string is very time-consuming. So just compare
    // variable names according to address (we only need to distinguish them)
    if (a.var != b.var) {
      return false;
    }
    return true;
  }
};

class DepHasher {
  public:
      size_t operator() (Dep const& key) const {     // the parameter type should be the same as the type of key of unordered_map
          size_t hash = 0;
          hash += std::hash<int64_t>{}(key.depOn);
          hash += std::hash<int>{}((int)key.type);
          return hash;
      }
  };

typedef std::unordered_set<Dep, DepHasher, eqDep> depSet;
typedef std::unordered_map<LID, depSet *> depMap;

// Hybrid anaysis
typedef std::unordered_map<std::string, std::unordered_set<std::string>> stringDepMap;
typedef std::unordered_set<std::uint32_t> ReportedBBSet;
// End HA

} // namespace __dp
