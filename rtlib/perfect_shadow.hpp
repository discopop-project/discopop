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

#pragma once

#include "signature.hpp"
#include "abstract_shadow.hpp"
#include "CallStack.hpp"

#include <stdint.h>
#include <unordered_map>
#include <iostream>


namespace __dp {

    class PerfectShadow : public Shadow {
    public:
        PerfectShadow(int slotSize, int size, int numHash)
                : PerfectShadow() {}

        PerfectShadow() {
            sigRead = new std::unordered_map<int64_t, sigElement>();
            sigWrite = new std::unordered_map<int64_t, sigElement>();
            addrToLastReadAccessCallStack = new std::unordered_map<int64_t, CallStack*>();
            addrToLastWriteAccessCallStack = new std::unordered_map<int64_t, CallStack*>();
        }

        ~PerfectShadow() {
            delete sigRead;
            delete sigWrite;
            for (auto elem : *addrToLastReadAccessCallStack){
                cleanReadAccessCallStack(elem.first);
            }
            for (auto elem: *addrToLastWriteAccessCallStack){
                cleanWriteAccessCallStack(elem.first);
            }
            delete addrToLastReadAccessCallStack;
            delete addrToLastWriteAccessCallStack;
        }

        inline sigElement testInRead(int64_t memAddr) {
            return (*sigRead)[memAddr];
        }

        inline sigElement testInWrite(int64_t memAddr) {
            return (*sigWrite)[memAddr];
        }

        inline sigElement insertToRead(int64_t memAddr, sigElement value) {
            sigElement oldValue = testInRead(memAddr);
            (*sigRead)[memAddr] = value;
            return oldValue;
        }

        inline sigElement insertToWrite(int64_t memAddr, sigElement value) {
            sigElement oldValue = testInWrite(memAddr);
            (*sigWrite)[memAddr] = value;
            return oldValue;
        }

        inline void updateInRead(int64_t memAddr, sigElement newValue) {
            (*sigRead)[memAddr] = newValue;
        }

        inline void updateInWrite(int64_t memAddr, sigElement newValue) {
            (*sigWrite)[memAddr] = newValue;
        }

        inline void removeFromRead(int64_t memAddr) {
            (*sigRead)[memAddr] = 0;
        }

        inline void removeFromWrite(int64_t memAddr) {
            (*sigWrite)[memAddr] = 0;
        }

        inline CallStack* getLastReadAccessCallStack(int64_t memAddr){
           return (*addrToLastReadAccessCallStack)[memAddr];
        }

        inline void setLastReadAccessCallStack(int64_t memAddr, CallStack* p_cs){
            // check if entry exists already
            std::unordered_map<int64_t, CallStack*>::const_iterator got = (*addrToLastReadAccessCallStack).find(memAddr);
            if ( got == (*addrToLastReadAccessCallStack).end() ){
                // no entry exists
                (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
            }
            else{
                // entry exists already. Cleanup the old CallStack and save the new one.
                CallStack* p_old_cs = (CallStack*) (*addrToLastReadAccessCallStack)[memAddr];
                if(p_old_cs){
                    delete p_old_cs;
                }
                (*addrToLastReadAccessCallStack)[memAddr] = p_cs;
            }
        }

        inline void cleanReadAccessCallStack(int64_t memAddr){
            if((*addrToLastReadAccessCallStack)[memAddr]){
                delete (*addrToLastReadAccessCallStack)[memAddr];
                (*addrToLastReadAccessCallStack)[memAddr] = nullptr;
            }
        }

        inline CallStack* getLastWriteAccessCallStack(int64_t memAddr){
           return (*addrToLastWriteAccessCallStack)[memAddr];
        }

        inline void setLastWriteAccessCallStack(int64_t memAddr, CallStack* p_cs){
            // check if entry exists already
            std::unordered_map<int64_t, CallStack*>::const_iterator got = (*addrToLastWriteAccessCallStack).find(memAddr);
            if ( got == (*addrToLastWriteAccessCallStack).end() ){
                // no entry exists
                (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
            }
            else{
                // entry exists already. Cleanup the old CallStack and save the new one.
                CallStack* p_old_cs = (CallStack*) (*addrToLastWriteAccessCallStack)[memAddr];
                if(p_old_cs){
                    delete p_old_cs;
                }
                (*addrToLastWriteAccessCallStack)[memAddr] = p_cs;
            }
        }

        inline void cleanWriteAccessCallStack(int64_t memAddr){
            if((*addrToLastWriteAccessCallStack)[memAddr]){
                delete (*addrToLastWriteAccessCallStack)[memAddr];
                (*addrToLastWriteAccessCallStack)[memAddr] = nullptr;
            }
        }

    private:
        std::unordered_map <int64_t, sigElement> *sigRead;
        std::unordered_map <int64_t, sigElement> *sigWrite;
        std::unordered_map <int64_t, CallStack*> *addrToLastReadAccessCallStack;
        std::unordered_map <int64_t, CallStack*> *addrToLastWriteAccessCallStack;
    };

} // namespace __dp
