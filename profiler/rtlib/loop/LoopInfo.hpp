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

namespace dp {

struct LoopInfoT {
  int line_nr = 0;
  int loop_id = 0;
  int file_id = 0;

  bool operator==(const LoopInfoT& other) const noexcept {
    return line_nr == other.line_nr && loop_id == other.loop_id && file_id == other.file_id;
  }

  bool operator!=(const LoopInfoT& other) const noexcept { return !(*this == other); }
};

}  // namespace dp
