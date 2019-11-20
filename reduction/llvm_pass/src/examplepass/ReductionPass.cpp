#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/IRBuilder.h"
//#include "llvm/Support/DPUtils.h"
#include "DPUtils.h"


#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/istreamwrapper.h"
#include "rapidjson/filereadstream.h"
#include <fstream>
#include <iostream>
#include <algorithm>
#include <string>
#include <sstream>
#include <set>



#define PROG_NAME "DataSharingClausePass=> "

#define TRUE true
#define FALSE false


using namespace llvm;
using namespace rapidjson;
using namespace std;
int32_t fileID;
map<string, llvm::Value*> VarNames;
map<string, MDNode*> Structs; 


typedef struct reduction_struct {
        int loopId;
        int redLine;
} reduction;

typedef struct reduction_var_struct {
		int loopId;
        int redLine;
        string varName;
		int reductionfileID;
        string op;
} reduction_var;

namespace {
	static bool defaultIsGlobalVariableValue;
	string FileMappingPath="./FileMapping.txt";
	
	struct ReductionPass: public FunctionPass {
	static char ID;
	vector<reduction> reductions;
	vector<reduction_var> reduction_vars;

	ReductionPass() : FunctionPass (ID) {}
	
//Determination of file id
int determineFileID(Function &F) {
    fileID = 0;

	// if FileMapping.txt is not given, we use 1 as file index
	if (!dputil::fexists(FileMappingPath))
	{
		int32_t fileID = 1;
	}
	else
	{
		for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI)
		{
			BasicBlock &BB = *FI;
			for (BasicBlock::iterator BI = BB.begin(), EI = BB.end(); BI != EI; ++BI)
			{
				if (BI->getDebugLoc().getLine())
				{
					MDNode *N = BI->getMetadata("dbg");
					// N == NULL means BI is only a helper instruction.
					// No metadata is attached to BI.
					if (N)
					{
						llvm::StringRef File = "", Dir = "";
						DILocation Loc(N);
						File = Loc.getFilename();
						Dir = Loc.getDirectory();

						char* absolutePathFileName = realpath((Dir.str() + "/" + File.str()).c_str(), NULL);

						if (absolutePathFileName == NULL)
						{
							absolutePathFileName = realpath(File.data(), NULL);
						}

						if (absolutePathFileName)
						{
							fileID = dputil::getFileID(FileMappingPath, string(absolutePathFileName));
							delete[] absolutePathFileName;
						}
						break;
					}
				}
			}
		}
	}
	return int(fileID);
}

int getLID(Instruction* BI)
{

	int32_t lid = 0;
	int32_t lno = BI->getDebugLoc().getLine();

	if (lno == 0) {
		return 0;
	}

	if (fileID == 0)
	{
		// Get the new fileID.
		llvm::StringRef File = "", Dir = "";
		MDNode *N = BI->getMetadata("dbg");
		if (N == NULL)
		{
			// N == NULL means BI is only a helper instruction.
			// No metadata is attached to BI.
			return 0;
		}
		llvm::DILocation Loc(N);
		File = Loc.getFilename();
		Dir = Loc.getDirectory();


		if (File.str().substr(0, 2) == "./")
		{
			std::string sub = File.str().substr(0, 2);
			File = File.substr(2, File.size() - 1);
		}

		fileID = dputil::getFileID(FileMappingPath, Dir.str() + "/" + File.str());

		// file is not in FileMapping.txt
		if (fileID == 0)
			return -1;


	}
	lid = (fileID << LIDSIZE) + lno;
	//ofmap << lid << std::endl;
	return lid;
}


	int determineLinenumber(string line)
	{
		int lineNumber=0;
		std::size_t pos1 = line.find(":");
		std::string loadLine = line.substr (pos1+1);
		//std::string strFileId=lidLoad.substr (0,pos1);
		lineNumber= atoi(loadLine.c_str());
		//fileIdOfVar=atoi(strFileId.c_str());
		return lineNumber;
	}
	
