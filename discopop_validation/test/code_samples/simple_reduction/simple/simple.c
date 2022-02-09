#include <stdio.h>

int main(){
    int x = 3;
    int y = 2;
    int arr[10];

    for(int i=0; i < 100000; i++){
        x += i; 
        x = 3;
        y = i;
        arr[y % 10] = i; 
    }

    for(int j = 0; j < 10; j++){
        arr[x % 10] = j;
    }

}
