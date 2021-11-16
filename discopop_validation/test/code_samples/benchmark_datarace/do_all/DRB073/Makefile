all: combine

combine: simple
	gcc -o out DRB073-doall2-orig-yes.o

simple:
	gcc -c DRB073-doall2-orig-yes.c

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