	int determineFileIdFromString(string line)
	{
		int fileId=0;
		std::size_t pos1 = line.find(":");
		std::string loadLine = line.substr (0,pos1);
		//std::string strFileId=lidLoad.substr (0,pos1);
		fileId= atoi(loadLine.c_str());
		//fileIdOfVar=atoi(strFileId.c_str());
		return fileId;
	}

	
string getOrInsertVarName(string varName, IRBuilder<>& builder) {
	llvm::Value* valName = NULL;
	std::string vName = varName;
	map<string, llvm::Value*>::iterator pair = VarNames.find(varName);
	if (pair == VarNames.end()) {
		valName = builder.CreateGlobalStringPtr(llvm::StringRef(varName.c_str()), ".str");

		VarNames[varName] = valName;
	}
	else {
		vName = pair->first;
	}

	return vName;
}

llvm::Type* pointsToStruct(PointerType* PTy) {
	llvm::Type* structType = PTy;
	if (PTy->getTypeID() == llvm::Type::PointerTyID) {
		while (structType->getTypeID() == llvm::Type::PointerTyID) {
			structType = cast<PointerType>(structType)->getElementType();
		}
	}
	return structType->getTypeID() == llvm::Type::StructTyID ? structType : NULL;
}


string findStructMemberName(MDNode* structNode, unsigned idx, IRBuilder<>& builder) {
	llvm::MDNode* memberListNodes = cast<MDNode>(structNode->getOperand(10));
	if (idx < memberListNodes->getNumOperands()) {
		assert(memberListNodes->getOperand(idx));
		MDNode* member = cast<MDNode>(memberListNodes->getOperand(idx));
		if (member->getOperand(3)) {
			//getOrInsertVarName(string(member->getOperand(3)->getName().data()), builder);
			//return string(member->getOperand(3)->getName().data());
			getOrInsertVarName(dyn_cast<MDString>(member->getOperand(3))->getString(), builder);
			return dyn_cast<MDString>(member->getOperand(3))->getString();
		}
	}
	return NULL;
}

string determineVariableName(Instruction* I, bool &isGlobalVariable=defaultIsGlobalVariableValue) {
	
	assert(I && "Instruction cannot be NULL \n");
	int index = isa<StoreInst>(I) ? 1 : 0;
	llvm::Value* operand = I->getOperand(index);

	IRBuilder<> builder(I);

	if (operand == NULL) {
		return getOrInsertVarName("", builder);
	}

	if (operand->hasName()) {
		//// we've found a global variable
		if (isa<GlobalVariable>(*operand)) {
			//MOHAMMAD ADDED THIS FOR CHECKING
			isGlobalVariable = true;
			return string(operand->getName());
		}
		if (isa<GetElementPtrInst>(*operand)) {
			GetElementPtrInst* gep = cast<GetElementPtrInst>(operand);
			llvm::Value* ptrOperand = gep->getPointerOperand();
			PointerType *PTy = cast<PointerType>(ptrOperand->getType());

			// we've found a struct/class
			llvm::Type* structType = pointsToStruct(PTy);
			if (structType && gep->getNumOperands() > 2) {
				llvm::Value* constValue = gep->getOperand(2);
				if (constValue && isa<ConstantInt>(*constValue)) {
					ConstantInt* idxPtr = cast<ConstantInt>(gep->getOperand(2));
					uint64_t memberIdx = *(idxPtr->getValue().getRawData());

					string strName(structType->getStructName().data());
					map<string, MDNode*>::iterator it = Structs.find(strName);
					if (it != Structs.end()) {
						std::string ret = findStructMemberName(it->second, memberIdx, builder);
						if (ret.size() > 0)
							return ret;
						else
							return getOrInsertVarName("", builder);
						//return ret;

					}
				}
			}

			// we've found an array
			if (PTy->getElementType()->getTypeID() == llvm::Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand)) {
				return determineVariableName((Instruction*)ptrOperand, isGlobalVariable);
			}
			return determineVariableName((Instruction*)gep, isGlobalVariable);
		}
		return string(operand->getName().data());
		//return getOrInsertVarName(string(operand->getName().data()), builder);
	}

	if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand)) {
		return determineVariableName((Instruction*)(operand), isGlobalVariable);
	}
	// if we cannot determine the name, then return *
	return "";//getOrInsertVarName("*", builder);
}	

