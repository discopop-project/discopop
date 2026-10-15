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

#pragma once

#include <assert.h>
#include <fstream>
#include <iostream> // std::cerr
#include <sstream>
#include <stdexcept>
#include <stdint.h>
#include <string>
#include <unistd.h>
#include <utility>
#include <vector>

#include "DPTypes.hpp"


namespace dputil {

inline void decodeLID(std::int64_t lid, std::ostream &out) {
  if (lid == 0) {
    out << '*';
    return;
  }

  // unpack metadata
  // potentially TODO, currently not necessary

  // remove metadata
  lid &= 0x00000000FFFFFFFF;

  out << (lid >> LIDSIZE) << ':' << lid % MAXLNO;
}

inline std::string decodeLID(std::int64_t lid) {
  std::stringstream ss;
  decodeLID(lid, ss);
  return ss.str();
}

inline std::vector<std::string> *split(std::string input, char delim) {
  std::vector<std::string> *substrings = new std::vector<std::string>();
  std::istringstream inputStringStream(input);
  std::string sub;

  while (getline(inputStringStream, sub, delim)) {
    substrings->push_back(sub);
  }

  return substrings;
}

inline int32_t getFileID(std::string fileMapping, std::string fullPathName) {
  int32_t index = 0; // if the associated file id is not found, then we return 0
  std::string line;
  std::ifstream fileMap(fileMapping.c_str());

  if (fileMap.is_open()) {
    std::vector<std::string> *substrings = NULL;
    while (getline(fileMap, line)) {
      substrings = split(line, '\t');
      bool found = false;
      if (substrings->size() == 2) {
        std::string indexString = (*substrings)[0];
        std::string fileName = (*substrings)[1];
        if (fileName.compare(fullPathName) == 0) {
          index = (int32_t)atoi(indexString.c_str());
          found = true;
        }
      }
      // split() hands out ownership, so the line has to be released on the way out as well
      substrings->clear();
      delete substrings;
      if (found) {
        break;
      }
    }
    fileMap.close();
  }
  return index;
}

inline bool fexists(const std::string &filename) {
  std::ifstream ifile(filename.c_str());

  if (ifile.fail())
    return false;
  else
    return true;
}

inline std::string get_exe_dir() {
  char buff[1024];
  ssize_t len = ::readlink("/proc/self/exe", buff, sizeof(buff) - 1);
  if (len != -1) {
    buff[len] = '\0';
    std::string fullPath = std::string(buff);
    return fullPath.substr(0, fullPath.find_last_of('/'));
  } else {
    return "";
  }
}

} // namespace dputil
