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

#include "CallStack.hpp"

CallStackEntry* CallStackEntry::getCopy(){
        CallStackEntry* copy = new CallStackEntry(type, lid, counter);
        return copy;
    }

    std::string CallStackEntry::toString() {
        if(type == 0){
            return "Function (" + decodeLID(lid) + ") @ callid: " + to_string(counter);
        }
        else if(type == 1){
            return "Loop (" + decodeLID(lid) + ") @ it: " + to_string(counter);
        }
        else{
            return "Unknown";
        }
    };

    

    inline bool CallStackEntry::isLoop(){
        return type == 1;
    }

    inline bool CallStackEntry::isFunction(){
        return type == 0;
    }

    void CallStack::util_compare_callstacks(CallStack* cs_1, CallStack* cs_2, std::set<LID>* intra_iteration_dependencies,
                        std::set<LID>* inter_iteration_dependencies, std::set<LID>* intra_call_dependencies,
                        std::set<LID>* inter_call_dependencies){

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
    // TODO check all combinations of call stack entrys to support multiple entry points and call stacks of variable length
    for(CallStackEntry* element_1 : cs_1->stack){
        for(CallStackEntry* element_2 : cs_2->stack){

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