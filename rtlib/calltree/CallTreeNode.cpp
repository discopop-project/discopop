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

#include "CallTreeNode.hpp"
#include <memory>

namespace __dp {

CallTreeNode::CallTreeNode(){
    parent_ptr = nullptr;
    type = CallTreeNodeType::Root;
    loop_or_function_id = 0;
    iteration_id = 0;   
    call_tree_node_count += 1;
}

CallTreeNode::CallTreeNode(shared_ptr<CallTreeNode> parent_ptr, CallTreeNodeType type, unsigned int loop_or_function_id, unsigned int arg_iteration_id): parent_ptr(parent_ptr), type(type), loop_or_function_id(loop_or_function_id){
    if(type == CallTreeNodeType::Iteration){
        iteration_id = arg_iteration_id;
    }
    else{
        iteration_id = 0;
    }
    call_tree_node_count += 1;
}

CallTreeNode::~CallTreeNode(){
    call_tree_node_count -= 1;
}

bool CallTreeNode::operator==(const CallTreeNode& other) const{
    // && (iteration_id == other.iteration_id)  ignore loop id
    if((type == other.type) && (loop_or_function_id == other.loop_or_function_id) ){
        if(parent_ptr && other.parent_ptr){
            if(parent_ptr.get() == other.parent_ptr.get()){
                return true;
            }
            return false;
        }
        return false;
    }
    else{
        return false;
    }
}

shared_ptr<CallTreeNode> CallTreeNode::get_parent_ptr(){
    return parent_ptr;
}

CallTreeNodeType CallTreeNode::get_node_type(){
    return type;
}

unsigned int CallTreeNode::get_loop_or_function_id(){
    return loop_or_function_id;
}

unsigned int CallTreeNode::get_iteration_id(){
    return iteration_id;
}

} // namespace __dp


