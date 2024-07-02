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
#include "CallTreeNodeType.hpp"
#include "CallTreeGlobals.hpp"

#include <memory>

namespace __dp {

class CallTreeNode {
public:
    CallTreeNode();
    CallTreeNode(shared_ptr<CallTreeNode> parent_ptr, CallTreeNodeType type, unsigned int loop_or_function_id, unsigned int iteration_id);
    ~CallTreeNode();
    bool operator==(const CallTreeNode& other) const;
    shared_ptr<CallTreeNode> get_parent_ptr();
    CallTreeNodeType get_node_type();
    unsigned int get_loop_or_function_id();
    unsigned int get_iteration_id();  // only relevant for iteration type nodes, else always 0
private:
    CallTreeNodeType type;
    unsigned int loop_or_function_id;  // id of the loop or function that is represented by the current node
    unsigned int iteration_id;
    shared_ptr<CallTreeNode> parent_ptr;
    atomic<unsigned int>* node_count_ptr;
};

} // namespace __dp
