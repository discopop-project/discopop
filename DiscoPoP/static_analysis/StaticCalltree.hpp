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
#include <iostream>
#include <string>
#include <unordered_map>
#include <stdint.h>
#include <vector>
#include <algorithm>

class StaticCalltreeNode {
    private:
        uint32_t node_id;
        bool type; // 0: Function; 1: Call instruction
        std::string functionName;
        int32_t instructionID;

    public:
        std::vector<StaticCalltreeNode*> successors;
        std::vector<StaticCalltreeNode*> predecessors;
        StaticCalltreeNode(uint32_t node_id_arg, bool type_arg, std::string functionName_arg, int32_t instructionID_arg):node_id(node_id_arg),type(type_arg),functionName(functionName_arg),instructionID(instructionID_arg){};
        void print();
        std::string get_label();
        void register_successor(StaticCalltreeNode* succ);
};

class StaticCalltree {
    private:
        uint32_t node_count = 0;

    public:

        std::unordered_map<std::string, StaticCalltreeNode*> function_map;
        std::unordered_map<int32_t, StaticCalltreeNode*> instruction_map;
        StaticCalltree();
        ~StaticCalltree();
        StaticCalltreeNode* get_or_insert_function_node(std::string function_name);
        StaticCalltreeNode* get_or_insert_function_node(std::string function_nam, std::vector<int32_t> loop_iteration_instance);
        StaticCalltreeNode* get_or_insert_instruction_node(int32_t instructionID);
        void print();
        void printToDOT();
        void addEdge(StaticCalltreeNode* source, StaticCalltreeNode* target);
};
