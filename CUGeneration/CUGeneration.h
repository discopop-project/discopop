#ifndef CUDGENERATION_H
#define CUDGENERATION_H

#include "DPUtils.h"

#include <algorithm>
#include <iomanip>
#include <map>
#include <set>
#include <string.h>
#include <utility>

using namespace llvm;
using namespace std;
using namespace dputil;

namespace {

static unsigned int CUIDCounter;
static bool defaultIsGlobalVariableValue;
int32_t fileID;

typedef struct Variable_struct {
  string name;
  string type;
  string defLine;
  string isArray;

  Variable_struct(const Variable_struct &other)
      : name(other.name), type(other.type), defLine(other.defLine) {}

  Variable_struct(string n, string t, string d)
      : name(n), type(t), defLine(d) {}

  // We have a set of this struct. The set doesn't know how to order the
  // elements.
  inline bool operator<(const Variable_struct &rhs) const {
    return name < rhs.name;
  }

  inline bool operator>(const Variable_struct &rhs) const {
    return name > rhs.name;
  }

} Variable;

enum nodeTypes { cu, func, loop, dummy } type;

typedef struct Node_struct {
  string ID;
  nodeTypes type;
  int startLine;
  int endLine;



  BasicBlock *BB;

  // Only for func type
  string name;
  vector<Variable> argumentsList;
  set<int> returnLines;

  vector<Node_struct *> childrenNodes;
  Node_struct *parentNode;

  // isRecursive function (Mo 5.11.2019)
  string recursiveFunctionCall = "";

  Node_struct() {
    ID = to_string(fileID) + ":" + to_string(CUIDCounter++);
    parentNode = NULL;
    BB = NULL;
  }
} Node;

typedef struct CU_struct : Node_struct {

  string BBID; // BasicBlock Id where the CU appears in

  // BasicBlock *BB;

  unsigned readDataSize;  // number of bytes read from memory by the cu
  unsigned writeDataSize; // number of bytes written into memory during the cu
  unsigned instructionsCount;

  // basic block id & successor basic blocks for control dependence
  vector<string> successorCUs; // keeps IDs of control dependent CUs
  string basicBlockName;

  set<int> instructionsLineNumbers;
  set<int> readPhaseLineNumbers;
  set<int> writePhaseLineNumbers;
  set<int> returnInstructions;

  set<Variable> localVariableNames;
  set<Variable> globalVariableNames;

  // Map to record function call line numbers
  map<int, vector<Node *>> callLineTofunctionMap;

  CU_struct() {
    type = nodeTypes::cu;
    readDataSize = 0;
    writeDataSize = 0;
    instructionsCount = 0;
    // BB = NULL;
  }

  void removeCU() {
    CUIDCounter--; // if a CU does not contain any instruction, e.g. entry
                   // basic blocks, then remove it.
  }

} CU;

class CUGeneration : public FunctionPass {
private:
  ofstream *outCUs;
  ofstream *outOriginalVariables;
  ofstream *outCUIDCounter;
  // Mohammad 23.12.2020
  map<string, string> loopStartLines;

  // structures to get list of global variables
  Module *ThisModule;
  set<string> programGlobalVariablesSet;
  // set<string> originalVariablesSet;

  // used to get variable names. Originally appeared in DiscoPoP code!
  map<string, MDNode *> Structs;
  map<string, Value *> VarNames;

  RegionInfoPass *RIpass;
  RegionInfo *RI;

public:
  // DiscoPoP Functions
  string determineVariableType(Instruction *I);
  string  determineVariableName(Instruction *I,
                        bool &isGlobalVariable = defaultIsGlobalVariableValue);
  Type *pointsToStruct(PointerType *PTy);
  string getOrInsertVarName(string varName, IRBuilder<> &builder);
  string findStructMemberName(MDNode *structNode, unsigned idx,
                              IRBuilder<> &builder);
  // DIGlobalVariable* findDbgGlobalDeclare(GlobalVariable *v);

  // 29.6.2020 Mohammad
  string determineVariableDefLine(Instruction *I);
  void getFunctionReturnLines(Region *TopRegion, Node *root);

  // functions to get list of global variables
  bool doInitialization(Module &ThisModule);
  bool doFinalization(Module &M);
  void collectGlobalVariables();

  // functions to get recursive functions (Mo 5.11.2019)
  bool isRecursive(Function &F, CallGraph &CG);

  // Populate variable sets global to BB
  void populateGlobalVariablesSet(Region *TopRegion,
                                  set<string> &globalVariablesSet);
  void createCUs(Region *TopRegion, set<string> &globalVariablesSet,
                 vector<CU *> &CUVector,
                 map<string, vector<CU *>> &BBIDToCUIDsMap, Node *root,
                 LoopInfo &LI);
  // string refineVarName(string varName);
  void fillCUVariables(Region *TopRegion, set<string> &globalVariablesSet,
                       vector<CU *> &CUVector,
                       map<string, vector<CU *>> &BBIDToCUIDsMap);
  void fillStartEndLineNumbers(Node *root, LoopInfo &LI);
  void findStartEndLineNumbers(Node *root, int &start, int &end);

  // Output function
  void initializeCUIDCounter();
  string xmlEscape(string data);
  void secureStream();
  string getLineNumbersString(set<int> LineNumbers);
  string getChildrenNodesString(Node *node);
  // void printOriginalVariables(set<string> &originalVariablesSet);
  void printData(Node *node);
  void printTree(Node *node, bool isRoot);
  void printNode(Node *node, bool isRoot);
  void closeOutputFiles();

  virtual bool runOnFunction(Function &F);
  // changed const char * to Stringref
  StringRef getPassName() const;
  void getAnalysisUsage(AnalysisUsage &Info) const;

  static char ID;
  CUGeneration() : FunctionPass(ID) {}
}; // end of class CUGeneration
} // namespace
#endif /*CUDGENERATION_H*/