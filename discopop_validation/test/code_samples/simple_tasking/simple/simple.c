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
  }

  #pragma omp parallel for shared(result) reduction(+:result)
  for(int i = 0; i < 100; i++){
    result += i;
  }

  #pragma omp parallel for shared(result)
  for(int i = 0; i < 100; i++){
    result += i;
  }
}
