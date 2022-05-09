all: -1 1
-1:
0:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/discopop/fib && clang simple.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/discopop/fib/FileMapping.txt -o simple.ll;
1: 0
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/discopop/fib && clang++ simple.ll -o out -L/home/lukas/git/discopop/build//rtlib -lDiscoPoP_RT -lpthread;
