#ifndef _DP_UTIL_H_
#define _DP_UTIL_H_

#include "llvm/Support/CommandLine.h"

#include <stdint.h>
#include <string>
#include <sstream>
#include <stdexcept>
#include <iostream>   // std::cerr 
#include <fstream>
#include <vector>
#include <utility>
#include <unistd.h>
#include <assert.h>

#define LIDSIZE 14       // Number of bits for holding LID
#define MAXLNO 16384     // Maximum number of lines in a single file. Has to be 2^LIDSIZE.

typedef int32_t LID;
typedef int64_t ADDR;
using namespace std;
using namespace llvm;

extern cl::opt<string> FileMappingPath;
namespace dputil {

inline string decodeLID(int32_t lid) {
	if (lid == 0)
		return "*";

	stringstream ss;
	uint32_t ulid = (uint32_t)lid;
	ss << (ulid >> LIDSIZE) << ":" << ulid % MAXLNO;
	return ss.str();
}

inline vector<string>* split(string input, char delim) {
	vector<string>* substrings = new vector<string>();
	istringstream inputStringStream(input);
	string sub;

	while(getline(inputStringStream, sub, delim)) {
		substrings->push_back(sub);
	}

	return substrings;
}


inline bool fexists(const string& filename) {
  ifstream ifile(filename.c_str());
  if(ifile.fail())
	  return false;
  else
      return true;
}


int32_t getFileID(string fileMapping, string fullPathName);

string get_exe_dir();

} // namespace
#endif
