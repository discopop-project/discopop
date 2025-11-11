all: build_regular build_hybrid

build_regular:
	mkdir -p build_regular
	python3 -m venv build_regular/venv
	cmake -S ../.. -B build_regular -DCMAKE_BUILD_TYPE=Debug -DUSE_VENV=${PWD}/build_regular/venv -DDP_CALLTREE_PROFILING=1 -DDP_BUILD_UNITTESTS=0 -DDP_HYBRID_PROFILING=0
	make --directory=build_regular -j4
	make --directory=build_regular install_python_modules

build_hybrid:
	mkdir -p build_hybrid
	python3 -m venv build_hybrid/venv
	cmake -S ../.. -B build_hybrid -DCMAKE_BUILD_TYPE=Debug -DUSE_VENV=${PWD}/build_hybrid/venv -DDP_CALLTREE_PROFILING=1 -DDP_BUILD_UNITTESTS=0 -DDP_HYBRID_PROFILING=1
	make --directory=build_hybrid -j4
	make --directory=build_hybrid install_python_modules

clean:
	rm -rf build_regular
	rm -rf build_hybrid
