/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
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
#include "InstructionCFG.hpp"
#include "DPUtils.hpp"

class InstructionDG : public Graph<Instruction*>
{
	
private:
	dputil::VariableNameFinder *VNF;
	InstructionCFG *CFG;
	set<Instruction*> highlightedInstructionNodes;
	int32_t fid;

	void recursiveDepChecker(set<Instruction*>* checkedInstructions, Instruction* I, Instruction* C);
	void recursiveDepFinder(set<Instruction*>* checkedInstructions, Instruction* I);

public:
	InstructionDG(dputil::VariableNameFinder *_VNF, InstructionCFG *_CFG, int32_t _fid);

	string edgeToDPDep(Edge<Instruction*> *e);

	void highlightInstructionNode(Instruction *instr);
	void dumpToDot(const string targetPath);

};