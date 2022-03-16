int main()
{
  int result = 0, i=0, j=0;
#pragma omp parallel shared(result)
/*  {
    int x = foo(result);
    # pragma omp task shared(result)
    int y = result;
    # pragma omp task shared(result)
    result += 2;
    # pragma omp taskwait
    int q = result;
    # pragma omp task shared(result)
    int z = result;
    # pragma omp task shared(result)
    int w = result;
    # pragma omp taskwait
    int r = result;
  }
*/
    # pragma omp parallel shared(result, i, j)
    {
    # pragma omp single shared(result, i, j)
    {
        # pragma omp task shared(result, i, j)
        i = 3;
        # pragma omp task shared(result, i, j)
        j = 3;
        # pragma omp taskwait
        result = i + j;
        # pragma omp task shared(result, i, j)
        i = 3;
        # pragma omp task shared(result, i, j)
        j = 3;
        # pragma omp taskwait
        result = i + j;
	result = result + 4;
    }
    }

    #pragma omp parallel for reduction(+:result)
    for(int i = 0; i < 100; i++){
        result += 3;   
    }
}

int foo(int n){
    return n * 2;
}

