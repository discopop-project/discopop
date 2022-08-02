clang mergesort.cpp -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang ../../build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm FileMapping.txt -o mergesort.ll;
clang++ mergesort.ll -o out -L"../../build/rtlib" -lDiscoPoP_RT -lpthread;
./out

clang mergesort.cpp -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang ../../build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm FileMapping.txt -o mergesort.ll;
clang++ mergesort.ll -o out -L"../../build/rtlib" -lpthread;
./out

clang mergesort.cpp -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang ../../build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm FileMapping.txt -o mergesort.ll;
clang++ mergesort.ll -o out -L"../../build/rtlib" -lDiscoPoP_RT -lpthread;
./out


