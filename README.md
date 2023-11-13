<!--
 /*
 * This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */
 -->

# DiscoPoP - Discovery of Potential Parallelism
DiscoPoP is an open-source tool that helps software developers parallelize their programs with threads. It is a joint project of Technical University of Darmstadt and Iowa State University.

In a nutshell, DiscoPoP performs the following steps:
* detect parts of the code (computational units or CUs) with little to no internal parallelization potential,
* find data dependences among them,
* identify parallel patterns that can be used to parallelize a code region,
* and finally suggest corresponding OpenMP parallelization constructs and clauses to programmers.

DiscoPoP is built on top of LLVM. Therefore, DiscoPoP can perform the above-mentioned steps on any source code which can be transferred into the LLVM IR.

A more comprehensive overview of DiscoPoP can be found on our [project website](https://www.discopop.tu-darmstadt.de/).

## Wiki
Detailed information about each execution step, the setup as well as the functionality of DiscoPoP and how to contribute can be found on the [wiki page](https://discopop-project.github.io/discopop/).

### Quick Links
- [Quickstart guide - GUI](https://discopop-project.github.io/discopop/Quickstart)
- [Quickstart guide - CMake projects](https://discopop-project.github.io/discopop/Quickstart_CMake)
- [Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=TUDarmstadt-LaboratoryforParallelProgramming.discopop)

## Example
DiscoPoP creates parallelization suggestions for sequential source code.
Implementing these suggestions results in a parallel program.
A simple example for the results of the assisted parallelization on the basis of the created parallelization suggestions can be found below.

### Original Source Code
Let's assume the original source code looks as follows:

    int foo(int in, int d){
        return in * d;
    }

    int bar(int in, int d){
        return in + d;
    }

    int delta(int in, int d){
        return in -d;
    }

    int main( void)
    {
        int i;
        int d=20,a=22, b=44,c=90;
        for (i=0; i<100; i++) {
            a = foo(i, d);
            b = bar(a, d);
            c = delta(b, d);
        }
        a = b;
        return 0;
    }

Applying DiscoPop to this program will result in a set of parallelization suggestions.

### Parallel Source Code
For demonstration purposes we have applied the identified and suggested [pipeline pattern](https://discopop-project.github.io/discopop/Pattern_Detection/Patterns/Pipeline/) to the original source code, which resulted in the following parallel source code.
Please refer to the [parallel patterns](https://discopop-project.github.io/discopop/Pattern_Detection/Patterns) page of the [DiscoPoP wiki](https://discopop-project.github.io/discopop/) for a complete overview of the supported parallel patterns.

    int foo(int in, int d){
        return in * d;
    }

    int bar(int in, int d){
        return in + d;
    }

    int delta(int in, int d){
        return in -d;
    }

    int main( void)
    {
        int i;
        int d=20,a=22, b=44,c=90;
        for (i=0; i<100; i++) {
            #pragma omp task firsprivate(i) shared(d, in) depend(out:a)
            a = foo(i, d);
            #pragma omp task shared(d, in) depend(in:a) depend(out:b)
            b = bar(a, d);
            #pragma omp task private(c) shared(d, in) depend(in: b)
            c = delta(b, d);
        }
        a = b;
        return 0;
    }

### Convenience
For a convenient set, configuration, management, application, and browsing of identified parallelization suggestions, please consider using our [Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=TUDarmstadt-LaboratoryforParallelProgramming.discopop).




## License
© DiscoPoP is available under the terms of the BSD-3-Clause license, as specified in the LICENSE file.
