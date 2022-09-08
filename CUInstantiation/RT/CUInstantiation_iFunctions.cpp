#include <cstdio>
#include <map>
#include <unordered_map>
#include <vector>
#include <string>
#include <stdint.h>
#include <sstream>
#include <stdexcept>
#include <iostream>   // std::cerr
#include <fstream>
#include <utility>
#include <unistd.h>
#include <assert.h>
#include <set>
#include <algorithm>

#ifdef __linux__                    // headers only available on Linux
#include <unistd.h>
#include <linux/limits.h>
#endif

#define LIDSIZE 14    // Number of bits for holding LID
#define MAXLNO 16384  // Maximum number of lines in a single file. Has to be 2^LIDSIZE.

typedef int32_t LID;
typedef int64_t ADDR;

using namespace std;

bool CUInst_DEBUG = false;        // debug flag


namespace __CUInst {

    map<int, int> *stack = nullptr;
    map<int, int> *PIDs = nullptr;
    map<int, int> *counters = nullptr;

    map<string,string> *finalResults = nullptr;
    set<string> *readResults = nullptr;
    set<string> *writeResults = nullptr;
    set<string> *writeIntermediateResults = nullptr;

    set<string> *results = nullptr;

    set<ADDR> *writtenAddresses = nullptr;

    map<ADDR, vector<int>> *signature; // the map from memory addresses to PID calls.

    ofstream *out;

