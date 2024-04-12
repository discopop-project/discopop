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

#include "iFunctions.hpp"
#include "perfect_shadow.hpp"
#include "shadow.hpp"
#include "signature.hpp"
#include <string>
#include <list>
#include <cstdio>
#include <limits>
#include <mutex>

#ifdef __linux__ // headers only available on Linux
#include <unistd.h>
#include <linux/limits.h>
#endif

using namespace std;
using namespace dputil;

#define unpackLIDMetadata_getLoopID(lid) (lid >> 56)
#define unpackLIDMetadata_getLoopIteration_0(lid) ((lid >> 48) & 0x7F)
#define unpackLIDMetadata_getLoopIteration_1(lid) ((lid >> 40) & 0x7F)
#define unpackLIDMetadata_getLoopIteration_2(lid) ((lid >> 32) & 0x7F)
#define checkLIDMetadata_getLoopIterationValidity_0(lid) ((lid & 0x0080000000000000) >> 55)
#define checkLIDMetadata_getLoopIterationValidity_1(lid) ((lid & 0x0000800000000000) >> 47)
#define checkLIDMetadata_getLoopIterationValidity_2(lid) ((lid & 0x0000008000000000) >> 39)

// issue a warning if DP_PTHREAD_COMPATIBILITY_MODE is enabled
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
#    warning "DP_PTHREAD_COMPATIBILITY_MODE enabled! This may have negative implications on the profiling time."
#endif

bool DP_DEBUG = false; // debug flag

bool USE_PERFECT = true;
// Shadow memory parameters
int32_t SIG_ELEM_BIT = 56;
int32_t SIG_NUM_ELEM = 270000;
int32_t SIG_NUM_HASH = 2;

uint64_t *numAccesses;

namespace __dp {

    std::mutex pthread_compatibility_mutex;

    bool dpInited = false;         // library initialization flag
    bool targetTerminated = false; // whether the target program has returned from main()
    // In C++, destructors of global objects can run after main().
    // However, when the target program returns from main(), dp
    // also frees all the resources. If there are destructors run
    // after main(), __dp_func_entry() will be called again, but
    // resources are freed, leading to segmentation fault.

    // Runtime merging structures
    depMap *allDeps = nullptr;
    // hybrid analysis
    stringDepMap *outPutDeps = nullptr;
    ReportedBBSet *bbList = nullptr;
    // End HA
    LoopTable *loopStack = nullptr;    // loop stack tracking
    LoopRecords *loops = nullptr;      // loop merging
    BGNFuncList *beginFuncs = nullptr; // function entries
    ENDFuncList *endFuncs = nullptr;   // function returns
    ofstream *out;
    ofstream *outInsts;
    std::stack<std::pair<ADDR, ADDR>>* stackAddrs = nullptr;  // track stack adresses for entered functions

    LID lastCallOrInvoke = 0;
    LID lastProcessedLine = 0;
    int32_t FuncStackLevel = 0;

    MemoryRegionTree *allocatedMemRegTree;
    list<tuple<LID, string, int64_t, int64_t, int64_t, int64_t>> *allocatedMemoryRegions;
    /// (LID, identifier, startAddr, endAddr, numBytes, numElements)
    list<tuple<LID, string, int64_t, int64_t, int64_t, int64_t>>::iterator lastHitIterator;
    ADDR smallestAllocatedADDR = std::numeric_limits<int64_t>::max();
    ADDR largestAllocatedADDR = std::numeric_limits<int64_t>::min();
    int64_t nextFreeMemoryRegionId = 1;  // 0 is reserved as the identifier for "no region" in the MemoryRegionTree

    /******* BEGIN: parallelization section *******/

    pthread_cond_t *addrChunkPresentConds = nullptr; // condition variables
    pthread_mutex_t *addrChunkMutexes = nullptr;     // associated mutexes
    pthread_mutex_t allDepsLock;
    pthread_t *workers = nullptr; // worker threads

#define XSTR(x) STR(x)
#define STR(x) #x
#ifdef DP_NUM_WORKERS
#pragma message "Profiler: set NUM_WORKERS to " XSTR(DP_NUM_WORKERS)
    int32_t NUM_WORKERS = DP_NUM_WORKERS;
#else
    int32_t NUM_WORKERS = 3;               // default number of worker threads (multiple workers can potentially lead to non-deterministic results)
#endif
    int32_t CHUNK_SIZE = 500;              // default number of addresses in each chunk
    queue<AccessInfo *> *chunks = nullptr; // one queue of access info chunks for each worker thread
    bool *addrChunkPresent = nullptr;      // addrChunkPresent[thread_id] denotes whether or not a new chunk is available for the corresponding thread
    AccessInfo **tempAddrChunks = nullptr; // tempAddrChunks[thread_id] is the temporary chunk to collect memory accesses for the corresponding thread
    int32_t *tempAddrCount = nullptr;      // tempAddrCount[thread_id] denotes the current number of accesses in the temporary chunk
    bool stop = false;                     // ONLY set stop to true if no more accessed addresses will be collected
    thread_local depMap
    *
    myMap = nullptr;

    /******* END: parallelization section *******/

    /******* Helper functions *******/

