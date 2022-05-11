int main()
{
    int x0=0, x1=0;
    int y0=0, y1=0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task depend(out:x0)
            {
                x0 = 1;
            }
            #pragma omp task depend(in:x0)
            {
                y0 = 1;
            }
        }
    }
}

