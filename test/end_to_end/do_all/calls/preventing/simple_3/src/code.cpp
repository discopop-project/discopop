#include <stdlib.h>

void not_prevent_doall(double* tmp, int i){
    int z = i + tmp[i];
}

void prevent_doall(double* tmp, int i){
    for(int j = 0; j < 10; j++){  // wo w
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

    // not parallelizable
    for(int i = 0; i < n; ++i){
        prevent_doall(x, i);
    }

    // parallelizable
    for(int i = 0; i < n; ++i){
        not_prevent_doall(x, i);
    }
    free(x);
return 0;
}
