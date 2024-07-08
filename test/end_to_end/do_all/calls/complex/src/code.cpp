#include <stdio.h>
#include <stdlib.h>

void perform_calculation(double *base, int offset_1, int offset_2) { base[offset_1] = 42 + base[offset_2]; }

void doall_possible(double *base, int index) { perform_calculation(base, index, index); }

void doall_not_possible(double *base, int index, int n) { perform_calculation(base, index, (index + 422 % n)); }

int main(int argc, const char *argv[]) {
  static int n = 5000;
  static double a = 2.0; // n = 100000000;
  double *x = (double *)malloc(n * sizeof(double));
  // Initialize x

  // DOALL
  for (int i = 0; i < n; ++i) {
    x[i] = 1.0;
  }

  // DOALL
  for (int i = 0; i < n; i++) {
    doall_possible(x, i);
  }

  // NOT DOALL
  for (int i = 0; i < n; i++) {
    doall_not_possible(x, i, n);
  }

  free(x);
  ;
  return 0;
}
