# Profiler tests overview

## RAW
| test id |  source access description  | sink access description | implemented |
| --- | -------- | --- | ---|
| 0 | variable  | variable | X |
| 1 | variable | alias | X |
| 2 | alias | variable | X |
| 3 | variable | pointer | X |
| 4 | pointer | variable | X|
| 5 | static length array access | pointer | X |
| 6 | pointer | static length array access | X |
| 7 | static length array pointer arithmetics | pointer | X |
| 8 | static length array access | static length pointer arithmetics | X |
| 9 | static length pointer arithmetics | alias | X |
| 10_1 | variable length array access | pointer | X |
| 11_1 | pointer | variable length array access | X |
| 12_1 | variable length array pointer arithmetics | pointer | X |
| 13_1 | variable length array access | variable length pointer arithmetics | |
| 14_1 | variable length pointer arithmetics | alias | |
| 10_2 | heap array access | pointer | |
| 11_2 | pointer | heap array access | |
| 12_2 | heap array pointer arithmetics | pointer | |
| 13_2 | heap array access | heap pointer arithmetics | |
| 14_2 | heap pointer arithmetics | alias | |
| 16 | W before loop | R in loop initialization | |
| 17 | W before loop | R in loop condition | |
| 18 | W before loop | R in loop increment | |
| 19 | W before loop | R in loop | |
| 20 | W before loop | R in nested loop | |
| 21 | W before loop | R in function parameters | |
| 22 | W before loop | R in called function | |
| 23 | W before loop | R after loop
| 24 | W in loop increment | R in loop condition | |
| 25 | W in loop increment | R in loop | |
| 26 | W in loop increment | R in nested loop | |
| 27 | W in loop increment | R in function parameters | |
| 28 | W in loop increment | R in called function | |
| 29 | W in loop increment | R after loop | |
| 30 | W in loop body | R in loop body | |
| 31 | W in loop body | R in nested loop | |
| 32 | W in loop body | R in function parameters | |
| 33 | W in loop body | R in called function | |
| 34 | W in loop body | R after loop | |
| 35 | W in body | R in function parameters | |
| 36 | W in body | R in called function | |
| 37 | W in loop body | R in loop body (intra-iteration) | |
| 38 | W in loop body | R in loop body (inter-iteration forward) | |
| 39 | W in loop body | R in loop body (inter-iteration forward arbitrary distance) | |
| 40 | W in loop body | R in loop body (inter-iteration backwards) | |
| 41 | W in loop body | R in loop body (inter-iteration backwards arbitrary distance) | |
| 42 | W in called function | R in body | |
| 43 | W in called function | R in called function | |
| 44 | W in called function | R in nested called function body | |
| 45 | W in nested called function | R in body | |
| 46 | W in nested called function | R in called function | |
| 47 | W in nested called function | R in nested called function | |
| 48 | W is loop index increment | R is loop index read | |
| 49 | W is loop index increment | R is loop index read in next iteration | |
| 50 | W is loop index increment | R is loop index read as variable length array index | |
| 51 | W is loop index increment | R is loop index read as static length array index | |




