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

#include "StaticCallPathTree.hpp"

StaticCallPathTreeNode* StaticCallPathTreeNode::get_or_register_successor(StaticCalltreeNode* successor_node){
    std::lock_guard<std::mutex> lg(mtx);
    // search for successor
    for(auto succ: successors){
        if(succ->base_node == successor_node){
            return succ;
        }
    }
    // register successor
    StaticCallPathTreeNode* new_node = new StaticCallPathTreeNode(get_next_free_path_id(), successor_node, this);
    return new_node;
}

StaticCallPathTreeNode::~StaticCallPathTreeNode(){
    for(auto succ: successors){
        delete succ;
    }
}

std::string StaticCallPathTreeNode::to_dot_string(){
    std::string result = "";
    result += std::to_string(path_id) + ";\n";
    for(auto succ: successors){
        result += std::to_string(path_id) + " -> " + std::to_string(succ->path_id) + ";\n";
        result += succ->to_dot_string();
    }
    return result;
}

StaticCallPathTree::StaticCallPathTree(){
    root = new StaticCallPathTreeNode(get_next_free_path_id(), nullptr);
}

StaticCallPathTree::~StaticCallPathTree(){
    delete root;
}

std::string StaticCallPathTree::to_dot_string(){
    std::string result = "";
    result += "diGraph G {\n";
    result += root->to_dot_string();
    result += "}\n";
    return result;
}
