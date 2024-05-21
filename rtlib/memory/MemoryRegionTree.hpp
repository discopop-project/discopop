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

#include "../DPUtils.hpp"

#define MRTVerbose false

#define get_char_at_level(addr, level)                                         \
  ((((addr) << ((level) * 4)) >> 60) & 0x000000000000000F)

inline ADDR get_level_shifting_mask(int level) {
  switch (level) {
  case 0:
    return 0xF000000000000000;
  case 1:
    return 0x0F00000000000000;
  case 2:
    return 0x00F0000000000000;
  case 3:
    return 0x000F000000000000;
  case 4:
    return 0x0000F00000000000;
  case 5:
    return 0x00000F0000000000;
  case 6:
    return 0x000000F000000000;
  case 7:
    return 0x0000000F00000000;
  case 8:
    return 0x00000000F0000000;
  case 9:
    return 0x000000000F000000;
  case 10:
    return 0x0000000000F00000;
  case 11:
    return 0x00000000000F0000;
  case 12:
    return 0x000000000000F000;
  case 13:
    return 0x0000000000000F00;
  case 14:
    return 0x00000000000000F0;
  case 15:
    return 0x000000000000000F;
  default:
    return 0xFFFFFFFFFFFFFFFF;
  }
}

inline int get_shift(int level) {
  switch (level) {
  case 0:
    return 60;
  case 1:
    return 56;
  case 2:
    return 52;
  case 3:
    return 48;
  case 4:
    return 44;
  case 5:
    return 40;
  case 6:
    return 36;
  case 7:
    return 32;
  case 8:
    return 28;
  case 9:
    return 24;
  case 10:
    return 20;
  case 11:
    return 16;
  case 12:
    return 12;
  case 13:
    return 8;
  case 14:
    return 4;
  case 15:
    return 0;
  default:
    return -1;
  }
}

struct MRTNode {
  // Constructors
  MRTNode() = delete;
  MRTNode(const MRTNode &) = delete;

  MRTNode(ADDR addr_i, short level) : addr(addr_i), level(level), children{} {
#if MRTVerbose
      std::cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level
           << " childArrPtr: " << children << "\n";
#endif
  }

  MRTNode(MRTNode *parent_node, ADDR addr_i, short level)
      : parent(parent_node), addr(addr_i), level(level), children{} {
#if MRTVerbose
      std::cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level
           << " with parent addr: " << parent_node->addr
           << " childArrPtr: " << children << "\n";
#endif
  }

  MRTNode(MRTNode *parent_node, ADDR addr_i, uint memRegId, short level)
      : parent(parent_node), addr(addr_i), memoryRegionId(memRegId),
        level(level), children{} {
#if MRTVerbose
      std::cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level
           << " childArrPtr: " << children << "\n";
#endif
  }

  // Values
  ADDR addr = 0;
  short level = -1;
  MRTNode *parent = nullptr;
  unsigned int memoryRegionId = 0U;
  MRTNode *children[16] = {}; // 16 to split 64 bit addresses into 16 levels using
                         // Hex representation
};

struct MemoryRegionTree {
  MemoryRegionTree() {
#if MRTVerbose
    cout << "DBG: MRT: creating new Tree.\n";
#endif
  root = new MRTNode(0xFFFFFFFFFFFFFFFF, -1);
#if MRTVerbose
    cout << "DBG: RootNode: " << root << "\n";
    cout << "DBG: MRT: Done.\n";
#endif
  }

  ~MemoryRegionTree() = default;

  MRTNode* get_root() noexcept {
    return root;
  }

  const MRTNode* get_root() const noexcept {
    return root;
  }

  // Functions
  void allocate_region(ADDR startAddr, ADDR endAddr, int64_t memory_region_id); // TODO-WIP

  string get_memory_region_id(string fallback, ADDR addr);           // TODO

  void free_region(ADDR startADDR);                                  // TODO

  void wait_for_empty_chunks(int32_t *tempAddrCount, int32_t NUM_WORKERS);

private:
  // Root has ADDR 0xFF...FF and level -1 such that level 0corresponds to first character of hex code
  MRTNode *root;
};

class MRTNode2 {
public:
  MRTNode2(const ADDR first_addr, const ADDR last_addr, const short level) : first_addr(first_addr), last_addr(last_addr), level(level) {}

  ADDR get_first_addr() const noexcept {
    return first_addr;
  }

  ADDR get_last_addr() const noexcept {
    return last_addr;
  }

