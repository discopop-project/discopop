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


#include "StaticCalltree.hpp"

void StaticCalltreeNode::print(){
    std::cout << "Node: ID: " << node_id << " Type: " << type << " Name: " << functionName << " instructionID: " << instructionID << "\n";
}

std::string StaticCalltreeNode::get_label(){
    if(type == 0){
        // function
        return functionName;
    }
    else{
        // call instruction
        return "call_" + std::to_string(instructionID);
    }
}

void StaticCalltreeNode::register_successor(StaticCalltreeNode* succ){
    // check if succ is already registered
    if(std::find(successors.begin(), successors.end(), succ) != successors.end()){
        // already registered
        return;
    }
    else{
        // register successor
        successors.push_back(succ);
        succ->predecessors.push_back(this);
    }
}

StaticCalltree::StaticCalltree(){
    std::cout << "constructing StaticCalltree.\n";

}

StaticCalltree::~StaticCalltree(){
    // delete CalltreeNodes
    for(auto pair: function_map){
        delete pair.second;
    }
    for(auto pair: instruction_map){
        delete pair.second;
    }
}

StaticCalltreeNode* StaticCalltree::get_or_insert_function_node(std::string function_name){
    if(function_map.count(function_name) == 0){
//        std::cout << "first encountered function name: " << function_name << "\n";
        StaticCalltreeNode* node_ptr = new StaticCalltreeNode(node_count++, 0, function_name, 0);
        function_map[function_name] = node_ptr;
        return node_ptr;
    }
    else{
//        std::cout << "Retrieve function name: " << function_name << "\n";
        return function_map[function_name];
    }
}

StaticCalltreeNode* StaticCalltree::get_or_insert_function_node(std::string function_name, std::vector<int32_t> loop_iteration_instance){
    for(auto iteration_count: loop_iteration_instance){
        function_name = function_name + "_it" + std::to_string(iteration_count);
    }

    if(function_map.count(function_name) == 0){
//        std::cout << "first encountered function name: " << function_name << "\n";
        StaticCalltreeNode* node_ptr = new StaticCalltreeNode(node_count++, 0, function_name, 0);
        function_map[function_name] = node_ptr;
        return node_ptr;
    }
    else{
//        std::cout << "Retrieve function name: " << function_name << "\n";
        return function_map[function_name];
    }
}

StaticCalltreeNode* StaticCalltree::get_or_insert_instruction_node(int32_t instructionID){
    if(instruction_map.count(instructionID) == 0){
//        std::cout << "first encountered instruction id: " << instructionID << "\n";
        StaticCalltreeNode* node_ptr = new StaticCalltreeNode(node_count++, 1, "", instructionID);
        instruction_map[instructionID] = node_ptr;
        return node_ptr;
    }
    else{
//        std::cout << "Retrieve instruction id: " << instructionID << "\n";
        return instruction_map[instructionID];
    }
}

void StaticCalltree::addEdge(StaticCalltreeNode* source, StaticCalltreeNode* target){
    source->register_successor(target);
}

void StaticCalltree::print(){
    std::cout << "Calltree: \n";

    std::cout << "Calltree end.\n";
}

void StaticCalltree::printToDOT(){
    std::cout << "Calltree: \n";
    std::cout << "########## START DOT ###### \n";
    std::cout << "diGraph G {\n";
    // add function nodes and successors
    for(auto pair: function_map){
        auto node_ptr = pair.second;
        for(auto succ: node_ptr->successors){
            std::cout << "  " << node_ptr->get_label() << " -> " << succ->get_label() << ";\n";
        }
    }
    // add call instruction nodes and successors
    for(auto pair: instruction_map){
        auto node_ptr = pair.second;
        for(auto succ: node_ptr->successors){
            std::cout << "  " << node_ptr->get_label() << " -> " << succ->get_label() << ";\n";
        }
    }
    std::cout << "}\n";
    std::cout << "########## END DOT ###### \n";
    std::cout << "Calltree end.\n";
}
