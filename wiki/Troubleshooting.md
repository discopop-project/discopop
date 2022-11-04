### How to use DiscoPoP with projects which use CMake build system?
To run DiscoPoP instrumentation on projects which use CMake, you need to use the following commands instead of the normal CMake.
1. You first need to run CMake to just configure the project for compilation:
```bash
cmake -DCMAKE_CXX_COMPILER=<PATH_TO_CLANG> -DCMAKE_CXX_FLAGS="-c -g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_FOLDER>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm <PATH_TO_FILE_MAPPING>"
```
2. Then, configure the project for linking:
```bash
cmake -DCMAKE_CXX_COMPILER=<PATH_TO_CLANG> -DCMAKE_CXX_FLAGS="-g -O0 -fno-discard-value-names -Xclang -load -Xclang <PATH_TO_DISCOPOP_BUILD_FOLDER>/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm <PATH_TO_FILE_MAPPING>" -DCMAKE_CXX_STANDARD_LIBRARIES="-L<PATH_TO_DISCOPOP_BUILD_FOLDER>/rtlib -lDiscoPoP_RT -lpthread" .
```
3. Running `make` will build the project with DiscoPoP instrumentation applied on the code.

You may use Github issues to report potential bugs or ask your questions. In case you need individual support, please contact us using discopop[at]lists.parallel.informatik.tu-darmstadt.de.