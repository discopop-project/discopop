int main()
{
    int x = 0, y = 0;
    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task
            x = x + 1;
            #pragma omp task
            y = y + 1;
        }
    }
}

