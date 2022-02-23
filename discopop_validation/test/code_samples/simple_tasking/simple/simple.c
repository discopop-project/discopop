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
    }
    }
}

int foo(int n){
    return n * 2;
}

