#include <llvm/IR/Module.h>
#include "llvm/IR/Function.h"
#include "llvm/PassManager.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Verifier.h"
//#include "llvm/Assembly/PrintModulePass.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/Debug.h"
#include <fstream>
#include <vector>
#include <set>
#include <sstream>
#include <unordered_map>
#include <string>
#include <iostream>

//#define single

using namespace llvm;
using namespace std;
static cl::opt<std::string> InputFilename("inputone", cl::desc("<input file>"), cl::Optional);
//static cl::opt<std::string> FileMapping("filemapping", cl::desc("<filemapping file>"), cl::Optional);
//static cl::opt<std::string> InputFunctionName("func", cl::desc("<input func>"), cl::Optional);
//static cl::opt<std::string> AddOutput("addOutput", cl::desc("<true if also to insert the output instructions>"), cl::Optional);


typedef struct loopTuple_struct {
	std::vector<int> loopLines;
	int instLine;
	string varName;
	bool isStore;
} loopTuple;


namespace {
	struct ModuleFunc : public ModulePass {
		static char ID;
		Module* mod;
		LLVMContext* ctx;
		#ifdef single
		unordered_map<int64_t, int32_t> instAddressToLoopLineMap;
		#else
		unordered_map<int64_t, vector<int32_t>* > instAddressToLoopLineMap;
		#endif
		unordered_map<int, std::vector<Instruction*> > lineToInstructionMap;
		Function* get_address_func;
		Function* addStoreInstRecordFunction;
		Function* addLoadInstRecordFunction;
		Function* lcOutputFunc;
		vector<loopTuple> loopTuples;
		//to be used later
		set<int32_t> loopLines;
		set<int32_t> realLoopLines;
		bool needLoopInstrumentation;

		virtual bool runOnModule(Module &M);
		void getAnalysisUsage(AnalysisUsage &Info) const;
		void insertLoopCounterIncInstruction(int32_t loop_lno, Instruction& firstLoopBodyInstr);
		void insertLoopCounterOutputInstruction(Function* func);

		void createLineToInstMap(Function* func);
		void createInstToLoopLineMap(Function* func, LoopInfo &LI);
		void createLineToInstAndInstToLoopLineMap(Module* func);


		void createLcOutputFunction();
		void createGetAddressFuncion();
		void createAddStoreAndLoadInstRecordFunction();
		int32_t getLineNumberOfLoop(Loop *loop);
		std::vector<int>* getParentLoopsLineNumbers(Loop* loop);

		void addStoreInstructionRecordCall(StoreInst* store_instruction, string varName, std::vector<int32_t>& loopLines);
		void addLoadInstructionRecordCall(LoadInst* load_instruction, string varName, std::vector<int32_t>& loopLines);

		void instrumentLoopsInFunction(Function* func, LoopInfo& LI);

		void readLineNumberPairs(const char* fileName);

		void insertMemoryInstructions();

		void instrumentLoopsInAllFunctons(Module* mod);

		void instrumentLoops();

	ModuleFunc() : ModulePass(ID) {}
  	};
}

void ModuleFunc::getAnalysisUsage(AnalysisUsage &Info) const 
{
	Info.addRequired<LoopInfo>();
}


//returns void
//int loopLineNumber
//long long varAddress
//int iterationNumber
void ModuleFunc::createAddStoreAndLoadInstRecordFunction()
{
	Type** typeArray = new Type*[2];
	typeArray[0] = Type::getInt32Ty(*ctx);
	typeArray[1] = Type::getInt64Ty(*ctx);
	typeArray[2] = Type::getInt32Ty(*ctx);
	ArrayRef<Type*> ft_args(typeArray, 3);
	FunctionType* func_type = FunctionType::get(Type::getVoidTy(*ctx), ft_args, false);
	addStoreInstRecordFunction = dyn_cast<Function>(mod->getOrInsertFunction("addStoreInstRecord", func_type));
	addLoadInstRecordFunction = dyn_cast<Function>(mod->getOrInsertFunction("addLoadInstRecord", func_type));
	// if (addStoreInstRecordFunction)
		// errs() << "addStoreInstRecordFunction found\n";
}

