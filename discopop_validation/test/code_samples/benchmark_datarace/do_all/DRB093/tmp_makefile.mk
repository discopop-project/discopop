all: -1 1
-1:
0:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB093 && clang DRB093-doall2-collapse-orig-no.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB093/FileMapping.txt -o DRB093-doall2-collapse-orig-no.ll;
1: 0
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB093 && clang++ DRB093-doall2-collapse-orig-no.ll -o out -L/home/lukas/git/discopop/build//rtlib -lDiscoPoP_RT -lpthread;
