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

#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "DPTypes.hpp"

namespace dp {

// Data structure to store information on a single source code scope
struct Scope {
  explicit Scope(uint64_t id) : scope_id_(id) {}

  void RegisterStackRead(ADDR address, LID debug_lid, const char* debug_var) {
    if (!(first_written_.find(address) != first_written_.end())) {
      first_read_.insert(address);
    }
  }

  void RegisterStackWrite(ADDR address, LID debug_lid, const char* debug_var) {
    if (!(first_read_.find(address) != first_read_.end())) {
      first_written_.insert(address);
    }
  }

  uint64_t GetId() const noexcept { return scope_id_; }

  const std::unordered_set<ADDR>& GetFirstRead() const noexcept { return first_read_; }

  const std::unordered_set<ADDR>& GetFirstWrite() const noexcept { return first_written_; }

 private:
  uint64_t scope_id_;
  std::unordered_set<ADDR> first_read_;
  std::unordered_set<ADDR> first_written_;
};

// Data structure for stack access management in scopes
struct ScopeManager {
  const Scope& GetCurrentScope() { return scope_stack_.back(); }

  std::size_t NumberOpenScopes() const noexcept { return scope_stack_.size(); }

  void EnterScope(std::string type, LID debug_lid) { scope_stack_.push_back(Scope(next_scope_id_++)); }

  // the type is not compared against the one the scope was entered with, so leaving a scope pops
  // whatever is on top -- but never off the end of an empty stack
  void LeaveScope(std::string type, LID debug_lid) {
    if (scope_stack_.empty()) {
      return;
    }

    scope_stack_.pop_back();
  }

  void RegisterStackRead(ADDR address, LID debug_lid, const char* debug_var) {
    scope_stack_.back().RegisterStackRead(address, debug_lid, debug_var);
    addr_to_last_access_scope_id_[address] = scope_stack_.back().GetId();
  }

  void RegisterStackWrite(ADDR address, LID debug_lid, const char* debug_var) {
    scope_stack_.back().RegisterStackWrite(address, debug_lid, debug_var);
    addr_to_last_access_scope_id_[address] = scope_stack_.back().GetId();
  }

  bool IsOwnedByScope(ADDR addr, bool current_access_is_write) {
    // currentAccessIsWrite is used in case no access to addr has been

    // check for first_writes in previous scopes (i.e.: search for the "owner"
    // of the stack variable)
    std::size_t idx = 0;
    for (const auto& scope : scope_stack_) {
      if (scope.GetFirstWrite().count(addr) > 0) {
        if (idx == scope_stack_.size() - 1) {
          return true;
        } else {
          // scope variable "belongs" to a parent scope.
          // Thus, it may not be considered a scope variable for the inner
          // scope.
          return false;
        }
      }
      idx++;
    }

    // registered already
    if (scope_stack_.back().GetFirstWrite().count(addr) > 0) {
      return true;
    }

    if (scope_stack_.back().GetFirstRead().count(addr) > 0) {
      return false;
    }

    // no access to addr registered in the current scope
    if (current_access_is_write) {
      return true;
    }

    return false;
  }

  bool PositiveScopeChangeOccuredSinceLastAccess(ADDR addr) {
    // positive Scope change --> current scope id higher than the id during the
    // last access
    //
    // Asking through operator[] would add an entry for every address that has never been accessed,
    // so a query would make the map grow instead of only an access. ScopeManager2 uses find() for
    // the same reason.
    const auto iterator = addr_to_last_access_scope_id_.find(addr);
    if (iterator == addr_to_last_access_scope_id_.end()) {
      return true;
    }

    if (!iterator->second) {
      return true;
    }

    return iterator->second < scope_stack_.back().GetId();
  }

 private:
  std::vector<Scope> scope_stack_;
  uint64_t next_scope_id_ = 1;  // 0 marks invalid in addrToLastAccessScopeID

