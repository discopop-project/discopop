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

#include <cassert>
#include <chrono>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

/**
 * This type allows type-safe specification of a specific timer
 */
enum class TimerRegion : unsigned int {
  // These are directly inserted calls
  kAddBbDeps = 0,
  kAlloca,
  kCall,
  kDecl,
  kDelete,
  kFinalize,
  kFuncEntry,
  kFuncExit,
  kIncrTakenBranchCounter,
  kInit,
  kLandingPad,
  kLoopEntry,
  kLoopExit,
  kLoopIncr,
  kNew,
  kRead,
  kReportBb,
  kReportBbPair,
  kWrite,

  // These are indirectly inserted calls
  kAddDep,
  kGenerateStringDepMap,
  kOutputDeps,
  kOutputLoops,
  kOutputFuncs,
  kReadRuntimeInfo,
  kInitParallelization,
  kMergeDeps,
  kAnalyzeDeps,
  kAnalyzeSingleAccess,
  kFinalizeParallelization,

  kSizeDontUse,
};

/**
 * This number is used as a shortcut to count the number of values valid for
 * TimerRegion
 */
constexpr std::size_t kNumberTimers = static_cast<std::size_t>(TimerRegion::kSizeDontUse);

/**
 * This class is used to collect all sorts of different timers (see
 * TimerRegion). It provides an interface to start, stop, and print the timers
 */
class Timers {
  using TimePoint = std::chrono::high_resolution_clock::time_point;
  using IndexType = std::vector<TimePoint>::size_type;

 public:
  Timers() {
    time_start_ = std::vector<Timers::TimePoint>{kNumberTimers};
    time_stop_ = std::vector<Timers::TimePoint>{kNumberTimers};

    number_called_ = std::vector<std::size_t>(kNumberTimers, static_cast<std::size_t>(0));
    time_elapsed_ = std::vector<std::chrono::nanoseconds>{kNumberTimers};
  }

  /**
   * @brief Starts the respective timer
   * @param timer The timer to start
   */
  void Start(const TimerRegion timer) {
    const auto timer_id = GetTimerIndex(timer);
    number_called_[timer_id]++;
    time_start_[timer_id] = std::chrono::high_resolution_clock::now();
  }

  /**
   * @brief Stops the respective timer
   * @param timer The timer to stops
   */
  void Stop(const TimerRegion timer) {
    const auto timer_id = GetTimerIndex(timer);
    time_stop_[timer_id] = std::chrono::high_resolution_clock::now();
  }

  /**
   * @brief Stops the respective timer and adds the elapsed time
   * @param timer The timer to stops
   */
  void StopAndAdd(const TimerRegion timer) {
    Stop(timer);
    AddStartStopDiffToElapsed(timer);
  }

  /**
   * @brief Adds the difference between the current start and stop time points
   * to the elapsed time
   * @param timer The timer for which to add the difference
   */
  void AddStartStopDiffToElapsed(const TimerRegion timer) {
    const auto timer_id = GetTimerIndex(timer);
    time_elapsed_[timer_id] += (time_stop_[timer_id] - time_start_[timer_id]);
  }

  /**
   * @brief Resets the elapsed time for the timer
   * @param timer The timer for which to reset the elapsed time
   */
  void ResetElapsed(const TimerRegion timer) {
    const auto timer_id = GetTimerIndex(timer);
    time_elapsed_[timer_id] = std::chrono::nanoseconds(0);
  }

  /**
   * @brief Returns the elapsed time for the respective timer
   * @param timer The timer for which to return the elapsed time
   * @return The elapsed time
   */
  [[nodiscard]] std::chrono::nanoseconds GetElapsed(const TimerRegion timer) {
    const auto timer_id = GetTimerIndex(timer);
    return time_elapsed_[timer_id];
  }

