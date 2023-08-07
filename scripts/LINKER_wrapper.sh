# SETTINGS
DP_DIR=/home/lukas/git/discopop
DP_BUILD=${DP_DIR}/build
DP_SCRIPTS=${DP_DIR}/scripts


# original arguments: "$@"
echo "WRAPPED LINKING...."
echo "ARGS: $@"

# rename .o files to .ll to allow clang to identify the correct file type


#echo "clang++-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names ${@} -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DISCOPOP_FILEMAPPING_PATH}"
#clang++-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names "$@" -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DISCOPOP_FILEMAPPING_PATH} 
# opt-11 -S -load ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP test.ll -o test_dp.ll --fm-path FileMapping.txt
#--fm-path ${DISCOPOP_FILEMAPPING_PATH} 


echo "clang++ ${@} -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v"

clang++ --language=ir "$@" -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v