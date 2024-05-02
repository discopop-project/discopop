/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#define N 10000
int global_array[N];
int global_var = 0;

struct test_struct {
  int var_1;
  int var_2;
};

void reduction() {
  static int static_var = 0;
  int local_array[10] = {0};
  int local_multi_dim_array[10][10] = {0};
  int local_var = 0;
  float local_var_f = 0.0f;
  double local_var_f2 = 0.0;

  // ==== all possible reduction operations ====================================
  for (int i = 0; i < N; i++) {
    local_var += global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var *= global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var -= global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var &= global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var |= global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var ^= global_array[i];
  }

  // ==== local & global variables =============================================
  for (int i = 0; i < 10; i++) {
    local_var += local_array[i];
  }
  for (int i = 0; i < 10; i++) {
    global_var += local_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var += global_array[i];
  }
  for (int i = 0; i < N; i++) {
    global_var += global_array[i];
  }
  for (int i = 0; i < N; i++) {
    static_var += global_array[i];
  }

  // ==== different loop line numbers for load & store instructions ============
  for (int i = 0; i < N; i++) {
    int tmp_var = local_var;
    local_var = tmp_var + 1;
  }
  for (int i = 0; i < N; i++) {
    int tmp_var = local_var + 1;
    local_var = tmp_var;
  }
  for (int i = 0; i < N; i++) {
    int tmp_var = local_var + global_array[i];
    local_var = tmp_var;
  }

  // ==== other data types =====================================================
  for (int i = 0; i < N; i++) {
    local_var_f += (float)global_array[i];
  }
  for (int i = 0; i < N; i++) {
    local_var_f2 += (double)global_array[i];
  }

  // ==== nested loops =========================================================
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < 10; j++) {
      local_var += global_array[i] + j;
    }
  }
  for (int i = 0; i < N; i++) {
    global_var += global_array[i];
    for (int j = 0; j < 10; j++) {
      local_var += global_array[i] + j;
    }
  }
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < 10; j++) {
      local_var += global_array[i] + j;
    }
    global_var += global_array[i];
  }

  // ==== multi-dimensional arrays =============================================
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      local_var += local_multi_dim_array[i][j];
    }
  }

  // ==== writing to arrays ====================================================
  for (int i = 0; i < N; ++i) {
    local_array[5] += 1;
  }
  for (int i = 0; i < N; ++i) {
    int tmp_var = 5;
    local_array[tmp_var] += 1;
  }
  for (int i = 0; i < N; ++i) {
    int tmp_var_38 = local_array[5];
    local_array[5] = tmp_var_38 + 1;
  }
  for (int i = 0; i < N; ++i) {
    local_array[5] = local_array[5] + 1;
  }
  for (int i = 0; i < N; ++i) {
    local_multi_dim_array[5][5] += 1;
  }
  for (int i = 0; i < 10; ++i) {
    local_array[i] += 1;
  }

  // ==== other cases ==========================================================
  for (int i = 0; i < 10; ++i) {
    local_var = local_array[i] * 2 + local_var;
  }

  for (int i = 0; i < 10; ++i) {
    local_var = local_array[i] * 2 * local_var;
  }
}

void no_reduction() {
  int local_var = 0;
  int local_array[10] = {0};
  struct test_struct local_struct;

  // ==== different # of read and store instructions ===========================
  for (int i = 0; i < N; i++) {
    local_var += global_array[i];
    int tmp_var = local_var;
  }
  for (int i = 0; i < N; i++) {
    local_var += global_array[i];
    local_var = 0;
  }
  for (int i = 0; i < N; i++) {
    if (i % 2 == 0) {
      local_var += global_array[i];
    } else {
      int tmp_var = local_var;
    }
  }

  // ==== more than one load & store instruction ===============================
  for (int i = 0; i < N; i++) {
    local_var += global_array[i];
    local_var -= 2;
  }

  // ==== wrong instruction order ==============================================
  for (int i = 0; i < N; i++) {
    local_var = 0;
    int tmp_var = local_var + 1;
  }

  // ==== different array index written / read =================================
  for (int i = 0; i < 9; ++i) {
    local_array[i] = local_array[i + 1] + 1;
  }
  for (int i = 0; i < 9; ++i) {
    local_array[4] = local_array[5] + 1;
  }

  // ==== struct member reduction is not possible in OpenMP ====================
  for (int i = 0; i < 10; ++i) {
    local_struct.var_1 += 1;
  }

  int test_x = 0;
  int counter = 10;
  while (--counter) {
    test_x++;
  }

  // ==== other cases ==========================================================
  for (int i = 1; i < 10; ++i) {
    local_array[i] = local_array[i] + local_array[i - 1];
  }

  for (int i = 0; i < 10; ++i) {
    test_x = test_x * 10 + local_array[i];
  }
}

int main(int argc, char **argv) {
  for (int i = 0; i < N; i++)
    global_array[i] = i;

  reduction();
  no_reduction();

  return 0;
}
