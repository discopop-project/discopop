int main()
{
    int x0=0, x1=0, x2=0, x3=0, x4=0, x5=0;
    int y0=0, y1=0, y2=0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task
            {
                x0 = x0 + 1; x1 = x1 + 1; x2 = x2 + 1; x3 = x3 + 1; x4 = x4 + 1; x5 = 1;
            }
            #pragma omp task
            {
                y0 = 1;
            }
        }
    }
}

