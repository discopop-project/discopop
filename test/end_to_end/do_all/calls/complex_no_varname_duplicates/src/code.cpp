#include <stdio.h>
#include <stdlib.h>

void perform_calculation(double *base_1, int offset_1, int offset_2) { base_1[offset_1] = 42 + base_1[offset_2]; }

void doall_possible(double *base_2, int index_2) { perform_calculation(base_2, index_2, index_2); }

void doall_not_possible(double *base_3, int index_3, int n_3) {
  perform_calculation(base_3, index_3, (index_3 + 422 % n_3));
}

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
