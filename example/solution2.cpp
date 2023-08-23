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
#include <omp.h>

#define CHUNK_LIMITS 1000
#define NUM_TASKS 100

int main(){
    int N = 100000;
    long sum = 0;
    int Arr[N];

    #pragma omp parallel reduction(+:sum)
    #pragma omp single
    for(int x=0; x<NUM_TASKS; x++) {
        #pragma omp task
        {
            int tid = omp_get_thread_num();
            for(int i = tid*CHUNK_LIMITS; i < tid * CHUNK_LIMITS + CHUNK_LIMITS; i++) {
                Arr[i] = i % 13;
            }

            for(int i = tid*CHUNK_LIMITS; i < tid * CHUNK_LIMITS + CHUNK_LIMITS; i++) {
                sum += Arr[i];
            }
        }
    }
}
