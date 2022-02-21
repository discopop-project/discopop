int test(n){
    n = n + 2;
    return n;
}

int main()
{
  int result = 0;
#pragma omp parallel shared(result)
  {
    int x = result;
   #pragma omp single
    {
      result = 2;
    }
    test(result);
    #pragma omp task shared(result)
//    result = 4;
    #pragma omp task shared(result)
//    result = result - 3;
    #pragma omp taskwait
  }

  #pragma omp parallel for shared(result) reduction(+:result)
  for(int i = 0; i < 100; i++){
    result += i;
  }
}