    void addDep(depType type, LID curr, LID depOn, char *var, string AAvar) {
        // hybrid analysis
        if (depOn == 0 && type == WAW)
            type = INIT;
        // End HA

        depType originalType = type;        
        int loopIterationOffset = 0;

        std::vector<depTypeModifier> identifiedDepTypes;
        bool dependencyRegistered = false;

        // Compare metadata (Loop ID's and Loop Iterations) from LID's if loop id's are overwritten (not 0xFF anymore) and check for intra-iteration dependencies
        // Intra-Iteration dependency exists, if LoopId's and Iteration Id's are equal
        if(unpackLIDMetadata_getLoopID(curr) != (LID) 0xFF && unpackLIDMetadata_getLoopID(depOn) != (LID) 0xFF){
            if(unpackLIDMetadata_getLoopID(curr) == unpackLIDMetadata_getLoopID(depOn)){

                // determine iteration count offset in case a new loop has been entered between curr and depOn
                loopIterationOffset = checkLIDMetadata_getLoopIterationValidity_0(curr)
                                        + checkLIDMetadata_getLoopIterationValidity_1(curr)
                                        + checkLIDMetadata_getLoopIterationValidity_2(curr)
                                        - checkLIDMetadata_getLoopIterationValidity_0(depOn)
                                        - checkLIDMetadata_getLoopIterationValidity_1(depOn)
                                        - checkLIDMetadata_getLoopIterationValidity_2(depOn);
                
                if(loopIterationOffset == 0){

                    if(checkLIDMetadata_getLoopIterationValidity_0(curr) && checkLIDMetadata_getLoopIterationValidity_0(depOn)){
                        if(checkLIDMetadata_getLoopIterationValidity_1(curr) && checkLIDMetadata_getLoopIterationValidity_1(depOn)){
                            if(checkLIDMetadata_getLoopIterationValidity_2(curr) && checkLIDMetadata_getLoopIterationValidity_2(depOn)){
                                //loop 0+1+2 valid
                                if(unpackLIDMetadata_getLoopIteration_2(curr) == unpackLIDMetadata_getLoopIteration_2(depOn)){
                                    identifiedDepTypes.push_back(II_2);
                                    dependencyRegistered = true;

                                    if(unpackLIDMetadata_getLoopIteration_1(curr) == unpackLIDMetadata_getLoopIteration_1(depOn)){
                                        identifiedDepTypes.push_back(II_1);
                                        if(unpackLIDMetadata_getLoopIteration_0(curr) == unpackLIDMetadata_getLoopIteration_0(depOn)){
                                            identifiedDepTypes.push_back(II_0);
                                        }
                                    }
                                }
                            }
                            else{
                                // loop 0+1 valid
                                if(unpackLIDMetadata_getLoopIteration_1(curr) == unpackLIDMetadata_getLoopIteration_1(depOn)){
                                    identifiedDepTypes.push_back(II_1);
                                    dependencyRegistered = true;
                                    if(unpackLIDMetadata_getLoopIteration_0(curr) == unpackLIDMetadata_getLoopIteration_0(depOn)){
                                        identifiedDepTypes.push_back(II_0);
                                    }
                                }
                            }
                        }
                        else{
                            // loop 0 valid
                            if(unpackLIDMetadata_getLoopIteration_0(curr) == unpackLIDMetadata_getLoopIteration_0(depOn)){
                                identifiedDepTypes.push_back(II_0);
                                dependencyRegistered = true;
                            }
                        }
                    }
                    else{
                        // no loop valid
                    }

                }
                else if(loopIterationOffset == 1){
                    // check outer loop
                    if((unpackLIDMetadata_getLoopIteration_2(curr) == unpackLIDMetadata_getLoopIteration_1(depOn))
                        && checkLIDMetadata_getLoopIterationValidity_2(curr) && checkLIDMetadata_getLoopIterationValidity_1(depOn)){
                        // II 2
                        identifiedDepTypes.push_back(II_2);
                        dependencyRegistered = true;
                    }
                    // check second loop
                    else if((unpackLIDMetadata_getLoopIteration_1(curr) == unpackLIDMetadata_getLoopIteration_0(depOn))
                        && checkLIDMetadata_getLoopIterationValidity_1(curr) && checkLIDMetadata_getLoopIterationValidity_0(depOn)){
                        // II 1
                        identifiedDepTypes.push_back(II_1);
                        dependencyRegistered = true;
                    }
                }
                else if(loopIterationOffset == 2){
                    // check outer loop
                    if((unpackLIDMetadata_getLoopIteration_2(curr) == unpackLIDMetadata_getLoopIteration_0(depOn))
                        && checkLIDMetadata_getLoopIterationValidity_2(curr) && checkLIDMetadata_getLoopIterationValidity_0(depOn)){
                        // II 2
                        identifiedDepTypes.push_back(II_2);
                        dependencyRegistered = true;
                    }
                }
                else if(loopIterationOffset == -2){
                    // example: depOn inside an inner loop, curr happens after this inner loop
                    if((unpackLIDMetadata_getLoopIteration_0(curr) == unpackLIDMetadata_getLoopIteration_2(depOn))
                        && checkLIDMetadata_getLoopIterationValidity_0(curr) && checkLIDMetadata_getLoopIterationValidity_2(depOn)){
                        // II 0
                        identifiedDepTypes.push_back(II_0);
                        dependencyRegistered = true;
                    }
                }
                else if(loopIterationOffset == -1){
                    // check second loop
                    if((unpackLIDMetadata_getLoopIteration_1(curr) == unpackLIDMetadata_getLoopIteration_2(depOn))
                        && checkLIDMetadata_getLoopIterationValidity_1(curr) && checkLIDMetadata_getLoopIterationValidity_2(depOn)){
                        // II 1
                        identifiedDepTypes.push_back(II_1);
                        dependencyRegistered = true;
                        // check first loop
                        if((unpackLIDMetadata_getLoopIteration_0(curr) == unpackLIDMetadata_getLoopIteration_1(depOn))
                            && checkLIDMetadata_getLoopIterationValidity_0(curr) && checkLIDMetadata_getLoopIterationValidity_1(depOn)){
                            // II 0
                            identifiedDepTypes.push_back(II_0);
                            dependencyRegistered = true;
                        }
                    }
                    
                }
            }
        }

        if(!dependencyRegistered){
            // register dependency with original type
            identifiedDepTypes.push_back(NOM);
        }

        
        // TODO: Register dependencies from list


        // Remove metadata to preserve result correctness and add metadata to `Dep` object
        LID dbg_curr = curr;  // for printing only
        LID dbg_depOn = depOn;  // for printing only 

        curr &= 0x00000000FFFFFFFF;
        depOn &= 0x00000000FFFFFFFF;

        depMap::iterator posInDeps = myMap->find(curr);

        // register dependencies
        for(depTypeModifier dtm : identifiedDepTypes){
            depType modified_type = type;
            bool print_debug_info = false;
            switch (dtm)
            {
            case NOM:
                // keep modified_type = type
                // print_debug_info = true;
                break;
            case II_0:
                {
                    switch(type)
                    {
                        case RAW:
                            modified_type = RAW_II_0;
                            break;
                        case WAR:
                            modified_type = WAR_II_0;
                            break;
                        case WAW:
                            modified_type = WAW_II_0;
                            break;
                        case INIT:
                            break;
                        default:
                            break;
                    }
                }
                break;
            case II_1:
                {
                    switch(type)
                    {
                        case RAW:
                            modified_type = RAW_II_1;
                            break;
                        case WAR:
                            modified_type = WAR_II_1;
                            break;
                        case WAW:
                            modified_type = WAW_II_1;
                            break;
                        case INIT:
                            break;
                        default:
                            break;
                    }
                }
                break;
            case II_2:
                {
                    switch(type)
                    {
                        case RAW:
                            modified_type = RAW_II_2;
                            break;
                        case WAR:
                            modified_type = WAR_II_2;
                            break;
                        case WAW:
                            modified_type = WAW_II_2;
                            break;
                        case INIT:
                            break;
                        default:
                            break;
                    }
                }
                break;
            default:
                break;
            }

            if(print_debug_info){
                cout << "AddDep: CURR: " << decodeLID(curr) << "  DepOn: " << decodeLID(dbg_depOn) << "  LoopIDS: " << hex << unpackLIDMetadata_getLoopID(dbg_curr) << ";" << hex <<  unpackLIDMetadata_getLoopID(dbg_depOn) << "\n";
                cout << "  Var: " << var << "\n";
                cout << "  Loop Iterations(curr): " << hex << unpackLIDMetadata_getLoopIteration_0(dbg_curr) << ";"  << hex << unpackLIDMetadata_getLoopIteration_1(dbg_curr) << ";" << hex << unpackLIDMetadata_getLoopIteration_2(dbg_curr) << "\n";
                cout << "  Loop Iterations(depOn): " << hex << unpackLIDMetadata_getLoopIteration_0(dbg_depOn) << ";"  << hex << unpackLIDMetadata_getLoopIteration_1(dbg_depOn) << ";" << hex << unpackLIDMetadata_getLoopIteration_2(dbg_depOn) << "\n";
                cout << "  Valid(cur): " << checkLIDMetadata_getLoopIterationValidity_0(dbg_curr) << ";" << checkLIDMetadata_getLoopIterationValidity_1(dbg_curr) << ";" << checkLIDMetadata_getLoopIterationValidity_2(dbg_curr) << ";\n";
                cout << "  Valid(dep): " << checkLIDMetadata_getLoopIterationValidity_0(dbg_depOn) << ";" << checkLIDMetadata_getLoopIterationValidity_1(dbg_depOn) << ";" << checkLIDMetadata_getLoopIterationValidity_2(dbg_depOn) << ";\n";
                cout << "  LoopIterationOffset: " << to_string(loopIterationOffset) << "\n";
                cout << "  orig.type: " << originalType << "\n";
                cout << "  final.type: " << modified_type << "\n\n";
            }

        
            if (posInDeps == myMap->end()) {
                depSet *tmp_depSet = new depSet();
                tmp_depSet->insert(Dep(modified_type, depOn, var, AAvar));
                myMap->insert(pair<int32_t, depSet *>(curr, tmp_depSet));
            } else {
                posInDeps->second->insert(Dep(modified_type, depOn, var, AAvar));
            }

            if (DP_DEBUG) {
            cout << "inserted dep [" << decodeLID(curr) << ", ";
            switch (type) {
                case RAW:
                    cout << "RAW";
                    break;
                case WAR:
                    cout << "WAR";
                    break;
                case WAW:
                    cout << "WAW";
                    break;
                case INIT:
                    cout << "INIT";
                    break;
                default:
                    break;
            }
            cout << ", " << decodeLID(depOn) << "] into deps (" << myMap->size() << ")" << endl;
            }
        }

        
    }

