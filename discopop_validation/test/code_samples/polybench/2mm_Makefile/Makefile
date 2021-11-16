test: 2mm.o polybench.o
	gcc 2mm.o polybench.o -o out -DMINI_DATASET
	
atax.o:
	gcc -c 2mm.c -DMINI_DATASET
	
polybench.o:
	gcc -c polybench.c -DMINI_DATASET
	
direct_compile:
	gcc -o out 2mm.c polybench.c -DMINI_DATASET
	
clean:
	rm -f *.o
	rm -f out
	rm -f *.ll
	rm -f *.txt
	rm -f *.xml
	rm -f dp-fmap
	rm -f *.mk
