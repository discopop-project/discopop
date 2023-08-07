# SETTINGS
DP_DIR=/home/lukas/git/discopop
DP_BUILD=${DP_DIR}/build
DP_SCRIPTS=${DP_DIR}/scripts

# original arguments: "$@"
echo "WRAPPED CXX COMPILE..."
echo "ARGS: ${@}"
echo "DP_FM_PATH: ${DP_FM_PATH}"

# check if environment is prepared
if [ -z ${DP_FM_PATH} ]; then
  echo "ERROR: DP_FM_PATH unspecified!"
  echo "\tGenerate a FileMapping.txt file and create an environment Variable which points to this file."
  exit 1
fi

echo "clang++-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names ${@} -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}"
clang++-11 -g -c -O0 -S -emit-llvm -fno-discard-value-names "$@" -Xclang -load -Xclang ${DP_BUILD}/libi/LLVMDiscoPoP.so -DiscoPoP -mllvm --fm-path -mllvm ${DP_FM_PATH}

# WARNING: OUTPUT IS A .ll FILE, ENDING IS .o