    // hybrid analysis
    void generateStringDepMap() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter generateStringDepMap\n";
#endif
        for (auto &dline: *allDeps) {
            if (dline.first) {
                string lid = decodeLID(dline.first);
                set <string> lineDeps;
                for (auto &d: *(dline.second)) {
                    string dep = "";
                    switch (d.type) {
                        case RAW:
                            dep += "RAW";
                            break;
                        case WAR:
                            dep += "WAR";
                            break;
                        case WAW:
                            dep += "WAW";
                            break;
                        case RAW_II_0:
                            dep += "RAW_II_0";
                            break;
                        case WAR_II_0:
                            dep += "WAR_II_0";
                            break;
                        case WAW_II_0:
                            dep += "WAW_II_0";
                            break;
                        case RAW_II_1:
                            dep += "RAW_II_1";
                            break;
                        case WAR_II_1:
                            dep += "WAR_II_1";
                            break;
                        case WAW_II_1:
                            dep += "WAW_II_1";
                            break;
                        case RAW_II_2:
                            dep += "RAW_II_2";
                            break;
                        case WAR_II_2:
                            dep += "WAR_II_2";
                            break;
                        case WAW_II_2:
                            dep += "WAW_II_2";
                            break;
                        case INIT:
                            dep += "INIT";
                            break;
                        default:
                            break;
                    }

                    dep += " " + decodeLID(d.depOn);
                    dep += "|" + string(d.var);
                    dep += "(" + string(d.AAvar) + ")";
                    lineDeps.insert(dep);
                }

                if (outPutDeps->count(lid) == 0) {
                    (*outPutDeps)[lid] = lineDeps;
                } else {
                    (*outPutDeps)[lid].insert(lineDeps.begin(), lineDeps.end());
                }
                delete dline.second;
            }
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "enter generateStringDepMap\n";
#endif
    }

    void outputDeps() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter outputDeps\n";
#endif
        for (auto pair: *outPutDeps) {
            *out << pair.first << " NOM ";
            for (auto dep: pair.second) {
                *out << " " << dep;
            }
            *out << endl;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit outputDeps\n";
#endif
    }
    // End HA

    void outputLoops() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter outputLoops\n";
#endif
        assert((loops != nullptr) && "Loop map is not available!");
        for (auto &loop: *loops) {
            *out << decodeLID(loop.first) << " BGN loop ";
            *out << loop.second->total << " ";
            *out << loop.second->nEntered << " ";
            *out << static_cast<int32_t>(loop.second->total / loop.second->nEntered) << " ";
            *out << loop.second->maxIterationCount << endl;
            *out << decodeLID(loop.second->end) << " END loop" << endl;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit outputLoops\n";
#endif
    }

    void outputFuncs() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter outputFunc\n";
#endif
        assert(beginFuncs != nullptr && endFuncs != nullptr && "Function maps are not available!");
        for (auto &func_begin: *beginFuncs) {
            for (auto fb: *(func_begin.second)) {
                *out << decodeLID(func_begin.first) << " BGN func ";
                *out << decodeLID(fb) << endl;
            }
        }

        for (auto fe: *endFuncs) {
            *out << decodeLID(fe) << " END func" << endl;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit outputFunc\n";
#endif
    }

    void outputAllocations() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter outputAllocations\n";
#endif
        // prepare environment variables
        char const * tmp = getenv("DOT_DISCOPOP");
        if(tmp == NULL){
            // DOT_DISCOPOP needs to be initialized
            setenv("DOT_DISCOPOP", ".discopop", 1);
        }
        std::string tmp_str(getenv("DOT_DISCOPOP"));
        setenv("DOT_DISCOPOP_PROFILER", (tmp_str + "/profiler").data(), 1);
        std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
        tmp2 += "/memory_regions.txt";

        auto allocationsFileStream = new ofstream();
        allocationsFileStream->open(tmp2.data(), ios::out);
        for(auto memoryRegion : *allocatedMemoryRegions){
            string position = decodeLID(get<0>(memoryRegion));
            string id = get<1>(memoryRegion);
            string numBytes = to_string(get<4>(memoryRegion));

            *allocationsFileStream << id << " " << position << " " << numBytes << endl;
        }
        allocationsFileStream->flush();
        allocationsFileStream->close();
#ifdef DP_RTLIB_VERBOSE
        cout << "exit outputAllocations\n";
#endif
    }

    void readRuntimeInfo() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter readRuntimeInfo\n";
#endif
        ifstream conf(get_exe_dir() + "/dp.conf");
        string line;
        if (conf.is_open()) {
            auto func = [](char c) {
                return (c == ' ');
            };
            vector <string> *substrings = nullptr;
            while (getline(conf, line)) {
                substrings = split(line, '=');
                if (substrings->size() == 2) {
                    string variable = (*substrings)[0];
                    string value = (*substrings)[1];
                    variable.erase(std::remove_if(variable.begin(), variable.end(), func), variable.end());
                    value.erase(std::remove_if(value.begin(), value.end(), func), value.end());

                    int32_t intValue = (int32_t) atoi(value.c_str());
                    if (intValue > 0) {
                        if (variable.compare("DP_DEBUG") == 0) {
                            DP_DEBUG = true;
                        } else if (variable.compare("SIG_ELEM_BIT") == 0) {
                            SIG_ELEM_BIT = intValue;
                        } else if (variable.compare("SIG_NUM_ELEM") == 0) {
                            SIG_NUM_ELEM = intValue;
                        } else if (variable.compare("SIG_NUM_HASH") == 0) {
                            SIG_NUM_HASH = intValue;
                        } else if (variable.compare("NUM_WORKERS") == 0) {
                            NUM_WORKERS = intValue;
                        } else if (variable.compare("CHUNK_SIZE") == 0) {
                            CHUNK_SIZE = intValue;
                        } else if (variable.compare("USE_PERFECT") == 0) {
                            USE_PERFECT = intValue != 0;
                        }
                    }
                }
                substrings->clear();
                delete substrings;
            }
        }
        if (DP_DEBUG) {
            cout << "sig_elem_bit = " << SIG_ELEM_BIT << "\n";
            cout << "sig_num_elem = " << SIG_NUM_ELEM << "\n";
            cout << "sig_num_hash = " << SIG_NUM_HASH << "\n";
            cout << "num_workers  = " << NUM_WORKERS << "\n";
            cout << "chunk_size   = " << CHUNK_SIZE << "\n";
            sleep(2);
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit readRuntimeInfo\n";
#endif
    }

    void initParallelization() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter initParallelization\n";
