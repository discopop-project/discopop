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

void DiscoPoP::InitializeCallpathStateIdCounter() {
  std::string callpath_state_counter_file(dputil::GetEnvOrDefault("DOT_DISCOPOP_PROFILER", ".discopop/profiler"));
  callpath_state_counter_file += "/DP_CallpathStateIDCounter.txt";
  if (dputil::FileExists(callpath_state_counter_file)) {
    std::fstream in_callpath_state_id_counter(callpath_state_counter_file, std::ios_base::in);
    ;
    in_callpath_state_id_counter >> callpath_state_id_counter;
    in_callpath_state_id_counter.close();
  }
}
