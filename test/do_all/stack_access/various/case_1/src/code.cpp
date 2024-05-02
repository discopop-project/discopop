#include <stdio.h>
#include <stdlib.h>

int f(int t) {
  t = t * 42 + t - 2;
  return t;
}

int main(int argc, const char *argv[]) {
  static int n = 1000;
  double *x = (double *)malloc(n * sizeof(double));

  int k = 0;
  int s = 0;
  for (int i = 0; i < n; ++i) {
    s = f(i);
    x[i] = s;
  }
  k = f(s);

  free(x);
  return 0;
}
