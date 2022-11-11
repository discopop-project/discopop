#include <stdio.h>

int main(){
    int N = 100000;
    long sum;
    int Arr[N];

    for(int i = 0; i < N; i++){
        Arr[i] = i % 13;
    }

    for(int i = 0; i < N; i++){
        sum = sum + Arr[i];
    }
    
    printf("Sum: %ld\n", sum);
}