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

#include "AbstractShadow.hpp"
#include "Signature.hpp"

#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <unordered_set>
#include <vector>


namespace dp {

class ShadowMemory : public AbstractShadow {
public:
  ShadowMemory(int slot_size, int size, int num_hash) {
    sig_read_ = new Signature(slot_size, size, num_hash);
    sig_write_ = new Signature(slot_size, size, num_hash);
  }

  ~ShadowMemory() override {
    delete sig_read_;
    delete sig_write_;
  }

  inline SigElement TestInRead(std::int64_t mem_addr) override { return sig_read_->MembershipCheck(mem_addr); }

  inline SigElement TestInWrite(std::int64_t mem_addr) override { return sig_write_->MembershipCheck(mem_addr); }

  inline SigElement InsertToRead(std::int64_t mem_addr, SigElement value) override {
    return sig_read_->Insert(mem_addr, value);
  }

  inline SigElement InsertToWrite(std::int64_t mem_addr, SigElement value) override {
    return sig_write_->Insert(mem_addr, value);
  }

  inline void UpdateInRead(std::int64_t mem_addr, SigElement new_value) override { sig_read_->Update(mem_addr, new_value); }

  inline void UpdateInWrite(std::int64_t mem_addr, SigElement new_value) override { sig_write_->Update(mem_addr, new_value); }

  inline void RemoveFromRead(std::int64_t mem_addr) override { sig_read_->Remove(mem_addr); }

  inline void RemoveFromWrite(std::int64_t mem_addr) override { sig_write_->Remove(mem_addr); }

  inline std::unordered_set<ADDR> GetAddrsInRange(std::int64_t /*startAddr*/, std::int64_t /*endAddr*/) override {
    // not possible for Shadow, since not all addresses are kept
    std::unordered_set<ADDR> result;
    return result;
  }

  // a signature does not keep the addresses it was given, so it cannot list them back
  inline std::vector<std::pair<std::int64_t, SigElement>> GetReadKvPairs() override {
    throw std::logic_error("NOT IMPLEMENTED!");
  }

  inline std::vector<std::pair<std::int64_t, SigElement>> GetWriteKvPairs() override {
    throw std::logic_error("NOT IMPLEMENTED!");
  }

  inline void Print() override {}

private:
  Signature *sig_read_;
  Signature *sig_write_;
};

} // namespace dp
