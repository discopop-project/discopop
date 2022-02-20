int main()
{
  int result = 0;
#pragma omp parallel shared(result)
  {
    result = 2;
   #pragma omp single
    {
      result += 2;
    }
    #pragma omp task shared(result)
    result = 4;
    #pragma omp task shared(result)
    result = result - 3;
    #pragma omp taskwait
  }

  #pragma omp parallel for shared(result) reduction(+:result)
  for(int i = 0; i < 100; i++){
    result += i;
  }
}
