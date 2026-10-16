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

#include "runtime_shutdown.hpp"

#include <cassert>
#include <chrono>
#include <fstream>
#include <iostream>
#include <string>

#include "callback_scope.hpp"
#include "hybrid_analysis/bb_deps.hpp"
#include "injected_functions/dp_func_exit.hpp"
#include "injected_functions/dp_loop_output.hpp"
#include "injected_functions/dp_taken_branch_counter_output.hpp"
#include "output_paths.hpp"
#include "runtimeFunctions.hpp"
#include "runtimeFunctionsGlobals.hpp"

namespace dp {

void UnwindFunctionStack(LID lid) {
  // The loop below assumes a function stack that both halves of the bracket maintained:
  // __dp_func_entry raises the level, __dp_func_exit lowers it, and the loop drives the second
  // until the first has been undone. A benchmark build that leaves either body out (see
  // callback_body_enabled()) breaks that in one of two ways -- without the exit the level never
  // reaches -1 and this spins forever, without the entry it is already far below -1. Neither has a
  // stack worth unwinding, and the two invariants below describe one that was being maintained.
  if (!CallbackBodyEnabled(CallbackId::FUNC_ENTRY) || !CallbackBodyEnabled(CallbackId::FUNC_EXIT)) {
    return;
  }

  while (function_manager->GetCurrentStackLevel() >= 0) {
    __dp_func_exit(lid, 1);
  }

  assert(function_manager->GetCurrentStackLevel() == -1 && "Program terminates without clearing function stack!");
  assert(loop_manager->empty() && "Program terminates but loop stack is not empty!");
}

void WriteResults(LID lid) {
  if (dp_debug) {
    std::cout << "Program terminates at LID " << std::dec << dputil::DecodeLid(lid) << ", clearing up" << std::endl;
  }

  if (num_workers > 0) {
    FinalizeParallelization();
  } else {
    FinalizeSingleThreadedExecution();
  }

  {
    DP_TIMED_SECTION(kOutputLoops, "outputLoops");
    loop_manager->Output(*out);
  }

  // The iteration counters and the taken branch counters used to be dumped from a call the pass
  // put in front of main's return. That missed every iteration and branch of the global
  // destructors, and was lost entirely when the target left through exit(). Both dumps belong
  // here, where the runtime knows the target is done -- and where the managers they read are
  // still alive.
  __dp_loop_output();
  __dp_taken_branch_counter_output();

  {
    DP_TIMED_SECTION(kOutputFuncs, "outputFunc");
    function_manager->OutputFunctions(*out);
  }

  // hybrid analysis
  // the dependencies of the omitted instructions first: their basic blocks are
  // known to be complete only now that the target has terminated
  ProcessRegisteredBbDeps();
  GenerateStringDepMap();
  // End HA
  OutputDeps();

  *out << dputil::DecodeLid(lid) << " END program" << std::endl;
  out->flush();
  out->close();

  const auto time_elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
      std::chrono::high_resolution_clock::now() - statistics_profiling_start_time);
  auto stats_file = std::ofstream(ProfilerOutputPath("statistics/profiling_time.txt"), std::ios::out);
  stats_file << std::to_string(time_elapsed.count()) << " ms\n";
  stats_file.close();
}

void ReleaseRuntime() {
  // hybrid analysis
  delete all_deps;
  all_deps = nullptr;
  delete out_put_deps;
  out_put_deps = nullptr;
  delete bb_list;
  bb_list = nullptr;
  // End HA

  delete call_state_graph;
  call_state_graph = nullptr;
  // The last reader of the memory manager is the allocation output in write_results(); the
  // accesses that ask it for a region id are all behind us, and the worker threads that could
  // still have been processing them were joined by finalizeParallelization().
  DestroyManagerGlobals();

  delete out;
  out = nullptr;

  runtime_state = RuntimeState::kTerminated;

  // last use of the manually managed globals is behind us, and every callback returns early
  // from here on, so they can go
  DestroyImmortalGlobals();

  if (dp_debug) {
    std::cout << "Program terminated." << std::endl;
  }
}

}  // namespace dp
