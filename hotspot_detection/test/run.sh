$HOME/.../clang-8 -S -emit-llvm rtlib.c
$HOME/.../clang-8 -g -O0 -fno-discard-value-names -Xclang -load -Xclang $HOME/.../HDPass/build/skeleton/libSkeletonPass.so -S -emit-llvm mycode.c
$HOME/.../llvm-as rtlib.ll -o rtlib.bc
$HOME/.../llvm-as mycode.ll -o mycode.bc
$HOME/.../llvm-link mycode.bc rtlib.bc -o a.bc
$HOME/.../clang-8 a.bc -o a.out

#delete the temp.txt before bash ./run.sh