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

#include "signature.h"

#include "stdint.h"
#include <iostream>
using namespace std;

namespace __dp
{
    // Byte wise signature



    // insert new value into signature
    // low index of signature store the lower part of value
    // for example value is in 16 bits store in
    // sigarray[0] and sigarray[1]:
    // value:    16 ------ 8 7 ------- 0
    //           |         | |         |
    // sigarray: |--- 0 ---| |--- 1 ---|
    //
    // The semantic of insert means elem is always a new
    // element. Hence if the slot selected for elem is
    // already used, a conflict is detected. In this case
    // the value is still inserted, which means the old
    // value is overwritten. Meanwhile, conflictElem is
    // increased by 1.
    sigElement Signature::insert(int64_t elem, sigElement value)
    {
        int32_t begin = hash(elem) * sigSlotSizeInByte;
        int32_t end = begin + sigSlotSizeInByte - 1;
        sigElement oldValue = 0;
        sigElement temp = 0;
        for (int i = end; i >= begin; --i)
        {
            temp = sigarray[i];
            oldValue += temp << (end - i) * 8;
            sigarray[i] = (uint8_t)value;
            value >>= 8;
        }
        return oldValue;
    }

    // update the value of elem to newValue
    // For update the conflict detection is not necessary.
    void Signature::update(int64_t elem, sigElement newValue)
    {
        int32_t begin = hash(elem) * sigSlotSizeInByte;
        int32_t end = begin + sigSlotSizeInByte - 1;
        for (int i = end; i >= begin; --i)
        {
            sigarray[i] = (int8_t)newValue;
            newValue >>= 8;
        }
    }

    // remove elem from sigarray
    // should be checked.
    void Signature::remove(int64_t elem)
    {
        int32_t begin = hash(elem) * sigSlotSizeInByte;
        int32_t end = begin + sigSlotSizeInByte - 1;
        for (int i = begin; i <= end; ++i)
        {
            sigarray[i] = 0;
        }
    }

    // test if elem is already exist in sigarray
    // see comments for Signature::insert()
    // for data layout information
    sigElement Signature::membershipCheck(int64_t elem)
    {
        sigElement res = 0;
        int32_t begin = hash(elem) * sigSlotSizeInByte;
        int32_t end = begin + sigSlotSizeInByte - 1;
        for (int i = begin; i <= end; ++i)
        {
            res = (res << 8) + sigarray[i];
        }
        return res;
    }

    bool Signature::intersect(Signature &other)
    {
        return false;
    }

    double Signature::expectedFalsePositiveRate()
    {
        double result = 0.0;
        return result;
    }
} //namespace __dp
