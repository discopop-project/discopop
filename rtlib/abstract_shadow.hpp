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

#ifndef _DP_ASHADOW_H_
#define _DP_ASHADOW_H_

#include "signature.hpp"

#include <stdint.h>
#include <map>
#include <iostream>


namespace __dp
{

    class Shadow
    {
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

    };

} // namespace __dp
#endif
