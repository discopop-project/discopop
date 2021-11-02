all: -1 3
-1:
0:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens && clang nqueens.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens/FileMapping.txt -o nqueens.ll;
1:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens && clang bots_common.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens/FileMapping.txt -o bots_common.ll;
2:
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens && clang bots_main.c -c -g -O0 -S -emit-llvm -fno-discard-value-names -Xclang -load -Xclang /home/lukas/git/discopop/build//libi/LLVMDPReduction.so -mllvm -fm-path -mllvm /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens/FileMapping.txt -o bots_main.ll;
3: 0 1 2
	cd /home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens && clang++ nqueens.ll bots_common.ll bots_main.ll -o out -L/home/lukas/git/discopop/build//rtlib -lDiscoPoP_RT -lpthread;
