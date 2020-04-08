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
#include <cmath>
#include <climits>

void merge(int A[], int p, int q, int r){
  int n1 = q - p + 1;
  int n2 = r - q;
  int L[n1 + 1];
  int R[n2 + 1];
  int i = 0;
  int j = 0;
  for(; i < n1; i++){
    L[i] = A[p + i];
  }
  for(; j < n2; j++){
    R[j] = A[q + j + 1];
  }
  L[n1] = INT_MAX;
  R[n2] = INT_MAX;
  i = 0; j = 0;
  for(int k = p; k <= r; k++){
    if(L[i] <= R[j]){
      A[k] = L[i];
      i++;
    }else{
      A[k] = R[j];
      j++;
    }
  }
}

void sort(int A[], int p, int r){
  if(p < r){
    int q = floor((p+r)/2);
    sort(A, p, q);
    sort(A, q + 1, r);
    merge(A, p, q, r);
  }
}

int main(){
  int array[10] = {1, 0, 5, 8, 4, 2, 7, 1, 3, 2};
  sort(array, 0, 9);
  for(int i = 0; i < 10; i++){
    printf("%d", array[i]);
  }
  return 0;
}
