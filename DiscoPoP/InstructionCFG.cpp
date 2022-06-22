#include "InstructionCFG.h"

InstructionCFG::InstructionCFG(dputil::VariableNameFinder *_VNF, Function &F): VNF(_VNF){
	entry = Graph::addInstructionNode((Instruction*)ENTRY);
	exit = Graph::addInstructionNode((Instruction*)EXIT);
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
		if(previousInstruction != nullptr) findAndAddFirstRelevantInstructionInSuccessorBlocks(&BB, previousInstruction);
	}
	
	// Conect entry/exit nodes
	for(auto instNode : Graph::getInstructionNodes()){
		if(instNode != entry && instNode != exit){
			if(Graph::getInEdges(instNode).empty()){
				Graph::addEdge(entry, instNode);
			}else if(Graph::getOutEdges(instNode).empty()){
				Graph::addEdge(instNode, exit);
			}
		}
	}
}


void InstructionCFG::findAndAddFirstRelevantInstructionInSuccessorBlocks(BasicBlock *BB, Instruction* previousInstruction) {
	bool hasSuccessors = false;
	for (BasicBlock *S : successors(BB)) {
		hasSuccessors = true;
		for (Instruction &I : *S){
			if(isa<StoreInst>(I) || isa<LoadInst>(I)){
				Graph::addEdge(previousInstruction, &I);
				goto next;
			}else if(isa<AllocaInst>(&I)){
				Graph::addEdge(previousInstruction, &I);
				goto next;
			}else if(isa<ReturnInst>(&I)){
				Graph::addEdge(Graph::getInstructionNode(previousInstruction), exit);
			}
		}
		if(S != BB) findAndAddFirstRelevantInstructionInSuccessorBlocks(S, previousInstruction);
		next:;
	}
}

set<Instruction*> InstructionCFG::findBoundaryInstructions(uint startLine, uint endLine){
	
}

void InstructionCFG::highlightInstructionNode(Instruction *instr){
	highlightedInstructionNodes.insert(instr);
}

void InstructionCFG::dumpToDot(const std::string targetPath)
{
	// Write the graph to a DOT file
	ofstream dotStream;
	dotStream.open(targetPath);
	dotStream << "digraph{";
	// Create all nodes in DOT format
	for (auto instNode : getInstructionNodes())
	{
		string label;
		DebugLoc dl;
		Instruction* instr;
		if(instNode == entry){
			label = "label=ENTRY"; goto printInstructionNode;
		}
		if(instNode == exit){
			label = "label=EXIT"; goto printInstructionNode;
		}
		label = "label=\"" + to_string(Graph::getInstructionNodeIndex(instNode)) + "\\n";
		instr = instNode->getItem();
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
			if(highlightedInstructionNodes.find(instr) != highlightedInstructionNodes.end()){
				label += "\",fillcolor=cyan,style=filled";
			}
		} else if(isa<AllocaInst>(instr)){
			label += "alloca(" + VNF->getVarName(instr) + ")";
			label += "\",shape=rectangle,fillcolor=wheat,style=filled";
		} else label += "?\"";

		printInstructionNode:
		dotStream << "\t\"" << getInstructionNodeIndex(instNode) 
			<< "\" [" << label << "];\n"
		;

	}
	dotStream << "\n\n";
	
	// Now print all outgoing edges and their labels
	for (auto e : getEdges())
	{
		dotStream << "\t\"" << getInstructionNodeIndex(e->getSrc()) 
			<< "\" -> \"" << getInstructionNodeIndex(e->getDst()) 
			<< "\";\n"
		;
	}
	dotStream << "}";
	dotStream.close();
}