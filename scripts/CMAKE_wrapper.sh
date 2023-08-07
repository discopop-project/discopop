# SETTINGS
DP_DIR=/home/lukas/git/discopop
DP_BUILD=${DP_DIR}/build
DP_SCRIPTS=${DP_DIR}/scripts

# original arguments: "$@"
echo "WRAPPED CMAKE BUILD..."
echo "ARGS: ${@}"

# execute cmake using CC, CXX and LINKER wrappers
# re-define structure of the link-executable to include the updated linker
cmake \
  -DCMAKE_C_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER_WORKS=1 \
  -DCMAKE_CXX_COMPILER=/home/lukas/git/discopop/scripts/CXX_wrapper.sh \
  -DCMAKE_C_COMPILER=/home/lukas/git/discopop/scripts/CC_wrapper.sh \
  -DCMAKE_LINKER=/home/lukas/git/discopop/scripts/LINKER_wrapper.sh \
  -DCMAKE_CXX_LINK_EXECUTABLE="<CMAKE_LINKER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" \
  "$@"

