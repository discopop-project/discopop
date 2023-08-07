# SETTINGS
DP_DIR=/home/lukas/git/discopop
DP_BUILD=${DP_DIR}/build
DP_SCRIPTS=${DP_DIR}/scripts


# original arguments: "$@"
echo "WRAPPED CC COMPILE..."
echo "ARGS: ${@}"
echo "clang-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names ${@} -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DISCOPOP_FILEMAPPING_PATH}"
clang-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names "$@" -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DISCOPOP_FILEMAPPING_PATH}

# WARNING: OUTPUT IS A .ll FILE, ENDING IS .o
