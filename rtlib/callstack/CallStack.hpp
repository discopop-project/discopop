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

#include "../DPUtils.hpp"
#include <set>
#include <vector>

#define DBG 0

using namespace dputil;

struct CallStackEntry {
  short type; // 0: function, 1: loop
  unsigned long counter = 0;

  LID lid;

  CallStackEntry(short arg_type, LID arg_lid, unsigned long arg_counter)
      : type(arg_type), lid(arg_lid), counter(arg_counter){};

  ~CallStackEntry() {
    if (DBG) {
      cout << "DBG: deleted CallStackEntry of type: " << toString() << "\n";
    }
  }

  CallStackEntry *getCopy();

  std::string toString();

  bool operator==(const CallStackEntry &rhs) const {
    if (type != rhs.type)
      return false;
    if (counter != rhs.counter)
      return false;
    if (lid != rhs.lid)
      return false;
    return true;
  }

  inline bool isLoop();

  inline bool isFunction();
};

struct CallStack {
  // Constructors
  CallStack() {
    if (DBG) {
      cout << "DBG: Created CallStack\n";
    }
  };
  // Destructors
  ~CallStack() {
    if (DBG) {
      cout << "DBG: Deleting CallStack\n";
    }
    while (stack.size() > 0) {
      pop();
    }
    if (DBG) {
      cout << "DBG: CallStack deleted\n";
    }
  };

  CallStack *getCopy() {
    CallStack *copy = new CallStack();
    for (auto elem : stack) {
      copy->stack.push_back(elem->getCopy());
    }
    if (DBG) {
      cout << "DBG: Copied CallStack\n";

      cout << "Original: \n";
      print();
      cout << "Copy: \n";
      copy->print();
      cout << "\n";
    }
    return copy;
  };

  // Functions
  void push(CallStackEntry *cse) {
    // prevent duplicate push of loop
    // this is an artifact of the implementation of __dp_func_entry, as it
    // relies on the "loops" hashmap to remove duplicates upon "insert"
    if (stack.size() > 0) {
      if (stack.back()->lid == cse->lid && stack.back()->type == 1 && cse->type == 1) {
        return;
      }
    }

    stack.push_back(cse);
    if (DBG) {
      cout << "DBG: push type: " << to_string(cse->type) << "\n";
      ;
    }
  }

  void pop() {
    CallStackEntry *p_cse = stack.back();
    if (DBG) {
      cout << "DBG: pop type: " << to_string(p_cse->type) << "\n";
      ;
    }
    stack.pop_back();
    delete p_cse;
  }

  void popLoop() {
    if (stack.back()->type == 1) {
      pop();
    }
  }

  void popFunction() {
    if (stack.back()->type == 0) {
      pop();
    }
  }

  void incrementIterationCounter() { stack.back()->counter++; }

  void print() const {
    cout << "CallStack: \n";
    cout << "--> Length: " << stack.size() << "\n";
    for (CallStackEntry *entry : stack) {
      cout << "  " << entry->toString() << " ptr: " << entry << "\n";
    }

    cout << "\n";
  };

  int size() { return stack.size(); }

  CallStackEntry *getElement(int n) { return stack.at(n); }

  void util_compare_callstacks(CallStack *cs_1, CallStack *cs_2, std::set<LID> *intra_iteration_dependencies,
                               std::set<LID> *inter_iteration_dependencies, std::set<LID> *intra_call_dependencies,
                               std::set<LID> *inter_call_dependencies);

  // Values
  std::vector<CallStackEntry *> stack;
};

/*
void compare_callstacks(CallStack* cs_1, CallStack* cs_2, std::set<LID>*
intra_iteration_dependencies, std::set<LID>* inter_iteration_dependencies,
std::set<LID>* intra_call_dependencies, std::set<LID>* inter_call_dependencies){

    // if any are nullptr, no information on the dependency type is contained
    if((!cs_1) || (!cs_2)){
        return;
    }

    if(DBG)
        cout << "compare CallStacks: \n";

    // iterate along CallStacks (check equal call paths)
    bool deviated_before = false;
    for(int i = 0; i < min(cs_1->size(), cs_2->size()); i++){
        CallStackEntry* element_1 = cs_1->getElement(i);
        CallStackEntry* element_2 = cs_2->getElement(i);
        if(DBG){
            cout << "i: " << i << "\n";
            cout << "  element_1: " << element_1->toString() << "\n";
            cout << "  element_2: " << element_2->toString() << "\n";
        }

        // check for deviations in the CallStack
        bool elements_differ = false;
        if(!(*element_1 == *element_2)){
            elements_differ = true;
        }

        // check for intra iteration dependencies
        if(! deviated_before){
            if(!elements_differ){
                if(element_1->isLoop()){
                    intra_iteration_dependencies->insert(element_1->lid);
                }
            }
        }

        // check for inter iteration dependencies
        if(! deviated_before){
            if(elements_differ){
                if(element_1->isLoop() && element_2->isLoop()){
                    if(element_1->lid == element_2->lid){
                        if(element_1->counter != element_2->counter){
                            inter_iteration_dependencies->insert(element_1->lid);
                        }
                    }
                }
            }
        }

        // check for intra call dependencies
        if(!deviated_before){
            if(!elements_differ){
                if(element_1->isFunction()){
                    intra_call_dependencies->insert(element_1->lid);
                }
            }
        }

        // check for inter call dependencies
        if(!deviated_before){
            if(elements_differ){
                if(element_1->isFunction() && element_2->isFunction()){
                    if(element_1->lid == element_2->lid){
                        if(element_1->counter != element_2->counter){
                            inter_call_dependencies->insert(element_1->lid);
                        }
                    }
                }
            }
        }

        // register deviation for successive iterations
        if(elements_differ){
            deviated_before = true;
        }
    }

    // check differing call paths
    // TODO check all combinations of call stack entrys to support multiple
entry points and call stacks of variable length for(CallStackEntry* element_1 :
cs_1->stack){ for(CallStackEntry* element_2 : cs_2->stack){

            // check for inter call dependencies
            if(element_1->isFunction() && element_2->isFunction()){
                if(element_1->lid == element_2->lid){
                    if(element_1->counter != element_2->counter){
                        inter_call_dependencies->insert(element_1->lid);
                    }
                }
            }
        }
    }
    if(DBG)
        cout << "\n";

}
*/