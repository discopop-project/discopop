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

#include "../DPTypes.hpp"
#include "../MemoryRegionTree.hpp"
#include "../scope.hpp"

#include <limits>
#include <stack>
#include <utility>

namespace __dp {

class MemoryManager {
public:
    MemoryManager() {
        nextFreeMemoryRegionId = 1;

        allocatedMemRegTree = new MemoryRegionTree();
        
        smallestAllocatedADDR = std::numeric_limits<ADDR>::max();
        largestAllocatedADDR = std::numeric_limits<ADDR>::min();

        stackAddrs.emplace(0, 0);
        scopeManager = new ScopeManager();

        allocatedMemoryRegions = new std::vector<std::tuple<LID, std::string, std::int64_t, std::int64_t, std::int64_t, std::int64_t>>();
    }

    ~MemoryManager() {
        delete allocatedMemoryRegions;
        delete scopeManager;
        delete allocatedMemRegTree;
    }

    MemoryManager(const MemoryManager& other) = delete;
    MemoryManager(MemoryManager&& other) = delete;

    MemoryManager& operator=(const MemoryManager& other) = delete;
    MemoryManager& operator=(MemoryManager&& other) = delete;

    std::int64_t get_next_free_memory_region_id() noexcept {
        const auto old_value = nextFreeMemoryRegionId;
        nextFreeMemoryRegionId++;
        return old_value;
    }

    void update_smallest_allocated_address(const ADDR other) {
        if (other < smallestAllocatedADDR) {
            smallestAllocatedADDR = other;
        }
    }

    void update_largest_allocated_address(const ADDR other) {
        if (other > largestAllocatedADDR) {
            largestAllocatedADDR = other;
        }
    }

    void update_stack_addresses(const ADDR start, const ADDR end) {
        auto& top = stackAddrs.top();
        if (top.first == 0) {
            top.first = start;
        }

        if (top.second == 0) {
            top.second = end;
        } 
        else if (top.second > end) {
            top.second = end;
        }
    }

    std::pair<ADDR, ADDR> pop_last_stack_address() {
        const auto val = stackAddrs.top();
        stackAddrs.pop();
        return val;
    }

    bool is_stack_access(const ADDR address) noexcept {
        if (stackAddrs.empty()) {
            return false;
        }

        const auto& addrs = stackAddrs.top();
        if (addrs.first == 0 || addrs.second == 0) {
            return false;
        }

        return addrs.first <= address && address <= addrs.second;
    }

private:
    std::int64_t nextFreeMemoryRegionId; // 0 is reserved as the identifier for "no region" in the MemoryRegionTree

    ADDR smallestAllocatedADDR;
    ADDR largestAllocatedADDR;

    std::stack<std::pair<ADDR, ADDR>> stackAddrs; // track stack adresses for entered functions

public:
    MemoryRegionTree *allocatedMemRegTree;

    ScopeManager *scopeManager;

    // (LID, identifier, startAddr, endAddr, numBytes, numElements)
    std::vector<std::tuple<LID, std::string, std::int64_t, std::int64_t, std::int64_t, std::int64_t>> *allocatedMemoryRegions;
    std::vector<std::tuple<LID, std::string, std::int64_t, std::int64_t, std::int64_t, std::int64_t>>::iterator lastHitIterator;
};

} // namespace __dp
