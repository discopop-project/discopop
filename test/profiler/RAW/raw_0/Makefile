all: compile execute

setup:
	echo "Hello world!"

compile:
	echo "PWD: ${PWD}" && discopop_cxx test.cpp

execute:
	./a.out

clean:
	echo "Cleanup Makefile"
	rm -rf .discopop
	rm -f a.out
