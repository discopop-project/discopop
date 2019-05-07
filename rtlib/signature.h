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

#ifndef _DP_SIGNATURE_H_
#define _DP_SIGNATURE_H_

#include <stdint.h>
#include <assert.h>

#include <iostream>
using namespace std;
typedef  int32_t sigElement;

namespace __dp
{
    class Signature
    {
    public:
        Signature(int32_t slotSize, int32_t size, int32_t numOfHash = 1) :
            sigSlotSize(slotSize), numSlot(size), numHash(numOfHash)
        {
            assert((slotSize % 8 == 0) && (slotSize <= 32 && slotSize >= 8) && "slotSize must be byte aligned!");
            sigSlotSizeInByte = sigSlotSize / 8;
            sigSizeInByte = sigSlotSizeInByte * numSlot;

            sigarray = new uint8_t[sigSizeInByte];
            for (int i = 0; i < sigSizeInByte; ++i)
            {
                sigarray[i] = 0;
            }

            insertedElem = 0;
            conflictElem = 0;
        }

        ~Signature()
        {
            delete [] sigarray;
        }

        sigElement insert(int64_t elem, sigElement value);
        void update(int64_t elem, sigElement newValue);
        void remove(int64_t elem);
        sigElement membershipCheck(int64_t elem);
        bool intersect(Signature &other);
        double expectedFalsePositiveRate();

    private:
        int32_t sigSlotSize;        // in bits
        int32_t numSlot;
        int32_t numHash;            // 1 by default
        int32_t sigSlotSizeInByte;  // slot size in byte
        int32_t sigSizeInByte;      // total size in byte
        uint8_t *sigarray;

        int32_t insertedElem;
        int32_t conflictElem;

        uint32_t hash(int64_t value)
        {
            //cout << "hash: " << std::hex << value << ", " << std::dec << numSlot << endl;
            return (uint32_t)((value >> 8) + value) % numSlot;
        }
    };
} // namespace __dp
#endif
