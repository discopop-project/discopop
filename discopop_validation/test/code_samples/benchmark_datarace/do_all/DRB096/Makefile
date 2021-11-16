all: combine

combine: simple
	gcc -o out DRB096-doall2-taskloop-collapse-orig-no.o

simple:
	gcc -c DRB096-doall2-taskloop-collapse-orig-no.c

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
