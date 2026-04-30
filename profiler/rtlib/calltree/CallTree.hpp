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

#include "../DPUtils.hpp"

#include "CallTreeGlobals.hpp"
#include "CallTreeNode.hpp"
#include <atomic>
#include <memory>

namespace __dp {

class CallTree {
public:
  CallTree();
  ~CallTree();
  void enter_function(unsigned int function_id);
  void exit_function();
  void enter_loop(unsigned int loop_id);
  void exit_loop();
  void enter_iteration(unsigned int iteration_id);
  // exit_iteration not possible, as determining the iteration end is not trivial
  unsigned int get_node_count();
  std::shared_ptr<CallTreeNode> get_current_node_ptr();

private:
  std::shared_ptr<CallTreeNode> current;
};

} // namespace __dp
