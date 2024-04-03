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

#include <stdint.h>
#include <map>
#include <iostream>


namespace __dp {

    class Shadow {
    public:
        virtual ~Shadow() {}

        virtual sigElement testInRead(int64_t memAddr);

        virtual sigElement testInWrite(int64_t memAddr);

        virtual sigElement insertToRead(int64_t memAddr, sigElement value);

        virtual sigElement insertToWrite(int64_t memAddr, sigElement value);

        virtual void updateInRead(int64_t memAddr, sigElement newValue);

        virtual void updateInWrite(int64_t memAddr, sigElement newValue);

        virtual void removeFromRead(int64_t memAddr);

        virtual void removeFromWrite(int64_t memAddr);

        virtual CallStack* getLastReadAccessCallStack(int64_t memAddr);

        virtual void setLastReadAccessCallStack(int64_t memAddr, CallStack* p_cs);

        virtual void cleanReadAccessCallStack(int64_t memAddr);

        virtual CallStack* getLastWriteAccessCallStack(int64_t memAddr);

        virtual void setLastWriteAccessCallStack(int64_t memAddr, CallStack* p_cs);

        virtual void cleanWriteAccessCallStack(int64_t memAddr);

    };

} // namespace __dp
