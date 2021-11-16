all: fib.o bots_dependencies
	gcc fib.o bots_common.o bots_main.o -o out
fib.o:
	gcc -c fib.c
	
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
