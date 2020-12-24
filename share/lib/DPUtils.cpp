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

#include "DPUtils.h"

using namespace std;

cl::opt<string> FileMappingPath("fm-path", cl::init(""),
	cl::desc("Specify file mapping location"), cl::Hidden);

namespace dputil {

int32_t getFileID(string fileMapping, string fullPathName) {
	int32_t index = 0; // if the associated file id is not found, then we return 0
	string line;
	ifstream fileMap(fileMapping.c_str());

	if (fileMap.is_open()) {
		vector<string>* substrings = NULL;
		while (getline(fileMap, line)) {
			substrings = split(line, '\t');
			if (substrings->size() == 2) {
				string indexString = (*substrings)[0];
				string fileName = (*substrings)[1];
				if (fileName.compare(fullPathName) == 0) {
					index = (int32_t)atoi(indexString.c_str());
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
// This is needed to support multiple files in a project.
int32_t getLID(Instruction* BI, int32_t& fileID)
{
    int32_t lid = 0;
    int32_t lno;

    const DebugLoc &location = BI->getDebugLoc();
    if (location)
    {
        lno = BI->getDebugLoc().getLine();
    }
    else
    {
        lno = 0;
    }


    if (lno == 0)
    {
        return 0;
    }

    if (fileID == 0)
    {
        // Get the new fileID.
        StringRef File = "", Dir = "";
        MDNode *N = BI->getMetadata("dbg");
        if (N == NULL)
        {
            // N == NULL means BI is only a helper instruction.
            // No metadata is attached to BI.
            return 0;
        }
        // NOTE: Replace  next 3 lines with next 3 lines
        // DILocation Loc(N);
        // File = Loc.getFilename();
        // Dir = Loc.getDirectory();
        const DebugLoc &location = BI->getDebugLoc();
        const DILocation *Loc = location.get();
        File = Loc->getFilename();
        Dir = Loc->getDirectory();


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

// determine the file index according to the given FileMapping
void determineFileID(Function &F, int32_t& fileID)
{
    fileID = 0;

    // if FileMapping.txt is not given, we use 1 as file index
    if (!dputil::fexists(FileMappingPath))
    {
        fileID = 1;
    }
    else
    {
        for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI)
        {
            BasicBlock &BB = *FI;
            for (BasicBlock::iterator BI = BB.begin(), EI = BB.end(); BI != EI; ++BI)
            {
                int32_t lno;
                const DebugLoc &location = BI->getDebugLoc();
                if (location)
                {
                    lno = BI->getDebugLoc().getLine();
                }
                else
                {
                    lno = 0;
                }

                if (lno)
                {
                    MDNode *N = BI->getMetadata("dbg");
                    // N == NULL means BI is only a helper instruction.
                    // No metadata is attached to BI.
                    if (N)
                    {
                        StringRef File = "", Dir = "";
                        // NOTE: Replace  next 3 lines with next 3 lines
                        // DILocation Loc(N);
                        // File = Loc.getFilename();
                        // Dir = Loc.getDirectory();
                        const DILocation *Loc = location.get();
                        File = Loc->getFilename();
                        Dir = Loc->getDirectory();

                        char *absolutePathFileName = realpath((Dir.str() + "/" + File.str()).c_str(), NULL);

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
    // if(fileID == 0)
    //     errs() << "------------ " << F.getName() << "\n";
}

string get_exe_dir() {
	char buff[1024];
	ssize_t len = ::readlink("/proc/self/exe", buff, sizeof(buff)-1);
    if (len != -1) {
		buff[len] = '\0';
		string fullPath = std::string(buff);
		return fullPath.substr(0, fullPath.find_last_of('/'));
    } else {
		return "";     
    }
}

}//namespace
