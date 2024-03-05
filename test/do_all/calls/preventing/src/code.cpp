#include <stdlib.h>
#include <stdio.h>

void prevent_doall(double* tmp, int i){
    // DOALL
    for(int j = 0; j < 10; j++){
        tmp[j] = i;
    }
}

int main(int argc, const char* argv[]) {
    static int n = 1000;
    double *x = (double *) malloc(n * sizeof(double));
    // Initialize x, y
    // NOT DOALL
    for(int i = 0; i < n; ++i){
        x[i] = 1.0;
        prevent_doall(x, i);
    }
    free(x);
return 0;
}
