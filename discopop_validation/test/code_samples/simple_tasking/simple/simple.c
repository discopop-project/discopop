int main()
{
  int result = 0;
#pragma omp parallel shared(result)
  {
    int x = result;
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
  }

   #pragma omp parallel for shared(result)
    for(int i = 0; i < 100; i++){
        result += 3;
    }   

   #pragma omp parallel for shared(result) reduction(+:result)
    for(int i = 0; i < 100; i++){
        result += 3;
    }   

    #pragma omp parallel for shared(result) reduction(+:result)
    for(int i = 0; i < 100; i++){
        result = 4;
        result += 3;
    }   

    #pragma omp parallel for shared(result)
    for(int i = 0; i < 100; i++){
        int z = result;
        z = z + result;
    } 
}
