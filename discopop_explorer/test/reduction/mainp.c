#include <stdio.h>
#include <omp.h>

int simpleLoop(int n)
{
    int sum = 0;
    #pragma omp parallel for private(i) reduction(+:sum)
    for (int i = 0; i < n; i++)
    {
        sum += i;
    }
    return sum;
}


int main()
{
    int res = simpleLoop(10);

    printf("%d\n", res);

    return 0;
}