  /**
   * @brief Prints a formatted output to the stream
   * @param stream The out stream
   */
  void Print(std::ostream& stream) {
    stream << "\n========== DiscoPoP TIMERS: Inserted calls ==========\n";
    Print(stream, " Function call                                   : ", TimerRegion::kCall);
    Print(stream, " Function entry                                  : ", TimerRegion::kFuncEntry);
    Print(stream, " Function exit                                   : ", TimerRegion::kFuncExit);
    stream << '\n';
    Print(stream, " Landing pad                                     : ", TimerRegion::kLandingPad);
    Print(stream, " Loop entry                                      : ", TimerRegion::kLoopEntry);
    Print(stream, " Loop exit                                       : ", TimerRegion::kLoopExit);
    Print(stream, " Loop iteration                                  : ", TimerRegion::kLoopIncr);
    Print(stream, " Taken branch counter                            : ", TimerRegion::kIncrTakenBranchCounter);
    stream << '\n';
    Print(stream, " Add basic block dependencies                    : ", TimerRegion::kAddBbDeps);
    Print(stream, " Report a basic block                            : ", TimerRegion::kReportBb);
    Print(stream, " Report a pair of basic blocks                   : ", TimerRegion::kReportBbPair);
    stream << '\n';
    Print(stream, " New memory on the stack                         : ", TimerRegion::kAlloca);
    Print(stream, " New memory on the heap                          : ", TimerRegion::kNew);
    Print(stream, " Delete memory                                   : ", TimerRegion::kDelete);
    stream << '\n';
    Print(stream, " Read from memory                                : ", TimerRegion::kRead);
    Print(stream, " Write to memory                                 : ", TimerRegion::kWrite);
    stream << '\n';
    Print(stream, " Decl                                            : ", TimerRegion::kDecl);
    Print(stream, " Init                                            : ", TimerRegion::kInit);
    Print(stream, " Finalize                                        : ", TimerRegion::kFinalize);
    stream << '\n';

    stream << "\n========== DiscoPoP TIMERS: Indirect calls ==========\n";
    Print(stream, " Reading the runtime info                        : ", TimerRegion::kReadRuntimeInfo);
    Print(stream, " Initializing the parallelization                : ", TimerRegion::kInitParallelization);
    Print(stream, " Finalizing the parallelization                  : ", TimerRegion::kFinalizeParallelization);
    stream << '\n';
    Print(stream, " Generate the dependency map                     : ", TimerRegion::kGenerateStringDepMap);
    Print(stream, " Analyze singe accesses                          : ", TimerRegion::kAnalyzeSingleAccess);
    Print(stream, "  |- Add a dependency                            : ", TimerRegion::kAddDep);
    Print(stream, " Merge dendencies                                : ", TimerRegion::kMergeDeps);
    Print(stream, " Analyze the dependencies (incorrect!)           : ",
          TimerRegion::kAnalyzeDeps);  // Incorrect due to multithreading
    stream << '\n';
    Print(stream, " Output the dependencies                         : ", TimerRegion::kOutputDeps);
    Print(stream, " Output the loops                                : ", TimerRegion::kOutputLoops);
    Print(stream, " Output the functions                            : ", TimerRegion::kOutputFuncs);
    stream << '\n';
  }

  /**
   * @brief Returns the current time as a string
   * @return The current time as a string
   */
  [[nodiscard]] std::string WallClockTime() {
    // The time is printed with 24 interesting characters followed by '\n'
    constexpr std::size_t kSizeOfDateString = 24;

#if defined(__linux__) || defined(__APPLE__)
    time_t raw_time = 0;
    struct tm time_info;

    // Need some more space for '\n' and other checks
    char char_buff[kSizeOfDateString + 3];

    time(&raw_time);
    localtime_r(&raw_time, &time_info);
    asctime_r(&time_info, char_buff);

    // Avoid '\n'
    return std::string(char_buff, kSizeOfDateString);
#else
    time_t raw_time = 0;
    struct tm time_info;

    // Need some more space for '\n' and other checks
    char char_buff[size_of_date_string + 3];

    time(&raw_time);
    localtime_s(&time_info, &raw_time);
    asctime_s(char_buff, &time_info);

    // Avoid '\n'
    return std::string(char_buff, size_of_date_string);
#endif
  }

 private:
  /**
   * @brief Casts the value of timer to an index for the vectors
   * @param timer The timer as an enum value
   * @result The timer as an index
   */
  [[nodiscard]] IndexType GetTimerIndex(const TimerRegion timer) noexcept {
    const auto timer_id = static_cast<IndexType>(timer);
    return timer_id;
  }

  void Print(std::ostream& stream, const char* message, const TimerRegion region) {
    const auto index = GetTimerIndex(region);

    const auto counted = time_elapsed_[index].count();
    const auto seconds = static_cast<double>(counted) * 1e-9;

    const auto called = number_called_[index];

    stream << message << std::setw(8) << std::fixed << seconds << "\t(" << called << " times called)\n";
  }

  std::vector<TimePoint> time_start_;
  std::vector<TimePoint> time_stop_;

  std::vector<std::size_t> number_called_;
  std::vector<std::chrono::nanoseconds> time_elapsed_;
};

class Timer {
 public:
  Timer(Timers* timers, TimerRegion region, bool also_print = false)
      : timers_(timers), region_(region), print_(also_print) {
    assert(timers != nullptr && "Timer started but timers is nullptr");
    timers->Start(region);
  }

  ~Timer() {
    timers_->StopAndAdd(region_);
    if (print_) {
      timers_->Print(std::cout);
    }
  }

 private:
  Timers* timers_;
  TimerRegion region_;
  bool print_;
};
