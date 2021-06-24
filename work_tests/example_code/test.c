#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//Example 1
//Find the determinant of the given matrix 5 x 5
int determinant(int matrix[5][5], int n) {
    int det = 0;
    int sub[5][5];
    if (n == 2){
        return ((matrix[0][0] * matrix[1][1]) - (matrix[1][0] * matrix[0][1]));
    }
    else{
        for (int i = 0; i < n; i++) {
            int row = 0;
            for (int j = 1; j < n; j++) {
                int col = 0;
                for (int k = 0; k < n; k++) {
                    if (k == i){
                        continue;
                    }
                    sub[row][col] = matrix[j][k];
                    col++;
                }
                row++;
            }
            det = det + (pow(-1, i) * matrix[0][i] * determinant(sub, n - 1));
        }
    }
   return det;
}

//Example 2
//Find the expectations of x-times rolling of n sided dice 
float expectations(int *matrix, int n){
    float exp = 0;
    float rolls = 0;
    int *count = matrix;
    for (int i = 0; i < n; i++)
    {
        rolls += count[i];
    } 

    for (int i = 1; i <= n; i++){
        exp += (i * *matrix);
        matrix++;
    }
    return exp/rolls;
}

//Example 3
//Sort an Array with quicksort algorithm
void swap(int* x, int* y)
{
    int t = *x;
    *x = *y;
    *y = t;
}

int partition (int array[], int low, int high)
{
    int pivot = array[high];
    int i = (low - 1);

    for (int j = low; j <= high - 1; j++)
    {
        if (array[j] < pivot)
        {
            i++;
            swap(&array[i], &array[j]);
        }
    }
    swap(&array[i + 1], &array[high]);
    return (i + 1);
}

void quickSort(int array[], int low, int high)
{
    if (low < high)
    {
        int part = partition(array, low, high);

        quickSort(array, low, part - 1);
        quickSort(array, part + 1, high);
    }
}

//Sort an Array with bubble sort algorithm
void bubbleSort(int array[], int n)
{
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++){
            if (array[j] > array[j+1]){
                swap(&array[j], &array[j+1]);
            }
        }
    }
}

int main(){

    //Determinant of Matrix 5 x 5
    int n = 5;
    int a[5][5];
    for (int i = 0; i < n; i++){ 
        for(int j = 0; j < n; j++){
            int r = rand()%42;
            a[i][j] = -(i<<j)%100 + r;
        }
    }
    int det = determinant(a,n);
    printf("Determinant : %d\n", det);

    //Expectation of n times rolling of 6 sided dice 
    int roll[] = {72, 30, 28, 42, 55, 63};

    float exp = expectations(roll, 6);
    printf("Expectations : %f\n", exp);


    //Sort array with n-Elements using quicksort algorithm 
    int length = rand()%200;
    int array[length];
    printf("unsorted : \t");
    for (int i = 0; i < length; i++){
        int random = rand()%100;
        array[i] = random;
        printf("%d\t", array[i]);
    }

    printf("\n");

    quickSort(array, 0, length-1);
    printf("sorted : \t");
    for (int i = 0; i < length; i++){
        printf("%d\t", array[i]);
    }

    printf("\n");


    //Sort array with n-Elements using bubble sort algorithm 
    int arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25};
    int len = 25;
    printf("before bubble sort : \t");
    for (int i = 0; i < len; i++){
        printf("%d\t", arr[i]);
    }

    printf("\n");

    bubbleSort(arr, len);
    printf("after bubble sort : \t");
    for (int i = 0; i < len; i++){
        printf("%d\t", arr[i]);
    }

}



