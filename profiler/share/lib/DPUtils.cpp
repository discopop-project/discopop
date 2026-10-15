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

#include "DPUtils.hpp"

#include <set>
#include <string>

#define DP_DEBUG_TYPE "dputils"

using dputil::VariableNameFinder;
using dputil::determineFileID;
using dputil::encodeLID;
using dputil::getFileID;
using dputil::getLID;
using dputil::get_exe_dir;
using llvm::AllocaInst;
using llvm::BasicBlock;
using llvm::BinaryOperator;
using llvm::ConstantInt;
using llvm::DILocation;
using llvm::DebugLoc;
using llvm::Function;
using llvm::GEPOperator;
using llvm::GetElementPtrInst;
using llvm::GlobalValue;
using llvm::GlobalVariable;
using llvm::Instruction;
using llvm::LoadInst;
using llvm::MDNode;
using llvm::Module;
using llvm::SExtInst;
using llvm::StoreInst;
using llvm::StringRef;
using llvm::StructType;
using llvm::Value;
using llvm::dyn_cast;
using llvm::errs;
using llvm::isa;

// cl::opt <string> FileMappingPath("fm-path", cl::init(""),
//                                  cl::desc("Specify file mapping location"),
//                                  cl::Hidden);
std::string FileMappingPath = "";

llvm::cl::opt<bool>
    DP_MEMORY_PROFILING_SKIP_FUNCTION_ARGUMENTS("memory-profiling-skip-function-arguments", llvm::cl::init(false),
                                                llvm::cl::desc("disable the memory profiling for allocations which belong to "
                                                         "function arguments"),
                                                llvm::cl::Hidden);

namespace dputil {

std::int32_t getFileID(std::string /*fileMapping*/, std::string fullPathName) {
  // prepare environment variables
  if (FileMappingPath.length() == 0) {
    char const *tmp = std::getenv("DOT_DISCOPOP");
    if (tmp == nullptr) {
      // DOT_DISCOPOP needs to be initialized
      setenv("DOT_DISCOPOP", ".discopop", 1);
    }
    FileMappingPath = std::getenv("DOT_DISCOPOP");
    FileMappingPath += "/FileMapping.txt";
  }

  // check if path in DP_PROJECT_ROOT_DIR
  std::string dp_project_dir(dputil::getEnvOrDefault("DP_PROJECT_ROOT_DIR", "/"));
  if (fullPathName.find(dp_project_dir) == std::string::npos) // function defined outside project
  {
    return 0;
  }

  // Keep FileMapping.txt in an in-memory cache. getFileID is called per-instruction, so
  // re-reading the file on every call dominates the pass runtime.
  static std::map<std::string, std::int32_t> fileIdCache;
  static std::int32_t nextFileId = 1;
  static bool fileMappingLoaded = false;

  auto loadFileMapping = [&]() {
    std::fstream fileMappingFile;
    fileMappingFile.open(FileMappingPath.data(), std::ios::in);
    if (fileMappingFile) {
      std::string tp;
      while (std::getline(fileMappingFile, tp)) {
        std::size_t tab = tp.find("\t");
        if (tab == std::string::npos) {
          continue;
        }
        std::int32_t id = std::stoi(tp.substr(0, tab));
        std::string file_name = tp.substr(tab + 1);
        fileIdCache[file_name] = id;
        if (id >= nextFileId) {
          nextFileId = id + 1;
        }
      }
      fileMappingFile.close();
    }
    fileMappingLoaded = true;
  };

  if (!fileMappingLoaded) {
    loadFileMapping();
  }

  // hot path: in-memory lookup, no file I/O
  auto cached = fileIdCache.find(fullPathName);
  if (cached != fileIdCache.end()) {
    return cached->second;
  }

  // Miss. FileMapping.txt is shared by all compiler processes of a build and is not
  // necessarily pre-generated (see the dp-fmap script), so a file unknown to this process may
  // well have been registered by a concurrently running one in the meantime. Re-read the file
  // before handing out a new id, otherwise two processes assign the same id to different
  // files. Only the miss path pays for this, the cached lookups above stay free.
  // NOTE: the append below remains racy - two processes missing at the same time still end up
  // with the same id. Removing that window requires locking the file.
  loadFileMapping();
  cached = fileIdCache.find(fullPathName);
  if (cached != fileIdCache.end()) {
    return cached->second;
  }

  // still unknown: assign a new id, persist it once, and cache it
  std::int32_t tempfid = nextFileId++;
  std::fstream fileMappingFile;
  fileMappingFile.open(FileMappingPath.data(), std::ios_base::app);
  fileMappingFile << tempfid << "\t" << fullPathName << "\n";
  fileMappingFile.close();
  fileIdCache[fullPathName] = tempfid;
  return tempfid;
  /*
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
  */
}

std::int64_t encodeLID(std::int32_t fileID, std::int64_t line) {
  static std::set<std::int32_t> warnedFileIDs;
  if (fileID < 0 || fileID > MAXFILEID) {
    if (warnedFileIDs.insert(fileID).second) {
      errs() << "DiscoPoP: warning: the file id " << fileID << " exceeds the maximum of " << MAXFILEID
             << " files, its instructions are not instrumented\n";
    }
    return 0;
  }
  if (line < 0 || line >= MAXLNO) {
    if (warnedFileIDs.insert(fileID).second) {
      errs() << "DiscoPoP: warning: line " << line << " of the file with the id " << fileID << " exceeds the maximum of "
             << MAXLNO - 1 << " lines, its instructions are not instrumented (see FileMapping.txt for the file)\n";
    }
    return 0;
  }
  return (static_cast<std::int64_t>(fileID) << LIDSIZE) + line;
}

// Encode the fileID and line number of BI as LID.
// Encode metadata regarding the instruction in the first LIDMETADATASIZE bits
// This is needed to support multiple files in a project.
std::int64_t getLID(Instruction *BI, std::int32_t &fileID) {
  // prepare environment variables
  if (FileMappingPath.length() == 0) {
    char const *tmp = std::getenv("DOT_DISCOPOP");
    if (tmp == nullptr) {
      // DOT_DISCOPOP needs to be initialized
      setenv("DOT_DISCOPOP", ".discopop", 1);
    }
    FileMappingPath = std::getenv("DOT_DISCOPOP");
    FileMappingPath += "/FileMapping.txt";
  }

  std::int32_t lno = 0;

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
    if (N == nullptr) {
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

    const std::string fullPathName = Dir.str() + "/" + File.str();
    fileID = dputil::getFileID(FileMappingPath, fullPathName);

    // file is not in FileMapping.txt: there is no location to report. 0 means "no location" to every caller
    // (they do not instrument the instruction); -1 would have been instrumented as the location 262143:16383
    if (fileID == 0) {
      static std::set<std::string> warnedFiles;
      if (warnedFiles.insert(fullPathName).second) {
        errs() << "DiscoPoP: warning: " << fullPathName
               << " is not in the file mapping or outside of DP_PROJECT_ROOT_DIR, its instructions are not "
                  "instrumented\n";
      }
      return 0;
    }
  }
  return encodeLID(fileID, lno);
}

// determine the file index according to the given FileMapping
void determineFileID(Function &F, std::int32_t &fileID) {
  // prepare environment variables
  if (FileMappingPath.length() == 0) {
    char const *tmp = std::getenv("DOT_DISCOPOP");
    if (tmp == nullptr) {
      // DOT_DISCOPOP needs to be initialized
      setenv("DOT_DISCOPOP", ".discopop", 1);
    }
    FileMappingPath = std::getenv("DOT_DISCOPOP");
    FileMappingPath += "/FileMapping.txt";
  }
  fileID = 0;

  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    BasicBlock &BB = *FI;
    for (BasicBlock::iterator BI = BB.begin(), EI = BB.end(); BI != EI; ++BI) {
      std::int32_t lno;
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

          char *absolutePathFileName = realpath((Dir.str() + "/" + File.str()).c_str(), nullptr);

          if (absolutePathFileName == nullptr) {
            absolutePathFileName = realpath(File.data(), nullptr);
          }

          if (absolutePathFileName) {
            fileID = dputil::getFileID(FileMappingPath, std::string(absolutePathFileName));
            std::free(absolutePathFileName); // allocated by realpath
          }
          // the first instruction with a debug location determines the file
          return;
        }
      }
    }
  }
}