#endif
        // initialize global variables
        addrChunkPresentConds = new pthread_cond_t[NUM_WORKERS];
        addrChunkMutexes = new pthread_mutex_t[NUM_WORKERS];

        chunks = new queue<AccessInfo *>[NUM_WORKERS];
        addrChunkPresent = new bool[NUM_WORKERS];
        tempAddrChunks = new AccessInfo *[NUM_WORKERS];
        tempAddrCount = new int32_t[NUM_WORKERS];
        workers = new pthread_t[NUM_WORKERS];

        //Initialize count of accesses
        numAccesses = new uint64_t[NUM_WORKERS]();

        // initialize and set thread detached attribute
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
        pthread_mutex_init(&allDepsLock, NULL);

        // create worker threads and set default value for temp variables
        for (int64_t i = 0; i < NUM_WORKERS; ++i) {
            addrChunkPresent[i] = false;
            tempAddrCount[i] = 0;
            tempAddrChunks[i] = new AccessInfo[CHUNK_SIZE];
            pthread_mutex_init(&addrChunkMutexes[i], NULL);
            pthread_cond_init(&addrChunkPresentConds[i], NULL);
            pthread_create(&workers[i], &attr, analyzeDeps, (void *) i);
        }

        pthread_attr_destroy(&attr);
#ifdef DP_RTLIB_VERBOSE
        cout << "exit initParallelization\n";
#endif
    }


    string getMemoryRegionIdFromAddr(string fallback, ADDR addr){
        // use tree
        return fallback + "-" + allocatedMemRegTree->get_memory_region_id(fallback, addr);

        /*// check if accessed addr in knwon range. If not, return fallback immediately
        if(addr >= smallestAllocatedADDR && addr <= largestAllocatedADDR){
            // FOR NOW, ONLY SEARCH BACKWARDS TO FIND THE LATEST ALLOCA ENTRY IN CASE MEMORY ADDRESSES ARE REUSED
            if(allocatedMemoryRegions->size() != 0){
                // search backwards in the list
                auto bw_it = allocatedMemoryRegions->end();
                bw_it--;
                bool search_backwards = true;

                while(true){
                    if(*bw_it == allocatedMemoryRegions->front()){
                        search_backwards = false;
                    }
                    if(get<2>(*bw_it) <= addr && get<3>(*bw_it) >= addr){
                        lastHitIterator = bw_it;
                        return get<1>(*bw_it);
                    }

                    if(search_backwards){
                        bw_it--;
                    }
                    else{
                        break;
                    }
                }
            }

        }

        return fallback;
        */
    }

    void addAccessInfo(bool isRead, LID lid, char *var, ADDR addr) {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter addAccessInfo\n";
#endif
        int64_t workerID = ((addr - (addr % 4)) % (NUM_WORKERS*4)) / 4; // implicit "floor"
        numAccesses[workerID]++;
        AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
        current.isRead = isRead;
        current.lid = lid;
        current.var = var;
        current.AAvar = getMemoryRegionIdFromAddr(var, addr);
        current.addr = addr;
        // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop iteration count as valid, last 7 bits for loop iteration)
        // last 8 bits are sufficient, since metadata is only used to check for different iterations, not exact values.
        // first 32 bits of current.lid are reserved for metadata and thus empty
        if (loopStack->size() > 0){
            if (loopStack->size() == 1){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id

                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
            }
            else if (loopStack->size() == 2){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
            }
            else{ // (loopStack->size() >= 3)
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(2).count & 0x7F)) << 32); // add masked loop count
                current.lid = current.lid | (LID) 0x0000008000000000; // mark loop count valid
            }
        }
        else{
            // mark loopID as invalid (0xFF to allow 0 as valid loop id)
            current.lid = current.lid | (((LID) 0xFF) << 56);
        }

        if (tempAddrCount[workerID] == CHUNK_SIZE) {
            pthread_mutex_lock(&addrChunkMutexes[workerID]);
            addrChunkPresent[workerID] = true;
            chunks[workerID].push(tempAddrChunks[workerID]);
            pthread_cond_signal(&addrChunkPresentConds[workerID]);
            pthread_mutex_unlock(&addrChunkMutexes[workerID]);
            tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
            tempAddrCount[workerID] = 0;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit addAccessInfo\n";
#endif
    }

    void mergeDeps() {
        depSet *tmp_depSet = nullptr; // pointer to the current processing set of dps
        depMap::iterator globalPos;   // position of the current processing lid in allDeps

        pthread_mutex_lock(&allDepsLock);
        for (auto &dep: *myMap) {
            // if a lid occurs the first time, then add it in to the global hash table.
            // Otherwise just take the associated set of dps.
            globalPos = allDeps->find(dep.first);
            if (globalPos == allDeps->end()) {
                tmp_depSet = new depSet();
                (*allDeps)[dep.first] = tmp_depSet;
            } else {
                tmp_depSet = globalPos->second;
            }

            // merge the associated set with current lid into the global hash table
            for (auto &d: *(dep.second)) {
                tmp_depSet->insert(d);
            }
        }
        pthread_mutex_unlock(&allDepsLock);
    }

    void *analyzeDeps(void *arg) {
        int64_t id = (int64_t) arg;
        Shadow *SMem;
        if (USE_PERFECT) {
            SMem = new PerfectShadow(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
        } else {
            SMem = new ShadowMemory(SIG_ELEM_BIT, SIG_NUM_ELEM, SIG_NUM_HASH);
        }
        myMap = new depMap();
        bool isLocked = false;
        while (true) {
            if (!isLocked)
                pthread_mutex_lock(&addrChunkMutexes[id]);

            while (!addrChunkPresent[id]) {
                pthread_cond_wait(&addrChunkPresentConds[id], &addrChunkMutexes[id]);
            }
            isLocked = true;

            if (chunks[id].size()) {
                // take a chunk of memory accesses from the queue
                AccessInfo *accesses = chunks[id].front();
                chunks[id].pop();

                // unlock the mutex so that the master thread can add more chunks
                pthread_mutex_unlock(&addrChunkMutexes[id]);
                isLocked = false;
                AccessInfo access;

                // analyze data dependences
                for (unsigned short i = 0; i < CHUNK_SIZE; ++i) {
                    access = accesses[i];

                    if (access.isRead) {
                        // hybrid analysis
                        if (access.skip) {
                            SMem->insertToRead(access.addr, access.lid);
                            continue;
                        }
                        // End HA
                        sigElement lastWrite = SMem->testInWrite(access.addr);
                        if (lastWrite != 0) {
                            // RAW
                            SMem->insertToRead(access.addr, access.lid);
                            addDep(RAW, access.lid, lastWrite, access.var, access.AAvar);
                        }
                    } else {
                        sigElement lastWrite = SMem->insertToWrite(access.addr, access.lid);
                        if (lastWrite == 0) {
                            // INIT
                            addDep(INIT, access.lid, 0, access.var, access.AAvar);
                        } else {
                            sigElement lastRead = SMem->testInRead(access.addr);
                            if (lastRead != 0) {
                                // WAR
                                addDep(WAR, access.lid, lastRead, access.var, access.AAvar);
                                // Clear intermediate read ops
                                SMem->insertToRead(access.addr, 0);
                            } else {
                                // WAW
                                addDep(WAW, access.lid, lastWrite, access.var, access.AAvar);
                            }
                        }
                    }
                }
                // delete the current chunk at the end
                if (accesses)
                    delete[] accesses;
            }

            if (!isLocked) {
                pthread_mutex_lock(&addrChunkMutexes[id]);
                isLocked = true;
            }

            // if current chunk is empty and no more addresses will be collected (stop = true) then exits .
            // Otherwise continues to wait for new chunks
            if (chunks[id].size() == 0) {
                if (stop) {
                    break;
                } else {
                    addrChunkPresent[id] = false;
                }
            }
        }

        delete SMem;
        pthread_mutex_unlock(&addrChunkMutexes[id]);
        mergeDeps();

        if (DP_DEBUG) {
            cout << "thread " << id << " exits... \n";
        }
        pthread_exit(NULL);
    }

    void finalizeParallelization() {
#ifdef DP_RTLIB_VERBOSE
        cout << "enter finalizeParallelization\n";
#endif
        if (DP_DEBUG) {
            cout << "BEGIN: finalize parallelization... \n";
        }

        // fake signaling: just notify the workers that no more addresses will be collected
        for (int i = 0; i < NUM_WORKERS; ++i) {
            pthread_mutex_lock(&addrChunkMutexes[i]);
            stop = true;
            addrChunkPresent[i] = true;
            if (0 < tempAddrCount[i]) {
                chunks[i].push(tempAddrChunks[i]);
            }
            pthread_cond_signal(&addrChunkPresentConds[i]);
            pthread_mutex_unlock(&addrChunkMutexes[i]);
        }

        if (DP_DEBUG) {
            for (int i = 0; i < NUM_WORKERS; ++i) {
                cout << chunks[i].size() << "\n";
            }
        }

        // wait for worker threads
        for (int i = 0; i < NUM_WORKERS; ++i)
            pthread_join(workers[i], NULL);

        // destroy mutexes and condition variables
        for (int i = 0; i < NUM_WORKERS; ++i) {
            pthread_mutex_destroy(&addrChunkMutexes[i]);
            pthread_cond_destroy(&addrChunkPresentConds[i]);
        }

        // delete allocated memory
        delete[] chunks;
        delete[] tempAddrCount;
        delete[] tempAddrChunks;
        delete[] workers;

        if (DP_DEBUG) {
            cout << "END: finalize parallelization... \n";
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit finalizeParallelization\n";
#endif
    }

    /******* Instrumentation functions *******/

    //The wrapper is to avoid mangling
    extern "C"
    {

#ifdef SKIP_DUP_INSTR
    void __dp_read(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count)
    {
#else
    void __dp_read(LID lid, ADDR addr, char *var) {
#endif

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_read\n";
#endif

        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_read() is not executed since target program has returned from main()." << endl;
            }
            return;
        }
        // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
        if (lastaddr == addr && count >= 2)
        {
             return;
        }
#endif
        lastCallOrInvoke = 0;
        lastProcessedLine = lid;

        if (DP_DEBUG) {
            cout << "instLoad at encoded LID " << std::dec << decodeLID(lid) << " and addr " << std::hex << addr
                 << endl;
        }

        // TEST
        // check for stack access
//        cout << "\n";
//        cout << "READ: " << var << "  ADDR: " << hex << addr << "  Stack: " << stackAddrs->top().first << " - " << stackAddrs->top().second << "\n";
        if(stackAddrs->top().first && stackAddrs->top().second){
            if((addr <= stackAddrs->top().first) && (addr >= stackAddrs->top().second)){
//                cout << "READ STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
                return;

            }
//            else{
//                cout << "NON READ STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
//            }
        }
//        else{
//                cout << "NON READ STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
//            }
        // !TEST

        //addAccessInfo(true, lid, var, addr);
        int64_t workerID = ((addr - (addr % 4)) % (NUM_WORKERS*4)) / 4; // implicit "floor"
        AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
        current.isRead = true;
        current.lid = lid;
        current.var = var;
        current.AAvar = getMemoryRegionIdFromAddr(var, addr);
        current.addr = addr;
        // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop iteration count as valid, last 7 bits for loop iteration)
        // last 8 bits are sufficient, since metadata is only used to check for different iterations, not exact values.
        // first 32 bits of current.lid are reserved for metadata and thus empty
        if (loopStack->size() > 0){
            if (loopStack->size() == 1){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
            }
            else if (loopStack->size() == 2){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
            }
            else{ // (loopStack->size() >= 3)
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(2).count & 0x7F)) << 32); // add masked loop count
                current.lid = current.lid | (LID) 0x0000008000000000; // mark loop count valid
            }
        }
        else{
            // mark loopID as invalid (0xFF to allow 0 as valid loop id)
            current.lid = current.lid | (((LID) 0xFF) << 56);
        }

        if (tempAddrCount[workerID] == CHUNK_SIZE) {
            pthread_mutex_lock(&addrChunkMutexes[workerID]);
            addrChunkPresent[workerID] = true;
            chunks[workerID].push(tempAddrChunks[workerID]);
            pthread_cond_signal(&addrChunkPresentConds[workerID]);
            pthread_mutex_unlock(&addrChunkMutexes[workerID]);
            tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
            tempAddrCount[workerID] = 0;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_read\n";
#endif
    }

