/**********************************************************************************************/
/*  This program is part of the Barcelona OpenMP Tasks Suite                                  */
/*  Copyright (C) 2009 Barcelona Supercomputing Center - Centro Nacional de Supercomputacion  */
/*  Copyright (C) 2009 Universitat Politecnica de Catalunya                                   */
/*                                                                                            */
/*  This program is free software; you can redistribute it and/or modify                      */
/*  it under the terms of the GNU General Public License as published by                      */
/*  the Free Software Foundation; either version 2 of the License, or                         */
/*  (at your option) any later version.                                                       */
/*                                                                                            */
/*  This program is distributed in the hope that it will be useful,                           */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of                            */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                             */
/*  GNU General Public License for more details.                                              */
/*                                                                                            */
/*  You should have received a copy of the GNU General Public License                         */
/*  along with this program; if not, write to the Free Software                               */
/*  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA            */
/**********************************************************************************************/

#include "serial-app.h"

#define BOTS_APP_NAME "Strassen"
#define BOTS_APP_PARAMETERS_DESC "N=%d:Y=%d"
#define BOTS_APP_PARAMETERS_LIST ,bots_arg_size,bots_app_cutoff_value

#define BOTS_APP_USES_ARG_SIZE
#define BOTS_APP_DEF_ARG_SIZE 1024
#define BOTS_APP_DESC_ARG_SIZE "Matrix Size"

#define BOTS_APP_USES_ARG_BLOCK
#define BOTS_APP_DEF_ARG_BLOCK 32
#define BOTS_APP_DESC_ARG_BLOCK "Matrix Block Size"

#define BOTS_APP_USES_ARG_CUTOFF
#define BOTS_APP_DEF_ARG_CUTOFF 64
#define BOTS_APP_DESC_ARG_CUTOFF "Strassen Cutoff"

/***********************************************************************
 * The real numbers we are using --- either double or float
 **********************************************************************/
typedef double REAL;
typedef unsigned long PTR;

void matrixmul(int n, REAL *A, int an, REAL *B, int bn, REAL *C, int cn);
void FastNaiveMatrixMultiply(REAL *C, REAL *A, REAL *B, unsigned MatrixSize,
     unsigned RowWidthC, unsigned RowWidthA, unsigned RowWidthB);
void FastAdditiveNaiveMatrixMultiply(REAL *C, REAL *A, REAL *B, unsigned MatrixSize,
     unsigned RowWidthC, unsigned RowWidthA, unsigned RowWidthB);
void MultiplyByDivideAndConquer(REAL *C, REAL *A, REAL *B,
				     unsigned MatrixSize,
				     unsigned RowWidthC,
				     unsigned RowWidthA,
				     unsigned RowWidthB,
				     int AdditiveMode
				    );
void OptimizedStrassenMultiply(REAL *C, REAL *A, REAL *B, unsigned MatrixSize,
     unsigned RowWidthC, unsigned RowWidthA, unsigned RowWidthB, int Depth);
void init_matrix(int n, REAL *A, int an);
int compare_matrix(int n, REAL *A, int an, REAL *B, int bn);
REAL *alloc_matrix(int n);
void strassen_main(REAL *A, REAL *B, REAL *C, int n);

#define BOTS_APP_INIT\
    double *A, *B, *C;\
    if ((bots_arg_size & (bots_arg_size - 1)) != 0 || (bots_arg_size % 16) != 0) {\
        bots_message("Error: matrix size (%d) must be a power of 2 and a multiple of %d\n", bots_arg_size, 16);\
        exit (1);\
    }\
    A = (double *) malloc (bots_arg_size * bots_arg_size * sizeof(double));\
    B = (double *) malloc (bots_arg_size * bots_arg_size * sizeof(double));\
    C = (double *) malloc (bots_arg_size * bots_arg_size * sizeof(double));\
    init_matrix(bots_arg_size,A,bots_arg_size);\
    init_matrix(bots_arg_size,B,bots_arg_size);

//#define KERNEL_INIT
#define KERNEL_CALL strassen_main(C,A,B,bots_arg_size);
//#define KERNEL_FINI

//#define KERNEL_SEQ_INIT
//#define KERNEL_SEQ_CALL strassen_main_seq(D,A,B,bots_arg_size);
//#define KERNEL_SEQ_FINI


#define KERNEL_CHECK BOTS_RESULT_NA 

