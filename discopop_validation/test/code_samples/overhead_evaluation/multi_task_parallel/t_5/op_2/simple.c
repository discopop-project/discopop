int main()
{
    int x0=0, x1=0, x2=0;
    int y0=0, y1=0, y2=0;
    int z0=0, z1=0, z2=0;
    int a0=0, a1=0, a2=0;
    int b0=0, b1=0, b2=0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task depend(out:x0)
            {
                x0 = x0 + 1;
            }
            #pragma omp task depend(inout:x0)
            {
                y0 = y0 + 1;
            }
            #pragma omp task depend(inout:x0)
            {
                z0 = z0 + 1;
            }
            #pragma omp task depend(inout:x0)
            {
                a0 = a0 + 1;
            }
            #pragma omp task depend(in:x0)
            {
                b0 = b0 + 1;
            }
        }
    }
}

