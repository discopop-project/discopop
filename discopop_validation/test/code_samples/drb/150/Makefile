all: combine

combine: simple
	gcc -o out simple.o

simple:
	cp simple.c simple.c.last_profiled
	gcc -c simple.c

clean:
	rm -f *.o
	rm -f out
	rm -f a.out
	rm -f *.ll
	rm -f *.bc
	rm -f *.txt
	rm -f *.xml
	rm -f dp-fmap
	rm -f tmp_makefile.mk
	rm -f simple_dp_run
	rm -f simple_dp_run_red
	rm -f simple
	rm -f *.last_profiled
	rm -f *.modified
	rm -f *.omp
	rm -f *.json
