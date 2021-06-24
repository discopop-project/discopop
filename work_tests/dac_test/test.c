#include <stdio.h>
#include <stdlib.h>
// #include <omp.h>

int main(int argc, char* argv[])
{
    // omp_set_num_threads(32);
    int i;
    int len=100;
    int a[100];
    int b[100];
    int sum = 0;

    for (i=0;i<len;i++){
        a[i]=i;
        b[i]=i+1;
    }

    // #pragma omp parallel for
    for (i=0;i<len-1;i++){
        // #pragma omp ordered
        // {
        a[i+1]=a[i] + b[i]+1;
        // }
        b[i] = a[i+1] + 2;
    }

    for (i=0;i<50;i++){
        a[2*i+1]=a[i]+1;
    }

    for (i=0; i<len; i++){
        sum = sum + a[i];
    }

    for (i=0;i<len;i++){
        printf("a[%d] = %d\n", i, a[i]);
    }

    return 0;
}

