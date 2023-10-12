// temporary rtlib
#include <stdio.h>
#include "time.h"
#include <stdbool.h>
#include <sys/time.h>
#include <unistd.h>

// temporary data structures
bool time_flag[500] = {false};
long double time_a[500] = {0};
long double time_b[500] = {0};

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

    // determine filename for result storage
    const char* result_base_name = "hotspot_result_";
    const char* result_file_ending = ".txt";
    char unused_file_name[80];
    int counter = 0;
    char* s_counter;

    while(true){
        // create file name
        if (asprintf(&s_counter, "%d", counter) == -1) {
            perror("asprintf");
        } else {
            // assemble the next filename to be checked
            strcat(strcat(strcpy(unused_file_name, result_base_name), s_counter), result_file_ending);
        }
        // check if file name already exists
        if(access(unused_file_name, F_OK) == 0){
            // file exists. increment counter.
            counter++;
        }
        else{
            // file does not exist yet. Use the identified filename to output the results.
            break;
        }
    }
    free(s_counter);

    fptr = fopen(unused_file_name, "w");
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