void ModuleFunc::addStoreInstructionRecordCall(StoreInst* store_instruction, string varName, std::vector<int32_t>& loopLines)
{
	Value* pointerOperand = store_instruction->getPointerOperand();
	string pVarName = pointerOperand->getName().str();
	if (varName.compare("ignore")!=0 && varName.compare(pVarName) != 0)
		return;
	int32_t lno = store_instruction->getDebugLoc().getLine();
	Value* intPointerOperand = PtrToIntInst::CreatePointerCast(pointerOperand, 
							Type::getInt64Ty(*ctx), "", 
								store_instruction);
	
	Value** arguments = new Value*[3];
	#ifdef single
	int32_t loopLineNumber = instAddressToLoopLineMap[(int64_t) store_instruction];
	arguments[0] = ConstantInt::get(Type::getInt32Ty(*ctx), loopLineNumber);
	arguments[1] = intPointerOperand;
	ArrayRef<Value*> argsStoreInst(arguments, 2);
	CallInst::Create(addStoreInstRecordFunction, argsStoreInst, "", store_instruction);
	// errs() << "hdhdhdhdhdhdh\n";
	#else
	// vector<int32_t> *loopLineNumbers = instAddressToLoopLineMap[(int64_t) store_instruction];
	// errs() << "inside store insertion, loopLines.size()=" << loopLines.size() << "\n";
	vector<int32_t> *loopLineNumbers = &loopLines;
	int ik = 0;
	
	for (vector<int32_t>::iterator it = loopLineNumbers->begin(); it != loopLineNumbers->end(); ++it)
	{
		int32_t loopLineNumber = *it;
		arguments[0] = ConstantInt::get(Type::getInt32Ty(*ctx), loopLineNumber);
		arguments[1] = intPointerOperand;
		arguments[2] = ConstantInt::get(Type::getInt32Ty(*ctx), lno);
		ArrayRef<Value*> argsStoreInst(arguments, 3);
		// errs() << "Loop: " << loopLineNumber << ", store instruction inserted                  " << ik << "\n";
		CallInst::Create(addStoreInstRecordFunction, argsStoreInst, "", store_instruction);
		ik++;
		// errs() << "=====================loopLineNumber: " << loopLineNumber << "\n";
	}
	#endif
}

void ModuleFunc::addLoadInstructionRecordCall(LoadInst* load_instruction, string varName, std::vector<int32_t>& loopLines)
{
	Value* pointerOperand = load_instruction->getPointerOperand();
	string pVarName = pointerOperand->getName().str();
	if (varName.compare("ignore")!=0 && varName.compare(pVarName) != 0)
		return;
	int32_t lno = load_instruction->getDebugLoc().getLine();
	Value* intPointerOperand = PtrToIntInst::CreatePointerCast(pointerOperand, 
							Type::getInt64Ty(*ctx), "", 
								load_instruction);
	
	Value** arguments = new Value*[3];
	#ifdef single
	int32_t loopLineNumber = instAddressToLoopLineMap[(int64_t) load_instruction];
	arguments[0] = ConstantInt::get(Type::getInt32Ty(*ctx), loopLineNumber);
	arguments[1] = intPointerOperand;
	ArrayRef<Value*> argsStoreInst(arguments, 2);
	CallInst::Create(addLoadInstRecordFunction, argsStoreInst, "", load_instruction);
	#else
	// vector<int32_t> *loopLineNumbers = instAddressToLoopLineMap[(int64_t) load_instruction];
	vector<int32_t> *loopLineNumbers = &loopLines;
	int ik = 0;
	// errs() << "loopLineNumbers.size: " << loopLineNumbers->size() << "\n";
	for (vector<int32_t>::iterator it = loopLineNumbers->begin(); it != loopLineNumbers->end(); ++it)
	{
		int32_t loopLineNumber = *it;
		arguments[0] = ConstantInt::get(Type::getInt32Ty(*ctx), loopLineNumber);
		arguments[1] = intPointerOperand;
		arguments[2] = ConstantInt::get(Type::getInt32Ty(*ctx), lno);
		ArrayRef<Value*> argsStoreInst(arguments, 3);
		// errs() << "Loop: " << loopLineNumber << ", load instruction inserted                  " << ik << "\n";
		CallInst::Create(addLoadInstRecordFunction, argsStoreInst, "", load_instruction);
		ik++;
	}
	#endif	
}

