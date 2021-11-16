all: sort.o bots_dependencies
	gcc sort.o bots_common.o bots_main.o -o out
sort.o:
	gcc -c sort.c
	
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
