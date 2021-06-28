/home/raynard/discopop/scripts/dp-fmap

#CU Generation
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c 2mm.c
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c


#Dependence Profiling
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c 2mm.c -o 2mm.o
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c -o polybench.o
clang++ 2mm.o polybench.o -o 2mmpolybench -L /home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./2mmpolybench

#Reduction
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c 2mm.c -o 2mm.o
clang -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c polybench.c -o polybench.o
clang++ 2mm.o polybench.o -o 2mmpolybench_red -L /home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./2mmpolybench_red