void ModuleFunc::insertMemoryInstructions() {
	if (loopTuples.size() != 0)
	{
		// errs() << "SloopTuples.size(): " << loopTuples.size() << "\n";
		for (vector<loopTuple>::iterator tupleIter = loopTuples.begin(); tupleIter!=loopTuples.end(); ++tupleIter)
		{
			loopTuple &t = *tupleIter;
			/* when we keep only 'real'(discopop gives not real sometimes) loop lines there is a problem with files whose code is run inside a loop of a different file
			vector<int32_t> newLoopLines;
			for (vector<int32_t>::iterator itr = t.loopLines.begin(); itr != t.loopLines.end(); itr++) {
				if (realLoopLines.find(*itr) != realLoopLines.end())
					newLoopLines.push_back(*itr);
			}
			t.loopLines = newLoopLines;
			*/
			// errs() << "t.instline: " << t.instLine << "\n";
			vector<Instruction*> instructions = lineToInstructionMap[t.instLine];
			for (vector<Instruction*>::iterator instIter = instructions.begin(); instIter != instructions.end(); ++instIter)
			{
				Instruction* instruction = *instIter;
				if (t.isStore)
				{
					if (StoreInst* store_instruction = dyn_cast<StoreInst>(instruction)) 
					{
						// errs() << "==== Store instrumentation is inserted \n";
						addStoreInstructionRecordCall(store_instruction, t.varName, t.loopLines);
					}
				}
				else if (!t.isStore)
				{	
					if (LoadInst* load_instruction = dyn_cast<LoadInst>(instruction)) 
					{
						// errs() << "Load instrumentation is inserted\n";
						addLoadInstructionRecordCall(load_instruction, t.varName, t.loopLines);
					}
				}
			}
		}
	}
	else
		{
		#ifdef single
		for (std::unordered_map<int64_t, int32_t>::iterator it = instAddressToLoopLineMap.begin(); it != instAddressToLoopLineMap.end(); ++it) 
		#else
		for (std::unordered_map<int64_t, vector<int32_t>* >::iterator it = instAddressToLoopLineMap.begin(); it != instAddressToLoopLineMap.end(); ++it) 
		#endif
		{
			Instruction* instruction = (Instruction *)it->first;
			vector<int32_t> *loopLines = instAddressToLoopLineMap[(int64_t) instruction];
			if (StoreInst* store_instruction = dyn_cast<StoreInst>(instruction))
			{
				addStoreInstructionRecordCall(store_instruction, string("ignore"), *loopLines);
			}
			else if (LoadInst* load_instruction = dyn_cast<LoadInst>(instruction))
			{
				addLoadInstructionRecordCall(load_instruction, string("ignore"), *loopLines);
			}
		}
	}
}

void ModuleFunc::createLineToInstMap(Function* func)
{
	for (inst_iterator it = inst_begin(func); it!=inst_end(func); ++it) 
	{
		Instruction* inst = &*it;
		int32_t lno = inst->getDebugLoc().getLine();
		lineToInstructionMap[lno].push_back(inst);
		// errs() << "----- lno:" << lno << " inst: " << inst->getOpcodeName() << "\n";
	}
}

int32_t ModuleFunc::getLineNumberOfLoop(Loop *loop)
{
	if (loop == NULL)
		return -1;

	BasicBlock *block;
	if ((block = loop->getLoopPreheader())!= NULL)
	{
		DebugLoc loc = block->getTerminator()->getDebugLoc();
		if (!loc.isUnknown())
			return loc.getLine(); 
	}

	if ((block = loop->getHeader())!= NULL)
	{
		DebugLoc loc = block->getTerminator()->getDebugLoc();
			return loc.getLine(); 
	}

	return -1;
}

std::vector<int>* ModuleFunc::getParentLoopsLineNumbers(Loop* loop)
{
	std::vector<int> *v = new std::vector<int>();
	if (loop==NULL)
		return v;
	Loop* parentLoop = loop->getParentLoop();
	while (parentLoop != NULL)
	{
		int parentLoopLineNumber = getLineNumberOfLoop(parentLoop);
		v->push_back(parentLoopLineNumber);
		parentLoop = parentLoop->getParentLoop();
	}

	return v;
}

