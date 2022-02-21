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
  }
}
