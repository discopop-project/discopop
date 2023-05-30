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

#include "DPUtils.hpp"

#define DP_DEBUG_TYPE "dputils"
using namespace std;

cl::opt <string> FileMappingPath("fm-path", cl::init(""),
                                 cl::desc("Specify file mapping location"), cl::Hidden);

cl::opt <bool> DP_MEMORY_PROFILING_SKIP_FUNCTION_ARGUMENTS("memory-profiling-skip-function-arguments", cl::init(false),
                                                            cl::desc("disable the memory profiling for allocations which belong to function arguments"), cl::Hidden);                                 

namespace dputil {

    int32_t getFileID(string fileMapping, string fullPathName) {
        int32_t index = 0; // if the associated file id is not found, then we return 0
        string line;
        ifstream fileMap(fileMapping.c_str());

        if (fileMap.is_open()) {
            vector <string> *substrings = NULL;
            while (getline(fileMap, line)) {
                substrings = split(line, '\t');
                if (substrings->size() == 2) {
                    string indexString = (*substrings)[0];
                    string fileName = (*substrings)[1];
                    if (fileName.compare(fullPathName) == 0) {
                        index = (int32_t) atoi(indexString.c_str());
                        break;
                    }
                }
                delete substrings;
            }
            fileMap.close();
        }
        return index;
    }

// Encode the fileID and line number of BI as LID.
// Encode metadata regarding the instruction in the first LIDMETADATASIZE bits
// This is needed to support multiple files in a project.
    int64_t getLID(Instruction *BI, int32_t &fileID) {
        int64_t lid = 0;
        int32_t lno = 0;

        const DebugLoc &location = BI->getDebugLoc();
        if (location) {
            lno = BI->getDebugLoc().getLine();
        } else if (isa<AllocaInst>(BI) || isa<StoreInst>(BI)) {
            lno = BI->getFunction()->getSubprogram()->getLine();
        } else {
            return 0;
        }

        if (fileID == 0) {
            // Get the new fileID.
            StringRef File = "", Dir = "";
            MDNode *N = BI->getMetadata("dbg");
            if (N == NULL) {
                // N == NULL means BI is only a helper instruction.
                // No metadata is attached to BI.
                return 0;
            }
            const DebugLoc &location = BI->getDebugLoc();
            const DILocation *Loc = location.get();
            File = Loc->getFilename();
            Dir = Loc->getDirectory();


            if (File.str().substr(0, 2) == "./") {
                std::string sub = File.str().substr(0, 2);
                File = File.substr(2, File.size() - 1);
            }

            fileID = dputil::getFileID(FileMappingPath, Dir.str() + "/" + File.str());

            // file is not in FileMapping.txt
            if (fileID == 0)
                return -1;


        }
        lid = (fileID << LIDSIZE) + lno;
        
        // get and store metadata in the first 32 Bits if necessary
        // Layout metadata:
            // 8 bits reserved for loop id (added dynamically)
            // 8 bits reserved for loop iteration (added dynamically)
            // 16 bits unused
        // initialize loop id

        return lid;
    }

// Added for matching with AST nodes
// Returns the column for a given instruction
    int getColumn(Instruction *BI) {
        const DebugLoc &location = BI->getDebugLoc();

        //BI->print(errs());

        if (location) {
            //errs() << " (" << BI->getDebugLoc().getLine() << ", " << BI->getDebugLoc().getCol() << ")\n";
            return BI->getDebugLoc().getCol();
        }
        /*else if (isa<BranchInst>(BI)) {
            Instruction* prev_ins = BI->getPrevNode();
            DebugLoc prev_loc = prev_ins->getDebugLoc();
            errs() << "\n\nBranch\n";
            while (prev_ins) {
                prev_ins->print(errs());
                errs() << "\n";
                prev_ins = prev_ins->getPrevNode();
            }
        }*/
        
        //errs() << " error\n";

        /*Instruction* next_inst = BI->getNextNode();
        if(next_inst)
            return getColumn(next_inst);*/
        return -1;

    }

// determine the file index according to the given FileMapping
    void determineFileID(Function &F, int32_t &fileID) {
        fileID = 0;

        // if FileMapping.txt is not given, we use 1 as file index
        if (!dputil::fexists(FileMappingPath)) {
            fileID = 1;
        } else {
            for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
                BasicBlock &BB = *FI;
                for (BasicBlock::iterator BI = BB.begin(), EI = BB.end(); BI != EI; ++BI) {
                    int32_t lno;
                    const DebugLoc &location = BI->getDebugLoc();
                    if (location) {
                        lno = BI->getDebugLoc().getLine();
                    } else {
                        lno = 0;
                    }

                    if (lno) {
                        MDNode *N = BI->getMetadata("dbg");
                        // N == NULL means BI is only a helper instruction.
                        // No metadata is attached to BI.
                        if (N) {
                            StringRef File = "", Dir = "";
                            const DILocation *Loc = location.get();
                            File = Loc->getFilename();
                            Dir = Loc->getDirectory();

                            char *absolutePathFileName = realpath((Dir.str() + "/" + File.str()).c_str(), NULL);

                            if (absolutePathFileName == NULL) {
                                absolutePathFileName = realpath(File.data(), NULL);
                            }

                            if (absolutePathFileName) {
                                fileID = dputil::getFileID(FileMappingPath, string(absolutePathFileName));
                                delete[] absolutePathFileName;
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    string get_exe_dir() {
        char buff[1024];
        ssize_t len = ::readlink("/proc/self/exe", buff, sizeof(buff) - 1);
        if (len != -1) {
            buff[len] = '\0';
            string fullPath = std::string(buff);
            return fullPath.substr(0, fullPath.find_last_of('/'));
        } else {
            return "";
        }
    }

    VariableNameFinder::VariableNameFinder(Module &M) {
        DebugInfoFinder DIF;
        DIF.processModule(M);
        for (auto DI: DIF.types()) {
            if (auto CT = dyn_cast<DICompositeType>(DI)) {
                vector <string> v;
                for (auto E: CT->getElements()) {
                    if (auto DT = dyn_cast<DIDerivedType>(E)) {
                        v.push_back(DT->getName().str());
                    }
                }
                StructMemberMap.insert({CT->getName().str(), v});
            }
        }
    }

    string VariableNameFinder::getVarName(Value const *V) {
        if (const Instruction *I = dyn_cast<Instruction>(V)) {
            if (auto GEPI = dyn_cast<GetElementPtrInst>(I)) {
                Type *srcElemT = GEPI->getSourceElementType();
                string r = getVarName(GEPI->getOperand(0));

                if (GEPI->getNumOperands() == 2) {
                    return r;
                }

                if (dyn_cast<ConstantInt>(GEPI->getOperand(1))->getSExtValue() > 0) {
                    r += "";
                }

                if (isa<ArrayType>(srcElemT) || isa<IntegerType>(srcElemT)) {
                    return r;
                } else if (StructType * st = dyn_cast<StructType>(srcElemT)) {
                    if (st->hasName()) {
                        string structTypeName = st->getName().str();
                        if (structTypeName.find("struct.") != string::npos) {
                            structTypeName = structTypeName.erase(0, 7);
                        }
                        if (structTypeName.find("class.") != string::npos) {
                            structTypeName = structTypeName.erase(0, 6);
                        }
                        if (StructMemberMap.count(structTypeName) > 0) {
                            return r;
                        }
                    }
                }
                return r;
            }

            if (isa<SExtInst>(I)) {
                return getVarName(I->getOperand(0));
            }

            if (const BinaryOperator *binop = dyn_cast<BinaryOperator>(I)) {
                string op;
                switch (binop->getOpcode()) {
#define DP_DPUTILS_DEBUG 1
                    case Instruction::BinaryOps::Add:
                        op = "+";
                        break;
                    case Instruction::BinaryOps::FAdd:
                        op = "+";
                        break;
                    case Instruction::BinaryOps::Sub:
                        op = "-";
                        break;
                    case Instruction::BinaryOps::FSub:
                        op = "-";
                        break;
                    case Instruction::BinaryOps::Mul:
                        op = "*";
                        break;
                    case Instruction::BinaryOps::FMul:
                        op = "*";
                        break;
                    case Instruction::BinaryOps::UDiv:
                        op = "/";
                        break;
                    case Instruction::BinaryOps::SDiv:
                        op = "/";
                        break;
                    case Instruction::BinaryOps::FDiv:
                        op = "/";
                        break;
                    case Instruction::BinaryOps::URem:
                        op = "%";
                        break;
                    case Instruction::BinaryOps::SRem:
                        op = "%";
                        break;
                    case Instruction::BinaryOps::FRem:
                        op = "%";
                        break;
                    case Instruction::BinaryOps::Shl:
                        op = "<<";
                        break;
                    case Instruction::BinaryOps::LShr:
                        op = ">>";
                        break;
                    case Instruction::BinaryOps::AShr:
                        op = ">>";
                        break;
                    case Instruction::BinaryOps::And:
                        op = "&&";
                        break;
                    case Instruction::BinaryOps::Or:
                        op = "||";
                        break;
                    case Instruction::BinaryOps::Xor:
                        op = "^^";
                        break;

                        // robust solution to API changes (e.g. llvm adds more instruction types)
                        // case Instruction::BinaryOps::BinaryOpsEnd: // fall through
                    default:
#ifdef DP_DEBUG_TYPE
                        errs()
                                << "DPUTils VariableNameFinder::getVarName:  did not consider enum value in switch on BinaryOperator";
#endif
                        break;


                }
                return getVarName(I->getOperand(0)) + op + getVarName(I->getOperand(1));
            }

            if (isa<StoreInst>(I) || isa<LoadInst>(I)) {
                Value *v = I->getOperand((isa<StoreInst>(I) ? 1 : 0));
                if (isa<LoadInst>(v)) return "*" + getVarName(v);
                return getVarName(v);
            }
        }

        if (const GEPOperator *gepo = dyn_cast<GEPOperator>(V)) {
            if (const GlobalVariable *gv = dyn_cast<GlobalVariable>(gepo->getPointerOperand())) {
                string r = gv->getGlobalIdentifier();
                Type *st = gepo->getSourceElementType();
                if (StructType * ct = dyn_cast<StructType>(st)) {
                    string structTypeName = ct->getName().str().erase(0, 7);
                    r += "";
                    return r;
                }
            }
        }

        if (const ConstantInt *CI = dyn_cast<ConstantInt>(V)) {
            return to_string(CI->getSExtValue());
        }

        if (V->hasName()) {
            string r = V->getName().str();
            std::size_t found = r.find(".addr");
            if (found != string::npos) {
                return r.erase(found);
            }
            return r;
        }
        return "!";
    }

}//namespace
