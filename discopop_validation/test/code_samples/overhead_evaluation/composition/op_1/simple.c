int main()
{
    int x0=0;
    int y0=0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task
            {
                x0 = 1;
            }
            #pragma omp task
            {
                y0 = 1;
            }
        }
    }
}