## WAR
| test id |  source access description  | sink access description | implemented |
| --- | -------- | --- | ---|
| 0 | variable  | variable | |
| 1 | variable | alias | |
| 2 | alias | variable | |
| 3 | variable | pointer | |
| 4 | pointer | variable | |
| 5 | static length array access | pointer | |
| 6 | pointer | static length array access | |
| 7 | static length array pointer arithmetics | pointer | |
| 8 | static length array access | static length pointer arithmetics | |
| 9 | static length pointer arithmetics | alias | |
| 10 | variable length array access | pointer | |
| 11 | pointer | variable length array access | |
| 12 | variable length array pointer arithmetics | pointer | |
| 13 | variable length array access | variable length pointer arithmetics | |
| 14 | variable length pointer arithmetics | alias | |
| 15 | R before loop | W in loop initialization | |
| 16 | R before loop | W in loop condition | |
| 17 | R before loop | W in loop increment | |
| 18 | R before loop | W in loop | |
| 19 | R before loop | W in nested loop | |
| 20 | R before loop | W in function parameters | |
| 21 | R before loop | W in called function | |
| 22 | R before loop | W after loop
| 23 | R in loop increment | W in loop condition | |
| 24 | R in loop increment | W in loop | |
| 25 | R in loop increment | W in nested loop | |
| 26 | R in loop increment | W in function parameters | |
| 27 | R in loop increment | W in called function | |
| 28 | R in loop increment | W after loop | |
| 29 | R in loop body | W in loop body | |
| 30 | R in loop body | W in nested loop | |
| 31 | R in loop body | W in function parameters | |
| 32 | R in loop body | W in called function | |
| 33 | R in loop body | W after loop | |
| 34 | R in body | W in function parameters | |
| 35 | R in body | W in called function | |
| 36 | R in loop body | W in loop body (intra-iteration) | |
| 37 | R in loop body | W in loop body (inter-iteration forward) | |
| 38 | R in loop body | W in loop body (inter-iteration forward arbitrary distance) | |
| 39 | R in loop body | W in loop body (inter-iteration backwards) | |
| 40 | R in loop body | W in loop body (inter-iteration backwards arbitrary distance) | |
| 41 | R in called function | W in body | |
| 42 | R in called function | W in called function | |
| 43 | R in called function | W in nested called function body | |
| 44 | R in nested called function | W in body | |
| 45 | R in nested called function | W in called function | |
| 46 | R in nested called function | W in nested called function | |
| 47 | R is loop index read | W is loop index increment | |
| 48 | R is loop index read | W is loop index increment in next iteration | |
| 49 | R is loop index read as variable length array index | W is loop index increment | |
| 50 | R is loop index read as static length array index | W is loop index increment | |
| 51 | heap array access | pointer | |
| 52 | pointer | heap array access | |
| 53 | heap array pointer arithmetics | pointer | |
| 54 | heap array access | heap pointer arithmetics | |
| 55 | heap pointer arithmetics | alias | |


## WAW
| test id |  source access description  | sink access description | implemented |
| --- | -------- | --- | ---|
| 0 | variable  | variable | |
| 1 | variable | alias | |
| 2 | alias | variable | |
| 3 | variable | pointer | |
| 4 | pointer | variable | |
| 5 | static length array access | pointer | |
| 6 | pointer | static length array access | |
| 7 | static length array pointer arithmetics | pointer | |
| 8 | static length array access | static length pointer arithmetics | |
| 9 | static length pointer arithmetics | alias | |
| 10 | variable length array access | pointer | |
| 11 | pointer | variable length array access | |
| 12 | variable length array pointer arithmetics | pointer | |
| 13 | variable length array access | variable length pointer arithmetics | |
| 14 | variable length pointer arithmetics | alias | |
| 15 | W before loop | W in loop initialization | |
| 16 | W before loop | W in loop condition | |
| 17 | W before loop | W in loop increment | |
| 18 | W before loop | W in loop | |
| 19 | W before loop | W in nested loop | |
| 20 | W before loop | W in function parameters | |
| 21 | W before loop | W in called function | |
| 22 | W before loop | W after loop
| 23 | W in loop increment | W in loop condition | |
| 24 | W in loop increment | W in loop | |
| 25 | W in loop increment | W in nested loop | |
| 26 | W in loop increment | W in function parameters | |
| 27 | W in loop increment | W in called function | |
| 28 | W in loop increment | W after loop | |
| 29 | W in loop body | W in loop body | |
| 30 | W in loop body | W in nested loop | |
| 31 | W in loop body | W in function parameters | |
| 32 | W in loop body | W in called function | |
| 33 | W in loop body | W after loop | |
| 34 | W in body | W in function parameters | |
| 35 | W in body | W in called function | |
| 36 | W in loop body | W in loop body (intra-iteration) | |
| 37 | W in loop body | W in loop body (inter-iteration forward) | |
| 38 | W in loop body | W in loop body (inter-iteration forward arbitrary distance) | |
| 39 | W in loop body | W in loop body (inter-iteration backwards) | |
| 40 | W in loop body | W in loop body (inter-iteration backwards arbitrary distance) | |
| 41 | W in called function | W in body | |
| 42 | W in called function | W in called function | |
| 43 | W in called function | W in nested called function body | |
| 44 | W in nested called function | W in body | |
| 45 | W in nested called function | W in called function | |
| 46 | W in nested called function | W in nested called function | |
| 47 | W is loop index increment | W is loop index increment | |
| 48 | W is loop index increment | W is loop index increment in next iteration | |
| 49 | heap array access | pointer | |
| 50 | pointer | heap array access | |
| 51 | heap array pointer arithmetics | pointer | |
| 52 | heap array access | heap pointer arithmetics | |
| 53 | heap pointer arithmetics | alias | |