    bool flag;

/******* Helper functions *******/
    vector<string> split(const string &s, const char delim) {
    stringstream ss(s);
    string tmp;
    vector<string> out;
    while (getline(ss, tmp, delim)) {
        out.emplace_back(tmp);
    }
    return out;
}

LID encodeLID(const string s) {
    vector<string> tmp = split(s, ':');
    return (static_cast<LID>(stoi(tmp[0])) << LIDSIZE) + static_cast<LID>(stoi(tmp[1]));
}

// decode LID to string
string decodeLID(LID lid) {
    if (lid == 0)
        return "*";

    stringstream ss;
    ss << (lid >> LIDSIZE) << ":" << lid % MAXLNO;
    return ss.str();
}
/*
vector<int> vectorizePIDs(){
    vector<int> convertedPIDs;

    for(auto i = PIDs->begin(); i != PIDs->end(); i++ ){

        convertedPIDs.push_back(i->second);
    }
    return convertedPIDs;
}
*/
vector<int> getVectorizedPIDs(int index){
    vector<int> convertedPIDs;
    for(int i = 0; i < PIDs->size(); i++){
        if(i == index){
            convertedPIDs.push_back((*PIDs)[index]);
        }else{
            convertedPIDs.push_back(0);
        }
    }
    return convertedPIDs;
}
/*
bool checkVectorIsZero(vector<int> inVector){

    for(auto i: inVector){
        if( i != 0)
            return false;
    }
    return true;
}
*/
/******* END Helper functions *******/

/******* Instrumentation functions *******/

//The wrapper is to avoid mangling
extern "C"{

//void __CUInstantiationInitialize(char* allFunctionIndices){
void __CUInstantiationInitialize(char* allFunctionIndices){
    stack = new map<int, int>();
    PIDs = new map<int, int>();
    counters = new map<int, int>();
    signature = new map<ADDR, vector<int>>();

    finalResults = new map<string,string>();
    readResults = new set<string>();
    writeResults = new set<string>();
    writeIntermediateResults = new set<string>();

    results = new set<string>();

    writtenAddresses = new set<ADDR>();

    out = new ofstream();

    flag = false;

    string allFIndices(allFunctionIndices);

    for(auto i:split(allFIndices, ' ')){

        if(i.empty())
            continue;

        int index = stoi(i);

        (*stack)[index] = 0;
        (*PIDs)[index] = 0;
        (*counters)[index] = 0;
    }

    #ifdef __linux__
        // try to get an output file name w.r.t. the target application
        // if it is not available, fall back to "Output.txt"
    char* selfPath = new char[PATH_MAX];
    if (selfPath != nullptr) {
        if (readlink("/proc/self/exe", selfPath, PATH_MAX - 1) == -1) {
            delete[] selfPath;
            selfPath = nullptr;
            out->open("CUInstResult.txt", ios::out);
        }
        out->open(string(selfPath) + "_CUInstResult.txt", ios::out);
        cout << "CII: IF" << endl;
    }
    #else
        {
          out->open("CUInstResult.txt", ios::out);
          cout << "CII: ELSE"
        }
    #endif
        assert(out->is_open() && "Cannot open a file to output CU instantiation results.\n");
        if (CUInst_DEBUG) {
            cout << "CUInst initialized at the beginning of main function." << endl;
        }
}

void __CUInstantiationRead(LID lid, int pidIndex, ADDR addr, char* fName, char* varName) {

    /*
    map<int, int> *PIDsTmp = new map<int, int>();
    map<ADDR, vector<int>> *signatureTmp = new map<ADDR, vector<int>>();
    string read;
    string readRes;
    string readResComplete;

    (*PIDsTmp)[pidIndex] = (*PIDs)[pidIndex];

    if((*PIDs)[pidIndex] != 0){
        if(writtenAddresses->find(addr) != writtenAddresses->end()){
            readResComplete = to_string(addr) + " " + to_string(pidIndex) + " " + to_string((*PIDs)[pidIndex]);
            if(writeResults->find(readResComplete) == writeResults->end()){
                readRes = to_string(addr) + " " + to_string(pidIndex);
                if(writeIntermediateResults ->find(readRes) != writeIntermediateResults->end()){
                    readResults->insert(readResComplete);
                }
            }
        }
    }
    */
    if (CUInst_DEBUG) {
        *out << "DEBUG: instLoad at encoded LID " << decodeLID(lid) << " and addr " << std::hex << addr << " varname: " << varName << endl;

    }

    // reminder: map<ADDR, vector<int>> *signature; // the map from memory addresses to PID calls.
    // reminder: PIDs = new map<int, int>();

    if((*PIDs)[pidIndex] == 0)
        return;
    else if((*signature).count(addr) ==  0){
        if (CUInst_DEBUG) {
          *out << "READ_1" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\tADDR: " << addr << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
        }
        return;
      }
    /*
    else if((*signature)[addr][pidIndex] == 0){
      if (CUInst_DEBUG) {
          *out << "READ_2" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
          *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
      }
        return;
      }
    */
    else if((*signature)[addr][pidIndex] == (*PIDs)[pidIndex]){
        if (CUInst_DEBUG) {
          *out << "READ_3" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\tADDR: " << addr << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
          *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
        }
        return;
      }
    else if((*signature)[addr][pidIndex] != (*PIDs)[pidIndex]){
      if (CUInst_DEBUG) {
          *out << "READ_4 ACCEPTED" << endl;
      }

        string res = "RAW in line: " + decodeLID(lid)
                    //+ ", ADDR: " + to_string(addr)
                    + ", variable: " + string(varName);
                    //+ ", PIDIndex: " + to_string(pidIndex)
                    //+ ", Signature[" + to_string(pidIndex) + "]:" + to_string((*signature)[addr][pidIndex])
                    //+ ", PIDs[" + to_string(pidIndex) + "]: " + to_string((*PIDs)[pidIndex]);
                    //+ ", stack[" + to_string(pidIndex) + "]: " + to_string((*stack)[pidIndex]);

        //string readRes = to_string(addr) + " " + string(varName) + " " + string(fName);
        results->insert(res);

        //finalResults->insert(pair<string,string>(readRes, res));

        //*out << res << endl;
    }

}

void __CUInstantiationWrite(LID lid, int pidIndex, ADDR addr, char* fName, char* varName) {

    /*
    map<int, int> *PIDsTmp = new map<int, int>();
    map<ADDR, vector<int>> *signatureTmp = new map<ADDR, vector<int>>();

    (*PIDsTmp)[pidIndex] = (*PIDs)[pidIndex];

    if((*PIDs)[pidIndex] != 0){
        writtenAddresses->insert(addr);
        string writeIntermediateRes = to_string(addr) + " " + to_string(pidIndex);
        writeIntermediateResults->insert(writeIntermediateRes);
        string writeRes = to_string(addr) + " " + to_string(pidIndex) + " " + to_string((*PIDs)[pidIndex]);
        writeResults->insert(writeRes);
    }
    */

    if (CUInst_DEBUG) {
        *out << "DEBUG: instStore at encoded LID " << std::dec << decodeLID(lid) << " and addr " << std::hex << addr << " varname: " << varName << endl;
    }

    if((*PIDs)[pidIndex] == 0)
        return;
    else if((*signature).count(addr) == 0){
      if (CUInst_DEBUG) {
          *out << "WRITE_1" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\tADDR: " << addr << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
      }
        (*signature)[addr] = getVectorizedPIDs(pidIndex);

        if(CUInst_DEBUG){
          *out << "after Write:" << endl;
          *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
        }
    }
    /*else if((*signature)[addr][pidIndex] == 0){
      if (CUInst_DEBUG) {
          *out << "WRITE_2" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\tADDR: " << addr << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
          *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
      }
        (*signature)[addr][pidIndex] = (*PIDs)[pidIndex];
      if(CUInst_DEBUG){
        *out << "after Write:" << endl;
        *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
      }
    }*/
     else if((*signature)[addr][pidIndex] != (*PIDs)[pidIndex]){
      if (CUInst_DEBUG) {
          *out << "WRITE_3 ACCEPTED" << endl;
          *out << "\tpidIndex: " << pidIndex << endl;
          *out << "\tADDR: " << addr << endl;
          *out << "\t(*PIDs)[pidIndex]: " << (*PIDs)[pidIndex] << endl;
          *out << "\t(*signature)[addr][pidIndex]: " << (*signature)[addr][pidIndex] << endl;
      }
        string res = "WAW in function: " + string(fName) + ", line: " + decodeLID(lid) + ", variable: " + string(varName);
        results->insert(res);

        //string writeRes = to_string(addr) + " " + string(varName) + " " + string(fName);
        //writeResults->insert(writeRes);

        (*signature)[addr][pidIndex] = (*PIDs)[pidIndex];
    }

}

void __CUInstantiationCallBefore(int index) {

    map<int, int> *stackTmp = new map<int, int>();
    map<int, int> *PIDsTmp = new map<int, int>();
    map<int, int> *countersTmp = new map<int, int>();
    map<ADDR, vector<int>> *signatureTmp = new map<ADDR, vector<int>>();

    if (CUInst_DEBUG) {
        *out << "DEBUG: beforeInstCall in function " << index << endl;
    }

    (*stackTmp)[index] = (*stack)[index];
    (*PIDsTmp)[index] = (*PIDs)[index];
    (*countersTmp)[index] = (*counters)[index];

    if((*stack)[index] == 0){
        (*counters)[index]++;
        (*PIDs)[index] = (*counters)[index];

        (*countersTmp)[index]++;
        (*PIDsTmp)[index] = (*countersTmp)[index];
    }

    (*stack)[index]++;
    (*stackTmp)[index]++;
}

void __CUInstantiationCallAfter(int index, int lastCall) {

    map<int, int> *stackTmp = new map<int, int>();
    map<int, int> *PIDsTmp = new map<int, int>();
    map<int, int> *countersTmp = new map<int, int>();
    map<ADDR, vector<int>> *signatureTmp = new map<ADDR, vector<int>>();

    if (CUInst_DEBUG) {
        *out << "DEBUG: afterInstCall in function " << index << endl;
    }

    (*stackTmp)[index] = (*stack)[index];
    (*PIDsTmp)[index] = (*PIDs)[index];
    (*countersTmp)[index] = (*counters)[index];

    (*stackTmp)[index]--;
    (*stack)[index]--;
    if((*stack)[index] == 0){

        if(lastCall == 1){
            (*countersTmp)[index] = 0;
            (*counters)[index] = 0;

            (*PIDs)[index] = 0;
            (*PIDsTmp)[index] = 0;

            //Delete (* pidIndex PIDs[pidIndex]) tuples from writeResults

            /*
            for (set<string>::iterator it = writeResults->begin(); it != writeResults->end(); it++){
                string temp = " " + to_string(index) + " ";
                if(it->find(temp) != string::npos){
                    writeResults->erase(it);
                }
            }

            for (set<string>::iterator it = writeIntermediateResults->begin(); it != writeIntermediateResults->end(); it++){
                string temp = " " + to_string(index);
                if(it->find(temp) != string::npos){
                    writeIntermediateResults->erase(it);
                }
            }
            */

            for(auto &i:(*signature)){
                i.second[index] = 0;
            }
        }
    }
}

void __CUInstantiationFinalize(void) {

    /*
    set<string> res;
    set_difference(readResults->begin(), readResults->end(), writeResults->begin(), writeResults->end(),
        inserter(res, res.end()));

    set<string> res2;int tmp : PIDs->keySet()
    set_difference(writeResults->begin(), writeResults->end(), readResults->begin(), readResults->end(),
        inserter(res2, res2.end()));
    */
    for(auto i:(*results)){
        //map<string,string>::iterator it;
        *out << i << endl;

        //it = finalResults->find(i);
        //if (it != finalResults->end());
        //    *out << it->second << endl;
    }
    /*
    *out << "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" << endl;
    for(auto i:(*writeResults)){
        //map<string,string>::iterator it;
        *out << i << endl;
    }
    *out << "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" << endl;
    for(auto i:(*writeIntermediateResults)){
        //map<string,string>::iterator it;
        *out << i << endl;
    }
    */
    /*
    *out << "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" << endl;

    for(auto i:(*finalResults)){
        *out << i.second << endl;
    }
*/
    out->flush();
    out->close();

    delete out;
    delete stack;
    delete signature;
    delete PIDs;
    delete counters;

}

}
} // namespace __CUInst