void ModuleFunc::createInstToLoopLineMap(Function* func, LoopInfo &LI)
{
	for (inst_iterator it = inst_begin(func); it!=inst_end(func); ++it) 
	{
		Instruction* inst = &*it;
		BasicBlock *parentBlock = inst->getParent();
		Loop *loop = LI.getLoopFor(parentBlock);

		int32_t lineNumber = getLineNumberOfLoop(loop);

		if (lineNumber != -1)
		{
			#ifdef single
			instAddressToLoopLineMap[(int64_t)inst] = lineNumber;
			#else
			std::vector<int> *parentLoopsLineNumbers = getParentLoopsLineNumbers(loop);
			parentLoopsLineNumbers->push_back(lineNumber);
			instAddressToLoopLineMap[(int64_t)inst] = parentLoopsLineNumbers;
			#endif
		}
	}
}

// //puts all instructions of a module into a map by their line number
// void ModuleFunc::createLineToInstAndInstToLoopLineMap(Module* mod)
// {
// 	for (Module::iterator I = mod->begin(), E = mod->end(); I != E; ++I) 
// 	{
// 		Function* func = &*I;
// 		createLineToInstMap(func);
// 		// errs() << "Retreive LI for func start\n";
// 		// errs() << "Name: " << func->getName() << "\n";
// 		try
// 		{
// 			LoopInfo &LI = getAnalysis<LoopInfo>(*func);
// 			createInstToLoopLineMap(func, LI);
// 		}
// 		catch (int e)
// 		{
// 			errs() << "No LI for function " << func->getName() << "\n";
// 		}
// 		// errs() << "Retreive LI for func end\n";
// 	}
// }

inline vector<string>* split(string input, char delim) {
	vector<string>* substrings = new vector<string>();
	istringstream inputStringStream(input);
	string sub;
	
	while(getline(inputStringStream, sub, delim)) {
		substrings->push_back(sub);	
	}
	
	return substrings;
}

int32_t getFileID(string fileMapping, string fullPathName) {
	int32_t index = 0;
	string line;
	ifstream fileMap;
	fileMap.open(fileMapping.c_str());
	if (fileMap.is_open()) {
		vector<string>* substrings = NULL;
		while (getline(fileMap, line)) {
			substrings = split(line, ' ');
			if (substrings->size() == 2) {
				string indexString = (*substrings)[0];
				string fileName = (*substrings)[1];
				if (fileName.compare(fullPathName) == 0) {
					index = (int32_t)atoi(indexString.c_str());
					break;	
				}
			}
			substrings->clear();
			delete substrings;	
		}
		fileMap.close();
	}
	return index;
}

//puts all instructions of a module into a map by their line number
void ModuleFunc::createLineToInstAndInstToLoopLineMap(Module* mod)
{
	// StringRef fm = FileMapping;
	for (Module::iterator I = mod->begin(), E = mod->end(); I != E; ++I)
	{
		Function* func = &*I;
		createLineToInstMap(func);
	}
}

void ModuleFunc::instrumentLoopsInAllFunctons(Module* mod)
{
	// errs() << "instrumentLoopsInAllFunctons start \n";
	for (Module::iterator I = mod->begin(), E = mod->end(); I != E; ++I) 
	{
                Function* func = &*I;
				std::string fnName=func->getName();
				std::size_t found;
				
                found=(func->getName().find("llvm"));
                if(found!=std::string::npos || func->isDeclaration())  
                    continue;


 
		LoopInfo &LI = getAnalysis<LoopInfo>(*func);
		instrumentLoopsInFunction(func, LI);
	}
}

void ModuleFunc::readLineNumberPairs(const char* fileName) 
{
	ifstream inputFileStream;
	inputFileStream.open(fileName);
	string line;
	//read a list of loops
	std::getline(inputFileStream, line);
	istringstream iss(line);
	int ll;
	while (iss >> ll)
	{
		loopLines.insert(ll);
	}

	while (std::getline(inputFileStream, line)) 
	{
		//loop line is not really needed
		istringstream iss(line);
		int32_t loopCount;
		iss >> loopCount;
		std::vector<int32_t> v;
		for (int i=0; i<loopCount; i++)
		{
			int lln;
			iss >> lln;
			v.push_back(lln);
			// errs() << lln << "\n";
		}

		int32_t instLine;
		string varName;
		bool isStore;
		iss >> instLine;
		iss >> varName;
		iss >> isStore;
		
		loopTuple t;
		t.loopLines = v;
		t.instLine = instLine;
		t.varName = varName;
		t.isStore = isStore;
		loopTuples.push_back(t);
		// errs() << " -- t.instLine: " << t.instLine << " t.varName: " << t.varName << " t.isStore: " << t.isStore << "\n";
	}
}


