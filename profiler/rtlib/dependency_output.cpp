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


#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

#include "debug_print.hpp"
#include "timer.hpp"

#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_set>


namespace __dp {

// hybrid analysis
void generateStringDepMap() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("generateStringDepMap");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::GENERATE_STRING_DEP_MAP);
#endif

  for (auto &dline : *allDeps) {
    if (dline.first) {
      //  unpack dline.first (lid) to instructionID and callpathStateID
      std::uint32_t dline_first_instID = (dline.first & 0xFFFFFFFF);
      std::uint32_t dline_first_callpathStateID = ((dline.first & 0xFFFFFFFF00000000) >> 32);
      std::string unpacked_lid = std::to_string(dline_first_instID) + "@" +
                            std::to_string(dline_first_callpathStateID); // use instructionID instead of lineID
      std::unordered_set<std::string> lineDeps;
      for (auto &d : dline.second) {
        std::string dep = "";
        switch (d.type) {
        case RAW:
          dep += "RAW";
          break;
        case WAR:
          dep += "WAR";
          break;
        case WAW:
          dep += "WAW";
          break;
        case INIT:
          dep += "INIT";
          break;
        default:
          break;
        }

        // unpack d.depOn to instructionID and callpathStateID
        std::uint32_t d_depOn_instID = (d.depOn & 0xFFFFFFFF);
        std::uint32_t d_depOn_callpathStateID = ((d.depOn & 0xFFFFFFFF00000000) >> 32);
        dep += ' ' + std::to_string(d_depOn_instID) + "@" +
               std::to_string(d_depOn_callpathStateID); // use unpacked information instead of lineID

        dep += "|" + std::string(d.var);
        dep += "(" + std::to_string(d.AAvar) + ")";

        lineDeps.insert(dep);
      }

      if (outPutDeps->count(unpacked_lid) == 0) {
        (*outPutDeps)[unpacked_lid] = lineDeps;
      } else {
        (*outPutDeps)[unpacked_lid].insert(lineDeps.begin(), lineDeps.end());
      }
    }
  }
}

void outputDeps() {
#ifdef DP_RTLIB_VERBOSE
  const auto debug_print = make_debug_print("outputDeps");
#endif
#ifdef DP_INTERNAL_TIMER
  const auto timer = Timer(timers, TimerRegion::OUTPUT_DEPS);
#endif

  for (auto pair : *outPutDeps) {
    *out << pair.first << " NOM ";
    for (auto dep : pair.second) {
      *out << ' ' << dep;
    }
    *out << std::endl;
  }
}
// End HA

} // namespace __dp
