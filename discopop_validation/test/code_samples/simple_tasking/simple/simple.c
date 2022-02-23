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
    int q = result;
    # pragma omp task shared(result)
    int z = result;
    # pragma omp task shared(result)
    int w = result;
    # pragma omp taskwait
    int r = result;
  }

  # pragma omp parallel for reduction(+:result)
    for(int i = 0; i < 100; i++){
//    result += i;
    int y = result;
    result = y;
    y = result * 2;    
    }
}

int foo(int n){
    return n * 2;
}

