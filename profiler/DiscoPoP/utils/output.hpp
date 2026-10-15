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

#include "Structs.hpp"

#include <map>
#include <string>

// Data.xml: the CU graph of the instrumented functions
namespace cu_output {

// escapes the characters XML reserves (", &, < and >)
std::string XmlEscape(std::string data);

// appends the CU graph below root, the node of a function, to Data.xml; loopStartLines holds the
// start line of each loop node by its ID
void WriteCuGraph(Node *root, const std::map<std::string, std::string> &loop_start_lines);

} // namespace cu_output