#ifdef SKIP_DUP_INSTR
    void __dp_write(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count)
    {
#else
    void __dp_write(LID lid, ADDR addr, char *var) {
#endif

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_write\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_write() is not executed since target program has returned from main()." << endl;
            }
            return;
        }
        // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
        if (lastaddr == addr && count >= 2)
        {
             return;
        }
#endif
        // For tracking function call or invoke
        lastCallOrInvoke = 0;
        lastProcessedLine = lid;

        if (DP_DEBUG) {
            cout << "instStore at encoded LID " << std::dec << decodeLID(lid) << " and addr " << std::hex << addr
                 << endl;
        }

        // TEST
//        cout << "\n";
//        cout << "WRITE: " << var << "  ADDR: " << hex << addr << "  Stack: " << stackAddrs->top().first << " - " << stackAddrs->top().second << "\n";
        // check for stack access
        if(stackAddrs->top().first && stackAddrs->top().second){
            if((addr <= stackAddrs->top().first) && (addr >= stackAddrs->top().second)){
//                cout << "WRITE STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
                return;
            }
//            else{
//                cout << "NON WRITE STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
//            }
        }
//        else{
//                cout << "NON WRITE STACK ACCESS DETECTED! " << decodeLID(lid) << "  " << var << "\n";
//            }
        // !TEST


        int64_t workerID = ((addr - (addr % 4)) % (NUM_WORKERS*4)) / 4; // implicit "floor"
        AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
        current.isRead = false;
        current.lid = lid;
        current.var = var;
        current.AAvar = getMemoryRegionIdFromAddr(var, addr);
        current.addr = addr;
        // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop iteration count as valid, last 7 bits for loop iteration)
        // last 8 bits are sufficient, since metadata is only used to check for different iterations, not exact values.
        // first 32 bits of current.lid are reserved for metadata and thus empty
        if (loopStack->size() > 0){
            if (loopStack->size() == 1){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
            }
            else if (loopStack->size() == 2){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
            }
            else{ // (loopStack->size() >= 3)
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(2).count & 0x7F)) << 32); // add masked loop count
                current.lid = current.lid | (LID) 0x0000008000000000; // mark loop count valid
            }
        }
        else{
            // mark loopID as invalid (0xFF to allow 0 as valid loop id)
            current.lid = current.lid | (((LID) 0xFF) << 56);
        }

        if (tempAddrCount[workerID] == CHUNK_SIZE) {
            pthread_mutex_lock(&addrChunkMutexes[workerID]);
            addrChunkPresent[workerID] = true;
            chunks[workerID].push(tempAddrChunks[workerID]);
            pthread_cond_signal(&addrChunkPresentConds[workerID]);
            pthread_mutex_unlock(&addrChunkMutexes[workerID]);
            tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
            tempAddrCount[workerID] = 0;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_write\n";
#endif
    }

