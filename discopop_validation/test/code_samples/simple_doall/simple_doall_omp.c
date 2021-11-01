#include <stdio.h>
#include <omp.h>

int main(){
    int arr[10];
    #pragma omp parallel for shared(arr)
    for(int i=0; i < 10; i++){
        arr[i] = i;
        arr[i] += 3;
    }

    int x = 3;
    #pragma omp parallel for firstprivate(x) shared(arr)
    for(int i=0; i < 1000000; i++){
        arr[x] = i;
        arr[x] += 3;
    }

}
