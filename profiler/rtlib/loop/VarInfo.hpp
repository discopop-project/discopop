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

#include <string>

namespace dp {

struct VarInfoT {
  std::string var_name;
  int file_id = 0;
  int instr_id = 0;
  int loop_line_nr = 0;
  int instr_line = 0;
  char operation = 0;

  bool operator==(const VarInfoT &other) const noexcept {
    return var_name == other.var_name && file_id == other.file_id && instr_id == other.instr_id &&
           loop_line_nr == other.loop_line_nr && instr_line == other.instr_line && operation == other.operation;
  }

  bool operator!=(const VarInfoT &other) const noexcept { return !(*this == other); }
};

} // namespace dp