void ModuleFunc::createGetAddressFuncion() 
{
	Type* tp = Type::getInt64Ty(*ctx);
	ArrayRef<Type*> ft_args(tp);
	FunctionType* func_type = FunctionType::get(Type::getVoidTy(*ctx), ft_args, false);
	get_address_func = dyn_cast<Function>(mod->getOrInsertFunction("getVariableAddress", func_type));
}


void ModuleFunc::createLcOutputFunction() 
{
	FunctionType* func_type = FunctionType::get(Type::getVoidTy(*ctx), false);
	// errs() << "lcOutputFunc type created\n";
	lcOutputFunc = dyn_cast<Function>(mod->getOrInsertFunction("loop_counter_output", func_type));
	// errs() << "lcOutputFunc func created\n";
	if (lcOutputFunc == NULL)
		errs() << "  but still is null\n";
}

void ModuleFunc::insertLoopCounterIncInstruction(int32_t loop_lno, Instruction& firstLoopBodyInstr)  
{
	Type* tp = Type::getInt32Ty(*ctx);
	ArrayRef<Type*> ft_args(tp);
	FunctionType* func_type = FunctionType::get(Type::getVoidTy(*ctx), ft_args, false);
	Function* func = dyn_cast<Function>(mod->getOrInsertFunction("loop_counter_inc", func_type));
	Value* vp = ConstantInt::get(Type::getInt32Ty(*ctx), loop_lno);
	ArrayRef<Value*> args(vp);
	CallInst::Create(func, args, "", &firstLoopBodyInstr);
}

void ModuleFunc::instrumentLoops()
{
	set<Function*> loopsFunctions;
	for (std::set<int32_t>::iterator it = loopLines.begin(); it != loopLines.end(); ++it)
	{
		int32_t ln = *it;
		// errs() << "loopLines inside for loop: " << ln<<"\n";
		vector<Instruction*> instructions = lineToInstructionMap[ln];
		
		
		// for (vector<Instruction*>::iterator it = instructions.begin(); it!=instructions.end(); ++it)
		// {
		// 	Instruction* instr = *it;
		// 	BasicBlock* bb = instr->getParent();
		// 	Function* func = bb->getParent();
		// 	LoopInfo &LI = getAnalysis<LoopInfo>(*func);
		// 	Loop* L = LI.getLoopFor(bb);
		// 	if (L!=NULL && LI.isLoopHeader(bb)) 
		// 	{
		// 		Function::iterator b_nxt = ++bb;
		// 		BasicBlock *loopBodyBlock = dyn_cast<BasicBlock>(b_nxt);
		// 		Instruction *firstLoopBodyInstr = loopBodyBlock->begin();
		// 		insertLoopCounterIncInstruction(ln, *firstLoopBodyInstr);
		// 	}
		// }
		
		//errs()<<"instruction is "<<(instructions.size())<<"\n";
		if(instructions.size()==0)
		{
			continue; //had a bug on zero instruction size runtime error
		}
		Function* func = instructions[0]->getParent()->getParent();
				//errs()<<"func is "<<func<<"\n";
                std::size_t found;
				std::string fnName=func->getName();
				if(strcmp(fnName.c_str(),"NULL")!=0)
				{
					found=(func->getName().find("llvm"));
					if(found!=std::string::npos || func->isDeclaration()){
						continue;
					}
					
				loopsFunctions.insert(func);
				}
	}
	for (set<Function*>::iterator fi = loopsFunctions.begin(); fi!=loopsFunctions.end(); ++fi)
	{
		Function* func = *fi;
		LoopInfo &LI = getAnalysis<LoopInfo>(*func);
		Loop *L = NULL;
		for (Function::iterator b = func->begin(); b != func->end(); ++b) 
		{
			BasicBlock* BB = dyn_cast<BasicBlock>(b);

			L = LI.getLoopFor(BB);
			if (L!=NULL && LI.isLoopHeader(BB)) 
			{
				int32_t lno = getLineNumberOfLoop(L);
				if (std::find(loopLines.begin(), loopLines.end(), lno) != loopLines.end())
				{
					realLoopLines.insert(lno);
					Function::iterator b_nxt = ++b;
					BasicBlock *loopBodyBlock = dyn_cast<BasicBlock>(b_nxt);
					Instruction *firstLoopBodyInstr = loopBodyBlock->begin();
					// errs() << "insert loop inc at line " << lno << "\n"; 
					insertLoopCounterIncInstruction(lno, *firstLoopBodyInstr);
				}
			}
		}
	}
}

