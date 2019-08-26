/*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2019,
 * Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * a BSD-style license.  See the LICENSE file in the package base
 * directory for details.
 *
 */

#include <stdio.h>

int foo(int in, int d){
    return in * d;
}

int bar(int in, int d){
    return in + d;
}

int delta(int in, int d){
    return in -d;
}

int main( void)
{
    int i;
    int d = 20,a=22, b=44,c=90;
    for (i=0; i<100; i++) {
        a = foo(i, d);
        b = bar(a, d);
        c = delta(b, d);
    }
    a= b;
    return 0;
}