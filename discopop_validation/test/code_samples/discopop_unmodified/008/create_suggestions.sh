HOME_DIR=$PWD
# change to discopop directory
cd ../../../../..
DP_DIR=$PWD
echo "DP_DIR: $DP_DIR"

#python -m discopop_explorer --path=$HOME_DIR --dep-file=out_dep.txt --dp-build-path=/home/lukas/git/discopop/build --json=$HOME_DIR/original_suggestions.json --task-pattern

# generate Data_CUInst.txt
python -m discopop_explorer \
--path=$HOME_DIR \
--dep-file=out_dep.txt \
--generate-data-cu-inst=$HOME_DIR

# generate _CUInstResult.txt
DIR_PRE=$PWD
cd $HOME_DIR
echo $PWD
clang++ -S -emit-llvm -c -std=c++11 -g $DP_DIR/CUInstantiation/RT/CUInstantiation_iFunctions.cpp -o iFunctions_CUInst.ll
clang++ -g -O0 -emit-llvm -fno-discard-value-names -c simple.c -o tmp_target_app.ll
opt-8 -S -load=/home/lukas/git/discopop/build/libi/LLVMCUInstantiation.so -CUInstantiation -input=Data_CUInst.txt tmp_target_app.ll -fm-path=FileMapping.txt -o tmp_target_app_instrumented.ll
clang++ tmp_target_app_instrumented.ll iFunctions_CUInst.ll -o simple_cui -L/home/lukas/git/discopop/build/rtlib -lDiscoPoP_RT -lpthread -o simple_cui
rm tmp_target_app.ll tmp_target_app_instrumented.ll iFunctions_CUInst.ll
./simple_cui

cd $DIR_PRE



# execute discopop_explorer
python -m discopop_explorer \
--path=$HOME_DIR \
--dep-file=out_dep.txt \
--llvm-cxxfilt-path=llvm-cxxfilt-8 \
--dp-build-path=/home/lukas/git/discopop/build \
--json=$HOME_DIR/original_suggestions.json \
--fmap=FileMapping.txt \
--cu-inst-res=simple_cui_CUInstResult.txt \
--task-pattern



