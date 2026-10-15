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

#include "DiscoPoP.hpp"

void DiscoPoP::InitializeInstructionIdCounter() {
  std::string instruction_counter_file(dputil::GetEnvOrDefault("DOT_DISCOPOP_PROFILER", ".discopop/profiler"));
  instruction_counter_file += "/DP_InstructionIDCounter.txt";
  if (dputil::FileExists(instruction_counter_file)) {
    std::fstream in_instruction_id_counter(instruction_counter_file, std::ios_base::in);
    ;
    in_instruction_id_counter >> instruction_id_counter;
    in_instruction_id_counter.close();
  }
}