#ifdef SKIP_DUP_INSTR
    void __dp_decl(LID lid, ADDR addr, char *var, ADDR lastaddr, int64_t count)
    {
#else
    void __dp_decl(LID lid, ADDR addr, char *var) {
#endif

#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_decl\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_write() is not executed since target program has returned from main()." << endl;
            }
            return;
        }
        // For tracking function call or invoke
#ifdef SKIP_DUP_INSTR
        if (lastaddr == addr && count >= 2)
        {
             return;
        }
#endif
        // For tracking function call or invoke
        lastCallOrInvoke = 0;
        lastProcessedLine = lid;

        if (DP_DEBUG) {
            cout << "instStore at encoded LID " << std::dec << decodeLID(lid) << " and addr " << std::hex << addr
                 << endl;
        }

        int64_t workerID = ((addr - (addr % 4)) % (NUM_WORKERS*4)) / 4;  // implicit "floor"
        AccessInfo &current = tempAddrChunks[workerID][tempAddrCount[workerID]++];
        current.isRead = false;
        current.lid = 0;
        current.var = var;
        current.AAvar = getMemoryRegionIdFromAddr(var, addr);
        current.addr = addr;
        current.skip = true;
        // store loop iteration metadata (last 8 bits for loop id, 1 bit to mark loop iteration count as valid, last 7 bits for loop iteration)
        // last 8 bits are sufficient, since metadata is only used to check for different iterations, not exact values.
        // first 32 bits of current.lid are reserved for metadata and thus empty
        if (loopStack->size() > 0){
            if (loopStack->size() == 1){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
            }
            else if (loopStack->size() == 2){
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
            }
            else{ // (loopStack->size() >= 3)
                current.lid = current.lid | (((LID) (loopStack->first().loopID & 0xFF)) << 56);  // add masked loop id
                current.lid = current.lid | (((LID) (loopStack->top().count & 0x7F)) << 48); // add masked loop count
                current.lid = current.lid | (LID) 0x0080000000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(1).count & 0x7F)) << 40); // add masked loop count
                current.lid = current.lid | (LID) 0x0000800000000000; // mark loop count valid
                current.lid = current.lid | (((LID) (loopStack->topMinusN(2).count & 0x7F)) << 32); // add masked loop count
                current.lid = current.lid | (LID) 0x0000008000000000; // mark loop count valid
            }
        }
        else{
            // mark loopID as invalid (0xFF to allow 0 as valid loop id)
            current.lid = current.lid | (((LID) 0xFF) << 56);
        }

        if (tempAddrCount[workerID] == CHUNK_SIZE) {
            pthread_mutex_lock(&addrChunkMutexes[workerID]);
            addrChunkPresent[workerID] = true;
            chunks[workerID].push(tempAddrChunks[workerID]);
            pthread_cond_signal(&addrChunkPresentConds[workerID]);
            pthread_mutex_unlock(&addrChunkMutexes[workerID]);
            tempAddrChunks[workerID] = new AccessInfo[CHUNK_SIZE];
            tempAddrCount[workerID] = 0;
        }
    }

    void __dp_alloca(LID lid, char *var, ADDR startAddr, ADDR endAddr, int64_t numBytes, int64_t numElements) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_alloca\n";
#endif
        int64_t buffer = nextFreeMemoryRegionId;
        string allocId = to_string(buffer);
        nextFreeMemoryRegionId++;
        // create entry to list of allocatedMemoryRegions
        string var_name = allocId;
        if(DP_DEBUG){
            cout << "alloca: " << var << " (" <<  var_name <<  ") @ " << decodeLID(lid) <<  " : " << std::hex << startAddr << " - " << std::hex << endAddr << " -> #allocations: " << to_string(allocatedMemoryRegions->size()) << "\n";
        }
        allocatedMemoryRegions->push_back(tuple<LID, string, int64_t, int64_t, int64_t, int64_t>{lid, var_name, startAddr, endAddr, numBytes, numElements});
        allocatedMemRegTree->allocate_region(startAddr, endAddr, buffer, tempAddrCount, NUM_WORKERS);

        // update known min and max ADDR
        if(startAddr < smallestAllocatedADDR){
            smallestAllocatedADDR = startAddr;
        }
        if(endAddr > largestAllocatedADDR){
            largestAllocatedADDR = endAddr;
        }

        // TEST
        // update stack base address, if not already set
        if(stackAddrs->top().first == 0){
//            cout << "SET STACK BASE!\n";
            stackAddrs->top().first = startAddr;
        }
//        else{
//            cout << "NOT NECESSARY: SET STACK BASE\n";
//        }

        // update stack top address (note: stack grows top down!)
        if(stackAddrs->top().second == 0){
            // initialize stack top address
            stackAddrs->top().second = endAddr;
        }
        else if(stackAddrs->top().second > endAddr){
            // update stack top
//            cout << "UPDATE STACK TOP: " << stackAddrs->top().second << "  -->  " << endAddr << "\n";
            stackAddrs->top().second = endAddr;
        }

//        cout << "STACK REGION: " << stackAddrs->top().first << " - " << stackAddrs->top().second << "\n";
        // !TEST

#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_alloca\n";
#endif
    }

    void __dp_new(LID lid, ADDR startAddr, ADDR endAddr, int64_t numBytes){
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_new\n";
#endif
        // instrumentation function for new and malloc
        int64_t buffer = nextFreeMemoryRegionId;
        string allocId = to_string(buffer);
        nextFreeMemoryRegionId++;

        // calculate endAddr of memory region
        endAddr = startAddr + numBytes;

        allocatedMemRegTree->allocate_region(startAddr, endAddr, buffer, tempAddrCount, NUM_WORKERS);

        if(DP_DEBUG){
            cout << "new/malloc: " << decodeLID(lid) << ", " << allocId << ", " << std::hex << startAddr << " - " << std::hex << endAddr;
            printf(" NumBytes: %lld\n", numBytes);
        }

        allocatedMemoryRegions->push_back(tuple<LID, string, int64_t, int64_t, int64_t, int64_t>{lid, allocId, startAddr, endAddr, numBytes, -1});
        lastHitIterator = allocatedMemoryRegions->end();
        lastHitIterator--;

        // update known min and max ADDR
        if(startAddr < smallestAllocatedADDR){
            smallestAllocatedADDR = startAddr;
        }
        if(endAddr > largestAllocatedADDR){
            largestAllocatedADDR = endAddr;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_new\n";
#endif
    }

    void __dp_delete(LID lid, ADDR startAddr){
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_delete\n";
#endif
        // DO NOT DELETE MEMORY REGIONS AS THEY ARE STILL REQUIRED FOR LOGGING

        // TODO more efficient implementation

        // find memory region to be deleted
/*        for(tuple<LID, string, int64_t, int64_t, int64_t, int64_t> entry : allocatedMemoryRegions){
            if(get<2>(entry) == startAddr){
                // delete memory region
                cout << "delete/free: " << decodeLID(lid) << ", " << get<1>(entry) << ", " << std::hex << startAddr << "\n";
                allocatedMemoryRegions.remove(entry);
                return;
            }
        }
        cout << "__dp_delete: Could not find base addr: " << std::hex << startAddr << "\n";
*/
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_delete\n";
#endif
        return;
    }

    void __dp_report_bb(uint32_t bbIndex) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_report_bb\n";
        cout << "bbIndex: " << std::to_string(bbIndex) << "\n";
#endif
        bbList->insert(bbIndex);
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_report_bb\n";
#endif
    }

    void __dp_report_bb_pair(int32_t semaphore, uint32_t bbIndex) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_report_bb_pair\n";
