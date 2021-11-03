/*
 * Cilk program to solve the 0-1 knapsack problem using a branch-and-bound
 * technique. 
 *
 * Author: Matteo Frigo
 */
/*
 * Copyright (c) 2000 Massachusetts Institute of Technology
 * Copyright (c) 2000 Matteo Frigo
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include "app-desc.h"
#include "bots.h"

int best_so_far;

int compare(struct item *a, struct item *b)
{
     double c = ((double) a->value / a->weight) -
     ((double) b->value / b->weight);

     if (c > 0) return -1;
     if (c < 0) return 1;
     return 0;
}

int read_input(const char *filename, struct item *items, int *capacity, int *n)
{
     int i;
     FILE *f;

     if (filename == NULL) filename = "\0";
     f = fopen(filename, "r");
     if (f == NULL) {
	  fprintf(stderr, "open_input(\"%s\") failed\n", filename);
	  return -1;
     }
     /* format of the input: #items capacity value1 weight1 ... */
     fscanf(f, "%d", n);
     fscanf(f, "%d", capacity);

     for (i = 0; i < *n; ++i)
	  fscanf(f, "%d %d", &items[i].value, &items[i].weight);

     fclose(f);

     /* sort the items on decreasing order of value/weight */
     /* cilk2c is fascist in dealing with pointers, whence the ugly cast */
     qsort(items, *n, sizeof(struct item), (int (*)(const void *, const void *)) compare);

     return 0;
}

/* 
 * return the optimal solution for n items (first is e) and
 * capacity c. Value so far is v.
 */
void knapsack(struct item *e, int c, int n, int v, int *sol)
{
     int with, without, best;
     double ub;

     /* base case: full knapsack or no items */
     if (c < 0)
     {
         *sol = INT_MIN;
         return;
     }

     /* feasible solution, with value v */
     if (n == 0 || c == 0)
     {
         *sol = v;
         return;
     }

     ub = (double) v + c * e->value / e->weight;

     if (ub < best_so_far) {
	  /* prune ! */
          *sol = INT_MIN;
          return;
     }
     /* 
      * compute the best solution without the current item in the knapsack 
      */
     knapsack(e + 1, c, n - 1, v, &without);

     /* compute the best solution with the current item in the knapsack */
     knapsack(e + 1, c - e->weight, n - 1, v + e->value, &with);

     best = with > without ? with : without;

     /* 
      * notice the race condition here. The program is still
      * correct, in the sense that the best solution so far
      * is at least best_so_far. Moreover best_so_far gets updated
      * when returning, so eventually it should get the right
      * value. The program is highly non-deterministic.
      */
     if (best > best_so_far) best_so_far = best;

     *sol = best;
}
void knapsack_main(struct item *e, int c, int n, int *sol)
{
     best_so_far = INT_MIN;
     knapsack(e, c, n, 0, sol);
     if (bots_verbose_mode) printf("Best value is %d\n\n", *sol);
}
