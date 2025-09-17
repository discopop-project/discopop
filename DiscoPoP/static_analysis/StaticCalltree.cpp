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

void StaticCalltreeNode::register_successor(StaticCalltreeNode* succ, int32_t trigger_instructionID){
    // check if trigger is already registered
    if(successors.find(trigger_instructionID) != successors.end()){
        // already registered
    }
    else{
        // register trigger
        std::vector<StaticCalltreeNode*> tmp;
        successors[trigger_instructionID] = tmp;
    }

    // check if succ is already registered
    if(std::find(successors[trigger_instructionID].begin(), successors[trigger_instructionID].end(), succ) != successors[trigger_instructionID].end()){
        // already registered
        return;
    }
    else{
        // register successor
        successors[trigger_instructionID].push_back(succ);
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

StaticCalltreeNode* StaticCalltree::get_or_insert_function_node(std::string function_name, std::string loop_iteration_instance){
    function_name = function_name + "_loopstate" + loop_iteration_instance;

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

// trigger_instructionID = 0 -> no trigger required
void StaticCalltree::addEdge(StaticCalltreeNode* source, StaticCalltreeNode* target, int32_t trigger_instructionID){
    source->register_successor(target, trigger_instructionID);
}

void StaticCalltree::print(){
    std::cout << "Calltree: \n";

    std::cout << "Calltree end.\n";
}

std::string StaticCalltree::to_dot_string(){
    std::string result = "";
    result += "diGraph G {\n";
    // add function nodes and successors
    for(auto pair: function_map){
        auto node_ptr = pair.second;
        for(auto succ_pair: node_ptr->successors){
            int32_t trigger_instructionID = succ_pair.first;
            for (auto succ :succ_pair.second){
                result += "  "  + node_ptr->get_label() + " -> " + succ->get_label();
                if(trigger_instructionID != 0){
                    result += " [label = " + std::to_string(trigger_instructionID) + "]";
                }
                result += ";\n";
            }
        }
    }
    // add call instruction nodes and successors
    for(auto pair: instruction_map){
        auto node_ptr = pair.second;
        for(auto succ_pair: node_ptr->successors){
            int32_t trigger_instructionID = succ_pair.first;
            for(auto succ: succ_pair.second){
                result += "  " + node_ptr->get_label() + " -> " + succ->get_label();
                if(trigger_instructionID != 0){
                    result += " [label = " + std::to_string(trigger_instructionID) + "]";
                }
                result += ";\n";
            }
        }
    }
    result += "}\n";
    return result;
}
