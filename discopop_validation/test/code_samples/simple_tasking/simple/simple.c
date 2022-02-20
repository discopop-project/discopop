// SOURCE: DATARACEBENCH

/* This is a program based on a test contributed by Yizi Gu@Rice Univ.
 * Classic Fibonacci calculation using task but missing taskwait. 
 * Data races pairs: i@61:5:W vs. i@65:14:R
 *                   j@63:5:W vs. j@65:16:R
 * */
unsigned int input = 10;
int fib(unsigned int n)
{
  if (n<2)
    return n;
  else
  {
    int i, j;
#pragma omp task shared(i)
    i=fib(n-1);
#pragma omp task shared(j)
    j=fib(n-2);

    int res= i+j; 
/* We move the original taskwait to a location after i+j to 
 * simulate the missing taskwait mistake.
 * Directly removing the taskwait may cause a child task to write to i or j
 * within the stack of a parent task which may already be gone, causing seg fault.
 * This change is suggested by Joachim Protze @RWTH-Aachen. 
 * */
#pragma omp taskwait
    return res;
  }
}
int main()
{
  int result = 0;
#pragma omp parallel
  {
   #pragma omp single
    {
      result = fib(input);
    }
  }
  printf ("Fib(%d)=%d (correct answer should be 55)\n", input, result);
  return 0;
}