std::string get_exe_dir() {
  char buff[1024];
  ssize_t len = ::readlink("/proc/self/exe", buff, sizeof(buff) - 1);
  if (len != -1) {
    buff[len] = '\0';
    std::string fullPath = std::string(buff);
    return fullPath.substr(0, fullPath.find_last_of('/'));
  }     return "";

}

VariableNameFinder::VariableNameFinder(Module & /*M*/) {}

std::string VariableNameFinder::getVarName(Value const *V) {
  if (const Instruction *I = dyn_cast<Instruction>(V)) {
    if (auto GEPI = dyn_cast<GetElementPtrInst>(I)) {
      // an element (of an array, of a struct) is named like the object it belongs to
      return getVarName(GEPI->getOperand(0));
    }

    if (isa<SExtInst>(I)) {
      return getVarName(I->getOperand(0));
    }

    if (const BinaryOperator *binop = dyn_cast<BinaryOperator>(I)) {
      std::string op;
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

        // robust solution to API changes (e.g. llvm adds more instruction
        // types) case Instruction::BinaryOps::BinaryOpsEnd: // fall through
      default:
#ifdef DP_DEBUG_TYPE
        errs() << "DPUTils VariableNameFinder::getVarName:  did not consider "
                  "enum value in switch on BinaryOperator";
#endif
        break;
      }
      return getVarName(I->getOperand(0)) + op + getVarName(I->getOperand(1));
    }

    if (isa<StoreInst>(I) || isa<LoadInst>(I)) {
      Value *v = I->getOperand((isa<StoreInst>(I) ? 1 : 0));
      if (isa<LoadInst>(v)) {
        return "*" + getVarName(v);
}
      return getVarName(v);
    }
  }

  if (const GEPOperator *gepo = dyn_cast<GEPOperator>(V)) {
    if (const GlobalVariable *gv = dyn_cast<GlobalVariable>(gepo->getPointerOperand())) {
      if (isa<StructType>(gepo->getSourceElementType())) {
        return GlobalValue::getGlobalIdentifier(gv->getName(), gv->getLinkage(), gv->getParent()->getSourceFileName());
      }
    }
  }

  if (const ConstantInt *CI = dyn_cast<ConstantInt>(V)) {
    return std::to_string(CI->getSExtValue());
  }

  if (V->hasName()) {
    std::string r = V->getName().str();
//    std::size_t found = r.find(".addr");
//    if (found != string::npos) {
//      return r.erase(found);
//    }
    return r;
  }
  return "!";
}

} // namespace dputil
