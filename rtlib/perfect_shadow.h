/*-
Copyright (c) 2019, Technische Universität Darmstadt & Iowa State University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef _DP_PERFECTSHADOW_H_
#define _DP_PERFECTSHADOW_H_

#include "signature.h"
#include "abstract_shadow.h"

#include <stdint.h>
#include <map>
#include <iostream>


namespace __dp
{

    class PerfectShadow : public Shadow
    {
    public:
        PerfectShadow(int slotSize, int size, int numHash)
            : PerfectShadow() {}

        PerfectShadow()
        {
            sigRead = new std::map<int64_t, sigElement>();
            sigWrite = new std::map<int64_t, sigElement>();
        }

        ~PerfectShadow()
        {
            delete sigRead;
            delete sigWrite;
        }

        inline sigElement testInRead(int64_t memAddr)
        {
            return (*sigRead)[memAddr];
        }

        inline sigElement testInWrite(int64_t memAddr)
        {
            return (*sigWrite)[memAddr];
        }

        inline sigElement insertToRead(int64_t memAddr, sigElement value)
        {
            sigElement oldValue = testInRead(memAddr);
            (*sigRead)[memAddr] = value;
            return oldValue;
        }

        inline sigElement insertToWrite(int64_t memAddr, sigElement value)
        {
            sigElement oldValue = testInWrite(memAddr);
            (*sigWrite)[memAddr] = value;
            return oldValue;
        }

        inline void updateInRead(int64_t memAddr, sigElement newValue)
        {
            (*sigRead)[memAddr] = newValue;
        }

        inline void updateInWrite(int64_t memAddr, sigElement newValue)
        {
            (*sigWrite)[memAddr] = newValue;
        }

        inline void removeFromRead(int64_t memAddr)
        {
            (*sigRead)[memAddr] = 0;
        }

        inline void removeFromWrite(int64_t memAddr)
        {
            (*sigWrite)[memAddr] = 0;
        }

    private:
        std::map <int64_t, sigElement> *sigRead;
        std::map <int64_t, sigElement> *sigWrite;
    };

} // namespace __dp
#endif
