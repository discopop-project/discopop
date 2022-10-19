#include "InstructionCFG.h"

InstructionCFG::InstructionCFG(dputil::VariableNameFinder *_VNF, Function &F): VNF(_VNF){
	// if(F.getName() == "fbdev_read_packet")
	// 	return;
	entry = Graph::addNode((Instruction*)ENTRY);
	exit = Graph::addNode((Instruction*)EXIT);
	Instruction *previousInstruction;
	for (BasicBlock &BB : F){
		// Add current block's store/load/call-instructions and declarations to graph
		previousInstruction = nullptr;
		for (Instruction &I : BB){
			if(isa<StoreInst>(I) || isa<LoadInst>(I) || isa<AllocaInst>(&I)){
				if(previousInstruction != nullptr){
					Graph::addEdge(previousInstruction, &I);
				}
				previousInstruction = &I;
			}
		}
		// Add edges from last instruction in current block to first instruction all the successor blocks
		if(previousInstruction != nullptr && !BB.empty()) findAndAddFirstRelevantInstructionInSuccessorBlocks(&BB, previousInstruction);
	}
	
	// Conect entry/exit nodes
	for(auto node : Graph::getNodes()){
		if(node != entry && node != exit){
			if(Graph::getInEdges(node).empty()){
				Graph::addEdge(entry, node);
			}else if(Graph::getOutEdges(node).empty()){
				Graph::addEdge(node, exit);
			}
		}
	}
}


void InstructionCFG::findAndAddFirstRelevantInstructionInSuccessorBlocks(BasicBlock *BB, Instruction* previousInstruction) {
	// bool hasSuccessors = false;
	// if(BB == nullptr)
	// 	return;
	// if(BB->getParent()->getName() == "fbdev_read_packet"){
			
	// 		errs() << "----- " << BB->getName() << "\n";
	// }
	for (succ_iterator SI = succ_begin(BB), SE = succ_end(BB); SI != SE; ++SI) {
		
	// for (BasicBlock *S : successors(BB)) {
		// hasSuccessors = true;
	BasicBlock *S = *SI;
	if(S != BB)
		break;
	// if(S->getParent()->getName() == "fbdev_read_packet"){
	// 		errs() << "++++++ " << S->getName() << "\n";
	// }
	// if (S->empty())
	// 	continue;
	bool foundRelInst = false;
	for (llvm::Instruction &I : *S)
	{
		// if (&I == nullptr)
		// 	continue;

		if (isa<llvm::StoreInst>(I) || isa<llvm::LoadInst>(I))
		{
			// if(I.getParent()->getParent()->getName() == "fbdev_read_packet"){
			// 	errs() << I << "\n";
			// }
			Graph::addEdge(previousInstruction, &I);
			foundRelInst = true;
			// goto next;
			break;
		}
		else if (isa<llvm::AllocaInst>(I))
		{
			Graph::addEdge(previousInstruction, &I);
			// goto next;
			foundRelInst = true;
			break;
		}
		else if (isa<llvm::ReturnInst>(I))
		{
			Graph::addEdge(Graph::getNode(previousInstruction), exit);
			foundRelInst = true;
			break;
		}
	}
	if(foundRelInst) {
		if(previousInstruction->getParent() == S) // a self loop is found and we should return
			return;
		else
			continue;
	}
	else{
		if(S != BB) findAndAddFirstRelevantInstructionInSuccessorBlocks(S, previousInstruction);
	}
	// if(S != BB) findAndAddFirstRelevantInstructionInSuccessorBlocks(S, previousInstruction);
	// next:;
	}
}

set<Instruction*> InstructionCFG::findBoundaryInstructions(uint startLine, uint endLine){
	
}

void InstructionCFG::highlightNode(Instruction *instr){
	highlightedNodes.insert(instr);
}

void InstructionCFG::dumpToDot(const std::string targetPath)
{
	// Write the graph to a DOT file
	ofstream dotStream;
	dotStream.open(targetPath);
	dotStream << "digraph{";
	// Create all nodes in DOT format
	for (auto node : getNodes())
	{
		string label;
		DebugLoc dl;
		Instruction* instr;
		if(node == entry){
			label = "label=ENTRY"; goto printNode;
		}
		if(node == exit){
			label = "label=EXIT"; goto printNode;
		}
		label = "label=\"" + to_string(Graph::getNodeIndex(node)) + "\\n";
		instr = node->getItem();
		dl = instr->getDebugLoc();
		if(isa<StoreInst>(instr) || isa<LoadInst>(instr)){
			if(isa<StoreInst>(instr)){
				if(DebugLoc dl = instr->getDebugLoc())
					label += "write(";
				else
					label += "init(";
			}
			else label += "read(";
			label += VNF->getVarName(instr);
			label += ") ";

			if(dl){
				label += to_string(dl.getLine());
				label += ", ";
				label += to_string(dl.getCol());
			}else{
				label += to_string(instr->getFunction()->getSubprogram()->getLine());
			}
			label += "\"";
			if(highlightedNodes.find(instr) != highlightedNodes.end()){
				label += "\",fillcolor=cyan,style=filled";
			}
		} else if(isa<AllocaInst>(instr)){
			label += "alloca(" + VNF->getVarName(instr) + ")";
			label += "\",shape=rectangle,fillcolor=wheat,style=filled";
		} else label += "?\"";

		printNode:
		dotStream << "\t\"" << getNodeIndex(node) 
			<< "\" [" << label << "];\n"
		;

	}
	dotStream << "\n\n";
	
	// Now print all outgoing edges and their labels
	for (auto e : getEdges())
	{
		dotStream << "\t\"" << getNodeIndex(e->getSrc()) 
			<< "\" -> \"" << getNodeIndex(e->getDst()) 
			<< "\";\n"
		;
	}
	dotStream << "}";
	dotStream.close();
}