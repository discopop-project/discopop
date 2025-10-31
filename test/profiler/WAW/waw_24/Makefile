all: compile execute

compile:
	. $(DP_TEST_PROFILER_VENV)/bin/activate && discopop_cxx test.cpp -o instrumented.exe

execute:
	./instrumented.exe

clean:
	rm -rf .discopop
	rm -f instrumented.exe
