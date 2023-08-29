all: clean prog

prog: daxpy.o
	$(LINKER) -o prog daxpy.o $(CXXFLAGS)

daxpy.o:
	$(CXX) -c -o daxpy.o daxpy.cpp $(CXXFLAGS)

clean:
	find . -not -name daxpy.cpp -not -name Makefile -not -path **/FileMapping.txt -delete

veryclean: clean
	rm -f FileMapping.txt
