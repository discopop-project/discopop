int x = 42;
#pragma omp task private(x)
int z = 142;