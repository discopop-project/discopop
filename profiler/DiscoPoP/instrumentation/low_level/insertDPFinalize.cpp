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

using namespace llvm;
using namespace std;
using namespace dputil;

void DiscoPoP::insertDpFinalize(Instruction *before) {
  LID lid = getLID(before, fileID);
  assert((lid > 0) && "Returning on an invalid LID.");
  IRBuilder<> IRB(before);
  IRB.CreateCall(DpFinalize, lidConstant(lid));
}
