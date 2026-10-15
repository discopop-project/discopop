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

void DiscoPoP::initializeStaticMemoryRegionIDCounter() {
  std::string counterFile(dputil::getEnvOrDefault("DOT_DISCOPOP_PROFILER", ".discopop/profiler"));
  counterFile += "/DP_StaticMemoryRegionIDCounter.txt";
  if (dputil::fexists(counterFile)) {
    std::fstream inCounter(counterFile, std::ios_base::in);
    inCounter >> nextFreeStaticMemoryRegionID;
    inCounter.close();
  }
}
