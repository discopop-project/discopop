#CMAKE_CURRENT_SOURCE_DIR = "$1"
#CMAKE_CURRENT_BINARY_DIR = "$2"

mkdir $2/simple-alias-detection
cd $2/simple-alias-detection
cmake $1/simple-alias-detection
make