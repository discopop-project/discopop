#include <stdio.h>
#include <stdlib.h>

void prevent_doall(double *tmp, int i) {
  int z = i + tmp[i - 1];
  tmp[i] = z + 2;
}

int main(int argc, const char *argv[]) {
  static int n = 100;
  double *x = (double *)malloc(n * sizeof(double));
  // Initialize x, y
  // NOT DOALL
  for (int i = 1; i < n; ++i) {
    x[i] = 1.0;
    prevent_doall(x, i);
  }
  free(x);
  return 0;
}
