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
#include <mutex>

std::uint32_t next_free_path_id = 0;
std::mutex next_free_path_id_mtx;

[[nodiscard]] std::uint32_t get_next_free_path_id(){
    std::uint32_t buffer;
    {
        std::lock_guard<std::mutex> lg(next_free_path_id_mtx);
        buffer = next_free_path_id;
        ++next_free_path_id;
    }
    return buffer;
}


class StaticCallPathTreeNode {
    public:
        StaticCalltreeNode* base_node;
        const std::uint32_t path_id;
        std::mutex mtx;

        std::vector<StaticCallPathTreeNode*> successors;  // use vectors due to the assumption, that a single path generally has only a small number of successors. Save time and space for creating and managing a hashset or similar.
        StaticCallPathTreeNode* prefix;

        StaticCallPathTreeNode(std::uint32_t path_id, StaticCalltreeNode* base_node):path_id(path_id), base_node(base_node), prefix(nullptr){};

        StaticCallPathTreeNode(std::uint32_t path_id, StaticCalltreeNode* base_node, StaticCallPathTreeNode* prefix):path_id(path_id), base_node(base_node), prefix(prefix){};

        ~StaticCallPathTreeNode();

        StaticCallPathTreeNode* get_or_register_successor(StaticCalltreeNode* successor_node);

        std::string to_dot_string();
};


class StaticCallPathTree {
    private:

    public:
        StaticCallPathTreeNode* root = nullptr;

        StaticCallPathTree();
        ~StaticCallPathTree();
        std::string to_dot_string();
};
