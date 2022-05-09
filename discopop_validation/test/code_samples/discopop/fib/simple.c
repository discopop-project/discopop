#include <stdio.h>

static long long res;

long long fib (int n)
{
	long long x, y;
	if (n < 2) return n;

	x = fib(n - 1);
	y = fib(n - 2);

	return x + y;
}

int main()
{
    int n = 10;
	res = fib(n);
	printf("Fibonacci result for %d is %lld\n",n,res);
}

