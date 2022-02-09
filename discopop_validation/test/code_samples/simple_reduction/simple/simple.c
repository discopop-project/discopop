#include <stdio.h>

int main(){
    int x = 3;
    int y = 2;
    int arr[10];

    for(int i=0; i < 100000; i++){
        x = 3;  //no reduction candidate
        x += i;  // reduction candidate
        y = i;
        arr[y % 10] = i; 
    }

    for(int j = 0; j < 10; j++){
        arr[x % 10] = j;
    }

}