virtual bool doInitialization(Module &M) {
		//Openning file to write reduction result
		ofstream myfile;	
		//myfile.open ("/home/dutta/test/testy/reduction.txt",std::ios_base::app);
		myfile.open ("./reduction.txt",std::ofstream::out | std::ofstream::trunc);
		myfile.clear();
		
		//Getting Reduction records
				std::ifstream file("./reductionResults.txt");
				std::string str; 
				int ReductionfileId=0;
				string varName;
				string operand;
				string operation;
				bool noRecordFound=TRUE;
				while (getline(file, str))
				{
					//errs()<<"str is"<<str<<"\n";
					//errs()<<"======================"<<"\n";
					std::size_t pos1 = str.find(","); 
					std::string fileIdLine = str.substr (0,pos1);
					std::size_t pos2 = fileIdLine.find(" ");
					std::string fileId=fileIdLine.substr (pos2+1);
					std::string lineIdLine = str.substr (pos1+2);
					std::size_t pos3 = lineIdLine.find(" ");
					std::string lineNum=lineIdLine.substr(pos3+1);
					//errs()<<"Line Num in red block::"<<lineNum<<"pos "<<pos3<<"\n";
					
					reduction r;
					r.loopId=atoi(fileId.c_str());
					r.redLine=atoi(lineNum.c_str());
					//r.redLine=std::stoi(lineNum.c_str());
					reductions.push_back(r);
				}
				for (vector<reduction>::iterator redIter = reductions.begin();redIter!=reductions.end(); ++redIter)
				{
					reduction tt=*redIter;
					// errs()<<"Val is "<<tt.loopId<<" "<<tt.redLine<<"\n";
					
				}
				
				
				
				// errs()<<"Loop reduction Finished"<<"\n";
				
				//Getting Reduction Data from instrumented file
				for (vector<reduction>::iterator redIter = reductions.begin();redIter!=reductions.end(); ++redIter)
				{
					reduction tt=*redIter;
					for (Module::iterator modIter = M.begin(), end = M.end(); modIter != end; ++modIter) 
					{
							//llvm::Function F=*modIter;
							//ReductionfileId=determineFileID(*modIter);
							//errs()<<"ReductionfileId: "<<ReductionfileId<<"\n";
							
						for (Function::iterator funcIter = modIter->begin(), end = modIter->end(); funcIter != end; ++funcIter) 
						{
							ReductionfileId=determineFileID(*modIter);
							// errs()<<"ReductionfileId: "<<ReductionfileId<<"\n";
							
							for(BasicBlock::iterator BI = funcIter->begin(), BE = funcIter->end(); BI != BE; ++BI) 
							{
								int lineNumber = getLID(BI);
								string lineNum=dputil::decodeLID(lineNumber);
								std::size_t pos1 = lineNum.find(":");
								std::string Line = lineNum.substr (pos1+1);
								int lineNum1=atoi(Line.c_str());
								//cout<<"Line Number is "<<lineNum1<<"\n";
								operand=BI->getOpcodeName();
								//For store operation
								//errs()<<"================================="<<"\n";
								//errs()<<"Operand is"<<operand.c_str()<<"\n";
								//errs()<<"================================="<<"\n";
								
								if(tt.redLine==lineNum1 && std::strcmp (operand.c_str(),"store") == 0)
								{
									operation="+";
								}
								
								//for substraction operation
								if(tt.redLine==lineNum1 && std::strcmp (operand.c_str(),"sub") == 0)
								{
									operation="-";
								}
								if(tt.redLine==lineNum1 && std::strcmp (operand.c_str(),"store") == 0)
								{
									varName=determineVariableName(BI);
									for (vector<reduction_var>::iterator redIter1 = reduction_vars.begin();redIter1!=reduction_vars.end(); ++redIter1)
									{
										reduction_var tt1=*redIter1;
										if((std::strcmp (tt1.varName.c_str(),varName.c_str()) == 0) && tt1.redLine==tt.redLine && tt1.loopId==tt.loopId && ReductionfileId==tt1.reductionfileID)
										{
												noRecordFound=false;
										}
									}
									// errs()<<"Reduction file id"<<ReductionfileId<<"\n";
									if(noRecordFound==true)
									{
										
										reduction_var rv;
										rv.loopId=tt.loopId;
										rv.redLine=tt.redLine;
										rv.varName=varName;
										rv.op=operation;
										rv.reductionfileID=ReductionfileId;
									
										reduction_vars.push_back(rv);
									}
								}
								
								if(tt.redLine==lineNum1 && std::strcmp (operand.c_str(),"sub") == 0)
								{
									varName=determineVariableName(BI);
									for (vector<reduction_var>::iterator redIter1 = reduction_vars.begin();redIter1!=reduction_vars.end(); ++redIter1)
									{
										reduction_var tt1=*redIter1;
										if((std::strcmp (tt1.varName.c_str(),varName.c_str()) == 0) && tt1.redLine==tt.redLine && tt1.loopId==tt.loopId && ReductionfileId==tt1.reductionfileID)
										{
											noRecordFound=false;
										}
									}
									// errs()<<"substraction"<<"\n";
									// errs()<<"Reduction file id"<<ReductionfileId<<"\n";
									if(noRecordFound==true)
									{
										
										reduction_var rv;
										rv.loopId=tt.loopId;
										rv.redLine=tt.redLine;
										rv.varName=varName;
										rv.op=operation;
										rv.reductionfileID=ReductionfileId;
									
										reduction_vars.push_back(rv);
									}
								}								
								
							}
						}
							
					}
					noRecordFound=true;
				}
				// errs()<<"Reduction partially end here"<<"\n";
				// errs()<<"Reduction size"<<reduction_vars.size()<<"\n";
				myfile << "\n";
				
				for (vector<reduction_var>::iterator redIter1 = reduction_vars.begin();redIter1!=reduction_vars.end(); ++redIter1)
				{
					reduction_var tt1=*redIter1;
					
					// errs()<<"Val is "<<tt1.varName<<" "<<tt1.loopId<<" "<<tt1.redLine<<" "<<tt1.op<<" FileID : "<<tt1.reductionfileID<<"\n";
					myfile << " FileID : "<<tt1.reductionfileID;
					myfile << " Loop Line Number : "<<tt1.loopId;
					myfile << " Reduction Line Number : "<<tt1.redLine;
					myfile << " Variable Name : "<<tt1.varName;
					myfile << " Operand Name : "<<tt1.op;
					myfile<<"\n";
					myfile<<"\n";
					
					
				}
				reduction_vars.clear();
				myfile.close();
				
				// errs()<<"Reduction end here"<<"\n";	
	return true;
}
    virtual bool runOnFunction(Function &F)
	{


	if (F.isDeclaration())
        return false;

    return false;

    }

};

} //namespace ends here

char ReductionPass::ID = 0;
static RegisterPass<ReductionPass> X("ReductionPass", "Reduction Pass", false, false);		

