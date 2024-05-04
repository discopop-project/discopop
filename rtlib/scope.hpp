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

#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace __dp {

// Data structure to store information on a single source code scope
struct Scope {
  Scope(unsigned long id) : scope_id(id) {}

  void registerStackRead(ADDR address, LID debug_lid, char *debug_var) {
    if (!(first_written.find(address) != first_written.end())) {
      first_read.insert(address);
    }
  }

  void registerStackWrite(ADDR address, LID debug_lid, char *debug_var) {
    if (!(first_read.find(address) != first_read.end())) {
      first_written.insert(address);
    }
  }

  unsigned long get_id() const noexcept {
    return scope_id;
  }

  const std::unordered_set<ADDR>& get_first_read() const noexcept {
    return first_read;
  }

  const std::unordered_set<ADDR>& get_first_write() const noexcept {
    return first_written;
  }

private:
  unsigned long scope_id;
  std::unordered_set<ADDR> first_read;
  std::unordered_set<ADDR> first_written;
};

// Data structure for stack access management in scopes
struct ScopeManager {
  Scope getCurrentScope() { 
    return scopeStack.back(); 
  }

  void enterScope(std::string type, LID debug_lid) {
    scopeStack.push_back(Scope(next_scope_id++));
  }

  void leaveScope(std::string type, LID debug_lid) { 
    scopeStack.pop_back(); 
  }

  void registerStackRead(ADDR address, LID debug_lid, char *debug_var) {
    scopeStack.back().registerStackRead(address, debug_lid, debug_var);
    addrToLastAccessScopeID[address] = scopeStack.back().get_id();
  }

  void registerStackWrite(ADDR address, LID debug_lid, char *debug_var) {
    scopeStack.back().registerStackWrite(address, debug_lid, debug_var);
    addrToLastAccessScopeID[address] = scopeStack.back().get_id();
  }

  bool isFirstWrittenInScope(ADDR addr, bool currentAccessIsWrite) {
    // currentAccessIsWrite is used in case no access to addr has been
    // registered yet
    if (scopeStack.back().get_first_write().count(addr) > 0) {
      return true;
    }

    if (scopeStack.back().get_first_read().count(addr) > 0) {
      return false;
    }

    // no access to addr registered in the current scope
    if (currentAccessIsWrite) {
      return true;
    }

    return false;
  }

  bool positiveScopeChangeOccuredSinceLastAccess(ADDR addr) {
    // positive Scope change --> current scope id higher than the id during the
    // last access
    if (!addrToLastAccessScopeID[addr]) {
      // cout << "positiveStackChange\n";
      return true;
    }

    //            cout << "LAST: " << to_string(addrToLastAccessScopeID[addr])
    //            << "  current: " << to_string(scopeStack.back().scope_id) <<
    //            "\n";
    if (addrToLastAccessScopeID[addr] < scopeStack.back().get_id()) {
      // cout << "positiveStackChange\n";
      return true;
    }

    return false;
  }

private:
  std::vector<Scope> scopeStack;
  unsigned long next_scope_id = 1; // 0 marks invalid in addrToLastAccessScopeID

  std::unordered_map<ADDR, unsigned long> addrToLastAccessScopeID;
};

} // namespace __dp
