/home/raynard/discopop/scripts/dp-fmap

#CU Generation
clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMCUGeneration.so -mllvm -fm-path -mllvm ./FileMapping.txt -c test.c

#Dependence Profiling
clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPInstrumentation.so -mllvm -fm-path -mllvm ./FileMapping.txt -c test.c -o out.o

clang++ out.o -L /home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./a.out

#Reduction
clang++ -g -O0 -fno-discard-value-names -Xclang -load -Xclang /home/raynard/discopop/build/libi/LLVMDPReduction.so -mllvm -fm-path -mllvm ./FileMapping.txt -c test.c -o out.o

clang++ out.o -L/home/raynard/discopop/build/rtlib -lDiscoPoP_RT -lpthread

./a.out
