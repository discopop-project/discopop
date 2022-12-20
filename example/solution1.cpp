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

#include <stdio.h>

int main(){
    int N = 100000;
    long sum = 0;
    int Arr[N];

    #pragma omp parallel shared(Arr,N)
    {
        #pragma omp for 
        for(int i = 0; i < N; i++){
            Arr[i] = i % 13;
        }

        #pragma omp for reduction(+:sum)
        for(int i = 0; i < N; i++){
            sum += Arr[i];
        }
    } // end of parallel region
}