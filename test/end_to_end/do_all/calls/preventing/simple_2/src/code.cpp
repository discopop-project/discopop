#include <stdio.h>
#include <stdlib.h>

void prevent_doall(double* tmp, int i){
    for(int j = 0; j < 10; j++){
        tmp[j] = i;
    }
}

int main(int argc, const char* argv[]) {
    static int n = 10;
    double *x = (double *) malloc(n * sizeof(double));
    // Initialize x, y
    for(int i = 0; i < n; ++i){
        x[i] = i;
    }

    // parallelizable
    int index;
    for(int i = 0; i < n; ++i){
        prevent_doall(x, i);
    }
    free(x);
return 0;
}
