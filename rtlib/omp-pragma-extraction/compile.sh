#CMAKE_CURRENT_SOURCE_DIR = "$1"
#CMAKE_CURRENT_BINARY_DIR = "$2"

mkdir $2/omp-pragma-extraction
cd $2/omp-pragma-extraction
cmake $1/omp-pragma-extraction
make