void ModuleFunc::instrumentLoopsInFunction(Function* func, LoopInfo& LI)
{
	Loop *L = NULL;
	for (Function::iterator b = func->begin(); b != func->end(); ++b) 
	{
		BasicBlock* BB = dyn_cast<BasicBlock>(b);

		L = LI.getLoopFor(BB);
		if (L!=NULL && LI.isLoopHeader(BB)) 
		{
			int32_t lno = getLineNumberOfLoop(L);
			
			Function::iterator b_nxt = ++b;
			BasicBlock *loopBodyBlock = dyn_cast<BasicBlock>(b_nxt);
			Instruction *firstLoopBodyInstr = loopBodyBlock->begin();
			insertLoopCounterIncInstruction(lno, *firstLoopBodyInstr);
		}
	}
}

void ModuleFunc::insertLoopCounterOutputInstruction(Function * func) 
{
	for (inst_iterator ii = inst_begin(func); ii!=inst_end(func); ++ii) 
	{
		Instruction* instr = &*ii;
		if (isa<ReturnInst>(instr)) 
		{
            IRBuilder<> IRB(instr);
			IRB.CreateCall(lcOutputFunc);
        }
	}
}

bool ModuleFunc::runOnModule(Module &M) 
{
	mod = &M;
	LLVMContext& context = getGlobalContext();
	ctx = &context;
/*	StringRef addOutput = AddOutput;
	std::string trueString = "true";*/
	Function* realMain = M.getFunction("main");
	bool doOutput = false;
	if (realMain)
		doOutput = true;
//	if (addOutput.str().compare(trueString) == 0)
	if (doOutput)
	{
		createLcOutputFunction();
		//Function* realMain = M.getFunction("main");
		insertLoopCounterOutputInstruction(realMain);

		// for (Function::iterator FI = realMain->begin(), FE = realMain->end(); FI != FE; ++FI) {
		// 	BasicBlock &BB = *FI;
		// 	runOnBasicBlock(BB);
		// }



		// Function::iterator main_end_it = realMain->end();
		// main_end_it--;
		// BasicBlock* last_bblock = dyn_cast<BasicBlock>(main_end_it);
		// BasicBlock::iterator lastBBIterator = last_bblock->end();
		// lastBBIterator--;
		// Instruction *last_instr = &(*lastBBIterator);
		// insertLoopCounterOutputInstruction(last_instr);

		// return true;
		// errs() << "output added \n";
	}

	createLineToInstAndInstToLoopLineMap(&M);
	createGetAddressFuncion();
	createAddStoreAndLoadInstRecordFunction();

	// StringRef funcName = InputFunctionName;
	// if (!funcName.empty())
	// {
	// 	errs() << "funcName=" << funcName.data() << "\n";
	// 	Function* func = M.getFunction(funcName.data());
	// 	instrumentLoopsInFunction(func, LI);
	// }
	// else
	// {
	//errs() << "111\n";
	StringRef inputFileName = InputFilename;
	if (inputFileName.empty()) //input is not given
	{
		//errs() << "222\n";
		instrumentLoopsInAllFunctons(&M);
                //errs() <<"22.22\n";
	}
	else
	{
		// errs() <<inputFileName<< "   *************************\n";
		const char* fileName = inputFileName.data();
		readLineNumberPairs(fileName);
		// if (needLoopInstrumentation)
			instrumentLoops(); //should change it later to instrument only input loops
	}
	insertMemoryInstructions();
	return true;
}

char ModuleFunc::ID = 0;
static RegisterPass<ModuleFunc> X("modulefunc", "Modulefunc Pass", false, false);
