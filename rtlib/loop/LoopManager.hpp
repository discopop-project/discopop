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

#pragma once

#include "LoopRecord.hpp"
#include "LoopTable.hpp"

#include "../DPUtils.hpp"

#include <ostream>

namespace __dp {

class LoopManager {
public:
    LoopManager() {
    }

    ~LoopManager() {
        for (auto loop : loops) {
            delete loop.second;
        }
    }

    LID update_lid(LID lid) {
        return loopStack.update_lid(lid);
    }

    bool empty() {
        return loopStack.empty();
    }

    void clean_function_exit(const std::int32_t function_level, const LID lid) {
        // Clear up all unfinished loops in the function.
        // This usually happens when using return inside loop.
        while (!loopStack.empty() &&
                (loopStack.top().funcLevel == function_level)) {

            // No way to get the real end line of loop. Use the line where
            // function returns instead.
            LoopRecords::iterator loop = loops.find(loopStack.top().begin);
            assert(loop != loops.end() && "A loop ends without its entry being recorded.");

            if (loop->second->end == 0) {
                loop->second->end = lid;
            } else {
                // TODO: FIXME: loop end line > return line
            }

            loop->second->total += loopStack.top().count;
            ++loop->second->nEntered;

            loopStack.debug_output();
            loopStack.pop();
            loopStack.debug_output();
        }
    }

    bool is_new_loop(const std::int32_t loop_id) {
        return loopStack.empty() || (loopStack.top().loopID != loop_id);
    }

    void create_new_loop(const std::int32_t function_level, const std::int32_t loop_id, const LID lid) {
        loopStack.push(LoopTableEntry(function_level, loop_id, 0, lid));
        if (loops.find(lid) == loops.end()) {
            loops.insert(pair<LID, LoopRecord *>(lid, new LoopRecord(0, 0, 0)));
        }
#ifdef DP_DEBUG
        std::cout << "(" << std::dec << FuncStackLevel << ")Loop " << loop_id << " enters." << std::endl;
#endif
    }

    void iterate_loop(const std::int32_t function_level) {
        loopStack.top().count++;
#ifdef DP_DEBUG
      std::cout << "(" << std::dec << loopStack.top().funcLevel << ")";
      std::cout << "Loop " << loopStack.top().loopID << " iterates "
           << loopStack.top().count << " times." << std::endl;
#endif
    }

    void exit_loop(const LID lid) {
        LoopRecords::iterator loop = loops.find(loopStack.top().begin);
        assert(loop != loops.end() && "A loop ends without its entry being recorded.");
        if (loop->second->end == 0) {
            loop->second->end = lid;
        } else {
            // New loop exit found and it's smaller than before. That means
            // the current exit point can be the break inside the loop.
            // In this case we ignore the current exit point and keep the
            // regular one.
            if (lid < loop->second->end) {
                //    loop->second->end = lid;
            }
            // New loop exit found and it's bigger than before. This can
            // happen when the previous exit is a break inside the loop.
            // In this case we update the loop exit to the bigger one.
            else if (lid > loop->second->end) {
                loop->second->end = lid;
            }
            // New loop exit found and it's the same as before. Good.
        }

        if (loop->second->maxIterationCount < loopStack.top().count) {
            loop->second->maxIterationCount = loopStack.top().count;
        }

        loop->second->total += loopStack.top().count;
        ++loop->second->nEntered;

        loopStack.debug_output();
        loopStack.pop();
        loopStack.debug_output();
    }

    bool is_single_exit(const std::int32_t loop_id) {
        return loopStack.is_single_exit(loop_id);
    }

    std::int32_t get_current_loop_id() {
        return loopStack.top().loopID;
    }

    void correct_func_level(const std::int32_t function_level) {
        loopStack.correct_func_level(function_level);
    }

    void output(std::ostream& stream) {
        for (const auto& loop : loops) {
            stream << dputil::decodeLID(loop.first) << " BGN loop ";
            stream << loop.second->total << ' ';
            stream << loop.second->nEntered << ' ';
            stream << static_cast<std::int32_t>(loop.second->total / loop.second->nEntered) << ' ';
            stream << loop.second->maxIterationCount << std::endl;
            stream << dputil::decodeLID(loop.second->end) << " END loop" << std::endl;
        }
    }

private:
    LoopTable loopStack;    // loop stack tracking
    LoopRecords loops;      // loop merging

};

} // namespace __dp
