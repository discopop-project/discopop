#include <stdio.h>
#include <stdlib.h>

int main(int argc, const char *argv[]) {
  static int n = 10000;
  double *x = (double *)malloc(n * sizeof(double));
  int i;

  // initialization, do-all parallelizable
  for (i = 0; i < n; i++) {
    x[i] = i % 42;
  }

  // computation proxy, not parallelizable!
  for (i = 1; i < n; i++) {
    x[i] = x[i - 1];
  }

  free(x);
  return 0;
}