  std::unordered_map<ADDR, uint64_t> addr_to_last_access_scope_id_;
};

// Hopefully faster version

struct Scope2 {
  // Can use vectors for a speed up when dealing with < 100 addresses
  explicit Scope2(const uint64_t id) : scope_id_(id) {
    first_read_.reserve(64);
    first_written_.reserve(64);
  }

  void RegisterStackRead(ADDR address, LID debug_lid, const char* debug_var) {
    const auto not_found = first_written_.find(address) == first_written_.end();
    if (not_found) {
      first_read_.insert(address);
    }
  }

  void RegisterStackWrite(ADDR address, LID debug_lid, const char* debug_var) {
    const auto not_found = first_read_.find(address) == first_read_.end();
    if (not_found) {
      first_written_.insert(address);
    }
  }

  uint64_t GetId() const noexcept { return scope_id_; }

  const HashSet<ADDR>& GetFirstRead() const noexcept { return first_read_; }

  const HashSet<ADDR>& GetFirstWrite() const noexcept { return first_written_; }

 private:
  uint64_t scope_id_;
  HashSet<ADDR> first_read_;
  HashSet<ADDR> first_written_;
};

struct ScopeManager2 {
  ScopeManager2() {
    scope_stack_.reserve(32);
    addr_to_last_access_scope_id_.reserve(1024);
  }

  const Scope2& GetCurrentScope() const noexcept { return scope_stack_.back(); }

  std::size_t NumberOpenScopes() const noexcept { return scope_stack_.size(); }

  void EnterScope(const char* type, LID debug_lid) { scope_stack_.emplace_back(next_scope_id_++); }

  void LeaveScope(const char* type, LID debug_lid) {
    if (scope_stack_.empty()) {
      return;
    }

    scope_stack_.pop_back();
  }

  void RegisterStackRead(ADDR address, LID debug_lid, const char* debug_var) {
    auto& current_scope = scope_stack_.back();

    current_scope.RegisterStackRead(address, debug_lid, debug_var);
    addr_to_last_access_scope_id_[address] = current_scope.GetId();
  }

  void RegisterStackWrite(ADDR address, LID debug_lid, const char* debug_var) {
    auto& current_scope = scope_stack_.back();

    current_scope.RegisterStackWrite(address, debug_lid, debug_var);
    addr_to_last_access_scope_id_[address] = current_scope.GetId();
  }

  bool IsOwnedByScope(ADDR addr, bool current_access_is_write) {
    // currentAccessIsWrite is used in case no access to addr has been

    // check for first_writes in previous scopes (i.e.: search for the "owner"
    // of the stack variable)
    std::size_t idx = 0;
    for (const auto& scope : scope_stack_) {
      if (scope.GetFirstWrite().count(addr) > 0) {
        if (idx == scope_stack_.size() - 1) {
          return true;
        } else {
          // scope variable "belongs" to a parent scope.
          // Thus, it may not be considered a scope variable for the inner
          // scope.
          return false;
        }
      }
      idx++;
    }

    // registered already
    if (scope_stack_.back().GetFirstWrite().count(addr) > 0) {
      return true;
    }

    if (scope_stack_.back().GetFirstRead().count(addr) > 0) {
      return false;
    }

    // no access to addr registered in the current scope
    if (current_access_is_write) {
      return true;
    }

    return false;
  }

  bool PositiveScopeChangeOccuredSinceLastAccess(const ADDR addr) noexcept {
    const auto iterator = addr_to_last_access_scope_id_.find(addr);
    if (iterator == addr_to_last_access_scope_id_.end()) {
      return true;
    }

    const auto val = iterator->second;
    return val < scope_stack_.back().GetId();
  }

 private:
  uint64_t next_scope_id_ = 1;

  std::vector<Scope2> scope_stack_;
  HashMap<ADDR, uint64_t> addr_to_last_access_scope_id_;
};

}  // namespace dp
