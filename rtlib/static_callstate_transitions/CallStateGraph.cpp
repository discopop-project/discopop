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
 #include <string>
 #include <fstream>

CallStateGraph::CallStateGraph(){
    // open input file
    std::string tmp_2(getenv("DOT_DISCOPOP_PROFILER"));
    tmp_2 += "/callpath_state_transitions.txt";
    // create graph by parsing the file line by line
    std::ifstream file(tmp_2);
    std::string line;
    while (std::getline(file, line))
    {
        // process line
        if(line[0] == '#'){
            // ignore comment lines
            continue;
        }
        // get source id
        std::size_t pos = line.find(' ');
        std::string source_callstate_id_str = line.substr (0, pos);
        line = line.substr(pos + 1 );
        // get trigger instruction
        pos = line.find(' ');
        std::string trigger_instruction_id_str = line.substr (0, pos);
        line = line.substr(pos + 1 );
        // get target id
        std::string target_callstate_id_str = line;
        // register transition in CallStateGraph
        register_transition(std::stoi(source_callstate_id_str), std::stoi(trigger_instruction_id_str), std::stoi(target_callstate_id_str));
    }

}

 CallStateGraph::~CallStateGraph(){
    // delete nodes
    for(auto pair: node_map){
        delete pair.second;
    }
    std::cout << "DELETED CALLSTATE GRAPH\n";
}

CallState* CallStateGraph::get_or_register_node(std::int32_t call_state_id){
    if(node_map.find(call_state_id) == node_map.end()){
        CallState* node = new CallState(call_state_id);
        node_map[call_state_id] = node;
        return node;
    }
    return node_map[call_state_id];
}

void CallStateGraph::register_transition(std::int32_t source_call_state_id, std::int32_t trigger_instruction, std::int32_t target_call_state_id){
    CallState* source = get_or_register_node(source_call_state_id);
    CallState* target = get_or_register_node(target_call_state_id);
    source->register_transition(trigger_instruction, target);
    std::cout << "registered transition: " << source->get_id() << " (" << trigger_instruction << ") -> " << target->get_id() << "\n";
}