#endif
        if (semaphore)
            bbList->insert(bbIndex);
    }

    void __dp_finalize(LID lid) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
            pthread_compatibility_mutex.lock();
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_finalize\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_finalize() has been called before. Doing nothing this time to avoid double free." << endl;
            }
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
            pthread_compatibility_mutex.unlock();
#endif
            return;
        }

        // release mutex so it can be re-aquired in the called __dp_func_exit
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        pthread_compatibility_mutex.unlock();
#endif

        while (FuncStackLevel >= 0) {
            __dp_func_exit(lid, 1);
        }

        // use lock_guard here, since no other mutex-aquiring function is called
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif

        // Returning from main or exit from somewhere, clear up everything.
        assert(FuncStackLevel == -1 && "Program terminates without clearing function stack!");
        assert(loopStack->empty() && "Program terminates but loop stack is not empty!");

        if (DP_DEBUG) {
            cout << "Program terminates at LID " << std::dec << decodeLID(lid) << ", clearing up" << endl;
        }

        finalizeParallelization();
        outputLoops();
        outputFuncs();
        outputAllocations();
        // hybrid analysis
        generateStringDepMap();
        // End HA
        outputDeps();

        delete loopStack;
        delete endFuncs;
        // hybrid analysis
        delete allDeps;
        delete outPutDeps;
        delete bbList;
        // End HA

        for (auto loop: *loops) {
            delete loop.second;
        }
        delete loops;

        for (auto fb: *beginFuncs) {
            delete fb.second;
        }
        delete beginFuncs;

        *out << decodeLID(lid) << " END program" << endl;
        out->flush();
        out->close();

        delete out;
        targetTerminated = true; // mark the target program has returned from main()

        if (DP_DEBUG) {
            cout << "Program terminated." << endl;
        }
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_finalize\n";
#endif
    }

    // hybrid analysis
    void __dp_add_bb_deps(char *depStringPtr) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_add_bb_deps\n";
#endif
        string depString(depStringPtr);
        regex r0("[^\\/]+"), r1("[^=]+"), r2("[^,]+"), r3("[0-9]+:[0-9]+"), r4("(INIT|(R|W)A(R|W)).*");
        smatch res0, res1, res2, res3;

        while (regex_search(depString, res0, r0)) {
            string s(res0[0]);

            regex_search(s, res1, r1);
            string cond(res1[0]);

            if (bbList->find(stoi(cond)) == bbList->end()) {
                depString = res0.suffix();
                continue;
            }

            string line(res1.suffix());
            line.erase(0, 1);
            while (regex_search(line, res2, r2)) {
                string s(res2[0]);
                regex_search(s, res3, r3);
                string k(res3[0]);
                regex_search(s, res3, r4);
                string v(res3[0]);
                if (outPutDeps->count(k) == 0) {
                    set <string> depSet;
                    (*outPutDeps)[k] = depSet;
                }
                (*outPutDeps)[k].insert(v);
                line = res2.suffix();
            }
            depString = res0.suffix();
        }
    }
    // End HA

    void __dp_call(LID lid) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "__dp_call\n";
#endif
        lastCallOrInvoke = lid;
    }

    void __dp_func_entry(LID lid, int32_t isStart) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "enter __dp_func_entry\n";
#endif
        if (!dpInited) {
            // This part should be executed only once.
            readRuntimeInfo();
            loopStack = new LoopTable();
            loops = new LoopRecords();
            beginFuncs = new BGNFuncList();
            endFuncs = new ENDFuncList();
            out = new ofstream();

            // TEST
            stackAddrs = new std::stack<std::pair<ADDR, ADDR>>();
            // !TEST

            // hybrid analysis
            allDeps = new depMap();
            outPutDeps = new stringDepMap();
            bbList = new ReportedBBSet();
            // End HA
            // initialize AllocatedMemoryRegions:

            allocatedMemRegTree = new MemoryRegionTree();
            allocatedMemoryRegions = new list<tuple<LID, string, int64_t, int64_t, int64_t, int64_t>>;

            if (allocatedMemoryRegions->size() == 0 && allocatedMemoryRegions->empty() == 0){
                // re-initialize the list, as something went wrong
                allocatedMemoryRegions = new list<tuple<LID, string, int64_t, int64_t, int64_t, int64_t>>();
            }
            tuple<LID, string, int64_t, int64_t, int64_t, int64_t>{0, "%%dummy%%", 0, 0, 0, 0};
            // initialize lastHitIterator to dummy element
            allocatedMemoryRegions->push_back(tuple<LID, string, int64_t, int64_t, int64_t, int64_t>{0, "%%dummy%%", 0, 0, 0, 0});
            lastHitIterator = allocatedMemoryRegions->end();
            lastHitIterator--;

#ifdef __linux__
            // try to get an output file name w.r.t. the target application
            // if it is not available, fall back to "Output.txt"
            char *selfPath = new char[PATH_MAX];
            if (selfPath != nullptr)
            {
                 if (readlink("/proc/self/exe", selfPath, PATH_MAX - 1) == -1)
                 {
                      delete[] selfPath;
                      selfPath = nullptr;
                      out->open("Output.txt", ios::out);
                 }
                 //out->open(string(selfPath) + "_dep.txt", ios::out);  # results in the old <prog>_dep.txt
                 // prepare environment variables
                char const * tmp = getenv("DOT_DISCOPOP");
                if(tmp == NULL){
                    // DOT_DISCOPOP needs to be initialized
                    setenv("DOT_DISCOPOP", ".discopop", 1);
                }
                std::string tmp_str(getenv("DOT_DISCOPOP"));
                setenv("DOT_DISCOPOP_PROFILER", (tmp_str + "/profiler").data(), 1);
                std::string tmp2(getenv("DOT_DISCOPOP_PROFILER"));
                tmp2 += "/dynamic_dependencies.txt";

                out->open(tmp2.data(), ios::out);
            }
#else
            out->open("Output.txt", ios::out);
#endif
            assert(out->is_open() && "Cannot open a file to output dependences.\n");

            if (DP_DEBUG) {
                cout << "DP initialized at LID " << std::dec << decodeLID(lid) << endl;
            }
            dpInited = true;
            initParallelization();
        } else if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "Entering function LID " << std::dec << decodeLID(lid);
                cout << " but target program has returned from main(). Destructors?" << endl;
            }
        } else {
            // Process ordinary function call/invoke.
            assert((lastCallOrInvoke != 0 || lastProcessedLine != 0) &&
                   "Error: lastCalledFunc == lastProcessedLine == 0");
            if (lastCallOrInvoke == 0)
                lastCallOrInvoke = lastProcessedLine;
            ++FuncStackLevel;

            if (DP_DEBUG) {
                cout << "Entering function LID " << std::dec << decodeLID(lid) << endl;
                cout << "Function stack level = " << std::dec << FuncStackLevel << endl;
            }
            BGNFuncList::iterator func = beginFuncs->find(lastCallOrInvoke);
            if (func == beginFuncs->end()) {
                set <LID> *tmp = new set<LID>();
                tmp->insert(lid);
                beginFuncs->insert(pair < LID, set < LID > * > (lastCallOrInvoke, tmp));
            } else {
                func->second->insert(lid);
            }
        }

        // TEST
        // initialize stack addresses for function
        stackAddrs->push(std::pair<ADDR, ADDR>(0,0));
