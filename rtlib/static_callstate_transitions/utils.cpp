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

#include "utils.hpp"
#include "../runtimeFunctionsGlobals.hpp"

namespace __dp{
void update_callstate(int32_t instructionID){
        // update current callstate
        cout << "Updating callstate: " << "\n";
        cout << "  -> current: " << current_callpath_state << "\n";
        cout << "  -> inst:    " << instructionID << "\n";
        cout << "  -> current: " << current_callpath_state << "\n";
}

void initialize_current_callpath_state(){
    // open input file
    std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
    tmp += "/initial_stateID.txt";
    // create graph by parsing the file line by line
    std::ifstream file(tmp);
    std::string line;
    while (std::getline(file, line))
    {
        cout << "INITIAL_STATE: " << line << "\n";
        current_callpath_state = stoi(line);
    }
}

}  // namespace __dp
