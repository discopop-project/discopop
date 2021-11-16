all: nqueens.o bots_dependencies
	gcc nqueens.o bots_common.o bots_main.o -o out
nqueens.o:
	gcc -c nqueens.c
	
bots_dependencies:
	gcc -c bots_common.c
	gcc -c bots_main.c


clean:
	rm -f *.o
	rm -f out
	rm -f a.out
	rm -f *.ll
	rm -f *.txt
	rm -f *.xml
	rm -f dp-fmap
	rm -f *.mk
