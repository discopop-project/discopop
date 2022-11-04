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

#include "loop_counter.h"

#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

static LoopCounter lc;
static bool alreadyDone;

extern "C"
{

  // 0 = load instruction, 1 = store instruction
  void add_instr_rec(int loopLineNumber, long long var_id, int instruction_type)
  {
    if (alreadyDone)
      return;
    lc.incr_counter((int)var_id, instruction_type);
  }

  // 0 = load instruction, 1 = store instruction
  void add_ptr_instr_rec(int loopLineNumber, long long var_id,
                         int instruction_type, long long addr)
  {
    if (alreadyDone)
      return;
    lc.incr_counter((int)var_id, instruction_type);
    lc.update_ptr((int)var_id, instruction_type, addr);
  }

  void incr_loop_counter(int loop_id)
  {
    if (alreadyDone)
      return;
    lc.incr_loop_counter(loop_id);
  }

  void loop_counter_output()
  {
    if (alreadyDone)
      return;

    std::cout << "Outputting instrumentation results... ";

    // get meta information about the variables
    std::vector<var_info_t> var_infos;
    var_infos.push_back(var_info_t()); // dummy
    std::ifstream ifile;
    ifile.open("reduction_meta.txt");
    std::string line;
    while (std::getline(ifile, line))
    {
      char var_name[512];
      var_info_t var_info;
      int cnt = sscanf(line.c_str(), "%d %d %s %d %d %c", &var_info.file_id_,
                       &var_info.instr_id_, var_name, &var_info.loop_line_nr_,
                       &var_info.instr_line_, &var_info.operation_);
      if (cnt == 6)
      {
        var_info.var_name_ = std::string(var_name);
        var_infos.push_back(var_info);
      }
    }
    ifile.close();

    std::vector<size_t> reduction_vars;
    if (lc.var_counters_.size() < var_infos.size())
    {
      lc.var_counters_.resize(var_infos.size());
    }
    for (size_t i = 1; i < var_infos.size(); ++i)
    {
      if (lc.var_counters_[i].valid_ && (lc.var_counters_[i].counters_[0] ==
                                         lc.var_counters_[i].counters_[1]))
      {
        reduction_vars.push_back(i);
      }
    }

    // output information about the reduction variables
    std::ofstream ofile;
    ofile.open("reduction.txt");
    for (auto var_id : reduction_vars)
    {
      var_info_t const &var = var_infos[var_id];
      ofile << " FileID : " << var.file_id_;
      ofile << " Loop Line Number : " << var.loop_line_nr_;
      ofile << " Reduction Line Number : " << var.instr_line_;
      ofile << " Variable Name : " << var.var_name_;
      ofile << " Operation Name : " << var.operation_ << "\n";
    }
    ofile.close();

    // get meta information about the loops
    std::vector<loop_info_t> loop_infos;
    loop_infos.push_back(loop_info_t()); // dummy
    ifile.open("loop_meta.txt");
    while (std::getline(ifile, line))
    {
      loop_info_t loop_info;
      int cnt = sscanf(line.c_str(), "%d %d %d", &loop_info.file_id_,
                       &loop_info.loop_id_, &loop_info.line_nr_);
      if (cnt == 3)
      {
        loop_infos.push_back(loop_info);
      }
    }
    ifile.close();

    // output information about the loops
    ofile.open("loop_counter_output.txt");
    for (auto i = 1; i < lc.loop_counters_.size(); ++i)
    {
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

void LoopCounter::incr_counter(int var_id, int instr_type)
{
  if (var_counters_.size() < var_id + 1)
  {
    var_counters_.resize(var_id + 1);
  }
  var_counters_[var_id].counters_[instr_type] += 1;
}

void LoopCounter::incr_loop_counter(int loop_id)
{
  if (loop_counters_.size() < loop_id + 1)
  {
    loop_counters_.resize(loop_id + 1);
  }
  loop_counters_[loop_id] += 1;
}

void LoopCounter::update_ptr(int var_id, int instr_type, long long addr)
{
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
  if (instr_type == 1)
  {
    if (var_counters_[var_id].mem_addr_ != addr)
    {
      var_counters_[var_id].valid_ = false;
    }
  }
  else
  {
    var_counters_[var_id].mem_addr_ = addr;
  }
#endif
}
