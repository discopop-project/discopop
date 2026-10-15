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

#include "Structs.hpp"
#include "static_analysis/StaticCallPathTree.hpp"
#include "static_analysis/StaticCalltree.hpp"

#include "llvm/IR/Module.h"

#include <boost/container_hash/hash.hpp>

#include <cstddef>
#include <cstdint>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// The static call tree of a module and the call path states enumerated from it (the call path state
// transitions the runtime follows), with the files that describe them. None of this depends on the state of
// the pass, so these are functions of their own.
namespace static_callpaths {

// builds a call tree for the given Module on the basis of the statically available information; writes
// loopstate_positions.txt, naming the loops by `loop_id_to_identity`
StaticCalltree buildStaticCalltree(llvm::Module &M, const std::map<int32_t, LoopIdentity> &loop_id_to_identity);

//std::pair<std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>>, std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>>> enumerate_paths(StaticCalltree& calltree);
StaticCallPathTree* enumerate_paths(StaticCalltree& calltree, std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> *state_transitions,
std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> *inverse_state_transitions, std::uint32_t start_path_id);
//void save_initial_path(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths);
void save_initial_path(StaticCallPathTree* call_path_tree_ptr);
//void save_enumerated_paths(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths);
void save_enumerated_paths(StaticCallPathTree* call_path_tree_ptr);
// void save_path_state_transitions(std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> *transitions);
void save_path_state_transitions(StaticCallPathTree* call_path_tree_ptr);
void save_static_calltree_to_dot(StaticCalltree* calltree);
void save_function_entries(StaticCallPathTree* call_path_tree_ptr);

// hasher used for std::vector<StaticCalltreeNode*>
template <typename Container>
struct container_hash {
  std::size_t operator()(Container const& c) const {
      return boost::hash_range(c.begin(), c.end());
  }
};
// void add_function_exit_edges_to_transitions(std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>>& state_transitions, std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>> paths, std::unordered_map<std::vector<StaticCalltreeNode*>, int32_t, container_hash<std::vector<StaticCalltreeNode*>>> path_to_id_map);
//void add_function_exit_edges_to_transitions(std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>>& state_transitions, StaticCallPathTree* call_path_tree_ptr);
void add_function_exit_edges_to_transitions(StaticCallPathTree* call_path_tree_ptr);

std::unordered_map<StaticCalltreeNode*, std::unordered_set<int32_t>> get_contained_in_map(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>>& paths);
std::unordered_map<std::vector<StaticCalltreeNode*>, int32_t, container_hash<std::vector<StaticCalltreeNode*>>> get_path_to_id_map(std::unordered_map<int32_t, std::vector<StaticCalltreeNode*>>& paths);

} // namespace static_callpaths
