/home/raynard/discopop/scripts/dp-fmap

#CU Generation
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c cholesky.c
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c


#Dependence Profiling
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c cholesky.c -o cholesky.o
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c -o polybench.o
clang++ cholesky.o polybench.o -o choleskypolybench -L /home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./choleskypolybench

#Reduction
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c cholesky.c -o cholesky.o
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c -o polybench.o
clang++ cholesky.o polybench.o -o choleskypolybench_red -L /home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./choleskypolybench_red
