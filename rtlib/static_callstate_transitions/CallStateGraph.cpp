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

 #include "CallStateGraph.hpp"

CallStateGraph::~CallStateGraph(){
    // delete nodes
    for(auto pair: node_map){
        delete pair.second;
    }
}

CallState* CallStateGraph::get_or_register_node(int32_t call_state_id){
    if(node_map.find(call_state_id) == node_map.end()){
        CallState* node = new CallState();
        node_map[node_id] = node;
        return node;
    }
    return node_map[node_id];
}

void CallStateGraph::register_transition(int32_t source_call_state_id, int32_t trigger_instruction, int32_t target_call_state_id){
    CallState* source = get_or_register_node(source_call_state_id);
    CallState* target = get_or_register_node(target_call_state_id);
    source->register_transition(trigger_instruction, target);
    cout << "registered transition: " << source->get_id() << " (" << trigger_instruction << ") -> " << target->get_id() << "\n";
}
