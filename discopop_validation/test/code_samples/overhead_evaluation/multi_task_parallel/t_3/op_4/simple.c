int main()
{
    int x0=0, x1=0, x2=0;
    int y0=0, y1=0, y2=0;
    int z0=0, z1=0, z2=0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task depend(out:x0)
            {
                x0 = x0 + 1; x1 = x1 + 1;
            }
            #pragma omp task depend(in:x0, out:y0)
            {
                y0 = y0 + 1; y1 = y1 + 1;
            }
            #pragma omp task depend(in:y0)
            {
                z0 = z0 + 1; z1 = z1 + 1;
            }
        }
    }
}

