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

#include <fstream>
#include <ios>
#include <string>

#include "DPUtils.hpp"

// The files the pass writes into the profiler directory (DOT_DISCOPOP_PROFILER, default
// .discopop/profiler). A stream returned by open closes itself, and so flushes, when it goes
// out of scope; a file that cannot be opened is a stream with failbit set, to which writing does nothing,
// as it did before.
namespace profiler_files {

inline std::string Path(const std::string& name) {
  return dputil::GetEnvOrDefault("DOT_DISCOPOP_PROFILER", ".discopop/profiler") + "/" + name;
}

// opened for appending by default: the files collect the results of every module of the program
inline std::ofstream Open(const std::string& name, std::ios_base::openmode mode = std::ios_base::app) {
  std::ofstream stream;
  stream.open(Path(name), std::ios_base::out | mode);
  return stream;
}

// replaces the content of the file with `value`: the counters hand their state over to the next module
template <typename T>
void WriteCounter(const std::string& name, const T& value) {
  std::ofstream stream = Open(name, std::ios_base::trunc);
  if (stream.is_open()) {
    stream << value;
  }
}

}  // namespace profiler_files
