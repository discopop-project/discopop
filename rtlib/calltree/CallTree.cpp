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

# include "CallTree.hpp"

namespace __dp
{
    CallTree::CallTree(){
        current = make_shared<CallTreeNode>();
    }

    CallTree::~CallTree(){
    }

    unsigned int CallTree::get_node_count(){
        return call_tree_node_count.load();
    }

    std::shared_ptr<CallTreeNode> CallTree::get_current_node_ptr(){
        return current;
    }

    void CallTree::enter_function(unsigned int function_id){
        current = make_shared<CallTreeNode>(current, CallTreeNodeType::Function, function_id, 0);
    }

    void CallTree::enter_loop(unsigned int loop_id){
        current = make_shared<CallTreeNode>(current, CallTreeNodeType::Loop, loop_id, 0);
    }

    void CallTree::enter_iteration(unsigned int iteration_id){
        // identify loop id of nearest loop
        shared_ptr<CallTreeNode> node_ptr = get_current_node_ptr();
        if(! node_ptr){
            return;
        }
        unsigned int loop_id = 0;
        while(node_ptr.get()->get_node_type() != CallTreeNodeType::Root){
            if(node_ptr.get()->get_node_type() == CallTreeNodeType::Loop){
                // found nearest loop node
                loop_id = node_ptr.get()->get_loop_or_function_id();
                break;
            }
            // continue search with parent node
            node_ptr = node_ptr.get()->get_parent_ptr();
        }
        // create iteration node
        current = make_shared<CallTreeNode>(node_ptr, CallTreeNodeType::Iteration, loop_id, iteration_id);
    }

    void CallTree::exit_function(){
        // set current to the parent of the closest function
        shared_ptr<CallTreeNode> node_ptr = get_current_node_ptr();
        if(! node_ptr){
            return;
        }    
        while(node_ptr->get_node_type() != CallTreeNodeType::Root){
            if(node_ptr->get_node_type() == CallTreeNodeType::Function){
                // found closest function node
                break;
            }
            // continue search with parent
            node_ptr = node_ptr->get_parent_ptr();
        }
        current = node_ptr->get_parent_ptr();       
    }

    void CallTree::exit_loop(){
        // set current to the parent of the closest loop
        shared_ptr<CallTreeNode> node_ptr = get_current_node_ptr();
        if(! node_ptr){
            return;
        }
        while(node_ptr->get_node_type() != CallTreeNodeType::Root){
            if(node_ptr->get_node_type() == CallTreeNodeType::Loop){
                // found closest loop node
                break;
            }
            // continue search with parent
            node_ptr = node_ptr->get_parent_ptr();
        }
        current = node_ptr->get_parent_ptr();
    }

} // namespace __dp
