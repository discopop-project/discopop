all: -1 1
-1:
0:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB045 && clang DRB045-doall1-orig-no.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB045/FileMapping.txt -o DRB045-doall1-orig-no.ll;
1: 0
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB045 && clang++ DRB045-doall1-orig-no.ll -o out -L/home/lukas/git/discopop/build//rtlib -lDiscoPoP_RT -lpthread;
