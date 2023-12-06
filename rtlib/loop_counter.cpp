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

#include "loop_counter.hpp"

#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

static LoopCounter lc;
static bool alreadyDone;

extern "C"
{

// 0 = load instruction, 1 = store instruction
void add_instr_rec(int loopLineNumber, long long var_id, int instruction_type) {
    if (alreadyDone)
        return;
    lc.incr_counter((int) var_id, instruction_type);
}

// 0 = load instruction, 1 = store instruction
void add_ptr_instr_rec(int loopLineNumber, long long var_id,
                       int instruction_type, long long addr) {
    if (alreadyDone)
        return;
    lc.incr_counter((int) var_id, instruction_type);
    lc.update_ptr((int) var_id, instruction_type, addr);
}

void incr_loop_counter(int loop_id) {
    if (alreadyDone)
        return;
    lc.incr_loop_counter(loop_id);
}

void loop_counter_output() {
    if (alreadyDone)
        return;

    std::cout << "Outputting instrumentation results... ";

    std::ifstream ifile;
    std::string line;
    std::ofstream ofile;

    // get meta information about the loops
    std::vector <loop_info_t> loop_infos;
    loop_infos.push_back(loop_info_t()); // dummy
    std::string tmp(getenv("DOT_DISCOPOP_PROFILER"));
    tmp += "/loop_meta.txt";
    ifile.open(tmp.data());
    while (std::getline(ifile, line)) {
        loop_info_t loop_info;
        int cnt = sscanf(line.c_str(), "%d %d %d", &loop_info.file_id_,
                         &loop_info.loop_id_, &loop_info.line_nr_);
        if (cnt == 3) {
            loop_infos.push_back(loop_info);
        }
    }
    ifile.close();

    // output information about the loops
    std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
    tmp2 += "/loop_counter_output.txt";
    ofile.open(tmp2.data());
    for (auto i = 1; i < lc.loop_counters_.size(); ++i) {
        loop_info_t &loop_info = loop_infos[i];
        ofile << loop_info.file_id_ << " ";
        ofile << loop_info.line_nr_ << " ";
        ofile << lc.loop_counters_[i] << "\n";
    }
    ofile.close();

    std::cout << "done" << std::endl;

    alreadyDone = true;
}
}

void LoopCounter::incr_counter(int var_id, int instr_type) {
    if (var_counters_.size() < var_id + 1) {
        var_counters_.resize(var_id + 1);
    }
    var_counters_[var_id].counters_[instr_type] += 1;
}

void LoopCounter::incr_loop_counter(int loop_id) {
    if (loop_counters_.size() < loop_id + 1) {
        loop_counters_.resize(loop_id + 1);
    }
    loop_counters_[loop_id] += 1;
}

void LoopCounter::update_ptr(int var_id, int instr_type, long long addr) {
#ifdef ONLY_CONST_INDICES
    if (var_counters_[var_id].valid_)
    {
      if (var_counters_[var_id].mem_addr_ == 0)
      {
        var_counters_[var_id].mem_addr_ = addr;
      }
      else if (var_counters_[var_id].mem_addr_ != addr)
      {
        var_counters_[var_id].valid_ = false;
      }
    }
#else
    if (instr_type == 1) {
        if (var_counters_[var_id].mem_addr_ != addr) {
            var_counters_[var_id].valid_ = false;
        }
    } else {
        var_counters_[var_id].mem_addr_ = addr;
    }
#endif
}
