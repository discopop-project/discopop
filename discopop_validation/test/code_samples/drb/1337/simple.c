int main()
{
  int i,j;
  int n=10, m=10;
  double b[n][m];
  b[1][1] = 42;

// BEGIN GPU REGION
//  #pragma omp target teams distribute parallel for collapse(2) map(tofrom: b)
  for(i=0;i<n; i++) 
    for(j=0;j<n; j++) 
      b[i][j]=(double)(i*j);
  
  // EXECUTE ON HOST

  b[1][2] = b[42][21];

  int dummy = 42;

  double a[n][n];

  // END OF HOST EXECUTION
  
//  #pragma omp target teams distribute parallel for collapse(2) map(tofrom: a)
  for(i=0;i<n; i++){  // SEQUENTIAL WRITE ACCESS
    for(j=0;j<n/2; j++){
      if(i < n/2){
        dummy = 1;
      }
      a[i][j] = (double) (i*j + dummy);
      dummy += 1;
    }     
  }
// END GPU REGION

  int buffer = a[7][4] * b[2][5] + dummy;

  return 0;
}
