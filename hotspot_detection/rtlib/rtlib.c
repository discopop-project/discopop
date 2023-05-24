// temporary rtlib
#include <stdio.h>
#include "time.h"
#include <stdbool.h>
#include <sys/time.h>

// temporary data structures
bool time_flag[100] = {false};
long double time_a[100] = {0};
long double time_b[100] = {0};

struct timeval start1, end1;

extern inline void start(const long int id)
{
    if (time_flag[id] == false)
    {
        time_flag[id] = true;
        gettimeofday(&start1, NULL);
        time_a[id] = start1.tv_sec + 1e-6 * start1.tv_usec;
        // time_a[id] = clock();
    }
    return;
}

extern inline void end(const long int id)
{

    if (time_flag[id] == true)
    {
        time_flag[id] = false;
        gettimeofday(&end1, NULL);
        time_b[id] = time_b[id] + (end1.tv_sec + 1e-6 * end1.tv_usec) - time_a[id];
        // time_b[id] = time_b[id] + clock() - time_a[id];
    }
    return;
}

void printOut()
{
    FILE *filePointer;
    int bufferLength = 255;
    char buffer[bufferLength]; /* not ISO 90 compatible */
    char cntChar[bufferLength];
    filePointer = fopen("cs_id.txt", "r");
    int num = 0;
    while (fgets(buffer, bufferLength, filePointer))
    {
        num++;
    }
    // printf("%d", num);
    // printf("%s", buffer);
    fclose(filePointer);
    printf("rtl.c printOut \n");
    FILE *fptr;
    fptr = fopen("result.txt", "w");
    // fprintf(fptr,"RUNTIME:\n");
    for (int i = 1; i <= num; i++)
    {
        // if (time_b[i] > 0){
        fprintf(fptr, "%d", i);

        // fprintf(fptr, " %Lf", (time_b[i])/ (long double)(CLOCKS_PER_SEC) );
        fprintf(fptr, " %Lf", time_b[i]);

        fprintf(fptr, "\n");
        //}
    }
    fclose(fptr);
    return;
}