  void set_memory_region_id(const unsigned int memory_region_id) noexcept {
    this->memory_region_id = memory_region_id;
  }

  unsigned int get_memory_region_id() const noexcept {
    return memory_region_id;
  }

  short get_level() const noexcept {
    return level;
  }
 
  const std::array<MRTNode2*, 16>& get_children() const noexcept {
    return children;
  }

  MRTNode2* get_child(const unsigned int index) const noexcept {
    return children[index];
  }

  int get_child_index(const ADDR addr) const noexcept {
    if (addr < first_addr || addr > last_addr) {
      return -1;
    }

    const auto shift = get_shift(level);
    const auto mask = get_level_shifting_mask(level);
    const auto index = (addr & mask) >> shift; 

    return index;
  }

  void add_child(const unsigned int index) {
    assert(children[index] == nullptr && "Child already exists");

    const auto shift = get_shift(level);
    
    const auto child_start = first_addr | (static_cast<ADDR>(index) << shift);
    const	auto child_end = child_start | ((1ULL << shift) - 1ULL);

    children[index] = new MRTNode2(child_start, child_end, level + 1);
  }

private:
  ADDR first_addr = 0x0000000000000000;
  ADDR last_addr = 0x7FFFFFFFFFFFFFFF;

  unsigned int memory_region_id = 0U;
  unsigned short level = 65535;

  std::array<MRTNode2*, 16> children = {};
};

class MemoryRegionTree2 {
public:
  MemoryRegionTree2() {
    root = new MRTNode2(0x0000000000000000, 0x7FFFFFFFFFFFFFFF, 0);
  }

  ~MemoryRegionTree2() {
    delete root;
  }

  MRTNode2* get_root() noexcept {
    return root;
  }

  const MRTNode2* get_root() const noexcept {
    return root;
  }

  void allocate_region(const ADDR start, const ADDR end, const std::int64_t memory_region_id) {
    assert(start <= end && "Invalid memory region");
    allocate(start, end, memory_region_id, root);
  }

  std::string get_memory_region_id(const ADDR addr, const char* fallback) {
    auto* node = root;

    std::cout << "Searching " << addr << std::endl;

    while (true) {
      std::cout << "Node [" << node->get_first_addr() << ", " << node->get_last_addr() << "] with memory region id " << node->get_memory_region_id() << std::endl;

      if (node->get_memory_region_id() != 0) {
        if (addr >= node->get_first_addr() && addr <= node->get_last_addr()) {
          return std::to_string(node->get_memory_region_id());
        }

        std::cout << node->get_first_addr() << " <= " << addr << " <= " << node->get_last_addr() << " not satisfied" << std::endl;
        return fallback;
      }

      const auto index = node->get_child_index(addr);
      if (index == -1) {
        return fallback;
      }

      const auto child = node->get_child(index);
      if (child == nullptr) {
        return fallback;
      }

      node = child;
    }

    return fallback;
  }

private:
  static void allocate(const ADDR start, const ADDR end, const std::int64_t memory_region_id, MRTNode2* node) {
    std::cout << "DBG: MRT: Allocating memory region [" << start << ", " << end << "] with memory region id " << memory_region_id << "\n";
    std::cout << "DBG: MRT: Node [" << node->get_first_addr() << ", " << node->get_last_addr() << "] with memory region id " << node->get_memory_region_id() << "\n";

    assert(node != nullptr && "Node is null");
    assert(start >= node->get_first_addr() && end <= node->get_last_addr() && "Invalid memory region for node");

    if (start == node->get_first_addr() && end == node->get_last_addr()) {
      assert(node->get_memory_region_id() == 0 && "Memory region already allocated");
      node->set_memory_region_id(memory_region_id);

      std::cout << "DBG: MRT: Allocated memory region [" << start << ", " << end << "] with memory region id " << memory_region_id << "\n";
      return;
    }

    const auto child_start_index = node->get_child_index(start);
    const auto child_end_index = node->get_child_index(end);

    for (auto index = child_start_index; index <= child_end_index; ++index) {
      if (node->get_child(index) == nullptr) {
        node->add_child(index);
      }

      auto* child = node->get_child(index);

      const auto child_start = child->get_first_addr();
      const auto child_end = child->get_last_addr();

      const auto clamped_start = std::max(start, child_start);
      const auto clamped_end = std::min(end, child_end);

      allocate(clamped_start, clamped_end, memory_region_id, child);
    }
  }

  MRTNode2* root{};
};
