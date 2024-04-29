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

#include <stdint.h>
#include <iostream>

using namespace std;

namespace __dp {

    class ShadowMemory : public Shadow {
    public:
        ShadowMemory(int slotSize, int size, int numHash) {
            sigRead = new Signature(slotSize, size, numHash);
            sigWrite = new Signature(slotSize, size, numHash);
        }

        ~ShadowMemory() {
            delete sigRead;
            delete sigWrite;
        }

        inline sigElement testInRead(int64_t memAddr) {
            return sigRead->membershipCheck(memAddr);
        }

        inline sigElement testInWrite(int64_t memAddr) {
            return sigWrite->membershipCheck(memAddr);
        }

        inline sigElement insertToRead(int64_t memAddr, sigElement value) {
            return sigRead->insert(memAddr, value);
        }

        inline sigElement insertToWrite(int64_t memAddr, sigElement value) {
            return sigWrite->insert(memAddr, value);
        }

        inline void updateInRead(int64_t memAddr, sigElement newValue) {
            sigRead->update(memAddr, newValue);
        }

        inline void updateInWrite(int64_t memAddr, sigElement newValue) {
            sigWrite->update(memAddr, newValue);
        }

        inline void removeFromRead(int64_t memAddr) {
            sigRead->remove(memAddr);
        }

        inline void removeFromWrite(int64_t memAddr) {
            sigWrite->remove(memAddr);
        }

        inline std::unordered_set<ADDR> getAddrsInRange(int64_t startAddr, int64_t endAddr){
            // not possible for Shadow, since not all addresses are kept
            std::unordered_set<ADDR> result;
            return result;
        }


    private:
        Signature *sigRead;
        Signature *sigWrite;
    };

} // namespace __dp
