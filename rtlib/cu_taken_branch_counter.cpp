/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include "cu_taken_branch_counter.hpp"


static std::unordered_map<char*, long> cuec;

extern "C"
{

void __dp_incr_taken_branch_counter(char* source_and_target, int cmp_res, int active_on) {
    if(cmp_res == active_on){
        if(cuec.count(source_and_target) == 0){
            cuec[source_and_target] = 1;
        }
        else{
            cuec[source_and_target] = cuec[source_and_target] + 1;
        }
    }
}

void __dp_taken_branch_counter_output() {
    std::cout << "Outputting instrumentation results (taken branches)... ";

    std::ifstream ifile;
    std::string line;
    std::ofstream ofile;

    // output information about the loops
    std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
    tmp += "/cu_taken_branch_counter_output.txt";
    ofile.open(tmp.data());

    for(auto pair : cuec){
        ofile << pair.first << ";" << pair.second << "\n";
    }

    ofile.close();

    std::cout << "done" << std::endl;



}
}