//        cout << "PUSH STACK ENTRY\n";
        // !TEST


        if (isStart)
            *out << "START " << decodeLID(lid) << endl;

        // Reset last call tracker
        lastCallOrInvoke = 0;
#ifdef DP_RTLIB_VERBOSE
        cout << "exit __dp_func_entry\n";
#endif
    }

    void __dp_func_exit(LID lid, int32_t isExit) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "__dp_func_exit\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "Exiting function LID " << std::dec << decodeLID(lid);
                cout << " but target program has returned from main(). Destructors?" << endl;
            }
            return;
        }

        lastCallOrInvoke = 0;
        lastProcessedLine = lid;

        // Clear up all unfinished loops in the function.
        // This usually happens when using return inside loop.
        while (!loopStack->empty() &&
               (loopStack->top().funcLevel == FuncStackLevel)) {

            // No way to get the real end line of loop. Use the line where
            // function returns instead.
            LoopRecords::iterator loop = loops->find(loopStack->top().begin);
            assert(loop != loops->end() && "A loop ends without its entry being recorded.");
            if (loop->second->end == 0) {
                loop->second->end = lid;
            } else {
                //TODO: FIXME: loop end line > return line
            }
            loop->second->total += loopStack->top().count;
            ++loop->second->nEntered;

            if (DP_DEBUG) {
                cout << "(" << std::dec << loopStack->top().funcLevel << ")";
                cout << "Loop " << loopStack->top().loopID << " exits since function returns." << endl;
            }

            loopStack->pop();

            if (DP_DEBUG) {
                if (loopStack->empty())
                    cout << "Loop Stack is empty." << endl;
                else {
                    cout << "TOP: (" << std::dec << loopStack->top().funcLevel << ")";
                    cout << "Loop " << loopStack->top().loopID << "." << endl;
                }
            }
        }
        --FuncStackLevel;

        // TEST
        // clear information on allocated stack addresses
        stackAddrs->pop();
        // !TEST

        if (isExit == 0)
            endFuncs->insert(lid);

        if (DP_DEBUG) {
            cout << "Exiting fucntion LID " << std::dec << decodeLID(lid) << endl;
            cout << "Function stack level = " << std::dec << FuncStackLevel << endl;
        }
    }

    void __dp_loop_entry(LID lid, int32_t loopID) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "__dp_loop_entry\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_loop_entry() is not executed since target program has returned from main()." << endl;
            }
            return;
        }
        assert((loopStack != nullptr) && "Loop stack is not available!");

        if (loopStack->empty() || (loopStack->top().loopID != loopID)) {
            // A new loop
            loopStack->push(LoopTableEntry(FuncStackLevel, loopID, 0, lid));
            if (loops->find(lid) == loops->end()) {
                loops->insert(pair<LID, LoopRecord *>(lid, new LoopRecord(0, 0, 0)));
            }
            if (DP_DEBUG) {
                cout << "(" << std::dec << FuncStackLevel << ")Loop " << loopID << " enters." << endl;
            }
        } else {
            // The same loop iterates again
            loopStack->top().count++;
            if (DP_DEBUG) {
                cout << "(" << std::dec << loopStack->top().funcLevel << ")";
                cout << "Loop " << loopStack->top().loopID << " iterates " << loopStack->top().count << " times."
                     << endl;
            }

            // Handle error made in instrumentation.
            // When recorded loopStack->top().funcLevel is different
            // with the current FuncStackLevel, two possible errors
            // happen during instrumentation:
            // 1) the loop entry is wrong, earlier than the real place;
            // 2) return of at least one function call inside the loop
            //    is missing.
            // So far it seems the first case happens sometimes but
            // the second case has never been seen. Thus whenever we
            // encounter such problem, we trust the current FuncStackLevel
            // and update top().funcLevel.
            if (loopStack->top().funcLevel != FuncStackLevel) {
                if (DP_DEBUG) {
                    cout << "WARNING: changing funcLevel of Loop " << loopStack->top().loopID << " from "
                         << loopStack->top().funcLevel << " to " << FuncStackLevel << endl;
                }
                loopStack->top().funcLevel = FuncStackLevel;
            }
        }
    }

    void __dp_loop_exit(LID lid, int32_t loopID) {
#ifdef DP_PTHREAD_COMPATIBILITY_MODE
        std::lock_guard<std::mutex> guard(pthread_compatibility_mutex);
#endif
#ifdef DP_RTLIB_VERBOSE
        cout << "__dp_loop_exit\n";
#endif
        if (targetTerminated) {
            if (DP_DEBUG) {
                cout << "__dp_loop_exit() is not executed since target program has returned from main()." << endl;
            }
            return;
        }
        assert((loopStack != nullptr) && "Loop stack is not available!");

        // __dp_loop_exit() can be called without __dp_loop_entry()
        // being called. This can happen when a loop is encapsulated
        // by an "if" strucutre, and the condition of "if" fails
        bool singleExit = false;
        if (loopStack->empty())
            singleExit = true;
        else if (loopStack->top().loopID != loopID)
            singleExit = true;

        if (singleExit) {
            if (DP_DEBUG) {
                cout << "Ignored signle exit of loop " << loopStack->top().loopID << endl;
            }
            return;
        }

        // See comments in __dp_loop_entry() for explanation.
        if (loopStack->top().funcLevel != FuncStackLevel) {
            if (DP_DEBUG) {
                cout << "WARNING: changing funcLevel of Loop " << loopStack->top().loopID << " from "
                     << loopStack->top().funcLevel << " to " << FuncStackLevel << endl;
            }
            loopStack->top().funcLevel = FuncStackLevel;
        }

        LoopRecords::iterator loop = loops->find(loopStack->top().begin);
        assert(loop != loops->end() && "A loop ends without its entry being recorded.");
        if (loop->second->end == 0) {
            loop->second->end = lid;
        } else {
            // New loop exit found and it's smaller than before. That means
            // the current exit point can be the break inside the loop.
            // In this case we ignore the current exit point and keep the
            // regular one.

            // Note: keep, as i may be necessary in the future?
            if (lid < loop->second->end) {
                //    loop->second->end = lid;
            }
                // New loop exit found and it's bigger than before. This can
                // happen when the previous exit is a break inside the loop.
                // In this case we update the loop exit to the bigger one.
            else if (lid > loop->second->end) {
                loop->second->end = lid;
            }
            // New loop exit found and it's the same as before. Good.
        }
        if(loop->second->maxIterationCount < loopStack->top().count){
            loop->second->maxIterationCount = loopStack->top().count;
        }
        loop->second->total += loopStack->top().count;
        ++loop->second->nEntered;

        if (DP_DEBUG) {
            cout << "(" << std::dec << loopStack->top().funcLevel << ")";
            cout << "Loop " << loopStack->top().loopID << " exits." << endl;
        }

        loopStack->pop();

        if (DP_DEBUG) {
            if (loopStack->empty())
                cout << "Loop Stack is empty." << endl;
            else {
                cout << "TOP: (" << std::dec << loopStack->top().funcLevel << ")";
                cout << "Loop " << loopStack->top().loopID << "." << endl;
            }
        }
    }
    }
} // namespace __dp
