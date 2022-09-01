all: 0 2
-1:
0: -1
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/drb/061 && cp simple.c simple.c.last_profiled;
1:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/drb/061 && clang simple.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/drb/061/FileMapping.txt -o simple.ll;
2: 1
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/drb/061 && clang++ simple.ll -o out -L/home/lukas/git/discopop/build//rtlib -lDiscoPoP_RT -lpthread;
