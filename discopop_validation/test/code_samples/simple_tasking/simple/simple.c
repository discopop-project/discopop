int main()
{
  int result = 0;
#pragma omp parallel shared(result)
  {
    int x = foo(result);
    # pragma omp task shared(result)
    int y = result;
    # pragma omp task shared(result)
    result += 2;
    # pragma omp taskwait

    # pragma omp task shared(result)
    int z = result;
    # pragma omp task shared(result)
    int w = result;
    # pragma omp taskwait
    int r = result;
  }
}

int foo(int n){
    return n * 2;
}

