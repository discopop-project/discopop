#CURRENT_DIR = "$1"
#BUILD_DIR = "$2"

echo "CURRENT: $1"
echo "BUILD: $2"
echo "CMAKE_CURRENT_BINARY_DIR: $3"

echo "Compiling omp-pragma-extraction."

mkdir $3/omp-pragma-extraction
cd $3/omp-pragma-extraction
cmake $1/omp-pragma-extraction
make
# touch $BUILD_DIR/ALIVE.txt