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
Detailed information about each execution step, the setup as well as the functionality of DiscoPoP can be found on the [wiki page](https://discopop-project.github.io/discopop/).

### Quick Links
- [Setup](https://discopop-project.github.io/discopop/Setup/)
- [Example](https://discopop-project.github.io/discopop/Guide/)


## License
© DiscoPoP is available under the terms of the BSD-3-Clause license, as specified in the LICENSE file.
