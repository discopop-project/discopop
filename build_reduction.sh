# IMPORTANT : Make sure that the version of clang++ that is set as CXX matches
# the version of clang that is used to compile the programs that should be
# analyzed.

export CC=/usr/bin/clang-8
export CXX=/usr/bin/clang++-8

cd reduction
mkdir -p build
cd build

# compile the llvm pass code
cmake ../llvm_pass/
make -j4

# compile the loop counter lib
$CXX -c -g -emit-llvm ../mlp_lib/loop_counter.cpp -o loop_counter_lib.bc
#$CXX -DONLY_CONST_INDICES -c -g -emit-llvm ../mlp_lib/loop_counter.cpp -o loop_counter_lib.bc

cd ..
python3 ./gen_file_mapping.py
$CC -g -O0 -c -emit-llvm -fno-discard-value-names $1 -o $1_out.bc
export BC_IN="$1_out.bc"
export MODULE_LIB="build/libModuleFunc.so"
export LOOP_COUNTER_LIB="build/loop_counter_lib.bc"
./reduction.sh
python3 reduction_pass2.py && mv _reduction.txt reduction.txt
