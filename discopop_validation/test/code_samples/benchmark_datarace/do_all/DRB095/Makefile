all: combine

combine: simple
	gcc -o out DRB095-doall2-taskloop-orig-yes.o

simple:
	gcc -c DRB095-doall2-taskloop-orig-yes.c

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
