test: atax.o polybench.o
	gcc atax.o polybench.o -o out
	
atax.o: useless.o
	gcc -c atax.c -O3

useless.o:
	gcc -c useless.c
	
polybench.o:
	gcc -c polybench.c
	
direct_compile:
	gcc -o out atax.c polybench.c
	
clean:
	rm -f *.o
	rm -f out
	rm -f *.ll
	rm -f *.txt
	rm -f *.xml
	rm -f dp-fmap
	rm -f *.mk
