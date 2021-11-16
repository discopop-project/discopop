all: combine

combine: simple
	gcc -o out simple_doall.o

simple:
	gcc -c simple_doall.c

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
	rm -f simple_doall_dp_run
	rm -f simple_doall_dp_run_red
	rm -f simple_doall
