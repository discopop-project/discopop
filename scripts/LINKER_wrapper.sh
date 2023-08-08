# SETTINGS
DP_DIR=/home/lukas/git/discopop
DP_BUILD=${DP_DIR}/build
DP_SCRIPTS=${DP_DIR}/scripts


# original arguments: "$@"
echo "WRAPPED LINKING...."
echo "ARGS: $@"

echo "clang++ ${@} -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v"

#clang++ --language=ir "$@" -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -v
clang++ "$@" -L${DP_BUILD}/rtlib -lDiscoPoP_RT -lpthread -fPIC -v